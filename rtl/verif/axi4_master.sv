// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_AXI4_MASTER_SV
`define INC_AXI4_MASTER_SV

`include "helper.sv"
`include "test_base.sv"
`include "axi4_define.sv"

class AXI4Master extends TestBase;
  string                                        name;
  logic                  [`AXI4_DATA_WIDTH-1:0] rd_data[$];
  logic                  [`AXI4_DATA_WIDTH-1:0] wr_data[$];
  virtual axi4_if.master                        axi4;

  extern function new(string name = "axi4_master", virtual axi4_if.master axi4);
  extern task automatic init();
  extern task automatic write(
      input bit [`AXI4_ID_WIDTH-1:0] id, input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
      input bit [2:0] size, input bit [1:0] burst, input bit [`AXI4_DATA_WIDTH-1:0] data[$],
      input bit [`AXI4_DATA_WIDTH/8-1:0] strb);

  extern task automatic read(input bit [`AXI4_ID_WIDTH-1:0] id,
                             input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
                             input bit [2:0] size, input bit [1:0] burst);
  // extern task automatic wr_rd_check(input bit [31:0] addr, string name, input bit [63:0] data,
  //                                   input Helper::cmp_t cmp_type,
  //                                   input Helper::log_lev_t log_level = Helper::NORM);
  extern task automatic wr_check(
      input bit [`AXI4_ID_WIDTH-1:0] id, input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
      input bit [2:0] size, input bit [1:0] burst, input bit [`AXI4_DATA_WIDTH-1:0] data[$],
      input bit [`AXI4_DATA_WIDTH/8-1:0] strb, input bit [`AXI4_DATA_WIDTH-1:0] ref_data[$],
      input Helper::cmp_t cmp_type, input Helper::log_lev_t log_level = Helper::NORM);

  extern task automatic rd_check(
      input bit [`AXI4_ID_WIDTH-1:0] id, input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
      input bit [2:0] size, input bit [1:0] burst, input bit [`AXI4_DATA_WIDTH-1:0] ref_data[$],
      input Helper::cmp_t cmp_type, input Helper::log_lev_t log_level = Helper::NORM);
endclass

function AXI4Master::new(string name, virtual axi4_if.master axi4);
  super.new();
  this.name    = name;
  this.rd_data = {};
  this.wr_data = {};
  this.axi4    = axi4;
endfunction

task automatic AXI4Master::init();
  this.axi4.awid     = '0;
  this.axi4.awaddr   = 'x;
  this.axi4.awlen    = '0;
  this.axi4.awsize   = `AXI4_BURST_SIZE_1BYTE;
  this.axi4.awburst  = `AXI4_BURST_TYPE_FIXED;
  this.axi4.awlock   = `AXI4_LOCK_NORM;
  this.axi4.awcache  = `AXI4_CACHE_NO_BUF;
  this.axi4.awprot   = `AXI4_PROT_NORMAL;
  this.axi4.awqos    = `AXI4_QOS_NORMAL;
  this.axi4.awregion = `AXI4_REGION_NORMAL;
  this.axi4.awvalid  = '0;

  this.axi4.wdata    = 'x;
  this.axi4.wstrb    = '0;
  this.axi4.wlast    = '0;
  this.axi4.wuser    = '0;
  this.axi4.wvalid   = '0;

  this.axi4.bready   = '0;

  this.axi4.arid     = '0;
  this.axi4.araddr   = 'x;
  this.axi4.arlen    = '0;
  this.axi4.arsize   = `AXI4_BURST_SIZE_1BYTE;
  this.axi4.arburst  = `AXI4_BURST_TYPE_FIXED;
  this.axi4.arlock   = `AXI4_LOCK_NORM;
  this.axi4.arcache  = `AXI4_CACHE_NO_BUF;
  this.axi4.arprot   = `AXI4_PROT_NORMAL;
  this.axi4.arqos    = `AXI4_QOS_NORMAL;
  this.axi4.arregion = `AXI4_REGION_NORMAL;
  this.axi4.arvalid  = '0;

  this.axi4.rready   = '0;

  Helper::print("axi4 master device init done");
endtask

