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
//

`define RTC_IMPLEMENTED
`define RTC_READREGS
`define DIVIDER
`define RTCOFS_BITS	4:2
`define RRTC_TIME	3'h0	// Address 0x80
`define RRTC_DATE	3'h1	// Address 0x84
`define RRTC_TALRM	3'h2	// Address 0x08
`define RRTC_DALRM	3'h3	// Address 0x0c
`define RRTC_CTRL	3'h4	// Address 0x10

`define RRTC_TIME_TOS		3:0
`define RRTC_TIME_S		7:4
`define RRTC_TIME_TS		10:8
`define RRTC_TIME_M		14:11
`define RRTC_TIME_TM		17:15
`define RRTC_TIME_H		21:18
`define RRTC_TIME_TH		23:22
`define RRTC_TIME_DOW		26:24

`define RRTC_DATE_D		3:0
`define RRTC_DATE_TD		5:4
`define RRTC_DATE_M		9:6
`define RRTC_DATE_TM		10
`define RRTC_DATE_Y		14:11
`define RRTC_DATE_TY		18:15
`define RRTC_DATE_C		22:19
`define RRTC_DATE_TC		26:23

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

`define RRTC_CTRL_DIV		26:0
`define RRTC_CTRL_BTOS		27
`define RRTC_CTRL_ECLK		28
`define RRTC_CTRL_INTE		29
`define RRTC_CTRL_ALRM		30
`define RRTC_CTRL_EN		31
