SHELL = /bin/sh
.PHONY: clean quick
.SUFFIXES:
.SUFFIXES: .coffee .js

comb-compiled.js: comb.js
	java -jar compiler.jar --js comb.js --js_output_file comb-compiled.js

comb.js: comb.coffee
	coffee -c comb.coffee

comb.coffee: decaf.coffee
	./ppp.py decaf.coffee > comb.coffee

quick: comb.js

clean:
	rm -f comb-compile.js comb.js comb.coffee