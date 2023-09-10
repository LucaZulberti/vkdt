file(GLOB MODULES_COMPILE */CMakeLists.txt)

foreach(FILE ${MODULES_COMPILE})
  cmake_path(GET FILE PARENT_PATH DIR)
  cmake_path(GET DIR FILENAME DIR_NAME)
  add_subdirectory(${DIR_NAME})
endforeach()
