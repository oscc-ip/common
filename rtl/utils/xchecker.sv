
`ifndef INC_XCHECKER_SV
`define INC_XCHECKER_SV

module xchecker #(
    parameter DATA_WIDTH = 1
) (
    input logic                  clk_i,
    input logic [DATA_WIDTH-1:0] dat_i
);

  XCHECKER :
  assert property (@(posedge clk_i) ((^(dat_i)) !== 1'bx))
  else
    $fatal("\n [error]: detected x value here which can lead to the x state propagation problem\n");

endmodule
`endif
