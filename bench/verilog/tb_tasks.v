//////////////////////////////////////////////////////////////////////
////                                                              ////
////  RTC Testbench Tasks                                         ////
////                                                              ////
////  This file is part of the RTC project                        ////
////  http://www.opencores.org/cores/rtc/                         ////
////                                                              ////
////  Description                                                 ////
////  Testbench tasks.                                            ////
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
// Revision 1.2  2001/07/16 01:05:01  lampret
// Fixed some bugs in test bench. Added comments to tb_defines.v
//
// Revision 1.1  2001/06/05 07:45:41  lampret
// Added initial RTL and test benches. There are still some issues with these files.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

`include "defines.v"
`include "tb_defines.v"

module tb_tasks;

integer nr_failed;

//
// Count/report failed tests
//
task failed;
begin
	$display("FAILED !!!");
	nr_failed = nr_failed + 1;
end
endtask

//
// Set RTC_RRTC_TIME register
//
task settime;
input	[2:0] dow;
input	[5:0] hr;
input	[6:0] min;
input   [6:0] sec;
input	[3:0] tos;

reg	[31:0] tmp;

begin
	tmp[`RTC_RRTC_TIME_DOW] = dow[2:0];
	tmp[`RTC_RRTC_TIME_TH] = hr[5:4];
	tmp[`RTC_RRTC_TIME_H] = hr[3:0];
	tmp[`RTC_RRTC_TIME_TM] = min[6:4];
	tmp[`RTC_RRTC_TIME_M] = min[3:0];
	tmp[`RTC_RRTC_TIME_TS] = sec[6:4];
	tmp[`RTC_RRTC_TIME_S] = sec[3:0];
	tmp[`RTC_RRTC_TIME_TOS] = tos[3:0];
	tb_top.wb_master.wr(`RTC_RRTC_TIME<<2, tmp, 4'b1111);
end

endtask

//
// Set RTC_RRTC_DATE register
//
task setdate;
input	[5:0] d;
input	[4:0] m;
input   [15:0] cy;

reg	[31:0] tmp;

begin
	tmp[`RTC_RRTC_DATE_TD] = d[5:4];
	tmp[`RTC_RRTC_DATE_D] = d[3:0];
	tmp[`RTC_RRTC_DATE_TM] = m[4];
	tmp[`RTC_RRTC_DATE_M] = m[3:0];
	tmp[`RTC_RRTC_DATE_TC] = cy[15:12];
	tmp[`RTC_RRTC_DATE_C] = cy[11:8];
	tmp[`RTC_RRTC_DATE_TY] = cy[7:4];
	tmp[`RTC_RRTC_DATE_Y] = cy[3:0];
	tb_top.wb_master.wr(`RTC_RRTC_DATE<<2, tmp, 4'b1111);
end

endtask

//
// Set RTC_RRTC_TALRM register
//
task settalrm;
input   [4:0] en;
input	[2:0] dow;
input	[5:0] hr;
input	[6:0] min;
input   [6:0] sec;
input	[3:0] tos;

reg	[31:0] tmp;

begin
	tmp[31:27] = en;
	tmp[`RTC_RRTC_TIME_DOW] = dow[2:0];
	tmp[`RTC_RRTC_TIME_TH] = hr[5:4];
	tmp[`RTC_RRTC_TIME_H] = hr[3:0];
	tmp[`RTC_RRTC_TIME_TM] = min[6:4];
	tmp[`RTC_RRTC_TIME_M] = min[3:0];
	tmp[`RTC_RRTC_TIME_TS] = sec[6:4];
	tmp[`RTC_RRTC_TIME_S] = sec[3:0];
	tmp[`RTC_RRTC_TIME_TOS] = tos[3:0];
	tb_top.wb_master.wr(`RTC_RRTC_TALRM<<2, tmp, 4'b1111);
end

endtask

//
// Set RTC_RRTC_DALRM register
//
task setdalrm;
input	[3:0] en;
input	[5:0] d;
input	[4:0] m;
input   [15:0] cy;

reg	[31:0] tmp;

begin
	tmp[30:27] = en;
	tmp[`RTC_RRTC_DATE_TD] = d[5:4];
	tmp[`RTC_RRTC_DATE_D] = d[3:0];
	tmp[`RTC_RRTC_DATE_TM] = m[4];
	tmp[`RTC_RRTC_DATE_M] = m[3:0];
	tmp[`RTC_RRTC_DATE_TC] = cy[15:12];
	tmp[`RTC_RRTC_DATE_C] = cy[11:8];
	tmp[`RTC_RRTC_DATE_TY] = cy[7:4];
	tmp[`RTC_RRTC_DATE_Y] = cy[3:0];
	tb_top.wb_master.wr(`RTC_RRTC_DALRM<<2, tmp, 4'b1111);
end

endtask

//
// Display Day of Week
//
task showdow;
input	[2:0]	dow;

begin
	case (dow)
		3'd1: $write("Sun");
		3'd2: $write("Mon");
		3'd3: $write("Tue");
		3'd4: $write("Wed");
		3'd5: $write("Thu");
		3'd6: $write("Fri");
		3'd7: $write("Sat");
		default: $write("XXX");
	endcase
end

endtask

//
// Display RTC_RRTC_TIME register
//
task showtime;

reg	[31:0] tmp;

begin
	tb_top.wb_master.rd(`RTC_RRTC_TIME<<2, tmp);
	showdow(tmp[`RTC_RRTC_TIME_DOW]);
	$write(" %h%h:", tmp[`RTC_RRTC_TIME_TH], tmp[`RTC_RRTC_TIME_H]);
	$write("%h%h:", tmp[`RTC_RRTC_TIME_TM], tmp[`RTC_RRTC_TIME_M]);
	$write("%h%h:%h ", tmp[`RTC_RRTC_TIME_TS], tmp[`RTC_RRTC_TIME_S], tmp[`RTC_RRTC_TIME_TOS]);
end

endtask

//
// Display RTC_RRTC_TALRM register
//
task showtalrm;

reg	[31:0] tmp;

begin
	tb_top.wb_master.rd(`RTC_RRTC_TALRM<<2, tmp);
	$write("TALRM: %b", tmp[31:27]);
	showdow(tmp[`RTC_RRTC_TIME_DOW]);
	$write(" %h%h:", tmp[`RTC_RRTC_TIME_TH], tmp[`RTC_RRTC_TIME_H]);
	$write("%h%h:", tmp[`RTC_RRTC_TIME_TM], tmp[`RTC_RRTC_TIME_M]);
	$write("%h%h:%h ", tmp[`RTC_RRTC_TIME_TS], tmp[`RTC_RRTC_TIME_S], tmp[`RTC_RRTC_TIME_TOS]);
end

endtask

//
// Display RTC_RRTC_DATE register
//
task showdate;

reg	[31:0] tmp;

begin
	tb_top.wb_master.rd(`RTC_RRTC_DATE<<2, tmp);
	$write("%h%h.", tmp[`RTC_RRTC_DATE_TD], tmp[`RTC_RRTC_DATE_D]);
	$write("%h%h.", tmp[`RTC_RRTC_DATE_TM], tmp[`RTC_RRTC_DATE_M]);
	$write("%h%h", tmp[`RTC_RRTC_DATE_TC], tmp[`RTC_RRTC_DATE_C]);
	$write("%h%h ", tmp[`RTC_RRTC_DATE_TY], tmp[`RTC_RRTC_DATE_Y]);
end

endtask

//
// Display RTC_RRTC_DALRM register
//
task showdalrm;

reg	[31:0] tmp;

begin
	tb_top.wb_master.rd(`RTC_RRTC_DATE<<2, tmp);
	$write("DALRM: %b %h%h.", tmp[30:27], tmp[`RTC_RRTC_DATE_TD], tmp[`RTC_RRTC_DATE_D]);
	$write("%h%h.", tmp[`RTC_RRTC_DATE_TM], tmp[`RTC_RRTC_DATE_M]);
	$write("%h%h", tmp[`RTC_RRTC_DATE_TC], tmp[`RTC_RRTC_DATE_C]);
	$write("%h%h ", tmp[`RTC_RRTC_DATE_TY], tmp[`RTC_RRTC_DATE_Y]);
end

endtask

//
// Compare parameters with RTC_RRTC_TIME register
//
task comp_time;
input	[2:0] 	dow;
input	[5:0] 	hr;
input	[6:0] 	min;
input   [6:0] 	sec;
input	[3:0] 	tos;
output		ret;

reg	[31:0]	tmp;
reg		ret;
begin
	tb_top.wb_master.rd(`RTC_RRTC_TIME<<2, tmp);

	if (tmp[`RTC_RRTC_TIME_DOW] == dow[2:0] &&
	    tmp[`RTC_RRTC_TIME_TH] == hr[5:4] &&
	    tmp[`RTC_RRTC_TIME_H] == hr[3:0] &&
	    tmp[`RTC_RRTC_TIME_TM] == min[6:4] &&
	    tmp[`RTC_RRTC_TIME_M] == min[3:0] &&
	    tmp[`RTC_RRTC_TIME_TS] == sec[6:4] &&
	    tmp[`RTC_RRTC_TIME_S] == sec[3:0] &&
	    tmp[`RTC_RRTC_TIME_TOS] == tos[3:0])
		ret = 1;
	else
		ret = 0;
end

endtask

//
// Compare parameters with RTC_RRTC_DATE register
//
task comp_date;
input	[5:0]	d;
input	[4:0]	m;
input   [15:0]	cy;
output		ret;

reg	[31:0]	tmp;
reg		ret;
begin
	tb_top.wb_master.rd(`RTC_RRTC_DATE<<2, tmp);

	if (tmp[`RTC_RRTC_DATE_TD] == d[5:4] &&
	    tmp[`RTC_RRTC_DATE_D] == d[3:0] &&
	    tmp[`RTC_RRTC_DATE_TM] == m[4] &&
	    tmp[`RTC_RRTC_DATE_M] == m[3:0] &&
	    tmp[`RTC_RRTC_DATE_TC] == cy[15:12] &&
	    tmp[`RTC_RRTC_DATE_C] == cy[11:8] &&
	    tmp[`RTC_RRTC_DATE_TY] == cy[7:4] &&
	    tmp[`RTC_RRTC_DATE_Y] == cy[3:0])
		ret = 1;
	else
		ret = 0;
end

endtask

//
// Display RTC_RRTC_CTRL register
//
task showctrl;

reg	[31:0] tmp;

begin
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, tmp);
	$write("RTC_RRTC_CTRL: %h", tmp);
end

endtask

//
// Get linear value of time in tenths of a second (no date included)
//
task getlineartime;
output	[31:0] lin;
reg	[31:0] tmp;
integer		l;

begin
	tb_top.wb_master.rd(`RTC_RRTC_TIME<<2, tmp);
	l = tmp[`RTC_RRTC_TIME_TH] * 360000 + tmp[`RTC_RRTC_TIME_H] * 36000;
	l = l + tmp[`RTC_RRTC_TIME_TM] * 6000 + tmp[`RTC_RRTC_TIME_M] * 600;
	l = l + tmp[`RTC_RRTC_TIME_TS] * 100 + tmp[`RTC_RRTC_TIME_S] * 10 + tmp[`RTC_RRTC_TIME_TOS];
	lin = l;
end

endtask

//
// Get linear value of alarm time in tenths of a second (no date included)
//
task getlineartalrm;
output	[31:0] lin;
reg	[31:0] tmp;
integer		l;

begin
	tb_top.wb_master.rd(`RTC_RRTC_TALRM<<2, tmp);
	l = tmp[`RTC_RRTC_TALRM_TH] * 360000 + tmp[`RTC_RRTC_TALRM_H] * 36000;
	l = l + tmp[`RTC_RRTC_TALRM_TM] * 6000 + tmp[`RTC_RRTC_TALRM_M] * 600;
	l = l + tmp[`RTC_RRTC_TALRM_TS] * 100 + tmp[`RTC_RRTC_TALRM_S] * 10 + tmp[`RTC_RRTC_TALRM_TOS];
	lin = l;
end

endtask

//
// Test operation of control bit RTC_RRTC_CTRL[ECLK]
//
task test_eclk;
integer l1;
integer l2;
reg	[31:0] ctrl;
begin
	$write("  Testing control bit RTC_RRTC_CTRL[ECLK] ...");

	//
	// Phase 1
	//
	// RTC uses WISHBONE clock
	//

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h0, 'h0, 'h0);

	// Enable RTC, divider 'd16+2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 'h10;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Wait for time to advance
	#80000;

	// Get linear time
	tb_tasks.getlineartime(l1);
