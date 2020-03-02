cmake_minimum_required(VERSION 3.2)

set(CMAKE_CXX_STANDARD 11)

# version 1.0.0

# set configure directory and generate config.h file
set(CARTOGRAPHER_CONFIGURATION_FILES_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/config CACHE PATH ".lua config files directory")
configure_file(${CMAKE_CURRENT_LIST_DIR}/cartographer/common/config.h.cmake ${CMAKE_BINARY_DIR}/generated/cartographer/common/config.h)

# build proto
build_proto_files(${CMAKE_CURRENT_LIST_DIR} ${CMAKE_BINARY_DIR}/generated PROTO_SRCS)

# include directories
include_directories(${CMAKE_CURRENT_LIST_DIR} ${CMAKE_BINARY_DIR}/generated)

# get headers and sources
file(GLOB_RECURSE CARTO_SRCS "${CMAKE_CURRENT_LIST_DIR}/cartographer/*.*")

# targets
add_library(cartographer STATIC ${CARTO_SRCS} ${PROTO_SRCS})
target_link_libraries(cartographer PUBLIC ${Boost_LIBRARIES} protobuf protobuf-lite ceres cairo gflags glog pthread)
