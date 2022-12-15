.PHONY: test package

compile-cairo:
	@echo "Compiling cairo files..."
	find src -type f \( -iname "*.cairo" -and -not -iname "test_*.cairo" \) -exec cairo-compile {} --cairo_path src > build/zerosync_compiled.json \;

bin/stark_parser:
	@echo "Build parser..."
	cd src/stark_verifier/parser; \
	cargo build --target-dir ../../../build/parser
	mkdir bin
	cp build/parser/debug/parser bin/stark_parser

chain-proof:
	source ~/cairo_venv/bin/activate; python3 src/chain_proof/main.py

bridge-node:
	source ~/cairo_venv/bin/activate; python src/utreexo/bridge_node.py

unit-test:
	@echo "Running unit tests..."
	protostar test --cairo-path=./src target src

integration-test: bin/stark_parser
	@echo "Running integration tests..."
	protostar -p integration test

format-cairo:
	@echo "Formatting cairo files..."
	cairo-format src/**/*.cairo -i

format-cairo-check:
	@echo "Checking format of cairo files..."
	cairo-format src/**/*.cairo -c

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
