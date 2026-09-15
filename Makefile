.PHONY: test lint

TOP := soc_demo_tb
SOURCES := soc/ip_counter.sv soc/ip_gpio.sv soc/soc_top.sv soc/soc_demo_tb.sv

# Keep generated binaries and waveforms out of the source directory and Git.
test:
	mkdir -p build
	iverilog -g2012 -s $(TOP) -o build/$(TOP).vvp $(SOURCES)
	cd build && vvp $(TOP).vvp

lint:
	verilator --lint-only --timing --top-module $(TOP) $(SOURCES)
