test:
	cat testsrc
	perl supjs.pl < testsrc | tee testresult
install:
	cp supjs.pl /usr/bin/supjs
