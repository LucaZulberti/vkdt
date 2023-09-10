MOD_C=pipe/modules/i-geo/corona/prims.c\
      pipe/global.o\
	  core/log.o
MOD_LDFLAGS=-lm
pipe/modules/i-geo/libi-geo.$(SEXT): pipe/modules/i-geo/corona/geo.h pipe/modules/i-geo/corona/prims.h pipe/modules/i-geo/corona/prims.c
