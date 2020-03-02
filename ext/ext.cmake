cmake_minimum_required(VERSION 3.2)

set(CMAKE_CXX_STANDARD 11)

# abseil
include_directories(${CMAKE_CURRENT_LIST_DIR}/abseil)

# lua
include_directories(${CMAKE_CURRENT_LIST_DIR}/lua/src)

# cairo
include(FindPkgConfig)
PKG_SEARCH_MODULE(CAIRO REQUIRED cairo>=1.12.16)
include_directories(${CAIRO_INCLUDE_DIRS})

# eigen
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/eigen)
include(eigen)

# ceres
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/ceres)
include(ceres)

# protobuf
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/protobuf)
include(protobuf)

# boost iostreams
find_package(Boost REQUIRED COMPONENTS iostreams)
include_directories(${Boost_INCLUDE_DIRS})

# cartographer
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cartographer)
include(cartographer)

# collect all libs
set(EXT_DEPS cartographer ${Boost_LIBRARIES} protobuf protobuf-lite ceres cairo gflags glog pthread)