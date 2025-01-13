cmake_minimum_required(VERSION 3.16)
project(hyprlua LANGUAGES CXX)

# Force C++23
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Generate compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(PIXMAN REQUIRED pixman-1)
include_directories(${PIXMAN_INCLUDE_DIRS})

add_library(hyprlua SHARED
    src/main.cpp
    src/globals.hpp
)

target_link_libraries(hyprlua ${PIXMAN_LIBRARIES})
