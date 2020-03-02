
# get version
string(TIMESTAMP VERSION "1.%m.%d")
add_definitions(-DVERSION="${VERSION}")
message(STATUS "version = ${VERSION}")

add_definitions(-DPROJECT="${PROJECT_NAME}")
message(STATUS "project = ${PROJECT_NAME}")