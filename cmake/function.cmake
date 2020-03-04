############################## funcs ##############################
# set include dir
function(include_sub_directories_recursively root_dir)
	if (IS_DIRECTORY ${root_dir})
		#message("include dir: " ${root_dir})
		include_directories(${root_dir})
	endif ()
	file(GLOB ALL_SUB RELATIVE ${root_dir} ${root_dir}/*)
	foreach (sub ${ALL_SUB})
		if (IS_DIRECTORY ${root_dir}/${sub})
			include_sub_directories_recursively(${root_dir}/${sub})
		endif ()
	endforeach ()
endfunction()

# get all matched files
function(get_all_files_recursively dir files match)
	file(GLOB_RECURSE tempfiles ${dir} ${dir}/${match})
	set(${files} ${tempfiles} PARENT_SCOPE)
endfunction()

# set include dir and exclude some dir
function(include_sub_directories_and_exclude root_dir exclude)
	if (IS_DIRECTORY ${root_dir} AND NOT ${exclude} MATCHES ${root_dir})
		#message("include dir: " ${root_dir})
		include_directories(${root_dir})
	endif ()
	file(GLOB ALL_SUB RELATIVE ${root_dir} ${root_dir}/*)
	foreach (sub ${ALL_SUB})
		if (IS_DIRECTORY ${root_dir}/${sub})
			if (NOT ${exclude} MATCHES ${sub})
				include_sub_directories_and_exclude(${root_dir}/${sub} ${exclude})
			endif ()
		endif ()
	endforeach ()
endfunction()

# get all matched files and exclude some files
function(get_exclude_files_recursively dir files match exclude)
	set(result)
	file(GLOB all_files RELATIVE ${dir} ${dir}/*)
	foreach (sub ${all_files})
		set(temp_file ${dir}/${sub})
		if (NOT ${sub} MATCHES ${exclude})
			if (IS_DIRECTORY ${temp_file})
				set(temp_result)
				get_exclude_files_recursively(${temp_file} temp_result ${match} ${exclude})
				list(APPEND result ${temp_result})
			else ()
				list(APPEND result ${temp_file})
				#                message("result: " ${result})
			endif ()
			#        else ()
			#            message(${exclude} " matches " ${sub})
		endif ()
	endforeach ()
	set(${files} ${result} PARENT_SCOPE)
endfunction()

# build proto files
function(build_proto_files INPUT_DIR OUTPUT_DIR RESULT)
	file(GLOB_RECURSE ALL_PROTOS "${INPUT_DIR}/*.proto")
	set(ALL_PROTO_BUILD)
	foreach (ABS_FIL ${ALL_PROTOS})
		# get related file REL_FIL
		file(RELATIVE_PATH REL_FIL ${INPUT_DIR} ${ABS_FIL})
		# get related dir DIR
		get_filename_component(DIR ${REL_FIL} DIRECTORY)
		# get file name
		get_filename_component(FIL_WE ${REL_FIL} NAME_WE)
		# set output header & source
		set(ABS_FIL_HDR "${OUTPUT_DIR}/${DIR}/${FIL_WE}.pb.h")
		set(ABS_FIL_SRC "${OUTPUT_DIR}/${DIR}/${FIL_WE}.pb.cc")
		#		# output message
		#		message(STATUS "ABS_FIL:${ABS_FIL}")
		#		message(STATUS "DIR:${DIR}")
		#		message(STATUS "FIL_WE:${FIL_WE}")
		#		message(STATUS "ABS_FIL_HDR:${ABS_FIL_HDR}")
		# build header & source files
		add_custom_command(
				OUTPUT "${OUTPUT_DIR}/${DIR}/${FIL_WE}.pb.h" "${OUTPUT_DIR}/${DIR}/${FIL_WE}.pb.cc"
				COMMAND ${PROJECT_SOURCE_DIR}/bin/protoc
				ARGS --cpp_out ${OUTPUT_DIR} -I ${INPUT_DIR} ${ABS_FIL}
				DEPENDS ${ABS_FIL}
				COMMENT "Running C++ protocol buffer compiler(bin/protoc) on ${REL_FIL}"
				VERBATIM
		)
		list(APPEND ALL_PROTO_BUILD ${ABS_FIL_SRC})
		list(APPEND ALL_PROTO_BUILD ${ABS_FIL_HDR})
	endforeach ()
	set_source_files_properties(${ALL_PROTO_BUILD} PROPERTIES GENERATED TRUE)
	set(${RESULT} ${ALL_PROTO_BUILD} PARENT_SCOPE)
endfunction()

########## google ##########
macro(_parse_arguments ARGS)
	set(OPTIONS)
	set(ONE_VALUE_ARG)
	set(MULTI_VALUE_ARGS SRCS)
	cmake_parse_arguments(ARG "${OPTIONS}" "${ONE_VALUE_ARG}" "${MULTI_VALUE_ARGS}" ${ARGS})
endmacro(_parse_arguments)

macro(_common_compile_stuff VISIBILITY)
	set(TARGET_COMPILE_FLAGS "${TARGET_COMPILE_FLAGS} ${GOOG_CXX_FLAGS}")
	set_target_properties(${NAME} PROPERTIES COMPILE_FLAGS ${TARGET_COMPILE_FLAGS})
	target_include_directories(${NAME} PUBLIC ${PROJECT_NAME})
	target_link_libraries(${NAME} PUBLIC ${PROJECT_NAME})
endmacro(_common_compile_stuff)

function(google_test NAME ARG_SRC)
	add_executable(${NAME} ${ARG_SRC})
	_common_compile_stuff("PRIVATE")
	# Make sure that gmock always includes the correct gtest/gtest.h.
	target_include_directories("${NAME}" SYSTEM PRIVATE "${GMOCK_INCLUDE_DIRS}")
	target_link_libraries("${NAME}" PUBLIC ${GMOCK_LIBRARIES})
	add_test(${NAME} ${NAME})
endfunction()

function(google_binary NAME)
	_parse_arguments("${ARGN}")
	add_executable(${NAME} ${ARG_SRCS})
	_common_compile_stuff("PRIVATE")
	install(TARGETS "${NAME}" RUNTIME DESTINATION bin)
endfunction()

