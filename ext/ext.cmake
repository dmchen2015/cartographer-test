cmake_minimum_required(VERSION 3.2)

set(CMAKE_CXX_STANDARD 11)

# abseil
include_directories(${CMAKE_CURRENT_LIST_DIR}/abseil)

# cairo
include(FindPkgConfig)
PKG_SEARCH_MODULE(CAIRO REQUIRED cairo>=1.12.16)
include_directories(${CAIRO_INCLUDE_DIRS})

# boost iostreams
find_package(Boost REQUIRED COMPONENTS iostreams)
include_directories(${Boost_INCLUDE_DIRS})

# lua
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/lua)
include(lua)

# eigen
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/eigen)
include(eigen)

# ceres
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/ceres)
include(ceres)

# protobuf
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/protobuf)
include(protobuf)

# cartographer
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cartographer)
include(cartographer)

# collect all libs
message(STATUS "Boost_LIBRARIES : ${Boost_LIBRARIES}")
set(EXT_DEPS cartographer ${Boost_LIBRARIES} protobuf protobuf-lite ceres cairo lua gflags glog pthread)