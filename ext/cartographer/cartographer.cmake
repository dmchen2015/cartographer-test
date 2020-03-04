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
file(GLOB_RECURSE ALL_LIBRARY_HDRS "${CMAKE_CURRENT_LIST_DIR}/cartographer/*.h")
file(GLOB_RECURSE ALL_LIBRARY_SRCS "${CMAKE_CURRENT_LIST_DIR}/cartographer/*.cc")
file(GLOB_RECURSE TEST_LIBRARY_HDRS
     "${CMAKE_CURRENT_LIST_DIR}/cartographer/fake_*.h"
     "${CMAKE_CURRENT_LIST_DIR}/cartographer/*test_helpers*.h"
     "${CMAKE_CURRENT_LIST_DIR}/cartographer/mock_*.h")
file(GLOB_RECURSE TEST_LIBRARY_SRCS
     "${CMAKE_CURRENT_LIST_DIR}/cartographer/fake_*.cc"
     "${CMAKE_CURRENT_LIST_DIR}/cartographer/*test_helpers*.cc"
     "${CMAKE_CURRENT_LIST_DIR}/cartographer/mock_*.cc")
file(GLOB_RECURSE ALL_TESTS "${CMAKE_CURRENT_LIST_DIR}/cartographer/*_test.cc")
file(GLOB_RECURSE ALL_EXECUTABLES "${CMAKE_CURRENT_LIST_DIR}/cartographer/*_main.cc")
# remove useless files
list(REMOVE_ITEM ALL_LIBRARY_HDRS ${TEST_LIBRARY_HDRS})
list(REMOVE_ITEM ALL_LIBRARY_SRCS ${TEST_LIBRARY_SRCS})
list(REMOVE_ITEM ALL_LIBRARY_SRCS ${ALL_EXECUTABLES})
list(REMOVE_ITEM ALL_LIBRARY_SRCS ${ALL_TESTS})
# remove cloud files
set(CARTOGRAPHER_SRCS ${ALL_LIBRARY_HDRS} ${ALL_LIBRARY_SRCS})
list(REMOVE_ITEM CARTOGRAPHER_SRCS ${TEST_LIBRARY_HDRS})
list(REMOVE_ITEM CARTOGRAPHER_SRCS ${TEST_LIBRARY_SRCS})
list(REMOVE_ITEM CARTOGRAPHER_SRCS ${ALL_EXECUTABLES})
list(REMOVE_ITEM CARTOGRAPHER_SRCS ${ALL_TESTS})

# targets
add_library(cartographer STATIC ${CARTOGRAPHER_SRCS} ${PROTO_SRCS})
target_link_libraries(cartographer PUBLIC ${Boost_LIBRARIES} protobuf protobuf-lite ceres cairo gflags glog pthread)

