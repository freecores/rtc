//////////////////////////////////////////////////////////////////////
////                                                              ////
////  WISHBONE Real-Time Clock                                    ////
////                                                              ////
////  This file is part of the RTC project                        ////
////  http://www.opencores.org/cores/rtc/                         ////
////                                                              ////
////  Description                                                 ////
////  Implementation of Real-Time clock IP core according to      ////
////  RTC IP core specification document. Using async resets      ////
////  would make core even smaller.                               ////
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
`include "defines.vh"

module rtc(
	// WISHBONE Interface
	clk_i, rst_i, cyc_i, adr_i, dat_i, sel_i, we_i, stb_i,
	dat_o, ack_o, err_o, inta_o,

	// External RTC Interface
	rtc_clk
);

parameter dw = 32;
parameter aw = 16;

//
// WISHBONE Interface
//
input			clk_i;	// Clock
input			rst_i;	// Reset
input			cyc_i;	// cycle valid input
input 	[aw-1:0]	adr_i;	// address bus inputs
input	[dw-1:0]	dat_i;	// input data bus
input	[3:0]		sel_i;	// byte select inputs
input			we_i;	// indicates write transfer
input			stb_i;	// strobe input
output	[dw-1:0]	dat_o;	// output data bus
output			ack_o;	// normal termination
output			err_o;	// termination w/ error
output			inta_o;	// Interrupt request output

//
// External RTC Interface
//
input		rtc_clk;	// External clock

`ifdef RTC_IMPLEMENTED

//
// Counters of RTC Time Register
//
reg	[3:0]	time_tos;	// Tenth of second counter
reg	[3:0]	time_s;		// Seconds counter
reg	[2:0]	time_ts;	// Ten seconds counter
reg	[3:0]	time_m;		// Minutes counter
reg	[2:0]	time_tm;	// Ten minutes counter
reg	[3:0]	time_h;		// Hours counter
reg	[1:0]	time_th;	// Ten hours counter
reg	[2:0]	time_dow;	// Day of week counter

//
// Counter of RTC Date Register
//
reg	[3:0]	date_d;		// Days counter
reg	[1:0]	date_td;	// Ten days counter
reg	[3:0]	date_m;		// Months counter
reg		date_tm;	// Ten months counter
reg	[3:0]	date_y;		// Years counter
reg	[3:0]	date_ty;	// Ten years counter
reg	[3:0]	date_c;		// Centuries counter
reg	[3:0]	date_tc;	// Ten centuries counter

//
// Clock division counter
//
`ifdef DIVIDER
reg	[26:0]	cntr_div;	// Division counter
reg		div_clk;	// Tenth of a second clock
`else
wire		div_clk;	// Tenth of a second clock
`endif

//
// RTC TALRM Register
//
`ifdef RRTC_TALRM
reg	[31:0]	rrtc_talrm;		// RRTC_TALRM register
`else
wire	[31:0]	rrtc_talrm;		// No register
`endif

