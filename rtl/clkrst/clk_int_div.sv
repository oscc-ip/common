// Copyright (C) 2022 ETH Zurich, University of Bologna Copyright and related
// rights are licensed under the Solderpad Hardware License, Version 0.51 (the
// "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law or
// agreed to in writing, software, hardware and materials distributed under this
// License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
// OF ANY KIND, either express or implied. See the License for the specific
// language governing permissions and limitations under the License.
// SPDX-License-Identifier: SHL-0.51
//
// -- Adaptable modifications are redistributed under compatible License --
//
// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

module clk_int_even_div_static #(
    parameter int DIV_VALUE = 2
) (
    input  logic clk_i,
    input  logic rst_n_i,
    output logic clk_o
);
  if (DIV_VALUE <= 0 || DIV_VALUE % 2) begin
    $error("DIV_VALUE must be strictly larger than 0 and be even value");
  end

  localparam int DIV_VALUE_WIDTH = $clog2(DIV_VALUE) + 1;
  logic [DIV_VALUE_WIDTH-1:0] s_cnt_d, s_cnt_q;
  logic s_clk_d, s_clk_q;

  always_comb begin
    s_cnt_d = s_cnt_q + 1'b1;
    if (s_cnt_q == DIV_VALUE / 2 - 1) begin
      s_cnt_d = '0;
    end
  end

  dffr #(DIV_VALUE_WIDTH) u_cnt_dffr (
      clk_i,
      rst_n_i,
      s_cnt_d,
      s_cnt_q
  );

  always_comb begin
    s_clk_d = s_clk_q;
    if (s_cnt_q == DIV_VALUE / 2 - 1) begin
      s_clk_d = ~s_clk_q;
    end
  end

  dffr #(1) u_clk_dffr (
      clk_i,
      rst_n_i,
      s_clk_d,
      s_clk_q
  );

  //   clk_buf(s_clk_q, clk_o);
  assign clk_o = s_clk_q;
endmodule

module clk_int_odd_div_static #(
    parameter int DIV_VALUE = 3
) (
    input  logic clk_i,
    input  logic rst_n_i,
    output logic clk_o
);
  if (DIV_VALUE < 2 || DIV_VALUE % 2 == 0) begin
    $error("DIV_VALUE must be strictly larger than 0 and be odd value");
  end

  localparam int DIV_VALUE_WIDTH = $clog2(DIV_VALUE) + 1;
  logic [DIV_VALUE_WIDTH-1:0] s_cnt_d, s_cnt_q;
  logic s_clk1_d, s_clk1_q, s_clk2_d, s_clk2_q;

  always_comb begin
    s_cnt_d = s_cnt_q + 1'b1;
    if (s_cnt_q == DIV_VALUE - 1) begin
      s_cnt_d = '0;
    end
  end

  dffr #(DIV_VALUE_WIDTH) u_cnt_dffr (
      clk_i,
      rst_n_i,
      s_cnt_d,
      s_cnt_q
  );

  always_comb begin
    s_clk1_d = s_clk1_q;
    if (s_cnt_q == (DIV_VALUE - 1) / 2 - 1) begin
      s_clk1_d = ~s_clk1_q;
    end
  end

  dffr #(1) u_clk1_dffr (
      clk_i,
      rst_n_i,
      s_clk1_d,
      s_clk1_q
  );

  always_comb begin
    s_clk2_d = s_clk2_q;
    if (s_cnt_q == DIV_VALUE - 1) begin
      s_clk2_d = ~s_clk2_q;
    end
  end

  ndffr #(1) u_clk_ndffr (
      clk_i,
      rst_n_i,
      s_clk2_d,
      s_clk2_q
  );

  clk_xor2 u_clk_xor2 (
      s_clk1_q,
      s_clk2_q,
      clk_o
  );
endmodule

module clk_int_even_div #(
    parameter int DIV_VALUE             = 2,
    parameter bit ENABLE_CLOCK_IN_RESET = 1'b0
) (
    input  logic clk_i,
    input  logic rst_n_i,
    input  logic en_i,
    input  logic div_i,
    input  logic div_valid_i,
    output logic div_ready_o,
    output logic clk_o
);


endmodule
