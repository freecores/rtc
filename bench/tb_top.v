//////////////////////////////////////////////////////////////////////
////                                                              ////
////  RTC Testbench Top                                           ////
////                                                              ////
////  This file is part of the RTC project                        ////
////  http://www.opencores.org/cores/rtc/                         ////
////                                                              ////
////  Description                                                 ////
////  Top level of testbench. It instantiates all blocks.         ////
////                                                              ////
////  To Do:                                                      ////
////   Nothing                                                    ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
//

`include "timescale.vh"

module tb_top;

parameter aw = 16;
parameter dw = 32;

//
// Interconnect wires
//
wire			clk;	// Clock
wire			rst;	// Reset
wire			cyc;	// Cycle valid
wire	[aw-1:0]	adr;	// Address bus
wire	[dw-1:0]	dat_m;	// Data bus from RTC to WBM
wire	[3:0]		sel;	// Data selects
wire			we;	// Write enable
wire			stb;	// Strobe
wire	[dw-1:0]	dat_rtc;// Data bus from WBM to RTC
wire			ack;	// Successful cycle termination
wire			err;	// Failed cycle termination
wire			rtc_clk;// External RTC clock

//
// Instantiation of Clock/Reset Generator
//
clkrst clkrst(
	// Clock
	.clk_o(clk),
	// Reset
	.rst_o(rst),
	// External clock
	.rtc_clk(rtc_clk)
);

//
// Instantiation of Master WISHBONE BFM
//
wb_master wb_master(
	// WISHBONE Interface
	.CLK_I(clk),
	.RST_I(rst),
	.CYC_O(cyc),
	.ADR_O(adr),
	.DAT_O(dat_rtc),
	.SEL_O(sel),
	.WE_O(we),
	.STB_O(stb),
	.DAT_I(dat_m),
	.ACK_I(ack),
	.ERR_I(err),
	.RTY_I(0),
	.TAG_I(4'b0)
);

//
// Instantiation of RTC core
//
rtc rtc(
	// WISHBONE Interface
	.clk_i(clk),
	.rst_i(rst),
	.cyc_i(cyc),
	.adr_i(adr),
	.dat_i(dat_rtc),
	.sel_i(sel),
	.we_i(we),
	.stb_i(stb),
	.dat_o(dat_m),
	.ack_o(ack),
	.err_o(err),
	.inta_o(),

	// External RTC Interface
	.rtc_clk(rtc_clk)
);

endmodule
