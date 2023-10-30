// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

interface axi4_if #(
    parameter int AXI_ADDR_WIDTH = 32,
    parameter int AXI_DATA_WIDTH = 64,
    parameter int AXI_ID_WIDTH   = 4,
    parameter int AXI_USER_WIDTH = 4
) (
    input logic aclk,
    input logic aresetn
);
  logic [          AXI_ID_WIDTH-1:0] awid;
  logic [        AXI_ADDR_WIDTH-1:0] awaddr;
  logic [                       7:0] awlen;
  logic [                       2:0] awsize;
  logic [                       1:0] awburst;
  logic                              awlock;
  logic [                       3:0] awcache;
  logic [                       2:0] awprot;
  logic [                       3:0] awqos;
  logic [                       3:0] awregion;
  logic [        AXI_USER_WIDTH-1:0] awuser;
  logic                              awvalid;
  logic                              awready;

  logic [          AXI_ID_WIDTH-1:0] wid;
  logic [        AXI_DATA_WIDTH-1:0] wdata;
  logic [$clog2(AXI_DATA_WIDTH)-1:0] wstrb;
  logic                              wlast;
  logic [        AXI_USER_WIDTH-1:0] wuser;
  logic                              wvalid;
  logic                              wready;

  logic [          AXI_ID_WIDTH-1:0] bid;
  logic [                       1:0] bresp;
  logic [        AXI_USER_WIDTH-1:0] buser;
  logic                              bvalid;
  logic                              bready;

  logic [          AXI_ID_WIDTH-1:0] arid;
  logic [        AXI_ADDR_WIDTH-1:0] araddr;
  logic [                       7:0] arlen;
  logic [                       2:0] arsize;
  logic [                       1:0] arburst;
  logic                              arlock;
  logic [                       3:0] arcache;
  logic [                       2:0] arprot;
  logic [                       3:0] arqos;
  logic [                       3:0] arregion;
  logic [        AXI_USER_WIDTH-1:0] aruser;
  logic                              arvalid;
  logic                              arready;

  logic [          AXI_ID_WIDTH-1:0] rid;
  logic [        AXI_DATA_WIDTH-1:0] rdata;
  logic [                       1:0] rresp;
  logic                              rlast;
  logic [        AXI_USER_WIDTH-1:0] ruser;
  logic                              rvalid;
  logic                              rready;

  modport slave(
      input awid,
      input awaddr,
      input awlen,
      input awsize,
      input awburst,
      input awlock,
      input awcache,
      input awprot,
      input awqos,
      input awregion,
      input awuser,
      input awvalid,
      output awready,

      input wid,
      input wdata,
      input wstrb,
      input wlast,
      input wuser,
      input wvalid,
      output wready,

      output bid,
      output bresp,
      output buser,
      output bvalid,
      input bready,

      input arid,
      input araddr,
      input arlen,
      input arsize,
      input arburst,
      input arlock,
      input arcache,
      input arprot,
      input arqos,
      input arregion,
      input aruser,
      input arvalid,
      output arready,

      output rid,
      output rdata,
      output rresp,
      output rlast,
      output ruser,
      output rvalid,
      input rready
  );

  modport master(
      output awid,
      output awaddr,
      output awlen,
      output awsize,
      output awburst,
      output awlock,
      output awcache,
      output awprot,
      output awqos,
      output awregion,
      output awuser,
      output awvalid,
      input awready,

      output wid,
      output wdata,
      output wstrb,
      output wlast,
      output wuser,
      output wvalid,
      input wready,

      input bid,
      input bresp,
      input buser,
      input bvalid,
      output bready,

      output arid,
      output araddr,
      output arlen,
      output arsize,
      output arburst,
      output arlock,
      output arcache,
      output arprot,
      output arqos,
      output arregion,
      output aruser,
      output arvalid,
      input arready,

      input rid,
      input rdata,
      input rresp,
      input rlast,
      input ruser,
      input rvalid,
      output rready
  );

endinterface
