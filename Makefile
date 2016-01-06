all: $(patsubst %.cc,%.nexe,$(wildcard *.cc))

ifeq ($(NACL_ARCH),i686)
  CXXARCH_FLAGS=-m32 -L $(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/usr/lib32 \
		     -L $(NACL_TOOLCHAIN_ROOT)/i686-nacl/usr/lib
endif
CXXFLAGS = -O2 -I$(NACL_SDK_ROOT)/include $(CXXARCH_FLAGS)
LIBS = -lppapi_simple_cpp -lsdk_util -lnacl_io -lppapi -lppapi_cpp

%.nexe: %.cc
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $< -o $@ $(LIBS)

%: %.nexe
	bash -c 'NACL_SPAWN_MODE=popup NACL_POPUP_WIDTH=512 NACL_POPUP_HEIGHT=512 ./$<'

clean:
	bash -c 'rm -f *.nexe'
