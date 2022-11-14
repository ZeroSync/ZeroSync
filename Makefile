.PHONY: test

compile-cairo:
	@echo "Compiling cairo files..."
	find src -type f \( -iname "*.cairo" -and -not -iname "test_*.cairo" \) -exec cairo-compile {} --cairo_path src > build/zerosync_compiled.json \;

test:
	@echo "Running tests..."
	protostar test

format-cairo:
	@echo "Formatting cairo files..."
	cairo-format src/**/*.cairo -i

format-cairo-check:
	@echo "Checking format of cairo files..."
	cairo-format src/**/*.cairo -c

clean:
	rm -rf build
	mkdir build