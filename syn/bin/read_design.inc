/* Set search path for verilog include files */
search_path = search_path + { RTL_PATH } + { GATE_PATH }

/* Read verilog files of the RTC IP core */
if (TOPLEVEL == "rtc") {
	read -f verilog rtc.v
} else {
	echo "Non-existing top level."
	exit
}

