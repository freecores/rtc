#!/bin/sh
cd ../sim
verilog +turbo+3 -q ../bench/wb_master.v ../bench/clkrst.v ../bench/tb_top.v ../bench/tb_tasks.v \
../rtl/rtc.v +incdir+../rtl/ +incdir+../bench/
