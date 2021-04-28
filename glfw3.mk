PKG_CONFIG ?= pkg-config

ifndef GLFW3_MK
LGFW3_MK := 1

ALLDEPS += mkglue/glfw3.mk

ifeq ($(shell uname),Linux)

GLFW3_PKGS := glew glfw3
CPPFLAGS += $(shell pkg-config ${GLFW3_PKGS} --cflags)
LDFLAGS  += $(shell pkg-config ${GLFW3_PKGS} --libs)

else ifeq ($(shell uname),Darwin)

GLFW3_PKGS := glfw3
CPPFLAGS += $(shell pkg-config ${GLFW3_PKGS} --cflags)
LDFLAGS  += $(shell pkg-config ${GLFW3_PKGS} --libs)

LDFLAGS += -framework OpenGL

endif

endif
