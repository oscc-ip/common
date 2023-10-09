// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

module clk_int_even_div #(
    parameter int DIV_VALUE = 2
) (
    input  logic clk_i,
    input  logic rst_n_i,
    input  logic en_i,
    output logic clk_o
);

endmodule


module clk_int_odd_div #(
    parameter int DIV_VALUE = 1
) (
    input  logic clk_i,
    input  logic rst_n_i,
    input  logic en_i,
    output logic clk_o
);

endmodule
