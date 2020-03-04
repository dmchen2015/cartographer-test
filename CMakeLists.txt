cmake_minimum_required(VERSION 3.2)
project(cartographer)

# c++ 11
set(CMAKE_CXX_STANDARD 11)

# cmake include
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/ext)
include(function)
include(version)
include(ext)

# lib output & link dir
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
link_directories(${PROJECT_SOURCE_DIR}/lib)

# build executable
add_executable(cartographer_autogenerate_ground_truth ext/cartographer/cartographer/ground_truth/autogenerate_ground_truth_main.cc)
target_link_libraries(cartographer_autogenerate_ground_truth ${EXT_DEPS})
