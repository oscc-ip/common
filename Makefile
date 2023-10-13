SIM_TOOL    ?= iverilog
RUN_TOOL    ?= vvp
WAVE_FORMAT ?=

SIM_APP      ?= clk_int_even_div_simple
SIM_PATH     ?= clkrst
SIM_FILE     ?= clk_int_div
SIM_TOP      := $(SIM_APP)_tb
SIM_FILE_TOP := $(SIM_FILE)_tb
TEST_ARGS ?= default_args

ifeq ($(TEST_ARGS), dump_fst_wave)
WAVE_FORMAT := -fst
endif
ifeq ($(TEST_ARGS), dump_vcd_wave)
WAVE_FORMAT := -vcd
endif
# WARN_OPTIONS := -Wanachronisms -Wimplicit -Wportbind -Wselect-range -Winfloop
# WARN_OPTIONS += -Wsensitivity-entire-vector -Wsensitivity-entire-array
WARN_OPTIONS := -Wall -Winfloop -Wno-timescale
SIM_OPTIONS  := -g2012 -s $(SIM_TOP) $(WARN_OPTIONS)
INC_LIST     := -I ../rtl
SIMV_PROG    := simv

FILE_LIST += -f ../filelist/$(SIM_FILE)_tb.f
INC_LIST += -I ../tb

comp:
	@mkdir -p build
	cd build && ($(SIM_TOOL) $(SIM_OPTIONS) $(FILE_LIST) $(INC_LIST) ../rtl/$(SIM_PATH)/$(SIM_FILE).sv ../tb/$(SIM_FILE_TOP).sv -o $(SIMV_PROG) || exit -1) 2>&1 | tee compile.log

run: comp
	cd build && $(RUN_TOOL) -l run.log -n $(SIMV_PROG) +$(TEST_ARGS) $(WAVE_FORMAT)

clean:
	rm -rf build

.PHONY: comp run