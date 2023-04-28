cmake_minimum_required(VERSION 3.21)

project(ns_core VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

enable_testing()

add_custom_target(
  ns_core_vcs_metadata_updater
  COMMAND ${CMAKE_COMMAND}
  -D SRC=${CMAKE_CURRENT_SOURCE_DIR}/config/ns/core/vcs/metadata.hpp.in
  -D DST=${CMAKE_CURRENT_BINARY_DIR}/generated/ns/core/vcs/metadata.hpp
  -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/update_vcs_metadata.cmake
  COMMENT "Configuring ns::core VCS metadata"
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/generated/ns/core/vcs/metadata.hpp
  VERBATIM
)
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/config/ns/core/version.hpp.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/ns/core/version.hpp
    @ONLY
)

add_library(ns_core STATIC)
add_dependencies(ns_core ns_core_vcs_metadata_updater)
target_include_directories(
    ns_core
    INTERFACE include
    INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/generated
)
file(GLOB_RECURSE NS_CORE_SOURCES CONFIGURE_DEPENDS src/*.cpp src/*.cxx)
target_sources(ns_core PRIVATE ${NS_CORE_SOURCES})

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(ns_core PRIVATE
        -Wall
        -Wextra
        -Wpedantic
        -Werror
        -Wold-style-cast
        #-Wno-unused-function
        #-Wno-unused-value
        -Wconversion
        -Wshadow
        -Wsign-conversion
        -Wnon-virtual-dtor
        -O3
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    target_compile_options(ns_core PRIVATE
        /W4
        /WX
        /O2
        /EHsc
    )
endif()

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS tests/*.cpp tests/*.cxx)
foreach(test_src IN LISTS TEST_SOURCES)
  get_filename_component(test_base_name ${test_src} NAME_WE)
  set(test_name ns_core_${test_base_name})  # namespace it
  add_executable(${test_name} ${test_src})
  target_link_libraries(${test_name} ns_core)
  add_test(NAME ${test_name} COMMAND ${test_name})
endforeach()
