MOD_C=pipe/global.o\
	  core/log.o
MOD_CFLAGS=$(shell pkg-config --cflags libjpeg)
MOD_LDFLAGS=$(shell pkg-config --libs libjpeg)
pipe/modules/i-jpg/libi-jpg.$(SEXT):pipe/modules/i-jpg/jpegexiforient.h
