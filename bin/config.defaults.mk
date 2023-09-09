# build time configuration.
# select your favourite bloat here.
# this is the default file which is always loaded. please don't edit it
# directly, it will be overwritten by a new version that may come with a git
# pull or so. if 'config.mk' exists, it will be loaded after this, so you can
# overwrite the settings in here by copying the file over and making changes
# there.

# if you have freetype2 and png16, you can uncomment this:
# VKDT_USE_FREETYPE=1
# export VKDT_USE_FREETYPE

# if you disable this, the i-raw module will not be built
# and you will be unable to load raw images.
# since rawspeed is a submodule this is only useful if
# you want to avoid the recursive dependencies.
# note that since this in on by default in here, you'll need
# to explicitly set it to =0 and export again in config.mk to
# switch it off effectively.
VKDT_USE_RAWSPEED=1
export VKDT_USE_RAWSPEED

# exiv2 can optionally be used to load some super basic metadata (iso
# speed, shutter time etc) inside the i-raw module. that is, you don't
# have that you don't need to disable this.
# VKDT_USE_EXIV2=1
# export VKDT_USE_EXIV2

# v4l2 is used to read real-time webcam input in the i-v4l2 module.
# enable this feature here:
# VKDT_USE_V4L2=1
# export VKDT_USE_V4L2

# we use GPL3 code in the i-mlv magic lantern raw video input
# module. if you don't want it, leave it disabled here. if
# you want video, you probably also want VKDT_USE_ALSA=1, see below.
# VKDT_USE_MLV=1
# export VKDT_USE_MLV

# to play the audio that comes with the mlv video, vkdt uses
# alsa. this introduces an asound dependency. disable here:
# VKDT_USE_ALSA=1
# export VKDT_USE_ALSA

# for the i-vid module using libavformat/libavcodec to read
# video streams, we depend on these libraries
# VKDT_USE_FFMPEG=1
# export VKDT_USE_FFMPEG

# enable this if you have a custom build of glfw that supports the following
# three functions: glfwSetPenTabletDataCallback,
# glfwSetPenTabletCursorCallback, glfwSetPenTabletProximityCallback.
# VKDT_USE_PENTABLET=1
# export VKDT_USE_PENTABLET

# if this is enabled, it will build the i-quake module. it runs
# the quakespasm variant of the id software code for the classic quake
# game. it assumes you have the paks in /usr/share/games/quake.
# this will download and compile GPL code.
# VKDT_USE_QUAKE=1
# export VKDT_USE_QUAKE


# OS detect
UNAME := $(shell uname)

# compiler config
CC  = clang
CXX = clang++
AR  = ar

LDFLAGS =
EXE_LDFLAGS = -Wl,-pie

GLSLC=glslangValidator
GLSLC_FLAGS=--target-env vulkan1.2
# GLSLC=glslc
# GLSLC_FLAGS=--target-env=vulkan1.2

# optimised flags, you may want to use -march=x86-64 for distro builds:
OPT_CFLAGS=-Wall -pipe -O3 -march=native -DNDEBUG

ifneq ($(UNAME),Darwin)
SEXT = so

CFLAGS   += -D_GNU_SOURCE
CXXFLAGS += -D_GNU_SOURCE

EXE_CFLAGS ?= -fPIC

# Obsolete on macOS
OPT_LDFLAGS = -s

# Pass the library name as $1
generate_shared_flags = -shared -nostartfiles -Wl,-soname,$$1.$(SEXT)
else
SEXT = dylib

LDFLAGS += -rpath /usr/local/lib

# Pass the library name as $1
generate_shared_flags = -dynamiclib -Wl,-install_name,$$1.$(SEXT)
endif


# set this to 1 to signal rawspeed to build without processor specific extensions.
# again, this is important for building packages for distros.
RAWSPEED_PACKAGE_BUILD=0

export CC CXX AR LDFLAGS EXE_LDFLAGS GLSLC GLSLC_FLAGS OPT_CFLAGS OPT_LDFLAGS RAWSPEED_PACKAGE_BUILD SEXT generate_shared_flags

# where to find glfw for the gui:
VKDT_GLFW_CFLAGS=$(shell pkg-config --cflags glfw3)
VKDT_GLFW_LDFLAGS=$(shell pkg-config --libs glfw3)
export VKDT_GLFW_CFLAGS VKDT_GLFW_LDFLAGS

# where to find openmp:
ifneq ($(UNAME),Darwin)
  OMP_CC      = $(CC)
  OMP_CXX     = $(CXX)
  OMP_CFLAGS  = -fopenmp
  OMP_LDFLAGS = $(shell grep OpenMP_omp_LIBRARY:FILEPATH ../built/ext/rawspeed/CMakeCache.txt | cut -f2 -d=) -lgomp
else
  # FIXME: Not supported by macOS system clang, cannot pass -fopenmp flag
  OMP_CC      = /opt/homebrew/opt/llvm/bin/clang
  OMP_CXX     = /opt/homebrew/opt/llvm/bin/clang++
  OMP_CFLAGS  = -I/opt/homebrew/opt/libomp/include
  OMP_LDFLAGS = -L/opt/homebrew/opt/libomp/lib -lomp
endif
export OMP_CC OMP_CXX OMP_CFLAGS OMP_LDFLAGS