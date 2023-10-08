// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

module sync #(
    parameter int STATE      = 2,
    parameter int DATA_WIDTH = 1
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  logic [DATA_WIDTH-1:0] r_sync_dat[0:STATE-1];
  for (genvar i = 0; i < STATE; i++) begin
    if (i == 0) begin
      dffr #(DATA_WIDTH) u_sync_dffr (
          clk_i,
          rst_n_i,
          dat_i,
          r_sync_dat[0]
      );
    end else begin
      dffr #(DATA_WIDTH) u_sync_dffr (
          clk_i,
          rst_n_i,
          r_sync_dat[i-1],
          r_sync_dat[i]

      );
    end
  end

  assign dat_o = r_sync_dat[STATE-1];
endmodule