//
// RTC DALRM Register
//
`ifdef RRTC_DALRM
reg	[30:0]	rrtc_dalrm;		// RRTC_DALRM register
`else
wire	[30:0]	rrtc_dalrm;		// No register
`endif

//
// RTC CTRL register
//
reg	[31:0]	rrtc_ctrl;	// RRTC_CTRL register

//
// Internal wires & regs
//
wire	[31:0]	rrtc_time;	// Alias
wire	[31:0]	rrtc_date;	// Alias
wire		rrtc_time_sel;	// RRTC_TIME select
wire		rrtc_date_sel;	// RRTC_DATE select
wire		rrtc_talrm_sel;	// RRTC_TALRM select
wire		rrtc_dalrm_sel;	// RRTC_DALRM select
wire		rrtc_ctrl_sel;	// RRTC_CTRL select
wire		match_tos;	// Tenth of second match
wire		match_secs;	// Seconds match
wire		match_mins;	// Minutes match
wire		match_hrs;	// Hours match
wire		match_dow;	// Day of week match
wire		match_days;	// Days match
wire		match_months;	// Months match
wire		match_yrs;	// Years match
wire		match_cents;	// Centuries match
wire		rst_time_tos;	// Reset RRTC_TIME[TOS]
wire		rst_time_s;	// Reset RRTC_TIME[S]
wire		rst_time_ts;	// Reset RRTC_TIME[TS]
wire		rst_time_m;	// Reset RRTC_TIME[M]
wire		rst_time_tm;	// Reset RRTC_TIME[TM]
wire		rst_time_h;	// Reset RRTC_TIME[H]
wire		rst_time_th;	// Reset RRTC_TIME[TH]
wire		rst_time_dow;	// Reset RRTC_TIME[DOW]
wire		rst_date_d;	// Reset RRTC_DATE[D]
wire		rst_date_td;	// Reset RRTC_DATE[TD]
wire		rst_date_m;	// Reset RRTC_DATE[M]
wire		rst_date_tm;	// Reset RRTC_DATE[TM]
wire		rst_date_y;	// Reset RRTC_DATE[Y]
wire		rst_date_ty;	// Reset RRTC_DATE[TY]
wire		rst_date_c;	// Reset RRTC_DATE[C]
wire		rst_date_tc;	// Reset RRTC_DATE[TC]
wire		inc_time_tos;	// Enable counter RRTC_TIME[TOS]
wire		inc_time_s;	// Enable counter RRTC_TIME[S]
wire		inc_time_ts;	// Enable counter RRTC_TIME[TS]
wire		inc_time_m;	// Enable counter RRTC_TIME[M]
wire		inc_time_tm;	// Enable counter RRTC_TIME[TM]
wire		inc_time_h;	// Enable counter RRTC_TIME[H]
wire		inc_time_th;	// Enable counter RRTC_TIME[TH]
wire		inc_time_dow;	// Enable counter RRTC_TIME[DOW]
wire		inc_date_d;	// Enable counter RRTC_DATE[D]
wire		inc_date_td;	// Enable counter RRTC_DATE[TD]
wire		inc_date_m;	// Enable counter RRTC_DATE[M]
wire		inc_date_tm;	// Enable counter RRTC_DATE[TM]
wire		inc_date_y;	// Enable counter RRTC_DATE[Y]
wire		inc_date_ty;	// Enable counter RRTC_DATE[TY]
wire		inc_date_c;	// Enable counter RRTC_DATE[C]
wire		inc_date_tc;	// Enable counter RRTC_DATE[TC]
wire		one_date_d;	// Set RRTC_DATE[D] to 1
wire		one_date_m;	// Set RRTC_DATE[M] to 1
wire		hi_clk;		// Hi freq clock
wire		lo_clk;		// Lo freq clock
wire		alarm;		// Alarm condition
wire		leapyear;	// Leap year
reg	[dw-1:0] dat_o;		// Data out

//
// All WISHBONE transfer terminations are successful
//
assign ack_o = cyc_i & stb_i;
assign err_o = 1'b0;

//
// Hi freq clock is selected by RRTC_CTRL[ECLK]. When it is set,
// external clock is used.
//
assign hi_clk = rrtc_ctrl[`RRTC_CTRL_ECLK] ? rtc_clk : clk_i;

