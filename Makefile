# Directories
SRC_FOLDER = srcs/
PRECOMPILED_FOLDER = precompiled/
LIBS_FOLDER = libs/

# Final binary
BIN = tddmax2

# Specify Entry point
MAIN_SRC = $(SRC_FOLDER)$(BIN).cbl
# Get all .cbl files from source directory
ALL_SRC = $(shell find $(SRC_FOLDER) -type f -name '*.cbl')
# Remove entry point from src list, as it it compiled differently
SRC = $(filter-out $(MAIN_SRC), $(ALL_SRC))

# Compute precompiled .cob entry point
MAIN_PRECOMPILED = $(patsubst $(SRC_FOLDER)%.cbl, $(PRECOMPILED_FOLDER)%.cob, $(MAIN_SRC))
# Compute precompiled .cob files in objects/ (e.g., srcs/foo.cbl -> objects/foo.cob)
PRECOMPILED = $(patsubst $(SRC_FOLDER)%.cbl, $(PRECOMPILED_FOLDER)%.cob, $(SRC))

# Shared libraries (e.g., objects/foo.so)
LIBS = $(patsubst $(PRECOMPILED_FOLDER)%.cob, $(LIBS_FOLDER)%.so, $(PRECOMPILED))

# Exports the path to the local libs to allow for runtime linkage
export COB_LIBRARY_PATH := libs

# Default rule
all: $(BIN) $(LIBS)
	./$(BIN)

# Prevents the makefile from considering .cob as intermediary objects, as they are sometimes useful for debugging
.SECONDARY: $(PRECOMPILED) $(MAIN_PRECOMPILED)

# Rule to make the entry point
$(BIN): $(MAIN_PRECOMPILED)
	cobc -x -locesql $(MAIN_PRECOMPILED) -o $(BIN) -I srcs/Copybooks

# Rule to build .cob files from .cbl files via ocesql
$(PRECOMPILED_FOLDER)%.cob: $(SRC_FOLDER)%.cbl
	@mkdir -p $(dir $@)
	ocesql $< $@

# Rule to build .so from .cob
$(LIBS_FOLDER)%.so: $(PRECOMPILED_FOLDER)%.cob
	@mkdir -p $(dir $@)
	cobc -m -locesql $< -o $@  -I srcs/Copybooks

install:
	@mkdir -p srcs/Copybooks input output
# Clean all generated files
clean:
	rm -rf $(OBJECT_FOLDER) $(PRECOMPILED_FOLDER) $(LIBS_FOLDER) $(BIN)