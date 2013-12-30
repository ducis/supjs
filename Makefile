test:
	cat testsrc
	perl supjs.pl < testsrc
install:
	cp supjs.pl /usr/bin/supjs
