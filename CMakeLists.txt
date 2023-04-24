cmake_minimum_required(VERSION 3.21)

project(ns-core VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

enable_testing()

find_package(Git)
if(Git_FOUND)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    ERROR_QUIET
    OUTPUT_VARIABLE COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
endif()
if(NOT COMMIT_HASH)
  set(COMMIT_HASH "unknown")
endif()

configure_file(config/version.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/generated/ns/core/version.h @ONLY)

file(GLOB_RECURSE NSCORE_SOURCES CONFIGURE_DEPENDS src/*.cpp src/*.cxx)

add_library(ns-core INTERFACE)
target_include_directories(
    ns-core
    INTERFACE include
    INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/generated
)

# Static library used so that the build script works even if header only.
if(NSCORE_SOURCES)
  add_library(ns-core-impl STATIC ${NSCORE_SOURCES})
  target_link_libraries(ns-core INTERFACE ns-core-impl)

  if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
      target_compile_options(ns-core-impl PRIVATE
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
      target_compile_options(ns-core-impl PRIVATE
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
  add_executable(${test_name} ${test_src})
  target_link_libraries(${test_name} ns-core)
  add_test(NAME ${test_name} COMMAND ${test_name})
endforeach()
