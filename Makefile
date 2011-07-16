SHELL = /bin/sh
.PHONY: clean quick
.SUFFIXES:
.SUFFIXES: .m4 .coffee .js

decaf-compiled.js: decaf.js
	java -jar compiler.jar --js decaf.js --js_output_file decaf-compiled.js

decaf.js: decaf.coffee
	coffee -c decaf.coffee

decaf.coffee: *.m4
	m4 decaf.m4 > decaf.coffee

quick: decaf.js

clean:
	rm -f decaf-compile.js decaf.js decaf.coffee