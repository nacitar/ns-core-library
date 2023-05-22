cmake_minimum_required(VERSION 3.25)

project(ns_core VERSION 1.0.0 LANGUAGES CXX)

include(CTest)
include(cmake/functions.cmake)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Check platform/compiler capabilities
foreach(source_file
    has_8bit_integral_type.cxx
    has_16bit_integral_type.cxx
    has_32bit_integral_type.cxx
    has_64bit_integral_type.cxx
)
    ns_core_feature_check(NS_CORE_FEATURE ${source_file})
endforeach()

# Configure include files to incorporate build/config metadata
foreach(header_file
    ns/core/features.hxx
    ns/core/version.hxx
)
    ns_core_generate_header(${header_file})
endforeach()

# Create a target for updating vcs metadata on every build
ns_core_create_vcs_metadata_updater(ns_core_vcs_metadata_updater
    ns/core/vcs/metadata.hxx
)

# Library definition
add_library(ns_core STATIC)
add_dependencies(ns_core ns_core_vcs_metadata_updater)
target_include_directories(ns_core
    PUBLIC
        include
        ${CMAKE_CURRENT_BINARY_DIR}/generated
)
target_sources(ns_core
    PRIVATE 
        src/dummy.cxx
)
# Compiler settings
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(ns_core
        PRIVATE
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
    target_compile_options(ns_core
        PRIVATE
            /W4
            /WX
            /O2
            /EHsc
    )
endif()
#target_compile_options(ns_core PRIVATE -nostdinc++)

# Testing
set(testing_default OFF)
if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(testing_default ON)  # when building this specifically
endif()
option(NS_CORE_BUILD_TESTING "Enable ns::core tests" ${testing_default})
if(NS_CORE_BUILD_TESTING)
    foreach(source_file
        simple_test.cxx
    )
        get_filename_component(test_base_name ${source_file} NAME_WE)
        set(test_target nx_core_test_${test_base_name})  # namespace it
        ns_core_compilation_test(${test_target} ${source_file})
        target_link_libraries(${test_target} ns_core)
    endforeach()
endif()
