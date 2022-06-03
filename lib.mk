ALLDEPS += mkglue/lib.mk

.DEFAULT_GOAL := ${SOLIB}

CXXFLAGS += -fPIC
CFLAGS += -fPIC
NVCCFLAGS += --compiler-options -fPIC

include mkglue/obj.mk

${SOLIB}: $(OBJS) $(ALLDEPS)
	@mkdir -p $(dir $@)
	@echo "\tLINK\t$@"
	$(CXX) -shared -o $@ ${OBJS} $(LDFLAGS) ${LDFLAGS_cfg}

clean:
	rm -rf "${O}"

