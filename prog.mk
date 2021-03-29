ALLDEPS += mkglue/prog.mk

OBJS +=  $(SRCS:%.c=$(O)/%.o)
OBJS :=  $(OBJS:%.cc=$(O)/%.o)
OBJS :=  $(OBJS:%.cpp=$(O)/%.o)
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
