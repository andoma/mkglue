PKG_CONFIG ?= pkg-config

ifndef LIBAV_MK
LIBAV_MK := 1

ifeq '$(shell $(PKG_CONFIG) 2>/dev/null libavcodec ; echo $$?)' '0'

HAVE_LIBAV := yes

LIBAV_LDFLAGS  += $(shell $(PKG_CONFIG) --libs libavcodec libavutil)
LIBAV_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags libavcodec libavutil)

endif

endif
