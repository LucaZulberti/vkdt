cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME MOD_NAME)

add_library(${MOD_NAME} SHARED main.c)

find_package(AVFormat REQUIRED)
find_package(AVCodec REQUIRED)

target_include_directories(${MOD_NAME} PRIVATE ../../ ${AVFormat_INCLUDE_DIR} ${AVCodec_INCLUDE_DIR})
target_compile_options(${MOD_NAME} PRIVATE -fPIC)
target_link_libraries(${MOD_NAME} PRIVATE connector ${AVFormat_LIBRARY} ${AVCodec_LIBRARY})

set_target_properties(${MOD_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/modules/${MOD_NAME})
