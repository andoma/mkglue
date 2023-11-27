ALLDEPS += mkglue/cuda.mk

PKG_CONFIG ?= pkg-config

ifndef CUDA_MK

CUDA_MK := 1

ifeq '$(shell $(PKG_CONFIG) cuda-10.2 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-10.2/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-10.2)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-10.2)

else ifeq '$(shell $(PKG_CONFIG) cuda-11.0 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-11.0/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-11.0)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-11.0)

else ifeq '$(shell $(PKG_CONFIG) cuda-11.3 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-11.3/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-11.3)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-11.3)

else ifeq '$(shell $(PKG_CONFIG) cuda-11.4 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-11.4/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-11.4)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-11.4)

else ifeq '$(shell $(PKG_CONFIG) cuda-11.5 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-11.5/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-11.5)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-11.5)

else ifeq '$(shell $(PKG_CONFIG) cuda-11.6 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-11.6/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-11.6)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-11.6)

else ifeq '$(shell $(PKG_CONFIG) cuda-11.7 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-11.7/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-11.7)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-11.7)

else ifeq '$(shell $(PKG_CONFIG) cuda-11.8 ; echo $$?)' '0'

HAVE_CUDA := yes

NVCC := /usr/local/cuda-11.8/bin/nvcc

CUDA_LDFLAGS  += $(shell $(PKG_CONFIG) --libs cudart-11.8)
CUDA_CPPFLAGS += $(shell $(PKG_CONFIG) --cflags cudart-11.8)

else ifeq '$(shell which nvcc >/dev/null; echo $$?)' '0'
# nvcc is in path
# Ubuntu installs like this

NVCC := nvcc
CUDA_LDFLAGS += -lcudart
HAVE_CUDA := yes

endif

# Check for NCCL (no pkg-config)

CUDA_NCCL := $(shell :| gcc -include nccl.h ${CUDA_CPPFLAGS} -E -xc - >/dev/null 2>/dev/null; echo $$?)

ifeq '$(CUDA_NCCL)' '0'

CUDA_CPPFLAGS += -DHAVE_NCCL
CUDA_LDFLAGS += -lnccl

endif

# Optix

${O}/%.ptx.o: %.optix.cu ${ALLDEPS}
	mkdir -p $(dir $@)
	@echo "\tNVCC\t$@"
	${NVCC} ${CPPFLAGS} -ptx --use_fast_math ${NVCCFLAGS} -o $(O)/$*.ptx $<
	(cd $(dir $@) && xxd -i $(notdir $*.ptx)) >$@.c
	$(CC) -c -o $@ $@.c
	${NVCC} -M ${CPPFLAGS} ${NVCCFLAGS} -o ${@:%.o=%.d} -c $<
	sed -itmp "s:^$(notdir $*.optix.o) :$@ :" ${@:%.o=%.d}

# Standard cuda

${O}/%.cu.o: %.cu ${ALLDEPS}
	@mkdir -p $(dir $@)
	@echo "\tNVCC\t$@"
	${NVCC} ${CPPFLAGS} ${NVCCFLAGS} -o $@ -c $<
	${NVCC} -M ${CPPFLAGS} ${NVCCFLAGS} -o ${@:%.o=%.d} -c $<
	@sed -itmp "s:^$(notdir $@) :$@ :" ${@:%.o=%.d}

OBJS += $(patsubst %.cu, $(O)/%.cu.o, $(filter %.cu, $(filter-out %.optix.cu, ${SRCS})))
OBJS += $(patsubst %.optix.cu, $(O)/%.ptx.o, $(filter %.optix.cu, ${SRCS}))

endif
