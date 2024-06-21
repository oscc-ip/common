// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// -- Adaptable modifications are redistributed under compatible License --
//
// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_AXI4_SLV_FSM_SV
`define INC_AXI4_SLV_FSM_SV

`include "register.sv"
`include "axi4_define.sv"
`include "axi4_addr_gen.sv"

// each usr block capacity is 4KB
module axi4_slv_fsm #(
    parameter int USR_ADDR_SIZE  = 64 * 1024 * 1024,
    parameter int USR_ADDR_WIDTH = $clog2(USR_ADDR_SIZE)  // NOTE: dont modify!
) (
    input  logic                        aclk,
    input  logic                        aresetn,
    input  logic [  `AXI4_ID_WIDTH-1:0] awid,
    input  logic [`AXI4_ADDR_WIDTH-1:0] awaddr,
    input  logic [                 7:0] awlen,
    input  logic [                 2:0] awsize,
    input  logic [                 1:0] awburst,
    input  logic                        awlock,
    input  logic [                 3:0] awcache,
    input  logic [                 2:0] awprot,
    input  logic [                 3:0] awqos,
    input  logic [                 3:0] awregion,
    input  logic [`AXI4_USER_WIDTH-1:0] awuser,
    input  logic                        awvalid,
    output logic                        awready,

    input  logic [  `AXI4_DATA_WIDTH-1:0] wdata,
    input  logic [`AXI4_DATA_WIDTH/8-1:0] wstrb,
    input  logic                          wlast,
    input  logic [  `AXI4_USER_WIDTH-1:0] wuser,
    input  logic                          wvalid,
    output logic                          wready,

    output logic [  `AXI4_ID_WIDTH-1:0] bid,
    output logic [                 1:0] bresp,
    output logic [`AXI4_USER_WIDTH-1:0] buser,
    output logic                        bvalid,
    input  logic                        bready,

    input  logic [  `AXI4_ID_WIDTH-1:0] arid,
    input  logic [`AXI4_ADDR_WIDTH-1:0] araddr,
    input  logic [                 7:0] arlen,
    input  logic [                 2:0] arsize,
    input  logic [                 1:0] arburst,
    input  logic                        arlock,
    input  logic [                 3:0] arcache,
    input  logic [                 2:0] arprot,
    input  logic [                 3:0] arqos,
    input  logic [                 3:0] arregion,
    input  logic [`AXI4_USER_WIDTH-1:0] aruser,
    input  logic                        arvalid,
    output logic                        arready,

    output logic [   `AXI4_ID_WIDTH-1:0] rid,
    output logic [ `AXI4_DATA_WIDTH-1:0] rdata,
    output logic [                  1:0] rresp,
    output logic                         rlast,
    output logic [ `AXI4_USER_WIDTH-1:0] ruser,
    output logic                         rvalid,
    input  logic                         rready,
    // user interface
    output logic                         s_usr_en_o,
    output logic                         s_usr_wen_o,
    output logic [   USR_ADDR_WIDTH-1:0] s_usr_addr_o,
    output logic [`AXI4_WSTRB_WIDTH-1:0] s_usr_bm_i,
    input  logic [ `AXI4_DATA_WIDTH-1:0] s_usr_dat_i,
    input  logic                         s_usr_awready_i,
    input  logic                         s_usr_wready_i,
    input  logic                         s_usr_bvalid_i,
    input  logic                         s_usr_arready_i,
    input  logic                         s_usr_rvalid_i,
    output logic [ `AXI4_DATA_WIDTH-1:0] s_usr_dat_o
);

  assign awready = s_usr_awready_i;
  assign wready  = s_usr_wready_i;
  assign bvalid  = s_usr_bvalid_i;
  assign arready = s_usr_arready_i;
  assign rvalid  = s_usr_rvalid_i;
  // AXI has the following rules governing the use of bursts:
  // - a burst must not cross a 4KB address boundary
  typedef enum logic [1:0] {
    FIXED = 2'b00,
    INCR  = 2'b01,
    WRAP  = 2'b10
  } axi4_burst_t;

  typedef struct packed {
    logic [`AXI4_ID_WIDTH-1:0]   id;
    logic [`AXI4_ADDR_WIDTH-1:0] addr;
    logic [7:0]                  len;
    logic [2:0]                  size;
    axi4_burst_t                 burst;
  } axi4_req_t;

  typedef enum logic [2:0] {
    IDLE,
    READ,
    WRITE,
    SEND_B,
    WAIT_WVALID
  } axi4_fsm_t;

  axi4_req_t s_axi_req_d, s_axi_req_q;
  axi4_fsm_t s_state_d, s_state_q;
  logic [7:0] s_trans_cnt_d, s_trans_cnt_q;
  logic [    `AXI4_ADDR_WIDTH-1:0] s_trans_nxt_addr;
  logic [`AXI4_ADDR_OFT_WIDTH-1:0] s_oft_addr;

  assign s_trans_nxt_addr = {s_axi_req_q.addr[`AXI4_ADDR_WIDTH-1:`AXI4_ADDR_OFT_WIDTH], s_oft_addr};
  axi4_addr_gen u_axi4_addr_gen (
      .alen_i  (s_axi_req_q.len),
      .asize_i (s_axi_req_q.size),
      .aburst_i(s_axi_req_q.burst),
      .addr_i  (s_axi_req_q.addr[`AXI4_ADDR_OFT_WIDTH-1:0]),
      .addr_o  (s_oft_addr)
  );

  always_comb begin
    s_state_d        = s_state_q;
    s_axi_req_d      = s_axi_req_q;
    s_axi_req_d.addr = s_trans_nxt_addr;
    s_trans_cnt_d    = s_trans_cnt_q;
    // usr
    s_usr_dat_o      = wdata;
    s_usr_bm_i       = wstrb;
    s_usr_wen_o      = 1'b0;
    s_usr_en_o       = 1'b0;
    s_usr_addr_o     = '0;
    // axi4 request
    // awready          = 1'b0;
    // arready          = 1'b0;
    // axi4 read
    // rvalid           = 1'b0;
    rdata            = s_usr_dat_i;
    rresp            = '0;
    rlast            = '0;
    rid              = s_axi_req_q.id;
    ruser            = 1'b0;
    // axi4 write
    // wready           = 1'b0;
    // axi4 response
    // bvalid           = 1'b0;
    bresp            = 1'b0;
    bid              = 1'b0;
    buser            = 1'b0;

    case (s_state_q)
      IDLE: begin
        if (arvalid && arready) begin
          s_axi_req_d   = {arid, araddr, arlen, arsize, arburst};
          s_state_d     = READ;
          //  we can request the first address, this saves us time
          s_usr_en_o    = 1'b1;
          s_usr_addr_o  = araddr[USR_ADDR_WIDTH-1:`AXI4_DATA_BLOG];
          s_trans_cnt_d = 1;
        end else if (awvalid && awready) begin
          s_axi_req_d  = {awid, awaddr, awlen, awsize, awburst};
          s_usr_addr_o = awaddr[USR_ADDR_WIDTH-1:`AXI4_DATA_BLOG];
          // we've got our first wvalid so start the write process
          if (wvalid && wready) begin
            s_usr_en_o    = 1'b1;
            s_usr_wen_o   = 1'b1;

            s_state_d     = (wlast) ? SEND_B : WRITE;
            s_trans_cnt_d = 1;
            // we still have to wait for the first wvalid to arrive
          end else s_state_d = WAIT_WVALID;
        end
      end

      // we are still missing a wvalid
      WAIT_WVALID: begin
        s_usr_addr_o = s_axi_req_q.addr[USR_ADDR_WIDTH-1:`AXI4_DATA_BLOG];
        // we can now make our first request
        if (wvalid && wready) begin
          s_usr_en_o    = 1'b1;
          s_usr_wen_o   = 1'b1;
          s_state_d     = (wlast) ? SEND_B : WRITE;
          s_trans_cnt_d = 1;
        end
      end

      READ: begin
        // keep request to memory high
        s_usr_en_o   = 1'b1;
        s_usr_addr_o = s_axi_req_q.addr[USR_ADDR_WIDTH-1:`AXI4_DATA_BLOG];
        // send the response
        rdata        = s_usr_dat_i;
        rid          = s_axi_req_q.id;
        rlast        = (s_trans_cnt_q == s_axi_req_q.len + 1);

        // check that the master is ready, the axi4 must not wait on this
        if (rready && rvalid) begin
          // handle the correct burst type
          case (s_axi_req_q.burst)
            FIXED, INCR: s_usr_addr_o = s_axi_req_q.addr[USR_ADDR_WIDTH-1:`AXI4_DATA_BLOG];
            default:     s_usr_addr_o = '0;
          endcase
          // we need to change the address here for the upcoming request
          // we sent the last byte -> go back to idle
          if (rlast) begin
            s_state_d  = IDLE;
            // we already got everything
            s_usr_en_o = 1'b0;
          end
          // we can decrease the counter as the master has consumed the read data
          s_trans_cnt_d = s_trans_cnt_q + 1;
        end
      end

      WRITE: begin
        // consume a word here
        if (wvalid && wready) begin
          s_usr_en_o  = 1'b1;
          s_usr_wen_o = 1'b1;
          // handle the correct burst type
          case (s_axi_req_q.burst)
            FIXED, INCR: s_usr_addr_o = s_axi_req_q.addr[USR_ADDR_WIDTH-1:`AXI4_DATA_BLOG];
            default:     s_usr_addr_o = '0;
          endcase
          // we can decrease the counter as the master has consumed the read data
          s_trans_cnt_d = s_trans_cnt_q + 1;

          if (wlast) s_state_d = SEND_B;
        end
      end
      SEND_B: begin
        bid = s_axi_req_q.id;
        if (bready && bvalid) s_state_d = IDLE;
      end
    endcase
  end


  dffr #(8) u_cnt_dffr (
      aclk,
      aresetn,
      s_trans_cnt_d,
      s_trans_cnt_q
  );

  always_ff @(posedge aclk, negedge aresetn) begin
    if (~aresetn) begin
      s_state_q   <= #1 IDLE;
      s_axi_req_q <= #1'0;
    end else begin
      s_state_q   <= #1 s_state_d;
      s_axi_req_q <= #1 s_axi_req_d;
    end
  end
endmodule

`endif
