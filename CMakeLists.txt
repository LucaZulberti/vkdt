cmake_minimum_required(VERSION 3.20)
project(darktable_ng C CXX)

set(VKDT_VERSION 1.0.0)
set(VKDTLIB_VERSION 1.0.0)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
endif()

set(FLAGS "-DVK_PROTOTYPES -Wall -O3")

set(FLAGS "-DVK_PROTOTYPES -DVK_ENABLE_BETA_EXTENSIONS -Wall -O3")

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FLAGS}")

# GLFW
set(GLFW_DIR ./ext/glfw) # Set this to point to an up-to-date GLFW repo
option(GLFW_BUILD_EXAMPLES "Build the GLFW example programs" OFF)
option(GLFW_BUILD_TESTS "Build the GLFW test programs" OFF)
option(GLFW_BUILD_DOCS "Build the GLFW documentation" OFF)
option(GLFW_INSTALL "Generate installation target" OFF)
option(GLFW_DOCUMENT_INTERNALS "Include internals in documentation" OFF)
add_subdirectory(${GLFW_DIR} binary_dir EXCLUDE_FROM_ALL)
include_directories(${GLFW_DIR}/include)

# Dear ImGui
set(IMGUI_DIR ./ext/imgui)
include_directories(${IMGUI_DIR} ${IMGUI_DIR}/backends)
set(IMGUI_SRCS ${IMGUI_DIR}/backends/imgui_impl_glfw.cpp ${IMGUI_DIR}/backends/imgui_impl_vulkan.cpp ${IMGUI_DIR}/imgui.cpp ${IMGUI_DIR}/imgui_draw.cpp ${IMGUI_DIR}/imgui_tables.cpp ${IMGUI_DIR}/imgui_widgets.cpp)
# Use FreeType with ImGui
set(IMGUI_SRCS ${IMGUI_SRCS} ${IMGUI_DIR}/misc/freetype/imgui_freetype.cpp)

# Libraries
find_package(Vulkan REQUIRED)
set(VK_LIB "Vulkan::Vulkan")

# Use vulkan headers from glfw
include_directories(${GLFW_DIR}/deps)

# System includes
include_directories(/usr/local/include SYSTEM)

# Load VkDT components
include_directories(src)
add_subdirectory(src)

# VkDT Dynamic Library
add_library(vkdt SHARED)
set_target_properties(vkdt PROPERTIES VERSION ${VKDTLIB_VERSION})
set_target_properties(vkdt PROPERTIES PUBLIC_HEADER lib/vkdt.h)
target_link_libraries(vkdt core db qvk pipe ${VK_LIB})

# VkDT Fit (Optimiser)
add_executable(vkdt-fit)
target_link_libraries(vkdt-fit fit core db qvk pipe ${VK_LIB})

# VkDT CLI (Command Line Interface)
add_executable(vkdt-cli)
target_link_libraries(vkdt-cli cli core db qvk pipe ${VK_LIB})

# VkDT (GUI)
add_executable(vkdt-gui ${IMGUI_SRCS})
target_link_libraries(vkdt-gui gui snd core db qvk pipe glfw ${VK_LIB})
