//////////////////////////////////////////////////////////////////////
////                                                              ////
////  RTC Testbench Definitions                                   ////
////                                                              ////
////  This file is part of the RTC project                        ////
////  http://www.opencores.org/cores/rtc/                         ////
////                                                              ////
////  Description                                                 ////
////  Testbench definitions that affect how testbench simulation  ////
////  is performed.                                               ////
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
// Revision 1.3  2001/07/16 01:05:01  lampret
// Fixed some bugs in test bench. Added comments to tb_defines.v
//
// Revision 1.2  2001/06/05 08:10:47  lampret
// Tests dont go through.
//
// Revision 1.1  2001/06/05 07:45:41  lampret
// Added initial RTL and test benches. There are still some issues with these files.
//
//

//
// Define if you want test bench debugging information during simulation
//
//`define RTC_DEBUG

//
// Define if you want VCD dump
//
//`define RTC_DUMP_VCD
