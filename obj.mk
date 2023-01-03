ALLDEPS += mkglue/obj.mk

SRCS += ${SRCS-yes}

OBJS += $(patsubst %.c,    $(O)/%.o,      $(filter %.c,   ${SRCS}))
OBJS += $(patsubst %.cc,   $(O)/%.o,      $(filter %.cc,  ${SRCS}))
OBJS += $(patsubst %.cpp,  $(O)/%.o,      $(filter %.cpp, ${SRCS}))
OBJS += $(patsubst %.glsl, $(O)/%.glsl.o, $(filter %.glsl,${SRCS}))
OBJS += $(patsubst %.png,  $(O)/%.png.o,  $(filter %.png, ${SRCS}))

DEPS +=  ${OBJS:%.o=%.d}

${O}/%.o: %.c  $(ALLDEPS) $(SRCDEPS)
	@mkdir -p $(dir $@)
	@echo "\tCC\t$@"
	$(CC) -MD -MP $(CPPFLAGS) $(CFLAGS) -c -o $@ $(CURDIR)/$<

${O}/%.o: %.cc $(ALLDEPS)  $(SRCDEPS)
	@mkdir -p $(dir $@)
	@echo "\tCXX\t$@"
	$(CXX) -MD -MP $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $(CURDIR)/$<

${O}/%.o: %.cpp $(ALLDEPS) $(SRCDEPS)
	@mkdir -p $(dir $@)
	@echo "\tCXX\t$@"
	$(CXX) -MD -MP $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $(CURDIR)/$<

${O}/%.glsl.c: %.glsl ${ALLDEPS}
	@mkdir -p $(dir $@)
	@echo "\tXXD\t$@"
	@(cd $(dir $<) && xxd -i $(notdir $<)) >$@

${O}/%.glsl.o: ${O}/%.glsl.c ${ALLDEPS}
	@mkdir -p $(dir $@)
	@echo "\tCC\t$@"
	$(CC) -MD -MP $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

${O}/%.png.c: %.png ${ALLDEPS}
	@mkdir -p $(dir $@)
	@echo "\tXXD\t$@"
	@(cd $(dir $<) && xxd -i $(notdir $<)) >$@

${O}/%.png.o: ${O}/%.png.c ${ALLDEPS}
	@mkdir -p $(dir $@)
	@echo "\tCC\t$@"
	$(CC) -MD -MP $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

-include $(DEPS)

$(V).SILENT:
