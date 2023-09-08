# OS detect
UNAME := $(shell uname)

.PHONY:all clean rawspeed
BUILT=../built/ext

all: rawspeed

rawspeed: Makefile $(BUILT)/rawspeed/librawspeed.a

ifeq ($(UNAME),Darwin)
  CMAKE_OS_DEFS  = -DCMAKE_C_COMPILER=/opt/homebrew/opt/llvm/bin/clang -DCMAKE_CXX_COMPILER=/opt/homebrew/opt/llvm/bin/clang++
  CMAKE_OS_DEFS += -DCMAKE_C_FLAGS="-Wno-unsafe-buffer-usage" -DCMAKE_CXX_FLAGS="-Wno-unsafe-buffer-usage"
endif

$(BUILT)/rawspeed/Makefile: Makefile
ifneq ($(VKDT_USE_RAWSPEED),1)
	mkdir -p $(BUILT)/rawspeed
	touch $(BUILT)/rawspeed/Makefile
else
ifeq ($(RAWSPEED_PACKAGE_BUILD),0)
	mkdir -p $(BUILT)/rawspeed
	cd $(BUILT)/rawspeed; cmake ../../../ext/rawspeed -G "Unix Makefiles" $(CMAKE_OS_DEFS) -DBUILD_TESTING=0 -DCMAKE_BUILD_TYPE=release -DRAWSPEED_ENABLE_LTO=off -DRAWSPEED_ENABLE_DEBUG_INFO=off -DBUILD_BENCHMARKING=off -DBUILD_FUZZERS=off -DBUILD_TOOLS=off
else
	mkdir -p $(BUILT)/rawspeed
	cd $(BUILT)/rawspeed; cmake ../../../ext/rawspeed -G "Unix Makefiles" $(CMAKE_OS_DEFS) -DBUILD_TESTING=0 -DCMAKE_BUILD_TYPE=release -DRAWSPEED_ENABLE_LTO=off -DRAWSPEED_ENABLE_DEBUG_INFO=off -DBUILD_BENCHMARKING=off -DBUILD_FUZZERS=off -DBUILD_TOOLS=off -DBINARY_PACKAGE_BUILD=on
endif
endif

# for some reason this is challenging for older? cmake
# cmake -S rawspeed/ -B $(BUILT)/rawspeed/ -DBUILD_TESTING=0 -DCMAKE_BUILD_TYPE=release

$(BUILT)/rawspeed/librawspeed.a: Makefile $(BUILT)/rawspeed/Makefile
	mkdir -p $(BUILT)/rawspeed
ifneq ($(VKDT_USE_RAWSPEED),1)
	touch $(BUILT)/rawspeed/librawspeed.a
else
	$(MAKE) -C $(BUILT)/rawspeed
	strip -S $(BUILT)/rawspeed/librawspeed.a
endif

clean: Makefile
	rm -r $(BUILT)/rawspeed