`ifdef RTC_DEBUG
	$display;
	tb_tasks.showtime;
	$display(" linear: %d ", l1);
`endif

	//
	// Phase 2
	//
	// Use external RTC clock instead of WISHBONE clock.
	// Generate 2x more clock cycles than in phase 1.
	//

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h0, 'h0, 'h0);

	// Enable RTC, enable external clock, divider 'd16+2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h10;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Wait for time to advance
	// Generate 20000 external clock cycles
	tb_top.clkrst.gen_rtc_clk(20000);

	// Get linear time
	tb_tasks.getlineartime(l2);
`ifdef RTC_DEBUG
	$display;
	tb_tasks.showtime;
	$display(" linear: %d ", l2);
`endif

	//
	// Phase 3
	// Compare phase 1 and phase 2
	// Phase 2 should be 2x more than phase 1
	//
	if (l2 - l1 == l1)
		$display(" OK");
	else
		failed;
end
endtask

//
// Test operation of control bit RTC_RRTC_CTRL[EN]
//
task test_en;
integer l1;
integer l2;
integer l3;
reg	[31:0] ctrl;
begin
	$write("  Testing control bit RTC_RRTC_CTRL[EN] ...");

	//
	// Phase 1
	//
	// Run RTC off external clock for 5000 cycles
	//

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h0, 'h0, 'h0);

	// Enable RTC, enable external clock, divider 'd18+2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h12;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Wait for time to advance
	// Generate 5000 external clock cycles
	tb_top.clkrst.gen_rtc_clk(5000);

	// Get linear time
	#100 tb_tasks.getlineartime(l1);
