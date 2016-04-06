SUBDIRS=htsbox bgt

all:rtgeval.kit/htsbox rtgeval.kit/bgt rtgeval.kit/hapdip.js rtgeval.kit/k8 \
	rtgeval.kit/RTG.jar rtgeval.kit/run-rtgeval rtgeval.kit/run-flt \
	rtgeval.kit/RTG-LICENSE.txt

rtgeval.kit:
	mkdir -p $@

all-recur clean-recur:
	@target=`echo $@ | sed s/-recur//`; \
	wdir=`pwd`; \
	list='$(SUBDIRS)'; for subdir in $$list; do \
		cd $$subdir; \
		$(MAKE) $$target || exit 1; \
		cd $$wdir; \
	done;

prepare:all-recur rtgeval.kit

rtgeval.kit/htsbox:prepare
	cp htsbox/htsbox $@; strip $@

rtgeval.kit/bgt:prepare
	cp bgt/bgt $@; strip $@

rtgeval.kit/hapdip.js:prepare
	cp hapdip/hapdip.js $@

rtgeval.kit/k8:k8-0.2.2.tar.bz2 rtgeval.kit
	(cd rtgeval.kit; tar -jxf ../$< k8-`uname -s|tr [A-Z] [a-z]` && mv k8-`uname -s|tr [A-Z] [a-z]` k8)

rtgeval.kit/RTG.jar:prepare
	cp rtg/RTG.jar rtg/rtg rtg/rtg.cfg rtgeval.kit

rtgeval.kit/run-rtgeval:prepare
	cp run-rtgeval $@

rtgeval.kit/run-flt:prepare
	cp run-flt $@

rtgeval.kit/RTG-LICENSE.txt:prepare
	cp rtg/LICENSE.txt $@

clean:clean-recur
	rm -fr rtgeval.kit

.PHONY: all all-recur clean-recur prepare clean
