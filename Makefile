.PHONY: test package 

BIN_DIR = ./bin
BUILD_DIR = ./build
ARCH = $(shell uname -p)

CAIRO_PROGRAM = $(BUILD_DIR)/zerosync_compiled.json
STARK_PARSER = $(BIN_DIR)/stark_parser
RUST_HINT_LIB = $(BIN_DIR)/libzerosync_hints.dylib

# TODO: Create a recipe for $(CAIRO_PROGRAM) listing all prerequisites

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

chain_proof:
	python src/chain_proof/main.py

bridge_node:
	python src/utxo_set/bridge_node.py

stark_parser: $(STARK_PARSER)
	@echo "Building STARK proof parser..."

cairo_compile:
	@echo "Compiling cairo files..."
	find src -type f \( -iname "*.ejs" \) -exec sh -c 'ejs {} > $$(dirname {})/$$(basename {} .ejs)' \;
	find src -type f \( -iname "*.cairo" -and -not -iname "test_*.cairo" \) \
		-exec cairo-compile {} --cairo_path src > build/zerosync_compiled.json \;

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
	PYTHONPATH=$$(echo pwd)/tests:$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH protostar -p integration test

test:
	@echo "Running test $(TEST_PATH)..."
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH protostar test --cairo-path=./src target tests/unit/$(TEST_PATH)

clean:
	rm -rf build
	mkdir build
	rm -rf package_build
	
package:
	@echo "Building pip package..."
	mkdir -p package_build/
	cp -r MANIFEST.in __init.py__ setup.py setup.cfg src package_build/
	set -e; \
	set -f; \
	cd package_build; \
	mv src zerosync; \
	CAIRO_FILES=$$(find zerosync -type f \( -iname '*.cairo' -and -not -iname 'test_*.cairo' \)); \
	for FILE in $$CAIRO_FILES; do \
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
