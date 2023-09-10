file(GLOB SRCS *.c)

add_library(cli OBJECT ${SRCS})

target_link_libraries(cli -rdynamic)
