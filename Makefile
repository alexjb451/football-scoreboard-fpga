IVERILOG ?= iverilog
VVP ?= vvp
BUILD_DIR := build

.PHONY: test test-top test-scoring test-clock test-decoder clean

test: test-top test-scoring test-clock test-decoder

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

test-top: | $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -s football_scoreboard_top \
		-o $(BUILD_DIR)/football_scoreboard_top \
		football_scoreboard_top.v scoring_mechanism_DFF.v \
		edge_detector.v my_dff.v timer_module.v countdown_timer.v \
		hex_decoder.v

test-scoring: | $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -s scoring_tb \
		-o $(BUILD_DIR)/scoring_tb \
		testbench/scoring_tb.v scoring_mechanism_DFF.v edge_detector.v my_dff.v
	$(VVP) $(BUILD_DIR)/scoring_tb

test-clock: | $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -s countdown_timer_tb \
		-o $(BUILD_DIR)/countdown_timer_tb \
		testbench/countdown_timer_tb.v countdown_timer.v
	$(VVP) $(BUILD_DIR)/countdown_timer_tb

test-decoder: | $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -s hex_decoder_tb \
		-o $(BUILD_DIR)/hex_decoder_tb \
		testbench/hex_decoder_tb.v hex_decoder.v
	$(VVP) $(BUILD_DIR)/hex_decoder_tb

clean:
	rm -rf -- $(BUILD_DIR)