`ifdef RTC_DEBUG
	$display;
	tb_tasks.showtime;
	$display(" linear: %d ", l1);
`endif

	//
	// Phase 2
	//
	// Run disabled RTC off external clock for 5000 cycles
	//

	// Disable RTC, enable external clock, divider 'd18+2
	ctrl = 1 << `RTC_RRTC_CTRL_ECLK | 'h12;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Wait for time to advance
	// Generate 5000 external clock cycles
	tb_top.clkrst.gen_rtc_clk(5000);

	// Get linear time
	tb_tasks.getlineartime(l2);
`ifdef RTC_DEBUG
	$display;
	tb_tasks.showtime;
	$display(" linear: %d ", l2);
`endif

	//
	// Phase 3
	//
	// Re-enable RTC and run it off external clock for 5000 cycles
	//

	// Enable RTC, enable external clock, divider 'd18+2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h12;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Wait for time to advance
	// Generate 5000 external clock cycles
	tb_top.clkrst.gen_rtc_clk(5000);

	// Get linear time
	tb_tasks.getlineartime(l3);
`ifdef RTC_DEBUG
	$display;
	tb_tasks.showtime;
	$display(" linear: %d ", l3);
`endif

	//
	// Phase 4
	//
	// Compare phase 1, phase 2 and phase 3
	// Phase 1 and 2 should be equal and non-zero.
	// Phase 3 should be more than 1 or 2.
	//
$display("xxxx", l1, l2, l3);
	if (l1 && (l1 == l2) && (l3 > l2))
		$display(" OK");
	else
		failed;
end
endtask

//
// Test operation of control bit RTC_RRTC_CTRL[DIV]
//
task test_div;
integer l1;
integer l2;
reg	[31:0] ctrl;
begin
	$write("  Testing control bit RTC_RRTC_CTRL[DIV] ...");

	//
	// Phase 1
	//
	// Run RTC off external clock for 5000 cycles
	//

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h0, 'h0, 'h0);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Wait for time to advance
	// Generate 5000 external clock cycles
	tb_top.clkrst.gen_rtc_clk(5000);

	// Get linear time
	tb_tasks.getlineartime(l1);
`ifdef RTC_DEBUG
	$display;
	tb_tasks.showtime;
	$display(" linear: %d ", l1);
