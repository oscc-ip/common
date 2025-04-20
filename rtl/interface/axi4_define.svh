// Copyright (c) 2023-2025 Yuchi Miao <miaoyuchi@ict.ac.cn>
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_AXI4_DEF_SVH
`define INC_AXI4_DEF_SVH

// verilog_format: off
`define AXI4_ADDR_WIDTH          32
`define AXI4_ADDR_OFT_WIDTH      12 // no cross 4KB
`define AXI4_DATA_WIDTH          64
`define AXI4_WSTRB_WIDTH         (`AXI4_DATA_WIDTH / 8)
`define AXI4_DATA_BYTES          (`AXI4_DATA_WIDTH / 8)
`define AXI4_DATA_BLOG           $clog2(`AXI4_DATA_BYTES)
`define AXI4_USER_WIDTH          4
`define AXI4_ID_WIDTH            4

`define AXI4_BURST_SIZE_1BYTE    3'b000
`define AXI4_BURST_SIZE_2BYTES   3'b001
`define AXI4_BURST_SIZE_4BYTES   3'b010
`define AXI4_BURST_SIZE_8BYTES   3'b011
`define AXI4_BURST_SIZE_16BYTES  3'b100
`define AXI4_BURST_SIZE_32BYTES  3'b101
`define AXI4_BURST_SIZE_64BYTES  3'b110
`define AXI4_BURST_SIZE_128BYTES 3'b111

`define AXI4_BURST_TYPE_FIXED    2'b00
`define AXI4_BURST_TYPE_INCR     2'b01
`define AXI4_BURST_TYPE_WRAP     2'b10
`define AXI4_BURST_TYPE_RESV     2'b11

`define AXI4_LOCK_NORM           1'b0
`define AXI4_LOCK_EXCL           1'b1

`define AXI4_CACHE_NO_BUF        4'b0000

`define AXI4_PROT_NORMAL         3'b000
`define AXI4_PROT_PRIVILEGED     3'b001
`define AXI4_PROT_SECURE         3'b000
`define AXI4_PROT_NONSECURE      3'b010
`define AXI4_PROT_DATA           3'b000
`define AXI4_PROT_INSTRUCTION    3'b100

`define AXI4_QOS_NORMAL          4'b0000

`define AXI4_REGION_NORMAL       4'b0000

`define AXI4_RESP_OKAY           2'b00
`define AXI4_RESP_EXOKAY         2'b01
`define AXI4_RESP_SLAVE_ERROR    2'b10
`define AXI4_RESP_DECODE_ERROR   2'b11
// verilog_format: on

`endif
