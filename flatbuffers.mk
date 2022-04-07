ALLDEPS += mkglue/flatbuffers.mk

SRCDEPS += $(patsubst %.fbs,$(O)/%_generated.h,$(filter %.fbs,$(SRCS)))

${O}/%_generated.h: %.fbs ${ALLDEPS}
	@mkdir -p $(dir $@)
	@echo "\tFLATC\t$@"
	flatc -c --scoped-enums -o $(dir $@) $<
