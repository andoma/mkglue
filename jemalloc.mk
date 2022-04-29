ALLDEPS += mkglue/jemalloc.mk

PKG_CONFIG ?= pkg-config

ifndef JEMALLOC_MK
JEMALLOC_MK := 1

ifeq '$(shell $(PKG_CONFIG) 2>/dev/null jemalloc ; echo $$?)' '0'

HAVE_JEMALLOC := yes

JEMALLOC_LDFLAGS  += $(shell $(PKG_CONFIG) --libs jemalloc)
JEMALLOC_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags jemalloc) -DHAVE_JEMALLOC

endif

endif
