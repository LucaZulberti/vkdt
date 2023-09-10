file(GLOB SRCS *.c)

add_library(fit OBJECT ${SRCS})

target_link_libraries(fit m -rdynamic)
