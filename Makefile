.PHONY: test package

BIN_DIR = ./bin
BUILD_DIR = ./build
ARCH = $(shell uname -p)

CAIRO_PROGRAM = $(BUILD_DIR)/zerosync_compiled.json
STARK_PARSER = $(BIN_DIR)/stark_parser
RUST_TEST_LIB = $(BIN_DIR)/libzerosync_tests.dylib

CAIRO_PROGRAM:
	find src -type f \( -iname "*.cairo" -and -not -iname "test_*.cairo" \) \
		-exec cairo-compile {} --cairo_path src > build/zerosync_compiled.json \;

STARK_PARSER:
	@echo "Building STARK proof parser..."
	cd src/stark_verifier/parser; \
	cargo build --target-dir ../../../build/parser
	mkdir bin
	cp build/parser/debug/parser bin/stark_parser

RUST_TEST_LIB:
	@echo "Building Rust testing library..."
	cd tests/rust_tests; \
	maturin develop
	cp tests/rust_tests/target/debug/libzerosync_tests.dylib bin/libzerosync_tests.dylib
ifeq ($(ARCH), arm)
	# On Apple Silicon (ARM), replace the installed site-package binary with one targeting x86_64.
	# This is required due to a lack of ARM support in Protostar.
	cd tests/rust_tests; \
	maturin build --target x86_64-apple-darwin
	cp tests/rust_tests/target/x86_64-apple-darwin/debug/libzerosync_tests.dylib \
	   $$(python -c "import site; print(site.getsitepackages()[0])")/zerosync_tests/zerosync_tests.cpython-39-darwin.so
endif

chain-proof:
	python src/chain_proof/main.py

bridge-node:
	python src/utreexo/bridge_node.py

cairo-compile: CAIRO_PROGRAM
	@echo "Compiling cairo files..."

format-cairo:
	@echo "Formatting cairo files..."
	cairo-format src/**/*.cairo -i

format-cairo-check:
	@echo "Checking format of cairo files..."
	cairo-format src/**/*.cairo -c

rust-test-lib: RUST_TEST_LIB
	@echo "Building Rust testing library..."

unit-test:
	@echo "Running unit tests..."
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH protostar -p unit test


integration-test: STARK_PARSER
	@echo "Running integration tests..."
	PYTHONPATH=$$(python -c "import site; print(site.getsitepackages()[0])"):$$PYTHONPATH protostar -p integration test

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
