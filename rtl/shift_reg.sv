// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_SHIFT_REG_SV
`define INC_SHIFT_REG_SV

`include "register.sv"

// verilog_format: off
`define SHIFT_REG_TYPE_ARICH 2'b00
`define SHIFT_REG_TYPE_LOGIC 2'b01
`define SHIFT_REG_TYPE_LOOP  2'b10
`define SHIFT_REG_TYPE_SERI  2'b11

`define SHIFT_REG_DIR_KEEP   2'b00
`define SHIFT_REG_DIR_LEFT   2'b01
`define SHIFT_REG_DIR_RIGHT  2'b10
// verilog_format: on

// NOTE: assure DATA_WIDTH >= 2
module shift_reg #(
    parameter int DATA_WIDTH = 8
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic [           1:0] type_i,
    input  logic [           1:0] dir_i,
    input  logic [           1:0] ld_en_i,
    input  logic                  sft_en_i,
    input  logic                  ser_dat_i,
    input  logic [DATA_WIDTH-1:0] par_data_i,
    output logci                  ser_dat_o,
    output logic [DATA_WIDTH-1:0] par_data_o
);

  logic [DATA_WIDTH-1:0] s_sf_d, s_sf_q;
  logic s_sf_en;

  assign ser_dat_o = dir_i == `SHIFT_REG_DIR_RIGHT ? s_sf_q[0] : s_sf_q[DATA_WIDTH-1];
  assign par_data_o = s_sf_q;

  assign s_sf_en = ld_en_i || (dir_i != `SHIFT_REG_DIR_KEEP && sft_en_i);
  always_comb begin
    if (ld_en_i) begin
      s_sf_d = par_data_i;
    end else begin
      s_sf_d = s_sf_q;
      unique case (dir_i)
        `SHIFT_REG_DIR_KEEP: s_sf_d = s_sf_q;
        `SHIFT_REG_DIR_LEFT: begin
          s_sf_d[DATA_WIDTH-1:1] = s_sf_q[DATA_WIDTH-2:0];
          unique case (type_i)
            `SHIFT_REG_TYPE_ARICH: s_sf_d[0] = 1'b0;
            `SHIFT_REG_TYPE_LOGIC: s_sf_d[0] = 1'b0;
            `SHIFT_REG_TYPE_LOOP: s_sf_d[0] = s_sf_q[DATA_WIDTH-1];
            `SHIFT_REG_TYPE_SERI: s_sf_d[0] = ser_dat_i;
            default: s_sf_d[0] = 1'b0;
          endcase
        end
        `SHIFT_REG_DIR_RIGHT: begin
          s_sf_d[DATA_WIDTH-2:0] = s_sf_q[DATA_WIDTH-1:1];
          unique case (type_i)
            `SHIFT_REG_TYPE_ARICH: s_sf_d[DATA_WIDTH-1] = s_sf_q[DATA_WIDTH-1] == 1'b1;
            `SHIFT_REG_TYPE_LOGIC: s_sf_d[DATA_WIDTH-1] = 1'b0;
            `SHIFT_REG_TYPE_LOOP: s_sf_d[DATA_WIDTH-1] = s_sf_q[0];
            `SHIFT_REG_TYPE_SERI: s_sf_d[DATA_WIDTH-1] = ser_dat_i;
            default: s_sf_d[DATA_WIDTH-1] = 1'b0;
          endcase
        end
        default: s_sf_d = s_sf_q;
      endcase
    end
  end
  dffer #(DATA_WIDTH) u_sf_dffer (
      clk_i,
      rst_n_i,
      s_sf_en,
      s_sf_d,
      s_sf_q
  );
endmodule

`endif