`endif

	//
	// Phase 2
	//
	// Run RTC for another 5000 cycles with different divider
	//

	// Enable RTC, enable external clock, divider 'd2+2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h1;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Wait for time to advance
	// Generate 5000 external clock cycles
	tb_top.clkrst.gen_rtc_clk(5000);

	// Get linear time
	tb_tasks.getlineartime(l2);
`ifdef RTC_DEBUG
	$display;
	tb_tasks.showtime;
	$display(" linear: %d ", l2);
`endif

	//
	// Phase 3
	//
	// Phase 1 should be 2500 and phase 2 should be 2500+1250.
	//
	if ((l2 - l1) == 1250)
		$display(" OK");
	else
		failed;
end
endtask

//
// Test operation of RTC_RRTC_TALRM
//
task test_talrm;
reg		a0;
reg		a1;
reg	[31:0] ctrl;
begin

	// Clear date alarms
	#100 tb_tasks.setdalrm('b0000, 'h00, 'h00, 'h0000);

	//
	// Phase 1
	//
	// Check tenths of a second alarm
	//

	$write("  Testing Alarm RTC_RRTC_TALRM[CTOS] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h0, 'h0, 'h0);

	// Set TOS alarm to 9
	#100 tb_tasks.settalrm('b00001, 'h0, 'h0, 'h0, 'h0, 'h9);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 0.7 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(16);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	//
	// Phase 2
	//
	// Check seconds alarm
	//

	$write("  Testing Alarm RTC_RRTC_TALRM[CS] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h0, 'h0, 'h0);

	// Set seconds alarm to 9
	#100 tb_tasks.settalrm('b00010, 'h0, 'h0, 'h0, 'h10, 'h0);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 9.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(198);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	//
	// Phase 3
	//
	// Check minutes alarm
	//

	$write("  Testing Alarm RTC_RRTC_TALRM[CM] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 00:02:00:0
	#100 tb_tasks.settime('h0, 'h0, 'h02, 'h0, 'h0);

	// Set minutes alarm to 4
	#100 tb_tasks.settalrm('b00100, 'h0, 'h0, 'h4, 'h0, 'h0);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	//
	// Phase 4
	//
	// Check hours alarm
	//

	$write("  Testing Alarm RTC_RRTC_TALRM[CH] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h58, 'h0, 'h0);

	// Set hours alarm to 01:00:00:0
	#100 tb_tasks.settalrm('b01000, 'h0, 'h1, 'h0, 'h0, 'h0);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	//
	// Phase 5
	//
	// Check day of week alarm
	//

	$write("  Testing Alarm RTC_RRTC_TALRM[CDOW] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 23:58:00
	#100 tb_tasks.settime('h1, 'h23, 'h58, 'h0, 'h0);

	// Set DOW alarm to 1
	#100 tb_tasks.settalrm('b10000, 'h2, 'h0, 'h0, 'h0, 'h0);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	// Clear all time alarms
	#100 tb_tasks.settalrm('b00000, 'h0, 'h0, 'h0, 'h0, 'h0);

end
endtask

//
// Test operation of RTC_RRTC_DALRM
//
task test_dalrm;
reg		a0;
reg		a1;
reg	[31:0] ctrl;
begin

	// Clear time alarms
	#100 tb_tasks.settalrm('b00000, 'h0, 'h00, 'h00, 'h00, 'h0);

	//
	// Phase 1
	//
	// Check days alarm
	//

	$write("  Testing Alarm RTC_RRTC_DALRM[CD] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 23:58:00:0
	#100 tb_tasks.settime('h0, 'h23, 'h58, 'h00, 'h0);

	// Set date to 1.1.2000
	#100 tb_tasks.setdate('h01, 'h01, 'h2000);

	// Set days alarm to 2
	#100 tb_tasks.setdalrm('b0001, 'h2, 'h0, 'h0000);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	//
	// Phase 2
	//
	// Check months alarm
	//

	$write("  Testing Alarm RTC_RRTC_DALRM[CM] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 23:58:00:0
	#100 tb_tasks.settime('h0, 'h23, 'h58, 'h00, 'h0);

	// Set date to 31.1.2000
	#100 tb_tasks.setdate('h31, 'h01, 'h2000);

	// Set months alarm to 2
	#100 tb_tasks.setdalrm('b0010, 'h0, 'h2, 'h0000);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	//
	// Phase 3
	//
	// Check years alarm
	//

	$write("  Testing Alarm RTC_RRTC_DALRM[CY] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 23:58:00:0
	#100 tb_tasks.settime('h0, 'h23, 'h58, 'h00, 'h0);

	// Set date to 31.12.2000
	#100 tb_tasks.setdate('h31, 'h12, 'h2000);

	// Set year alarm to 01
	#100 tb_tasks.setdalrm('b0100, 'h0, 'h0, 'h0001);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	//
	// Phase 4
	//
	// Check century alarm
	//

	$write("  Testing Alarm RTC_RRTC_DALRM[CC] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 23:58:00:0
	#100 tb_tasks.settime('h0, 'h23, 'h58, 'h00, 'h0);

	// Set date to 31.12.2099
	#100 tb_tasks.setdate('h31, 'h12, 'h2099);

	// Set century alarm to 21
	#100 tb_tasks.setdalrm('b1000, 'h0, 'h0, 'h2100);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

	// Clear all date alarms
	#100 tb_tasks.setdalrm('b0000, 'h00, 'h00, 'h0000);
end

endtask

//
// Test operation of RTC_RRTC_CTRL[INTE] and RTC_RRTC_CRTL[INT]
//
task test_inte_int;
reg		a0;
reg		a1;
reg	[31:0] ctrl;
begin

	// Clear time alarms
	#100 tb_tasks.settalrm('b00000, 'h0, 'h00, 'h00, 'h00, 'h0);

	//
	// Phase 1
	//
	// Set days alarm, disable ints
	//

	$write("  Testing RTC_RRTC_CTRL[INTE] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 23:58:00:0
	#100 tb_tasks.settime('h0, 'h23, 'h58, 'h00, 'h0);

	// Set date to 1.1.2000
	#100 tb_tasks.setdate('h01, 'h01, 'h2000);

	// Set days alarm to 2
	#100 tb_tasks.setdalrm('b0001, 'h2, 'h0, 'h0000);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.9 seconds, get alarm flag,
	// advance 0.1 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set and interrupt cleared?
	if ((a1 > a0) && !tb_top.rtc.wb_inta_o)
		$display(" OK");
	else
		failed;

	//
	// Phase 2
	//
	// Set days alarm, enable ints
	//

	$write("  Testing interrupt request assertion ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to 23:58:00:0
	#100 tb_tasks.settime('h0, 'h23, 'h58, 'h00, 'h0);

	// Set date to 1.1.2000
	#100 tb_tasks.setdate('h01, 'h01, 'h2000);

	// Set days alarm to 2
	#100 tb_tasks.setdalrm('b0001, 'h2, 'h0, 'h0000);

	// Enable RTC, enable interrupts enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_INTE | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 119.8 seconds, get alarm flag,
	// advance 0.2 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(2398);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(2);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set and interrupt asserted?
	if ((a1 > a0) && tb_top.rtc.wb_inta_o)
		$display(" OK");
	else
		failed;

	// Clear RTC_RRTC_CTRL[INTE] and RTC_RRTC_CTRL[ALRM]
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	$write("  Testing interrupt request negation ...");

	// Is interrupt request still asserted?
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	if (!tb_top.rtc.wb_inta_o)
		$display(" OK");
	else
		failed;
end

endtask

//
// Test correct operation of RTC_RRTC_CTRL[BTOS] bit
//
task test_btos;
reg		a0;
reg		a1;
reg	[31:0]	ctrl;
begin

	// Clear date alarms
	#100 tb_tasks.setdalrm('b0000, 'h0, 'h0, 'h0000);

	//
	// Phase 1
	//
	// Check RTC_RRTC_CTRL[BTOS]
	//

	$write("  Testing RTC_RRTC_CTRL[BTOS] ...");

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set time to zero
	#100 tb_tasks.settime('h0, 'h0, 'h0, 'h0, 'h0);

	// Set seconds alarm to 50
	#100 tb_tasks.settalrm('b00010, 'h0, 'h0, 'h0, 'h50, 'h0);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_BTOS | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif

	// Advance time for 49.5 seconds, get alarm flag,
	// advance 0.5 second and get alarm flag again
	tb_top.clkrst.gen_rtc_clk(99);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a0 = ctrl[`RTC_RRTC_CTRL_ALRM];
	tb_top.clkrst.gen_rtc_clk(1);
	tb_top.wb_master.rd(`RTC_RRTC_CTRL<<2, ctrl);
	a1 = ctrl[`RTC_RRTC_CTRL_ALRM];

	// Is alarm flag set?
	if (a1 > a0)
		$display(" OK");
	else
		failed;

