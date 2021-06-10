ALLDEPS += mkglue/prog.mk

OBJS += $(patsubst %.c,   $(O)/%.o, $(filter %.c,   ${SRCS}))
OBJS += $(patsubst %.cc,  $(O)/%.o, $(filter %.cc,  ${SRCS}))
OBJS += $(patsubst %.cpp, $(O)/%.o, $(filter %.cpp, ${SRCS}))

DEPS +=  ${OBJS:%.o=%.d}

${PROG}: $(OBJS) $(ALLDEPS)
	@mkdir -p $(dir $@)
	@echo "\tLINK\t$@"
	$(CXX) -o $@ ${OBJS} $(LDFLAGS) ${LDFLAGS_cfg}

${O}/%.o: %.c  $(ALLDEPS)
	@mkdir -p $(dir $@)
	@echo "\tCC\t$@"
	$(CC) -MD -MP $(CPPFLAGS) $(CFLAGS) -c -o $@ $(CURDIR)/$<

${O}/%.o: %.cc $(ALLDEPS)
	@mkdir -p $(dir $@)
	@echo "\tCXX\t$@"
	$(CXX) -MD -MP $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $(CURDIR)/$<

${O}/%.o: %.cpp $(ALLDEPS)
	@mkdir -p $(dir $@)
	@echo "\tCXX\t$@"
	$(CXX) -MD -MP $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $(CURDIR)/$<

clean:
	rm -rf "${O}"

-include $(DEPS)

$(V).SILENT:
