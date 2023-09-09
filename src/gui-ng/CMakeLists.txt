file(GLOB SRCS *.cc)

add_library(gui OBJECT ${SRCS})

set(GUI_LIBS m dl -rdynamic)

find_package(Freetype REQUIRED)
if (Freetype_FOUND)
    target_include_directories(gui PUBLIC ${FREETYPE_INCLUDE_DIRS})
    set(GUI_LIBS ${GUI_LIBS} ${FREETYPE_LIBRARIES})
endif(Freetype_FOUND)

target_compile_definitions(gui PUBLIC IMGUI_USER_CONFIG="gui/imconfig_user.h")
target_link_libraries(gui PUBLIC ${GUI_LIBS})
