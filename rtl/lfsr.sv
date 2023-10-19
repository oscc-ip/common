// Copyright (c) 2023 Beijing Institute of Open Source Chip
// timer is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

module lfsr_galois #(
    parameter int          DATA_WIDTH = 32,
    parameter int unsigned SEED       = 0
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  logic [DATA_WIDTH-1:0] s_shift_d, s_shift_q;

  assign s_shift_d[0]              = s_shift_q[1];
  assign s_shift_d[DATA_WIDTH-1:0] = s_shift_q[0];
  for (genvar i = 1; i < DATA_WIDTH - 1; i++) begin
    assign s_shift_d[i] = s_shift_q[i+1] ^ s_shift_q[i-1];
  end

  dffrc #(32, SEED) u_shift_dffrc (
      clk_i,
      rst_n_i,
      s_shift_d,
      s_shift_q
  );


endmodule

module lfsr_fibonacci ();
endmodule
