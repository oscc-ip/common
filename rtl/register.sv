// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

module dff #(
    parameter int DATA_WIDTH = 1
) (
    input  logic                  clk_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  always_ff @(posedge clk_i) begin
    dat_o <= dat_i;
  end
endmodule

module dffr #(
    parameter int DATA_WIDTH = 1
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  always_ff @(posedge clk_i, negedge rst_n_i) begin
    if (~rst_n_i) begin
      dat_o <= '0;
    end else begin
      dat_o <= dat_i;
    end
  end
endmodule

module dffsr #(
    parameter int DATA_WIDTH = 1
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  always_ff @(posedge clk_i) begin
    if (~rst_n_i) begin
      dat_o <= '0;
    end else begin
      dat_o <= dat_i;
    end
  end
endmodule

module dffl #(
    parameter int DATA_WIDTH = 1
) (
    input  logic                  clk_i,
    input  logic                  en_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  always_ff @(posedge clk_i) begin
    if (en_i) begin
      dat_o <= dat_i;
    end
  end
endmodule

module dfflr #(
    parameter int DATA_WIDTH = 1
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic                  en_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  always_ff @(posedge clk_i, negedge rst_n_i) begin
    if (~rst_n_i) begin
      dat_o <= '0;
    end else if (en_i) begin
      dat_o <= dat_i;
    end
  end
endmodule

module dfflsr #(
    parameter int DATA_WIDTH = 1
) (
    input  logic                  clk_i,
    input  logic                  rst_n_i,
    input  logic                  en_i,
    input  logic [DATA_WIDTH-1:0] dat_i,
    output logic [DATA_WIDTH-1:0] dat_o
);

  always_ff @(posedge clk_i) begin
    if (~rst_n_i) begin
      dat_o <= '0;
    end else if (en_i) begin
      dat_o <= dat_i;
    end
  end
endmodule
