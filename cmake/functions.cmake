function(ns_core_feature_check variable_prefix source_file)
    set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")  # not running; no main
    set(feature_checks_dir ${CMAKE_CURRENT_SOURCE_DIR}/feature_checks)
    string(TOUPPER ${variable_prefix} upper_variable_prefix)
    get_filename_component(source_file_basename ${source_file} NAME_WE)
    string(TOUPPER ${source_file_basename} source_file_basename)
    try_compile(${upper_variable_prefix}_${source_file_basename}
        SOURCES ${feature_checks_dir}/${source_file}
        CMAKE_FLAGS -DINCLUDE_DIRECTORIES=${feature_checks_dir}/include
    ) 
endfunction()

function(ns_core_configure_file source_file)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/include/${source_file}.in
        ${CMAKE_CURRENT_BINARY_DIR}/generated/${source_file}
        @ONLY
    )
endfunction()

function(ns_core_create_vcs_metadata_updater target_name metadata_file)
    add_custom_target(
        ${target_name}
        COMMAND
            ${CMAKE_COMMAND}
            -D SRC=${CMAKE_CURRENT_SOURCE_DIR}/include/${metadata_file}.in
            -D DST=${CMAKE_CURRENT_BINARY_DIR}/generated/${metadata_file}
            -P ${CMAKE_CURRENT_LIST_DIR}/cmake/update_vcs_metadata.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Configuring ${PROJECT_NAME} VCS metadata"
        VERBATIM
    )
endfunction()


function(ns_core_compilation_test source_file)
    set(source_file src/${source_file})  # tests live alongside the code
    get_filename_component(test_base_name ${source_file} NAME_WE)
    string(
        REGEX MATCH "(_fail(s)?_)?test(s)?$" TEST_SUFFIX ${test_base_name}
    )
    if(NOT TEST_SUFFIX)
        message(FATAL_ERROR "Invalid test filename '${source_file}'."
            "  The filename (without extension) must end with '_test' or"
            " '_tests', optionally preceded by '_fail' or '_fails'."
        )
    endif()
    string(REGEX MATCH "_fail(s)?" IS_FAIL ${TEST_SUFFIX})
    set(test_name ns_core_test_${test_base_name})  # namespace it
    # Running unit tests built for avr is non-trivial, so using
    # static assertions and simply testing that it compiles is preferred.
    add_executable(${test_name} EXCLUDE_FROM_ALL ${source_file})
    target_link_libraries(${test_name} ns_core)
    add_test(
        NAME ${test_name}_compile
        COMMAND
        ${CMAKE_COMMAND}
        --build ${CMAKE_CURRENT_BINARY_DIR}
        --target ${test_name}
    )
    if(IS_FAIL)
        set_tests_properties(
            ${test_name}_compile PROPERTIES WILL_FAIL TRUE
        )
    endif()
endfunction()
