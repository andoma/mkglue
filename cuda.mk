ALLDEPS += mkglue/cuda.mk

PKG_CONFIG ?= pkg-config

ifndef CUDA_MK

CUDA_MK := 1

ifeq '$(shell which nvcc >/dev/null; echo $$?)' '0'
# nvcc is in path (we assume we don't need pkg-config)
# Ubuntu installs like this

NVCC := nvcc
CUDA_LDFLAGS += -lcuda -lcudart
HAVE_CUDA := yes


else ifeq '$(shell $(PKG_CONFIG) cuda-10.2 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-10.2/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cuda-10.2 cudart-10.2)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cuda-10.2 cudart-10.2)

endif

endif
