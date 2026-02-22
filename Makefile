TOP := Proctb

SRC_DIR := src
TB_DIR := tb
BUILD_DIR := build

OUT := $(BUILD_DIR)/$(TOP).vvp
WAVE := $(BUILD_DIR)/$(TOP).vcd

IVERILOG := iverilog
VVP := vvp
GTKWAVE := gtkwave

COMMON_FLAGS := -g2012 -Wall

ifeq ($(OS),Windows_NT)
	RM := rmdir /s /q
	MKDIR := if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	NULLDEV := NUL
else
	RM := rm -rf
	MKDIR := mkdir -p $(BUILD_DIR)
	NULLDEV := /dev/null
endif

SRC := $(wildcard $(SRC_DIR)/*.v *.v) $(TB_DIR)/$(TOP).v

.PHONY: all run wave clean rebuild list

all: $(OUT)

$(OUT): $(SRC)
	@$(MKDIR)
	$(IVERILOG) $(COMMON_FLAGS) -o $(OUT) $(SRC)

run: $(OUT)
	$(VVP) $(OUT)

wave: $(OUT)
	$(VVP) $(OUT)
	$(GTKWAVE) $(WAVE)

clean:
	@$(RM) $(BUILD_DIR) 2>$(NULLDEV)

rebuild: clean all

list:
	@echo $(SRC)
