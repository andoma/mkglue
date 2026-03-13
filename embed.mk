ALLDEPS += mkglue/embed.mk

HOSTCC ?= cc

# Host tool: build mkembed for the build machine
MKEMBED := $(O)/mkglue/mkembed
$(MKEMBED): mkglue/mkembed.c $(ALLDEPS)
	@mkdir -p $(dir $@)
	@echo "\tHOSTCC\t$@"
	$(HOSTCC) -o $@ $<

# Template: called with $(1)=prefix $(2)=directory
define EMBED_BUNDLE_template
  _eb_files_$(1) := $$(shell find $(2) -type f 2>/dev/null)
  _eb_out_$(1)   := $(O)/embed/$(1).c
  _eb_obj_$(1)   := $(O)/embed/$(1).o
  _eb_dep_$(1)   := $(O)/embed/$(1).d

  $$(O)/embed/$(1).c: $$(_eb_files_$(1)) $$(MKEMBED) $$(ALLDEPS)
	@mkdir -p $$(dir $$@)
	@echo "\tEMBED\t$(1)"
	$$(MKEMBED) -o $$@ -d $$(O)/embed/$(1).embed.d -p $(1) $$(_eb_files_$(1))

  $$(O)/embed/$(1).o: $$(O)/embed/$(1).c $$(ALLDEPS)
	@mkdir -p $$(dir $$@)
	@echo "\tCC\t$$@"
	$$(CC) -MD -MP $$(CPPFLAGS) $$(CFLAGS) -c -o $$@ $$<

  OBJS += $$(O)/embed/$(1).o
  DEPS += $$(O)/embed/$(1).d $$(O)/embed/$(1).embed.d
endef

# Split "prefix:dir" and call template with two args
$(foreach b,$(EMBED_BUNDLES),$(eval $(call EMBED_BUNDLE_template,$(word 1,$(subst :, ,$(b))),$(word 2,$(subst :, ,$(b))))))
