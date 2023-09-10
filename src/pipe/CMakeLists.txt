file(GLOB SRCS *.c)

add_library(pipe OBJECT ${SRCS})


# Modules

file(GLOB MODULES_DIR modules)

# Needed by some modules
add_library(connector OBJECT connector.c)
add_library(global OBJECT global.c ../core/log.c)
add_library(graph-io OBJECT graph-io.c module.c)

add_subdirectory(modules)


# Shaders

set(GLSL_VALIDATOR glslangValidator)

file(GLOB GLSL_SRCS
  "modules/*/*.comp"
  "modules/*/*.vert"
  "modules/*/*.tesc"
  "modules/*/*.tese"
  "modules/*/*.geom"
  "modules/*/*.frag"
)

foreach(GLSL ${GLSL_SRCS})
  cmake_path(GET GLSL FILENAME GLSL_NAME)
  cmake_path(GET GLSL PARENT_PATH MOD_DIR)
  cmake_path(GET MOD_DIR FILENAME MOD_NAME)

  set(SPIRV ${PROJECT_BINARY_DIR}/modules/${MOD_NAME}/${GLSL_NAME}.spv)

  add_custom_command(
    OUTPUT  ${SPIRV}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/modules/${MOD_NAME}
    COMMAND ${GLSL_VALIDATOR} --quiet -V -I${MODULES_DIR} --target-env vulkan1.2 ${GLSL} -o ${SPIRV}
    DEPENDS ${GLSL})

  list(APPEND ${MOD_NAME}_SHADERS ${SPIRV})
endforeach()


# Tooltips

file(GLOB RDME_SRCS modules/*/readme.md)

foreach(RDME ${RDME_SRCS})
  cmake_path(GET RDME PARENT_PATH MOD_DIR)
  cmake_path(GET MOD_DIR FILENAME MOD_NAME)

  set(PTOOLTIPS ${PROJECT_BINARY_DIR}/modules/${MOD_NAME}/ptooltips)
  set(CTOOLTIPS ${PROJECT_BINARY_DIR}/modules/${MOD_NAME}/ctooltips)
  set(TOOLTIPS ${PTOOLTIPS} ${CTOOLTIPS})

  add_custom_command(
    OUTPUT  ${TOOLTIPS}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/modules/${MOD_NAME}
    COMMAND ${CMAKE_COMMAND} -E touch ${TOOLTIPS}
    COMMAND sed -n "/## parameters/,/## / p" ${RDME} | sed -n -e "/^* / p" -e "/^  / p" | tr -d "\\n" | sed -e "s/\\* `/\\n/g" -e "s/` */`/g" -e "s/`/:/g" | sed -e "1d" -e "$a\\" > ${PTOOLTIPS}
    COMMAND sed -n "/## connectors/,/## / p" ${RDME} | sed -n -e "/^* / p" -e "/^  / p" | tr -d "\\n" | sed -e "s/\\* `/\\n/g" -e "s/` */`/g" -e "s/`/:/g" | sed -e "1d" -e "$a\\" > ${PTOOLTIPS}
    VERBATIM
    DEPENDS ${RDME})

  list(APPEND ${MOD_NAME}_TOOLTIPS ${TOOLTIPS})
endforeach()


# Connectors

file(GLOB CONNECTORS modules/*/connectors)

foreach(CONN ${CONNECTORS})
  cmake_path(GET CONN PARENT_PATH MOD_DIR)
  cmake_path(GET MOD_DIR FILENAME MOD_NAME)

  set(CONN_CPY ${PROJECT_BINARY_DIR}/modules/${MOD_NAME}/connectors)

  add_custom_command(
    OUTPUT  ${CONN_CPY}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/modules/${MOD_NAME}
    COMMAND ${CMAKE_COMMAND} -E copy ${CONN} ${CONN_CPY}
    DEPENDS ${CONN})

  list(APPEND ${MOD_NAME}_CONNECTORS ${CONN_CPY})
endforeach()


# Group all modules components (use readme search)

foreach(MOD ${RDME_SRCS})
  cmake_path(GET MOD PARENT_PATH MOD_DIR)
  cmake_path(GET MOD_DIR FILENAME MOD_NAME)

  add_custom_target(module-${MOD_NAME} DEPENDS ${${MOD_NAME}_SHADERS} ${${MOD_NAME}_TOOLTIPS} ${${MOD_NAME}_CONNECTORS})

  if(TARGET ${MOD_NAME})
    add_dependencies(module-${MOD_NAME} ${MOD_NAME})
  endif()

  list(APPEND MODULES module-${MOD_NAME})
endforeach()

add_custom_target(modules DEPENDS ${MODULES})
