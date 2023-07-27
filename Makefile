.PHONY: test package 


BIN_DIR = ./bin
BUILD_DIR = ./build
ARCH = $(shell uname -p)

CAIRO_PARAMETERS = src/stark_verifier/parameters/parameters.cairo
CAIRO_FILES = $(shell find src -type f -iname "*.cairo" -and -not -iname "test_*.cairo" -not -path "./src/chain_proof/*" -not -path "./src/headers_chain_proof/*")
CHAIN_PROOF_PROGRAM = $(BUILD_DIR)/chain_proof_compiled.json
HEADERS_CHAIN_PROOF_PROGRAM = $(BUILD_DIR)/headers_chain_proof_compiled.json
STARK_PARSER = $(BIN_DIR)/stark_parser
RUST_HINT_LIB = $(BIN_DIR)/libzerosync_hints.dylib

.DELETE_ON_ERROR: $(CAIRO_PARAMETERS) $(CHAIN_PROOF_PROGRAM) $(HEADERS_CHAIN_PROOF_PROGRAM)

CHAIN_PROOF_PARAMETERS = src/chain_proof/parameters.json
HEADERS_CHAIN_PROOF_PARAMETERS = src/headers_chain_proof/parameters.json

# Recipe for header_chain_proof and chain_proof compilation
$(CHAIN_PROOF_PROGRAM): $(CAIRO_FILES) src/chain_proof/*.cairo
	mkdir -p $(BUILD_DIR)
	$([ -e $(CAIRO_PARAMETERS) ] && rm $(CAIRO_PARAMETERS))
	python ./src/stark_verifier/parameters/parameters.py $(CHAIN_PROOF_PARAMETERS)
	cairo-compile src/chain_proof/main.cairo --cairo_path src --output $@

compile_chain_proof: $(CHAIN_PROOF_PROGRAM)
	@echo "Compiled src/chain_proof/main.cairo"

$(HEADERS_CHAIN_PROOF_PROGRAM): $(CAIRO_FILES) src/headers_chain_proof/*.cairo
	mkdir -p $(BUILD_DIR)
	$([ -e $(CAIRO_PARAMETERS) ] && rm $(CAIRO_PARAMETERS))
	python ./src/stark_verifier/parameters/parameters.py $(HEADERS_CHAIN_PROOF_PARAMETERS)
	cairo-compile src/headers_chain_proof/main.cairo --cairo_path src --output $@ --proof_mode

compile_headers_chain_proof: $(HEADERS_CHAIN_PROOF_PROGRAM)
	@echo "Compiled src/headers_chain_proof/main.cairo"

INTEGRATION_PROGRAM_NAME := fibonacci
INTEGRATION_PARAMETERS = tests/integration/cairo_parameters/$(INTEGRATION_PROGRAM_NAME).json
INTEGRATION_PROGRAM_SRC = tests/integration/cairo_programs/$(INTEGRATION_PROGRAM_NAME).cairo
INTEGRATION_PROGRAM_COMPILED = tests/integration/cairo_programs_compiled/$(INTEGRATION_PROGRAM_NAME).json
INTEGRATION_PROGRAM_TRACE = tests/integration/cairo_programs_trace/$(INTEGRATION_PROGRAM_NAME)
INTEGRATION_PROGRAM_PROOF = tests/integration/stark_proofs/$(INTEGRATION_PROGRAM_NAME).bin
FOLDING_FACTOR = 8

$(INTEGRATION_PROGRAM_PROOF): $(INTEGRATION_PROGRAM_SRC)
	mkdir -p $(INTEGRATION_PROGRAM_TRACE)
	cairo-compile $< --cairo_path src --output $(INTEGRATION_PROGRAM_COMPILED)
	cairo-run --layout all --program $(INTEGRATION_PROGRAM_COMPILED) --trace_file $(INTEGRATION_PROGRAM_TRACE)/trace.bin --memory_file $(INTEGRATION_PROGRAM_TRACE)/memory.bin
	giza prove --program $(INTEGRATION_PROGRAM_COMPILED) --trace $(INTEGRATION_PROGRAM_TRACE)/trace.bin --memory $(INTEGRATION_PROGRAM_TRACE)/memory.bin --fri-folding-factor $(FOLDING_FACTOR) --output $@

$(STARK_PARSER): $(addprefix parser/src/,lib.rs main.rs memory.rs)
	cargo build;
	mkdir -p bin;
	cp target/debug/zerosync_parser bin/stark_parser

$(RUST_HINT_LIB): hints/src/lib.rs
	cd hints; \
	maturin develop; \
	cp target/debug/libzerosync_hints.dylib ../bin/libzerosync_hints.dylib | true
ifeq ($(ARCH), arm)
	# On Apple Silicon (ARM), replace the installed site-package binary with one targeting x86_64.
	# This is required due to a lack of ARM support in Protostar.
	cd hints; \
	maturin build --target x86_64-apple-darwin
	cp hints/target/x86_64-apple-darwin/debug/libzerosync_hints.dylib \
	   $$(python -c "import site; print(site.getsitepackages()[0])")/zerosync_hints/zerosync_hints.cpython-39-darwin.so
endif

chain_proof: $(CHAIN_PROOF_PROGRAM)
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH python src/chain_proof/main.py

headers_chain_proof: $(HEADERS_CHAIN_PROOF_PROGRAM)
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH python src/headers_chain_proof/main.py

bridge_node:
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$(pwd):$$PYTHONPATH python src/utxo_set/bridge_node.py

headers_bridge_node:
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$(pwd):$$PYTHONPATH python src/headers_chain_proof/bridge_node.py

stark_parser: $(STARK_PARSER)
	@echo "Building STARK proof parser..."

cairo_compile:
	@echo "Compiling Cairo programs into a single output file..."
	@find src -type f \( -iname "*.ejs" \) -exec sh -c 'ejs {} > $$(dirname {})/$$(basename {} .ejs)' \;
	@find src -type f \( -iname "*.cairo" \) \
		-exec cairo-compile {} --cairo_path src > build/zerosync_compiled.json \;

cairo_compile_programs:
	@echo "Compiling Cairo programs into separate programs files..."
	@find src -type f \( -iname "*.ejs" \) -exec sh -c 'ejs {} > $$(dirname {})/$$(basename {} .ejs)' \;
	@find src -type d | sed 's/src/build/g' | xargs mkdir -p
	@for file in ${CAIRO_FILES}; do \
		target=$$(echo "$${file%.cairo}_compiled.json" | sed 's/src/build/g'); \
		echo $$target...; \
		cairo-compile $$file --cairo_path src --output $$target || exit 1; \
	done

format_cairo:
	@echo "Formatting cairo files..."
	cairo-format src/**/*.cairo -i

