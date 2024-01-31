// Copyright 2018-2019 ETH Zurich and University of Bologna.
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
// Florian Zaruba <zarubaf@iis.ee.ethz.ch>
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

`ifndef INC_CDC_FIFO_SV
`define INC_CDC_FIFO_SV

`include "register.sv"
`include "cdc_sync.sv"
`include "bin2gray.sv"
`include "gray2bin.sv"

// verilog_format: off
(* no_ungroup *)
(* no_boundary_optimization *)
// verilog_format: on
module cdc_fifo #(
    parameter int DATA_WIDTH   = 32,
    parameter int BUFFER_DEPTH = 8,
    parameter int SYNC_STAGES  = 2
) (
    // input  logic                  flush_i,
    input  logic                  src_clk_i,
    input  logic                  src_rst_n_i,
    input  logic [DATA_WIDTH-1:0] src_data_i,
    input  logic                  src_push_i,
    output logic                  src_full_o,
    input  logic                  dst_clk_i,
    input  logic                  dst_rst_n_i,
    output logic [DATA_WIDTH-1:0] dst_data_o,
    output logic                  dst_empty_o,
    input  logic                  dst_pop_i
);

  logic [BUFFER_DEPTH-1:0][DATA_WIDTH-1:0] s_int_mem;
  logic [LOG_BUFFER_DEPTH:0] s_wr_ptr, s_rd_ptr;
  logic dst_valid_o;

  cdc_fifo_src #(DATA_WIDTH, BUFFER_DEPTH, SYNC_STAGES) u_cdc_fifo_src (
                  .clk_i         (src_clk_i),
                  .rst_n_i       (src_rst_n_i),
                  .data_i        (src_data_i),
                  .valid_i       (src_push_i),
                  .ready_o       (~src_full_o),
      (* async *) .async_data_o  (s_int_mem),
      (* async *) .async_wr_ptr_o(s_wr_ptr),
      (* async *) .async_rd_ptr_i(s_rd_ptr),
  );

  assign dst_empty_o = ~dst_valid_o;
  cdc_fifo_src #(DATA_WIDTH, BUFFER_DEPTH, SYNC_STAGES) u_cdc_fifo_dst (
                  .clk_i         (dst_clk_i),
                  .rst_n_i       (dst_rst_n_i),
                  .data_i        (dst_data_i),
                  .valid_o       (dst_valid_o),
                  .ready_i       (dst_pop_i),
      (* async *) .async_data_o  (s_int_mem),
      (* async *) .async_wr_ptr_o(s_wr_ptr),
      (* async *) .async_rd_ptr_i(s_rd_ptr),
  );
endmodule

// verilog_format: off
(* no_ungroup *)
(* no_boundary_optimization *)
// verilog_format: on
module cdc_fifo_src #(
    parameter int DATA_WIDTH   = 32,
    parameter int BUFFER_DEPTH = 8,
    parameter int SYNC_STAGES  = 2
) (
    input  logic                      clk_i,
    input  logic                      rst_n_i,
    input  logic [    DATA_WIDTH-1:0] data_i,
    input  logic                      valid_i,
    output logic                      ready_o,
    output logic [  BUFFER_DEPTH-1:0] async_data_o,
    output logic [LOG_BUFFER_DEPTH:0] async_wr_ptr_o,
    input  logic [LOG_BUFFER_DEPTH:0] async_rd_ptr_i
);
  localparam int LOG_BUFFER_DEPTH = (BUFFER_DEPTH > 1) ? $clog2(BUFFER_DEPTH) : 1;


endmodule

// verilog_format: off
(* no_ungroup *)
(* no_boundary_optimization *)
// verilog_format: on
module cdc_fifo_dst ();
endmodule
`endif
