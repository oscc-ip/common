// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_APB4_MASTER_SV
`define INC_APB4_MASTER_SV

`include "helper.sv"
`include "test_base.sv"

class APB4Master extends TestBase;
  string                        name;
  logic                  [31:0] rd_data;
  logic                  [31:0] wr_data;
  virtual apb4_if.master        apb4;

  extern function new(string name = "apb4_master", virtual apb4_if.master apb4);
  extern task init();
  extern task write(input bit [31:0] addr, input bit [31:0] data);
  extern task read(input bit [31:0] addr);
  extern task wr_check(input bit [31:0] addr, string name, input bit [31:0] data,
                       input Helper::cmp_t cmp_type,
                       input Helper::log_lev_t log_level = Helper::NORM);
  extern task rd_check(input bit [31:0] addr, string name, input bit [31:0] ref_data,
                       input Helper::cmp_t cmp_type,
                       input Helper::log_lev_t log_level = Helper::NORM);
  extern task test_reset_reg();
  extern task test_wr_rd_reg();
  extern task test_irq();
endclass

function APB4Master::new(string name, virtual apb4_if.master apb4);
  super.new();
  this.name = name;
  this.apb4 = apb4;
endfunction

task APB4Master::init();
  this.apb4.paddr   = 'x;
  this.apb4.psel    = '0;
  this.apb4.penable = '0;
  this.apb4.pwrite  = '0;
  this.apb4.pwdata  = 'x;
  this.apb4.pprot   = '0;
  this.apb4.pstrb   = '0;
  Helper::print("apb4 master device init done");
endtask

task APB4Master::write(input bit [31:0] addr, input bit [31:0] data);
  this.apb4.pprot = '0;
  @(posedge this.apb4.pclk);
  #1;
  this.apb4.paddr  = addr;
  this.apb4.psel   = 1'b1;
  this.apb4.pwrite = 1'b1;
  this.apb4.pwdata = data;
  this.apb4.pstrb  = '1;  // refer to APB4 LRM

  @(posedge this.apb4.pclk);
  #1;
  this.apb4.penable = 1'b1;
  @(posedge this.apb4.pclk && this.apb4.pready);
  #1;
  this.apb4.paddr   = 'x;
  this.apb4.psel    = '0;
  this.apb4.penable = '0;
  this.apb4.pwrite  = '0;
  this.apb4.pwdata  = 'x;
  this.apb4.pstrb   = '0;
endtask

task APB4Master::read(input bit [31:0] addr);
  logic [31:0] val;
  this.apb4.pprot = '0;
  this.apb4.pstrb = '0;
  @(posedge this.apb4.pclk);
  #1;
  this.apb4.paddr  = addr;
  this.apb4.psel   = 1'b1;
  this.apb4.pwrite = 1'b0;
  this.apb4.pwdata = 'x;

  @(posedge this.apb4.pclk);
  #1;
  this.apb4.penable = 1'b1;
  @(posedge this.apb4.pclk && this.apb4.pready);
  val          = this.apb4.prdata; // NOTE: read by posedge
  this.rd_data = val;
  #1;
  this.apb4.paddr   = 'x;
  this.apb4.psel    = '0;
  this.apb4.penable = '0;
  this.apb4.pwrite  = '0;
  this.apb4.pwdata  = 'x;


endtask

task APB4Master::wr_check(input bit [31:0] addr, string name, input bit [31:0] data,
                          input Helper::cmp_t cmp_type,
                          input Helper::log_lev_t log_level = Helper::NORM);
  this.wr_data = data;
  this.write(addr, this.wr_data);
  this.read(addr);
  Helper::check(name, this.rd_data, this.wr_data, cmp_type, log_level);

endtask

task APB4Master::rd_check(input bit [31:0] addr, string name, input bit [31:0] ref_data,
                          input Helper::cmp_t cmp_type,
                          input Helper::log_lev_t log_level = Helper::NORM);
  this.read(addr);
  Helper::check(name, this.rd_data, ref_data, cmp_type, log_level);
endtask

task APB4Master::test_reset_reg();
  $display("=== [test reset reg] ===");
endtask

task APB4Master::test_wr_rd_reg();
  $display("=== [test wr and rd reg] ===");
endtask

task APB4Master::test_irq();
  $display("=== [test irq] ===");
endtask

`endif
