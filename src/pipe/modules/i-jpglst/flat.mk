MOD_C=pipe/global.o\
	  core/log.o
MOD_CFLAGS=$(shell pkg-config --cflags libjpeg)
MOD_LDFLAGS=$(shell pkg-config --libs libjpeg)