end

endtask

//
// Test single time/date case
//
task test_case;
input	[31:0]  stime;
input	[31:0]  sdate;
input	[31:0]	eclks;
input	[31:0]  etime;
input	[31:0]  edate;
reg	[31:0] 	ctrl;
reg		corr_time;
reg		corr_date;
begin

	// Disable RTC
	ctrl = 0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);

	// Set start time
	#100 tb_tasks.settime(stime[30:28], stime[27:20], stime[19:12], stime[11:4], stime[3:0]);

	// Set start date
	#100 tb_tasks.setdate(sdate[31:24], sdate[23:16], sdate[15:0]);

	// Enable RTC, enable external clock, divider 'd2
	ctrl = 1 << `RTC_RRTC_CTRL_EN | 1 << `RTC_RRTC_CTRL_ECLK | 'h0;
	#100 tb_top.wb_master.wr(`RTC_RRTC_CTRL<<2, ctrl, 4'hf);
`ifdef RTC_DEBUG
	$display;
	#100 showctrl;
`endif
	showtime;
	showdate;

	// Wait for time to advance
	// Generate external clock cycles
	tb_top.clkrst.gen_rtc_clk(eclks);
	showtime;
	showdate;
	comp_time(etime[30:28], etime[27:20], etime[19:12], etime[11:4], etime[3:0], corr_time);
	comp_date(edate[31:24], edate[23:16], edate[15:0], corr_date);
	if (corr_time && corr_date)
		$display(" OK");
	else
		failed;
