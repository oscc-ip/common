// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

// this file only include behavioral model, for ASIC tape-out need to reimplement those models
module clk_buf (
    input  logic i_i,
    output logic z_o
);

  assign z_o = i_i;
endmodule

module clk_n (
    input  logic i_i,
    output logic zn_o
);

  assign zn_o = ~i_i;
endmodule

module clk_an2 (
    input  logic a1_i,
    input  logic a2_i,
    output logic z_o
);

  assign z_o = a1_i & a2_i;
endmodule


module clk_nd2 (
    input  logic a1_i,
    input  logic a2_i,
    output logic z_o
);

  assign z_o = ~(a1_i & a2_i);
endmodule

module clk_mux2 (
    input  logic a1_i,
    input  logic a2_i,
    input  logic s_i,
    output logic z_o
);

  assign z_o = s_i ? a2_i : a1_i;
endmodule

module clk_xor2 (
    input  logic a1_i,
    input  logic a2_i,
    output logic z_o
);

  assign z_o = a1_i ^ a2_i;
endmodule
