cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME MOD_NAME)

include_directories(corona)

add_library(${MOD_NAME} SHARED main.c corona/prims.c)

target_include_directories(${MOD_NAME} PRIVATE ../../)
target_compile_options(${MOD_NAME} PRIVATE -fPIC)
target_link_libraries(${MOD_NAME} PRIVATE core global ${VK_LIB})

set_target_properties(${MOD_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/modules/${MOD_NAME})