format_cairo_check:
	@echo "Checking format of cairo files..."
	cairo-format src/**/*.cairo -c

rust_hint_lib: $(RUST_HINT_LIB)
	@echo "Building Rust hint library..."

unit_test:
	@echo "Running unit tests..."
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH protostar -p unit test

integration_test: $(STARK_PARSER)
	@echo "Running integration tests..."
	$([ -e $(CAIRO_PARAMETERS) ] && rm $(CAIRO_PARAMETERS))
	python ./src/stark_verifier/parameters/parameters.py $(INTEGRATION_PARAMETERS)
	PYTHONPATH=$$(echo pwd)/tests:$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH protostar -p integration test --max-steps 100000000

test:
	@echo "Running test $(TEST_PATH)..."
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH protostar test --cairo-path=./src target tests/unit/$(TEST_PATH) --max-steps 100000000

# Generate a proof for any program in tests/integration/cairo_programs/
# Use make INTEGRATION_PROGRAM_NAME=fibonacci integration_proof
integration_proof: $(INTEGRATION_PROGRAM_PROOF)
	@echo "Generating proof for $(INTEGRATION_PROGRAM_NAME)..."


# To call benchmark block with a differnet block use: make BLOCK=12345 benchmark_block
BLOCK := 100000
benchmark_block:
	python src/utils/benchmark_block.py $(BLOCK)

clean:
	rm -rf build
	rm -rf bin
	mkdir build
	rm -rf package_build
	rm -rf tests/integration/cairo_programs_compiled/*
	rm -rf tests/integration/cairo_programs_trace/*
	rm -rf tests/integration/stark_proofs/*
	
package:
	@echo "Building pip package..."
	mkdir -p package_build/
	cp -r MANIFEST.in __init.py__ setup.py setup.cfg src package_build/
	set -e; \
	set -f; \
	cd package_build; \
	mv src zerosync; \
	for FILE in $$(find zerosync -type f -iname "*.cairo" -and -not -iname "test_*.cairo"); do \
		echo $$FILE;\
		IMPORTS=$$(grep -Po '(?<=from (?!starkware|zerosync))(.+?)(?=import)' $$FILE | tr '.' '/'); \
		echo $$IMPORTS; \
		for IMPORT in $$IMPORTS; do \
			TMP='**/'; \
			TMP+=$$IMPORT; \
			TMP+='.cairo'; \
			NEW_PATH=$$(find zerosync -type f \( -wholename $$TMP \)); \
			NEW_IMPORT=$${NEW_PATH//.cairo}; \
			REPLACE_STR='s/from '; \
			REPLACE_STR+=$${IMPORT//\//.}; \
			REPLACE_STR+='/from '; \
			REPLACE_STR+=$${NEW_IMPORT//\//.}; \
			REPLACE_STR+='/g'; \
			sed -i "$$REPLACE_STR" $$FILE; \
		done; \
	done; \
	python3 -m build
