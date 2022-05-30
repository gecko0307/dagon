cmake_minimum_required(VERSION 3.0)

project(nuklear        VERSION 4.02.5 DESCRIPTION "Nuklear GUI library")
project(nuklear_static VERSION 4.02.5 DESCRIPTION "Nuklear GUI library")

add_library(nuklear        SHARED nuklear.c)
add_library(nuklear_static STATIC nuklear.c)

set_target_properties(nuklear        PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(nuklear_static PROPERTIES VERSION ${PROJECT_VERSION})

set_target_properties(nuklear        PROPERTIES PUBLIC_HEADER nuklear.h)
# shared and static version have the same header file so do not install it twice
# set_target_properties(nuklear_static PROPERTIES PUBLIC_HEADER nuklear.h1)

install(TARGETS nuklear nuklear_static
        LIBRARY DESTINATION ${CMAKE_SOURCE_DIR}/../lib
        ARCHIVE DESTINATION ${CMAKE_SOURCE_DIR}/../lib
        PUBLIC_HEADER DESTINATION ${CMAKE_SOURCE_DIR}/../include)