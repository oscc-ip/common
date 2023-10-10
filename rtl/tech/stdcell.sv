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
    input  logic clk_i,
    output logic clk_o
);

  assign clk_o = clk_i;
endmodule

module clk_n (
    input  logic clk_i,
    output logic clk_o
);

  assign clk_o = ~clk_i;
endmodule

module clk_an2 (
    input  logic clk1_i,
    input  logic clk2_i,
    output logic clk_o
);

  assign clk_o = clk1_i & clk2_i;
endmodule


module clk_nd2 (
    input  logic clk1_i,
    input  logic clk2_i,
    output logic clk_o
);

  assign clk_o = ~(clk1_i & clk2_i);
endmodule

module clk_mux2 (
    input  logic clk1_i,
    input  logic clk2_i,
    input  logic en_i,
    output logic clk_o
);

  assign clk_o = en_i ? clk2_i : clk1_i;
endmodule

module clk_xor2 (
    input  logic clk1_i,
    input  logic clk2_i,
    output logic clk_o
);

  assign clk_o = clk1_i ^ clk2_i;
endmodule

module clk_icg (
    input  logic clk_i,
    input  logic en_i,
    input  logic te_i,
    output logic clk_o
);

  logic r_clk_en;
  always_latch begin
    if (clk_i == 1'b0) begin
      r_clk_en <= en_i | te_i;
    end
  end

  assign clk_o = clk_i & r_clk_en;
endmodule

module clk_icg2 (
    input  logic clk_i,
    input  logic en_i,
    input  logic te_i,
    output logic clk_o
);

  logic r_clk_en;
  always_latch begin
    if (clk_i == 1'b1) begin
      r_clk_en <= en_i | te_i;
    end
  end

  assign clk_o = clk_i | (~r_clk_en);
endmodule