# Copyright (c) 2014 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

CFLAGS=-g -O0 -I$(NACL_SDK_ROOT)/include
LIBS=-lppapi_simple_cpp -lsdk_util -lnacl_io -lppapi -lppapi_cpp
CFLAGS32=$(CFLAGS) -m32
CFLAGS64=$(CFLAGS) -m64
LDFLAGS32=-L$(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/usr/lib32 \
          -L$(NACL_TOOLCHAIN_ROOT)/i686-nacl/usr/lib
LDFLAGS64=-L$(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/usr/lib \
          -L$(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/usr/lib

all: voronoi.nmf

voronoi.nmf: voronoi_x86_32.nexe voronoi_x86_64.nexe lib32 lib64
	./nmf_gen.py

voronoi_x86_32.nexe: voronoi_x86_32.o
	$(CXX) $(CFLAGS32) -o $@ $< $(LIBS) $(LDFLAGS32)

voronoi_x86_64.nexe: voronoi_x86_64.o
	$(CXX) $(CFLAGS) -m64 -o $@ $< $(LIBS) $(LDFLAGS64)

voronoi_x86_32.o: voronoi.cc
	$(CXX) $(CFLAGS32) -c $< -o $@

voronoi_x86_64.o: voronoi.cc
	$(CXX) $(CFLAGS64) -c $< -o $@

lib32:
	bash -c 'mkdir -p lib32'
	bash -c 'cp $(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/lib32/*.so* lib32/'
	bash -c 'cp $(NACL_TOOLCHAIN_ROOT)/i686-nacl/usr/lib/*.so* lib32/'

lib64:
	bash -c 'mkdir -p lib64'
	bash -c 'cp $(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/lib/*.so* lib64/'
	bash -c 'cp $(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/usr/lib/*.so* lib64/'

serve:
	./demo.py

ifeq ($(NACL_ARCH),i686)
  NEXE_ARCH=x86_32
else 
  NEXE_ARCH=x86_64
endif

run:
	bash -c 'NACL_SPAWN_MODE=popup NACL_POPUP_WIDTH=512 NACL_POPUP_HEIGHT=512 ./voronoi_$(NEXE_ARCH).nexe'

clean:
	bash -c 'rm -rf *.nmf *.o *.nexe lib32 lib64 || true'
