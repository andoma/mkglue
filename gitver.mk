ALLDEPS += mkglue/gitver.mk

ifeq ($(shell uname),Darwin)
GITVER_MD5 := md5
else
GITVER_MD5 := md5sum
endif

GITVER_VARGUARD = $(1)_GUARD_$(shell echo $($(1)) | ${GITVER_MD5} | cut -d ' ' -f 1)

GIT_DESCRIBE_OUTPUT ?= $(shell git describe --always --dirty)

CPPFLAGS += -iquote${O}

${O}/version_git.h: ${O}/gitver/$(call GITVER_VARGUARD,GIT_DESCRIBE_OUTPUT)
	@echo  >$@ "#ifndef VERSION_GIT"
	@echo >>$@ "#define VERSION_GIT \"${GIT_DESCRIBE_OUTPUT}\""
	@echo >>$@ "#endif"

${O}/gitver/$(call GITVER_VARGUARD,GIT_DESCRIBE_OUTPUT):
	@rm -rf "${O}/gitver"
	@mkdir -p "${O}/gitver"
	@touch $@
