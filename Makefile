# Tell make to use cmd.exe
SHELL = cmd
.SHELLFLAGS = /C

# Tools
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Find testbenches (*tb.v)
TB_FILES := $(wildcard *tb.v)

# footb.v -> foo.vvp
TARGETS := $(patsubst %tb.v,%.vvp,$(TB_FILES))

# Default: build all
all: $(TARGETS)

# Build rule
# foo.vvp depends on foo.v and footb.v
%.vvp: %.v %tb.v
	$(IVERILOG) -g2012 -Wall -o $@ $^

# Run simulation
# Usage: make run name=foo
run:
ifndef name
	$(error Usage: make run name=<modulename>)
endif
	$(VVP) $(name).vvp

# Open waveform in GTKWave
# Usage: make wave name=foo
wave:
ifndef name
	$(error Usage: make wave name=<modulename>)
endif
	if not exist $(name).vcd ( \
		echo VCD file $(name).vcd not found. Run simulation first. & \
		exit /b 1 \
	)
	$(GTKWAVE) $(name).vcd

# Clean
clean:
	del /Q *.vvp 2>nul
	del /Q *.vcd 2>nul

.PHONY: all run wave clean