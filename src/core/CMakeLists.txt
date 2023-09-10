file(GLOB SRCS *.c)

file(WRITE version.h
  "#pragma once\n"
  "#define VKDT_VERSION \"${VKDT_VERSION}\"\n"
)

add_library(core OBJECT ${SRCS} version.h)

target_link_libraries(core pthread dl)