task automatic AXI4Master::write(
    input bit [`AXI4_ID_WIDTH-1:0] id, input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
    input bit [2:0] size, input bit [1:0] burst, input bit [`AXI4_DATA_WIDTH-1:0] data[$],
    input bit [`AXI4_DATA_WIDTH/8-1:0] strb);

  // aw channel
  @(posedge this.axi4.aclk);
  #1;
  this.axi4.awid    = id;
  this.axi4.awaddr  = addr;
  this.axi4.awlen   = len + 1'b1;
  this.axi4.awsize  = size;
  this.axi4.awburst = burst;
  this.axi4.awvalid = 1'b1;

  @(posedge this.axi4.aclk);
  while (~this.axi4.awready) begin
    @(posedge this.axi4.aclk);
  end
  #1;
  $display("%t aw trigger", $time);

  this.axi4.awid    = '0;
  this.axi4.awaddr  = 'x;
  this.axi4.awlen   = '0;
  this.axi4.awsize  = `AXI4_BURST_SIZE_1BYTE;
  this.axi4.awburst = `AXI4_BURST_TYPE_FIXED;
  this.axi4.awvalid = '0;

  // w burst channel
  for (int i = 0; i < len + 1'b1; i++) begin
    this.axi4.wdata  = data.pop_front();
    this.axi4.wstrb  = strb;
    this.axi4.wlast  = i == len;
    this.axi4.wvalid = 1'b1;
    @(posedge this.axi4.aclk);
    while (~this.axi4.wready) begin
      @(posedge this.axi4.aclk);
    end
    #1;
    $display("%t w burst trigger", $time);
  end

  this.axi4.wdata  = 'x;
  this.axi4.wstrb  = '0;
  this.axi4.wlast  = '0;
  this.axi4.wvalid = '0;

  this.axi4.bready = 1'b1;
  @(posedge this.axi4.aclk);
  while (~this.axi4.bvalid) begin
    @(posedge this.axi4.aclk);
  end

  if (this.axi4.bid != id) begin
    $error("%t [wr mismatch id] awid is %d, bid: %d", $time, id, this.axi4.bid);
  end
  #1;
  this.axi4.bready = 1'b0;
endtask

task automatic AXI4Master::read(input bit [`AXI4_ID_WIDTH-1:0] id,
                                input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
                                input bit [2:0] size, input bit [1:0] burst);
  this.rd_data = {};
  // ar channel
  @(posedge this.axi4.aclk);
  #1;
  this.axi4.arid    = id;
  this.axi4.araddr  = addr;
  this.axi4.arlen   = len + 1'b1;
  this.axi4.arsize  = size;
  this.axi4.arburst = burst;
  this.axi4.arvalid = 1'b1;

  @(posedge this.axi4.aclk);
  while (~this.axi4.arready) begin
    @(posedge this.axi4.aclk);
  end
  #1;

  this.axi4.arid    = '0;
  this.axi4.araddr  = 'x;
  this.axi4.arlen   = '0;
  this.axi4.arsize  = `AXI4_BURST_SIZE_1BYTE;
  this.axi4.arburst = `AXI4_BURST_TYPE_FIXED;
  this.axi4.arvalid = '0;

  // r burst channel
  this.axi4.rready  = 1'b1;
  for (int i = 0; i < len + 1'b1; i++) begin
    @(posedge this.axi4.aclk);
    while (~this.axi4.rvalid) begin
      @(posedge this.axi4.aclk);
    end
    this.rd_data.push_back(this.axi4.rdata);
    // $display("%t: this.axi4.rdata: %h", $time, this.axi4.rdata);
    #1;
  end

  this.axi4.rready = 1'b0;
endtask

// task automatic AXI4Master::wr_rd_check(input bit [31:0] addr, string name, input bit [63:0] data,
//                                        input Helper::cmp_t cmp_type,
//                                        input Helper::log_lev_t log_level = Helper::NORM);
//   this.wr_data = data;
//   this.write(addr, this.wr_data);
//   this.read(addr);
//   Helper::check(name, this.rd_data, this.wr_data, cmp_type, log_level);

// endtask

task automatic AXI4Master::wr_check(
    input bit [`AXI4_ID_WIDTH-1:0] id, input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
    input bit [2:0] size, input bit [1:0] burst, input bit [`AXI4_DATA_WIDTH-1:0] data[$],
    input bit [`AXI4_DATA_WIDTH/8-1:0] strb, input bit [`AXI4_DATA_WIDTH-1:0] ref_data[$],
    input Helper::cmp_t cmp_type, input Helper::log_lev_t log_level = Helper::NORM);

  this.wr_data = data;
  this.write(id, addr, len, size, burst, this.wr_data, strb);
  Helper::check_queue(name, this.wr_data, ref_data, cmp_type, log_level);
endtask

task automatic AXI4Master::rd_check(
    input bit [`AXI4_ID_WIDTH-1:0] id, input bit [`AXI4_ADDR_WIDTH-1:0] addr, input bit [7:0] len,
    input bit [2:0] size, input bit [1:0] burst, input bit [`AXI4_DATA_WIDTH-1:0] ref_data[$],
    input Helper::cmp_t cmp_type, input Helper::log_lev_t log_level = Helper::NORM);

  this.read(id, addr, len, size, burst);
  Helper::check_queue(name, this.rd_data, ref_data, cmp_type, log_level);
endtask

`endif