end

endtask

//
// Test time/date compliance with leapyears/Y2K etc
//
task test_cases;
begin

	$write("  Testing Y2K compliance: ");
	test_case('h7_23_30_00_0, 'h31_12_1999, 72000, 'h1_00_30_00_0, 'h01_01_2000);

	$write("  Testing Y2K leap year compliance: ");
	test_case('h3_23_30_00_0, 'h28_02_2000, 72000, 'h4_00_30_00_0, 'h29_02_2000);

	$write("  Testing 2001 leap year compliance: ");
	test_case('h4_23_30_00_0, 'h28_02_2001, 72000, 'h5_00_30_00_0, 'h01_03_2001);

	$write("  Testing 2004 leap year compliance: ");
	test_case('h7_23_30_00_0, 'h28_02_2004, 72000, 'h1_00_30_00_0, 'h29_02_2004);

	$write("  Testing 2100 leap year compliance: ");
	test_case('h1_23_30_00_0, 'h28_02_2100, 72000, 'h2_00_30_00_0, 'h01_03_2100);

	$write("  Testing change from Jan to Feb: ");
	test_case('h1_23_45_00_0, 'h31_01_2000, 36000, 'h2_00_15_00_0, 'h01_02_2000);

	$write("  Testing change from Mar to Apr: ");
	test_case('h1_23_45_00_0, 'h31_03_2000, 36000, 'h2_00_15_00_0, 'h01_04_2000);

	$write("  Testing change from Apr to May: ");
	test_case('h1_23_45_00_0, 'h30_04_2000, 36000, 'h2_00_15_00_0, 'h01_05_2000);

	$write("  Testing change from May to Jun: ");
	test_case('h1_23_45_00_0, 'h31_05_2000, 36000, 'h2_00_15_00_0, 'h01_06_2000);

	$write("  Testing change from Jun to Jul: ");
	test_case('h1_23_45_00_0, 'h30_06_2000, 36000, 'h2_00_15_00_0, 'h01_07_2000);

	$write("  Testing change from Jul to Aug: ");
	test_case('h1_23_45_00_0, 'h31_07_2000, 36000, 'h2_00_15_00_0, 'h01_08_2000);

	$write("  Testing change from Aug to Sep: ");
	test_case('h1_23_45_00_0, 'h31_08_2000, 36000, 'h2_00_15_00_0, 'h01_09_2000);

	$write("  Testing change from Sep to Oct: ");
	test_case('h1_23_45_00_0, 'h30_09_2000, 36000, 'h2_00_15_00_0, 'h01_10_2000);

	$write("  Testing change from Oct to Nov: ");
	test_case('h1_23_45_00_0, 'h31_10_2000, 36000, 'h2_00_15_00_0, 'h01_11_2000);

	$write("  Testing change from Nov to Dec: ");
	test_case('h1_23_45_00_0, 'h30_11_2000, 36000, 'h2_00_15_00_0, 'h01_12_2000);

	$write("  Testing change from Dec to Jan: ");
	test_case('h1_23_45_00_0, 'h31_12_2000, 36000, 'h2_00_15_00_0, 'h01_01_2001);

	$write("  Testing change of a day: ");
	test_case('h1_12_34_56_7, 'h29_01_2002, 72000*24, 'h2_12_34_56_7, 'h30_01_2002);

end

endtask

//
// Start of testbench test tasks
//
initial begin
`ifdef RTC_DUMP_VCD
	$dumpfile("../sim/tb_top.vcd");
	$dumpvars(3, tb_top);
`endif
	nr_failed = 0;
	$display;
	$display("###");
	$display("### RTC IP Core Verification ###");
	$display("###");
	$display;
	$display("I. Testing correct operation of RTC_RRTC_CTRL control bits");
	$display;
	tb_tasks.test_btos;
//	tb_tasks.test_eclk;
	tb_tasks.test_en;
	tb_tasks.test_div;
	tb_tasks.test_inte_int;
	$display;
	$display("II. Testing alarms ...");
	$display;
	tb_tasks.test_talrm;
	tb_tasks.test_dalrm;
	$display;
	$display("III. Testing correct operation of time/date counters");
	$display;
	tb_tasks.test_cases;
	$display;
	$display("###");
	$display("### FAILED TESTS: %d ###", nr_failed);
	$display("###");
	$display;
	#10000;
	$finish;
end

endmodule
