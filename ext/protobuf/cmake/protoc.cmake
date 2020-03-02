set(protoc_files ${protobuf_source_dir}/src/google/protobuf/compiler/main.cc)

add_executable(protoc ${protoc_files} ${protoc_rc_files})
target_link_libraries(protoc libprotoc libprotobuf ${CMAKE_THREAD_LIBS_INIT})
add_executable(protobuf::protoc ALIAS protoc)
#set_target_properties(protoc PROPERTIES VERSION ${protobuf_VERSION})
