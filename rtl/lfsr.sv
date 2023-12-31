// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_LFSR_SV
`define INC_LFSR_SV

`include "register.sv"

//https://en.wikipedia.org/wiki/Linear-feedback_shift_register
// MSB -> LSB [DATA_WIDTH-1:0]
module lfsr_galois #(
    parameter int                    DATA_WIDTH = 32,
    parameter logic [DATA_WIDTH-1:0] POLY       = '0
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic                  wr_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  logic [DATA_WIDTH-1:0] s_shift_d, s_shift_q;
  for (genvar i = 0; i < DATA_WIDTH; i++) begin
    if (i == DATA_WIDTH - 1) begin
      assign s_shift_d[i] = wr_i ? dat_i[i] : s_shift_q[0];
    end else begin
      if (POLY & (1 << i)) begin
        assign s_shift_d[i] = wr_i ? dat_i[i] : s_shift_q[i+1] ^ s_shift_q[0];
      end else begin
        assign s_shift_d[i] = wr_i ? dat_i[i] : s_shift_q[i+1];
      end
    end
  end

  assign dat_o = s_shift_q;
  dffr #(DATA_WIDTH) u_shift_dffr (
      clk_i,
      rst_n_i,
      s_shift_d,
      s_shift_q
  );

endmodule

// due to the delay, more recommand to use galois type lfsr
// NOTE: this module is no ready for use, need more test
module lfsr_fibonacci #(
    parameter int DATA_WIDTH = 32,
    parameter int SEED       = 0
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic                  wr_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  logic [DATA_WIDTH-1:0] s_shift_d, s_shift_q;

  assign dat_o = s_shift_q;
  for (genvar i = 0; i <= DATA_WIDTH - 1; i++) begin
    if (i == DATA_WIDTH - 1) begin
      assign s_shift_d[i] = wr_i ? dat_i[i] : s_shift_q[0] ^ s_shift_q[1];
    end else begin
      assign s_shift_d[i] = wr_i ? dat_i[i] : s_shift_q[i+1];
    end
  end

  dffrc #(DATA_WIDTH, SEED) u_shift_dffrc (
      clk_i,
      rst_n_i,
      s_shift_d,
      s_shift_q
  );

endmodule
`endif
