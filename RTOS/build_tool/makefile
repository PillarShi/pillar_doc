RUN_TARGET := order
SRC_DIR := source
BUILD_DIR := build

IS_NINJA := y

# DEFAULT_MAKE := full_run
DEFAULT_MAKE := only_build

PHONY := default full_run only_build gen build run clean run_begin run_end

.PHONY: $(PHONY)

default : $(DEFAULT_MAKE)

full_run : clean only_build run_begin run run_end

only_build : gen build

gen :
ifeq ($(IS_NINJA), y)
	@cmake -B $(BUILD_DIR) -S $(SRC_DIR) -GNinja
else
	@cmake -B $(BUILD_DIR) -S $(SRC_DIR)
endif

build :
	@cmake --build $(BUILD_DIR)

run :
	@./$(BUILD_DIR)/$(RUN_TARGET)

clean :
	@-rm -rf $(BUILD_DIR)

run_begin :
	@echo "-------------------------------- RUN TARGET --------------------------------"

run_end :
	@echo "----------------------------------------------------------------------------"