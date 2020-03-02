
set(CMAKE_CXX_STANDARD 11)

# Package version
set(protobuf_VERSION "3.11.4.0")

# cmake module
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

# definitions
add_definitions(-DGOOGLE_PROTOBUF_CMAKE_BUILD) # ignore some large .proto files
add_definitions(-DHAVE_PTHREAD) # pthread

# zlib
set(HAVE_ZLIB 0)
set(ZLIB_LIBRARIES)
# pthread
set(CMAKE_THREAD_LIBS_INIT pthread)

# static lib
set(protobuf_SHARED_OR_STATIC "STATIC") # library type

# include directories
set(protobuf_source_dir ${CMAKE_CURRENT_LIST_DIR})
include_directories(${protobuf_source_dir}/src)


# build
include(libprotobuf-lite)
include(libprotobuf)
include(libprotoc)
include(protoc)