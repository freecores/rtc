//////////////////////////////////////////////////////////////////////
////                                                              ////
////  WISHBONE Real-Time Clock Definitions                        ////
////                                                              ////
////  This file is part of the RTC project                        ////
////  http://www.opencores.org/cores/rtc/                         ////
////                                                              ////
////  Description                                                 ////
////  RTC definitions.                                            ////
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
// Revision 1.1  2001/06/05 07:45:43  lampret
// Added initial RTL and test benches. There are still some issues with these files.
//
//

//
// Undefine this one if you don't want to remove RTC block from your design
// but you also don't need it. When it is undefined, all RTC ports still
// remain valid and the core can be synthesized however internally there is
// no RTC funationality.
//
// Defined by default (duhh !).
//
`define RTC_IMPLEMENTED

//
// Undefine if you don't need to read RTC registers.
// When it is undefined all reads of RTC registers return zero. This
// is usually useful if you want really small area (for example when
// implemented in FPGA).
//
// To follow RTC IP core specification document this one must be defined.
// Also to successfully run the test bench it must be defined. By default
// it is defined.
//
`define RTC_READREGS

//
// Undefine if you don't need RTC internal clock divider circuitry. Without
// divider RTC is clocked directly by WISHBONE or external clock.
//
// To follow RTC IP core specification document this one must be defined. Also to
// successfully run the test bench it must be defined. By default it is defined.
//
`define DIVIDER

//
// Full WISHBONE address decoding
//
// It is is undefined, partial WISHBONE address decoding is performed.
// Undefine it if you need to save some area.
//
// By default it is defined.
//
`define FULL_DECODE

//
// Strict 32-bit WISHBONE access
//
// If this one is defined, all WISHBONE accesses must be 32-bit. If it is
// not defined, err_o is asserted whenever 8- or 16-bit access is made.
// Undefine it if you need to save some area.
//
// By default it is defined.
//
`define STRICT_32BIT_ACCESS

//
// WISHBONE address bits used for full decoding of RTC registers.
//
`define RTC_ADDRHH 15
`define RTC_ADDRHL 5
`define RTC_ADDRLH 1
`define RTC_ADDRLL 0

//
// Bits of WISHBONE address used for partial decoding of RTC registers.
//
// Default 4:2.
//
`define RTCOFS_BITS	`RTC_ADDRHL-1:`RTC_ADDRLH+1

//
// Addresses of RTC registers
//
// To comply with RTC IP core specification document they must go from
// address 0 to address 0x10 in the following order: RRTC_TIME, RRTC_DATE,
// RRTC_TALRM, RRTC_DALRM and RRTC_CTRL
//
// If particular alarm/ctrl register is not needed, it's address definition
// can be omitted and the register will not be implemented. Instead a fixed
// default value will
// be used.
//
`define RRTC_TIME	3'h0	// Address 0x80
`define RRTC_DATE	3'h1	// Address 0x84
`define RRTC_TALRM	3'h2	// Address 0x08
`define RRTC_DALRM	3'h3	// Address 0x0c
`define RRTC_CTRL	3'h4	// Address 0x10

//
// Default values for unimplemented RTC registers
//
`define DEF_RRTC_TALRM	32'h00000000	// No time alarms
`define DEF_RRTC_DALRM	31'h00000000	// No date alarms
`define DEF_RRTC_CTRL	32'h80000000	// RRTC_CTRL[EN] = 1

//
// RRTC_TIME bits
//
// To comply with the RTC IP core specification document they must go from
// bit 0 to bit 26 in the following order: TOS, S, TS, M, TM, H, TH, DOW
//
`define RRTC_TIME_TOS		3:0
`define RRTC_TIME_S		7:4
`define RRTC_TIME_TS		10:8
`define RRTC_TIME_M		14:11
`define RRTC_TIME_TM		17:15
`define RRTC_TIME_H		21:18
`define RRTC_TIME_TH		23:22
`define RRTC_TIME_DOW		26:24

//
// RRTC_DATE bits
//
// To comply with the RTC IP core specification document they must go from
// bit 0 to bit 26 in the following order: D, TD, M, TM, Y, TY, C, TC
//
`define RRTC_DATE_D		3:0
`define RRTC_DATE_TD		5:4
`define RRTC_DATE_M		9:6
`define RRTC_DATE_TM		10
`define RRTC_DATE_Y		14:11
`define RRTC_DATE_TY		18:15
`define RRTC_DATE_C		22:19
`define RRTC_DATE_TC		26:23

//
// RRTC_TALRM bits
//
// To comply with the RTC IP core specification document they must go from
// bit 0 to bit 31 in the following order: TOS, S, TS, M, TM, H, TH, DOW,
// CTOS, CS, CM, CH, CDOW
//
`define RRTC_TALRM_TOS		3:0
`define RRTC_TALRM_S		7:4
`define RRTC_TALRM_TS		10:8
`define RRTC_TALRM_M		14:11
`define RRTC_TALRM_TM		17:15
`define RRTC_TALRM_H		21:18
`define RRTC_TALRM_TH		23:22
`define RRTC_TALRM_DOW		26:24
`define RRTC_TALRM_CTOS		27
`define RRTC_TALRM_CS		28
`define RRTC_TALRM_CM		29
`define RRTC_TALRM_CH		30
`define RRTC_TALRM_CDOW		31

//
// RRTC_DALRM bits
//
// To comply with the RTC IP core specification document they must go from
// bit 0 to bit 30 in the following order: D, TD, M, TM, Y, TY, C, TC,
// CD, CM, CY, CC
//
`define RRTC_DALRM_D		3:0
`define RRTC_DALRM_TD		5:4
`define RRTC_DALRM_M		9:6
`define RRTC_DALRM_TM		10
`define RRTC_DALRM_Y		14:11
`define RRTC_DALRM_TY		18:15
`define RRTC_DALRM_C		22:19
`define RRTC_DALRM_TC		26:23
`define RRTC_DALRM_CD		27
`define RRTC_DALRM_CM		28
`define RRTC_DALRM_CY		29
`define RRTC_DALRM_CC		30

//
// RRTC_CTRL bits
//
// To comply with the RTC IP core specification document they must go from
// bit 0 to bit 31 in the following order: DIV, BTOS, ECLK, INTE, ALRM, EN
//
`define RRTC_CTRL_DIV		26:0
`define RRTC_CTRL_BTOS		27
`define RRTC_CTRL_ECLK		28
`define RRTC_CTRL_INTE		29
`define RRTC_CTRL_ALRM		30
`define RRTC_CTRL_EN		31
