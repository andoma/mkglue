ALLDEPS += mkglue/obj.mk

.DEFAULT_GOAL := ${PROG}

include mkglue/obj.mk

${PROG}: $(OBJS) $(ALLDEPS)
	@mkdir -p $(dir $@)
	@echo "\tLINK\t$@"
	$(CXX) -o $@ ${OBJS} $(LDFLAGS) ${LDFLAGS_cfg}

clean:
	rm -rf "${O}"


