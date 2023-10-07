// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

// need to use high freq clk to oversample the dat edge with sync
module edge_det (
    input  logic clk_i,
    input  logic rst_n_i,
    input  logic dat_i,
    output logic re_o,
    output logic fe_o
);

  logic s_dat_d, s_dat_q;
  sync u_sync (
      .clk_i,
      .rst_n_i,
      .dat_i,
      .dat_o(s_dat_d)
  );

  dffr u_dffr (
      .clk_i,
      .rst_n_i,
      .dat_i(s_dat_d),
      .dat_o(s_dat_q)
  );

  assign re_o = (~s_dat_q) & s_dat_d;
  assign fe_o = s_dat_q & (~s_dat_d);
endmodule
