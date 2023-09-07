interface apb4_if #(
    parameter APB_ADDR_WIDTH = 32,
    parameter APB_DATA_WIDTH = 32
) (
    input logic pclk,
    input logic presetn
);

  logic [  APB_ADDR_WIDTH-1:0] paddr;
  logic [                 2:0] pprot;
  logic                        psel;
  logic                        penable;
  logic                        pwrite;
  logic [  APB_DATA_WIDTH-1:0] pwdata;
  logic [APB_DATA_WIDTH/8-1:0] pstrb;
  logic                        pready;
  logic [  APB_DATA_WIDTH-1:0] prdata;
  logic                        pslverr;

  modport slave(
      input paddr,
      input pprot,
      input psel,
      input penable,
      input pwrite,
      input pwdata,
      input pstrb,
      output pready,
      output prdata,
      output pslverr
  );

  modport master(
      output paddr,
      output pprot,
      output psel,
      output penable,
      output pwrite,
      output pwdata,
      output pstrb,
      input pready,
      input prdata,
      input pslverr
  );

endinterface
