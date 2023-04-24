cmake_minimum_required(VERSION 3.21)

project(ns_core VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

enable_testing()

include(cmake/configure_helpers.cmake)

file(GLOB_RECURSE NSCORE_SOURCES CONFIGURE_DEPENDS src/*.cpp src/*.cxx)

add_library(ns_core INTERFACE)
configure_vcs_metadata_header(ns_core ns/core/vcs/metadata.hpp)
configure_header(ns/core/version.hpp)
target_include_directories(
    ns_core
    INTERFACE include
    INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/generated
)

# Static library used so that the build script works even if header only.
if(NSCORE_SOURCES)
  add_library(ns_core_impl STATIC ${NSCORE_SOURCES})
  target_link_libraries(ns_core INTERFACE ns_core_impl)

  if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
      target_compile_options(ns_core_impl PRIVATE
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
      target_compile_options(ns_core_impl PRIVATE
          /W4
          /WX
          /O2
          /EHsc
      )
  endif()
endif()

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS tests/*.cpp tests/*.cxx)

foreach(test_src IN LISTS TEST_SOURCES)
  get_filename_component(test_name ${test_src} NAME_WE)
  set(test_name ${PROJECT_NAME}_${test_name})
  add_executable(${test_name} ${test_src})
  target_link_libraries(${test_name} ns_core)
  add_test(NAME ${test_name} COMMAND ${test_name})
endforeach()