//
// Lo freq clock divided hi freq clock when RRTC_CTRL[EN] is set.
// When RRTC_CTRL[EN] is cleared, lo freq clock is equal WISHBONE
// clock to allow writes into registers.
//
assign lo_clk = rrtc_ctrl[`RRTC_CTRL_EN] ? div_clk : clk_i;

//
// RTC registers address decoder
//
assign rrtc_time_sel = cyc_i & stb_i & (adr_i[`RTCOFS_BITS] == `RRTC_TIME);
assign rrtc_date_sel = cyc_i & stb_i & (adr_i[`RTCOFS_BITS] == `RRTC_DATE);
assign rrtc_talrm_sel = cyc_i & stb_i & (adr_i[`RTCOFS_BITS] == `RRTC_TALRM);
assign rrtc_dalrm_sel = cyc_i & stb_i & (adr_i[`RTCOFS_BITS] == `RRTC_DALRM);
assign rrtc_ctrl_sel = cyc_i & stb_i & (adr_i[`RTCOFS_BITS] == `RRTC_CTRL);

//
// Grouping of seperate fields into registers
//
assign rrtc_time = {5'b0, time_dow, time_th, time_h, time_tm,
			time_m, time_ts, time_s, time_tos};
assign rrtc_date = {5'b0, date_tc, date_c, date_ty, date_y,
			date_tm, date_m, date_td, date_d};

//
// Write to RRTC_CTRL or update of RRTC_CTRL[ALRM] bit
//
`ifdef RRTC_CTRL
always @(posedge clk_i or posedge rst_i)
	if (rst_i)
		rrtc_ctrl <= #1 32'b0;
	else if (rrtc_ctrl_sel && we_i)
		rrtc_ctrl <= #1 dat_i;
	else if (rrtc_ctrl[`RRTC_CTRL_EN])
		rrtc_ctrl[`RRTC_CTRL_ALRM] <= #1 rrtc_ctrl[`RRTC_CTRL_ALRM] | alarm;
`else
assign rrtc_ctrl = 32'h80000000;	// RRTC_CTRL[EN] = 1
`endif

//
// Clock divider
//
`ifdef DIVIDER
always @(posedge hi_clk or posedge rst_i)
	if (rst_i) begin
		cntr_div <= #1 27'b0;
		div_clk <= #1 1'b0;
	end else if (!cntr_div) begin
		cntr_div <= #1 rrtc_ctrl[`RRTC_CTRL_DIV];
		div_clk <= #1 ~div_clk;
	end else if (rrtc_ctrl[`RRTC_CTRL_EN])
		cntr_div <= #1 cntr_div - 1;
`else
assign div_clk = hi_clk;
`endif

//
// Write to RRTC_TALRM
//
`ifdef RRTC_TALRM
always @(posedge clk_i or posedge rst_i)
	if (rst_i)
		rrtc_talrm <= #1 32'b0;
	else if (rrtc_talrm_sel && we_i)
		rrtc_talrm <= #1 dat_i;
`else
assign rrtc_talrm = 32'h0;	// No alarms set
`endif

//
// Write to RRTC_DALRM
//
`ifdef RRTC_DALRM
always @(posedge clk_i or posedge rst_i)
	if (rst_i)
		rrtc_dalrm <= #1 31'b0;
	else if (rrtc_dalrm_sel && we_i)
		rrtc_dalrm <= #1 dat_i[30:0];
`else
assign rrtc_dalrm = 31'h0;	// No alarms set
`endif

//
// RRTC_TIME[TOS]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_tos <= #1 dat_i[`RRTC_TIME_TOS];
	else if (rst_time_tos)
		time_tos <= #1 4'b0;
	else if (inc_time_tos)
		time_tos <= #1 time_tos + 1;

//
// RRTC_TIME[S]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_s <= #1 dat_i[`RRTC_TIME_S];
	else if (rst_time_s)
		time_s <= #1 4'b0;
	else if (inc_time_s)
		time_s <= #1 time_s + 1;

//
// RRTC_TIME[TS]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_ts <= #1 dat_i[`RRTC_TIME_TS];
	else if (rst_time_ts)
		time_ts <= #1 3'b0;
	else if (inc_time_ts)
		time_ts <= #1 time_ts + 1;

//
// RRTC_TIME[M]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_m <= #1 dat_i[`RRTC_TIME_M];
	else if (rst_time_m)
		time_m <= #1 4'b0;
	else if (inc_time_m)
		time_m <= #1 time_m + 1;

//
// RRTC_TIME[TM]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_tm <= #1 dat_i[`RRTC_TIME_TM];
	else if (rst_time_tm)
		time_tm <= #1 3'b0;
	else if (inc_time_tm)
		time_tm <= #1 time_tm + 1;

//
// RRTC_TIME[H]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_h <= #1 dat_i[`RRTC_TIME_H];
	else if (rst_time_h)
		time_h <= #1 4'b0;
	else if (inc_time_h)
		time_h <= #1 time_h + 1;

//
// RRTC_TIME[TH]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_th <= #1 dat_i[`RRTC_TIME_TH];
	else if (rst_time_th)
		time_th <= #1 2'b0;
	else if (inc_time_th)
		time_th <= #1 time_th + 1;

//
// RRTC_TIME[DOW]
//
always @(posedge lo_clk)
	if (rrtc_time_sel && we_i)
		time_dow <= #1 dat_i[`RRTC_TIME_DOW];
	else if (rst_time_dow)
		time_dow <= #1 3'h1;
	else if (inc_time_dow)
		time_dow <= #1 time_dow + 1;

//
// RRTC_DATE[D]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_d <= #1 dat_i[`RRTC_DATE_D];
	else if (one_date_d)
		date_d <= #1 4'h1;
	else if (rst_date_d)
		date_d <= #1 4'h0;
	else if (inc_date_d)
		date_d <= #1 date_d + 1;

//
// RRTC_DATE[TD]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_td <= #1 dat_i[`RRTC_DATE_TD];
	else if (rst_date_td)
		date_td <= #1 2'b0;
	else if (inc_date_td)
		date_td <= #1 date_td + 1;

//
// RRTC_DATE[M]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_m <= #1 dat_i[`RRTC_DATE_M];
	else if (one_date_m)
		date_m <= #1 4'h1;
	else if (rst_date_m)
		date_m <= #1 4'h0;
	else if (inc_date_m)
		date_m <= #1 date_m + 1;

//
// RRTC_DATE[TM]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_tm <= #1 dat_i[`RRTC_DATE_TM];
	else if (rst_date_tm)
		date_tm <= #1 1'b0;
	else if (inc_date_tm)
		date_tm <= #1 date_tm + 1;

//
// RRTC_DATE[Y]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_y <= #1 dat_i[`RRTC_DATE_Y];
	else if (rst_date_y)
		date_y <= #1 4'b0;
	else if (inc_date_y)
		date_y <= #1 date_y + 1;

//
// RRTC_DATE[TY]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_ty <= #1 dat_i[`RRTC_DATE_TY];
	else if (rst_date_ty)
		date_ty <= #1 4'b0;
	else if (inc_date_ty)
		date_ty <= #1 date_ty + 1;

//
// RRTC_DATE[C]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_c <= #1 dat_i[`RRTC_DATE_C];
	else if (rst_date_c)
		date_c <= #1 4'b0;
	else if (inc_date_c)
		date_c <= #1 date_c + 1;

//
// RRTC_DATE[TC]
//
always @(posedge lo_clk)
	if (rrtc_date_sel && we_i)
		date_tc <= #1 dat_i[`RRTC_DATE_TC];
	else if (rst_date_tc)
		date_tc <= #1 4'b0;
	else if (inc_date_tc)
		date_tc <= #1 date_tc + 1;

//
// Read RTC registers
//
always @(adr_i or rrtc_time or rrtc_date or rrtc_talrm or rrtc_dalrm or rrtc_ctrl)
	case (adr_i[`RTCOFS_BITS])	// synopsys full_case parallel_case
`ifdef RTC_READREGS
		`RRTC_TIME: dat_o <= rrtc_time;
		`RRTC_DATE: dat_o <= rrtc_date;
		`RRTC_TALRM: dat_o <= rrtc_talrm;
		`RRTC_DALRM: dat_o <= {1'b0, rrtc_dalrm};
`endif
		default: dat_o <= rrtc_ctrl;
	endcase

//
// Asserted high when correspoding RRTC_TIME/DATE fields match
// RRTC_T/DALRM fields
//
assign match_tos = (time_tos == rrtc_talrm[`RRTC_TALRM_TOS]);
assign match_secs = (time_s == rrtc_talrm[`RRTC_TALRM_S]) & 
			(time_ts == rrtc_talrm[`RRTC_TALRM_TS]);
assign match_mins = (time_m == rrtc_talrm[`RRTC_TALRM_M]) &
			(time_tm == rrtc_talrm[`RRTC_TALRM_TM]);
assign match_hrs = (time_h == rrtc_talrm[`RRTC_TALRM_H]) &
			(time_th == rrtc_talrm[`RRTC_TALRM_TH]);
assign match_dow = (time_dow == rrtc_talrm[`RRTC_TALRM_DOW]);
assign match_days = (date_d == rrtc_dalrm[`RRTC_DALRM_D]) &
			(date_td == rrtc_dalrm[`RRTC_DALRM_TD]);
assign match_months = (date_m == rrtc_dalrm[`RRTC_DALRM_M]) &
			(date_tm == rrtc_dalrm[`RRTC_DALRM_TM]);
assign match_yrs = (date_y == rrtc_dalrm[`RRTC_DALRM_Y]) &
			(date_ty == rrtc_dalrm[`RRTC_DALRM_TY]);
assign match_cents = (date_c == rrtc_dalrm[`RRTC_DALRM_C]) &
			(date_tc == rrtc_dalrm[`RRTC_DALRM_TC]);

//
// Generate an alarm when all enabled match conditions are asserted high
//
assign alarm = (match_tos | ~rrtc_talrm[`RRTC_TALRM_CTOS]) &
		(match_secs | ~rrtc_talrm[`RRTC_TALRM_CS]) &
		(match_mins | ~rrtc_talrm[`RRTC_TALRM_CM]) &
		(match_hrs | ~rrtc_talrm[`RRTC_TALRM_CH]) &
		(match_dow | ~rrtc_talrm[`RRTC_TALRM_CDOW]) &
		(match_days | ~rrtc_dalrm[`RRTC_DALRM_CD]) &
		(match_months | ~rrtc_dalrm[`RRTC_DALRM_CM]) &
		(match_yrs | ~rrtc_dalrm[`RRTC_DALRM_CY]) &
		(match_cents | ~rrtc_dalrm[`RRTC_DALRM_CC]) &
		(rrtc_talrm[`RRTC_TALRM_CTOS] | 
		 rrtc_talrm[`RRTC_TALRM_CS] | 
		 rrtc_talrm[`RRTC_TALRM_CM] | 
		 rrtc_talrm[`RRTC_TALRM_CH] | 
		 rrtc_talrm[`RRTC_TALRM_CDOW] | 
		 rrtc_dalrm[`RRTC_DALRM_CD] | 
		 rrtc_dalrm[`RRTC_DALRM_CM] | 
		 rrtc_dalrm[`RRTC_DALRM_CY] | 
		 rrtc_dalrm[`RRTC_DALRM_CC]);

//
// Generate an interrupt request
//
assign inta_o = rrtc_ctrl[`RRTC_CTRL_ALRM] & rrtc_ctrl[`RRTC_CTRL_INTE];

//
// Control of counters:
// Asserted high when correspoding RRTC_TIME/DATE fields reach
// boundary values and previous counters are cleared
//
assign rst_time_tos = (time_tos == 4'd9) | rrtc_ctrl[`RRTC_CTRL_BTOS] | rst_i;
assign rst_time_s = (time_s == 4'd9) & rst_time_tos | rst_i;
assign rst_time_ts = (time_ts == 3'd5) & rst_time_s | rst_i;
assign rst_time_m = (time_m == 4'd9) & rst_time_ts | rst_i;
assign rst_time_tm = (time_tm == 3'd5) & rst_time_m | rst_i;
assign rst_time_h = (time_h == 4'd9) & rst_time_tm
			| (time_th == 2'd2) & (time_h == 4'd3) & rst_time_tm
			| rst_i;
assign rst_time_th = (time_th == 2'd2) & rst_time_h | rst_i;
assign rst_time_dow = (time_dow == 3'd7) & rst_time_th | rst_i;
assign one_date_d = 
	       ({date_tm, date_m} == 8'h01 & date_td == 2'd3 & date_d == 4'd1 |
		{date_tm, date_m} == 8'h02 & date_td == 2'd2 & date_d == 4'd8 & ~leapyear |
		{date_tm, date_m} == 8'h02 & date_td == 2'd2 & date_d == 4'd9 & leapyear |
		{date_tm, date_m} == 8'h03 & date_td == 2'd3 & date_d == 4'd1 |
		{date_tm, date_m} == 8'h04 & date_td == 2'd3 & date_d == 4'd0 |
		{date_tm, date_m} == 8'h05 & date_td == 2'd3 & date_d == 4'd1 |
		{date_tm, date_m} == 8'h06 & date_td == 2'd3 & date_d == 4'd0 |
		{date_tm, date_m} == 8'h07 & date_td == 2'd3 & date_d == 4'd1 |
		{date_tm, date_m} == 8'h08 & date_td == 2'd3 & date_d == 4'd1 |
		{date_tm, date_m} == 8'h09 & date_td == 2'd3 & date_d == 4'd0 |
		{date_tm, date_m} == 8'h10 & date_td == 2'd3 & date_d == 4'd1 |
		{date_tm, date_m} == 8'h11 & date_td == 2'd3 & date_d == 4'd0 |
		{date_tm, date_m} == 8'h12 & date_td == 2'd3 & date_d == 4'd1 ) & rst_time_th |
		rst_i;
assign rst_date_d = date_d == 4'd9 & rst_time_th;
assign rst_date_td = ({date_tm, date_m} == 8'h02 & date_td[1] |
		date_td == 2'h3) & (rst_date_d | one_date_d) |
		rst_i;
assign one_date_m = date_tm & (date_m == 4'd2) & rst_date_td | rst_i;
assign rst_date_m = ~date_tm & (date_m == 4'd9) & rst_date_td;
assign rst_date_tm = date_tm & (rst_date_m | one_date_m) | rst_i;
assign rst_date_y = (date_y == 4'd9) & rst_date_tm | rst_i;
assign rst_date_ty = (date_ty == 4'd9)& rst_date_y  | rst_i;
assign rst_date_c = (date_c == 4'd9) & rst_date_ty | rst_i;
assign rst_date_tc = (date_tc == 4'd9) & rst_date_c | rst_i;

//
// Control for counter increment
//
assign inc_time_tos = rrtc_ctrl[`RRTC_CTRL_EN] & ~rrtc_ctrl[`RRTC_CTRL_BTOS];
assign inc_time_s = rst_time_tos | rrtc_ctrl[`RRTC_CTRL_BTOS] & rrtc_ctrl[`RRTC_CTRL_EN];
assign inc_time_ts = rst_time_s;
assign inc_time_m = rst_time_ts;
assign inc_time_tm = rst_time_m;
assign inc_time_h = rst_time_tm;
assign inc_time_th = rst_time_h;
assign inc_time_dow = rst_time_th;
assign inc_date_d = rst_time_th;
assign inc_date_td = rst_date_d;
assign inc_date_m = rst_date_td;
assign inc_date_tm = rst_date_m;
assign inc_date_y = rst_date_tm;
assign inc_date_ty = rst_date_y;
assign inc_date_c = rst_date_ty;
assign inc_date_tc = rst_date_c;

//
// Leap year calculation
//
assign leapyear =
	({date_ty, date_y} == 8'h00 &				// xx00
	 (( date_tc[0] & ~date_c[3] & date_c[1:0] == 2'b10) |	// 12xx, 16xx, 32xx ...
	  (~date_tc[0] & date_c[1:0] == 2'b00 &			// 00xx, 04xx, 08xx, 20xx, 24xx ...
	   (date_c[3:2] == 2'b01 | ~date_c[2])))) |
	(~date_ty[0] & date_y[1:0] == 2'b00 & {date_ty, date_y} != 8'h00) | // xx04, xx08, xx24 ...
	(date_ty[0] & date_y[1:0] == 2'b10);			// xx12, xx16, xx32 ...


`else

//
// When RTC is not implemented, drive all outputs as would when RRTC_CTRL
// is cleared and WISHBONE transfers complete with errors
//
assign inta_o = 1'b0;
assign ack_o = 1'b0;
assign err_o = cyc_i & stb_i;

//
// Read RTC registers
//
`ifdef RTC_READREGS
assign dat_o = {dw{1'b0}};
`endif

`endif

endmodule