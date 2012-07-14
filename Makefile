SHELL = /bin/sh
SOURCES=$(wildcard src/*.coffee)
.PHONY: clean quick
.SUFFIXES:
.SUFFIXES: .coffee .js

comb-compiled.js: comb.js
	java -jar compiler.jar --js comb.js --js_output_file comb-compiled.js

comb.js: build/comb.coffee
	coffee -o . -c build/comb.coffee

build/comb.coffee: $(SOURCES)
	./ppp.py src/decaf.coffee > build/comb.coffee

quick: comb.js

clean:
	rm -f comb-compiled.js comb.js build/comb.coffee