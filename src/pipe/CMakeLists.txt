file(GLOB SRCS *.c)

add_library(pipe OBJECT ${SRCS})

# Modules

file(GLOB MODULES_DIRS modules/*)

foreach(MOD_DIR ${MODULES_DIRS})
  file(GLOB MOD_SRCS ${MOD_DIR}/*.c ${MOD_DIR}/*.cc)
  cmake_path(GET MOD_DIR FILENAME MOD_NAME)

  if(MOD_SRCS)
    add_library(${MOD_NAME} SHARED ${MOD_SRCS} connector.c)

    target_include_directories(${MOD_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_compile_options(${MOD_NAME} PRIVATE -fPIC)
    set_target_properties(${MOD_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/modules/${SHD_MOD_NAME})
  endif(MOD_SRCS)

  # list(APPEND PIPE_MODULES_LIBS ${MOD_NAME})
endforeach()

# Shaders

set(GLSL_VALIDATOR glslangValidator)

file(GLOB MOD_DIR modules)

file(GLOB GLSL_SRCS
  "modules/*/*.comp"
  "modules/*/*.vert"
  "modules/*/*.tesc"
  "modules/*/*.tese"
  "modules/*/*.geom"
  "modules/*/*.frag"
)

foreach(GLSL ${GLSL_SRCS})
  cmake_path(GET GLSL FILENAME SHD_NAME)
  cmake_path(GET GLSL PARENT_PATH SHD_MOD)
  cmake_path(GET SHD_MOD FILENAME SHD_MOD_NAME)

  set(SPIRV ${PROJECT_BINARY_DIR}/modules/${SHD_MOD_NAME}/${SHD_NAME}.spv)

  add_custom_command(
    OUTPUT ${SPIRV}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/modules/${SHD_MOD_NAME}
    COMMAND ${GLSL_VALIDATOR} -I${MOD_DIR} --target-env vulkan1.2 ${GLSL} -o ${SPIRV}
    DEPENDS ${GLSL})

  list(APPEND SPIRV_BINS ${SPIRV})
endforeach(GLSL)

add_custom_target(shaders DEPENDS ${SPIRV_BINS})
