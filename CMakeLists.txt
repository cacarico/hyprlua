cmake_minimum_required(VERSION 3.16)
project(hyprlua LANGUAGES CXX)

# Set C++23 standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Generate compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Find PkgConfig and Pixman
find_package(PkgConfig REQUIRED)
pkg_check_modules(PIXMAN REQUIRED pixman-1)
include_directories(${PIXMAN_INCLUDE_DIRS})

# Find Threads package for threading support
find_package(Threads REQUIRED)

# Add the plugin as a shared library
add_library(hyprlua SHARED
  src/main.cpp
  src/globals.cpp
  src/globals.hpp
  src/watcher.cpp
  src/watcher.hpp
  src/utils.cpp
  src/utils.hpp
)

# Include the src directory for header files
target_include_directories(hyprlua PRIVATE src/)

# Link against pixman and Threads
target_link_libraries(hyprlua PRIVATE ${PIXMAN_LIBRARIES} Threads::Threads)

# Optionally, set the output directory for the compiled library
set_target_properties(hyprlua PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build
)
