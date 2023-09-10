file(GLOB SRCS *.c)

# file(GLOB MODULES RELATIVE ./ modules/*)
# foreach(MOD IN ${MODULES})
#     add_subdirectory(${MOD})
# endforeach()

add_library(pipe OBJECT ${SRCS})
