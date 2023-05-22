find_package(Git QUIET)
if(Git_FOUND)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} config --get remote.origin.url
        #WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        ERROR_QUIET
        OUTPUT_VARIABLE VCS_ORIGIN_URL
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse -q HEAD
        #WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        ERROR_QUIET
        OUTPUT_VARIABLE VCS_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} symbolic-ref -q --short HEAD
        #WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        ERROR_QUIET
        OUTPUT_VARIABLE VCS_BRANCH_NAME
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} status --porcelain
        #WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        ERROR_QUIET
        OUTPUT_VARIABLE VCS_HAS_LOCAL_CHANGES
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()
if(VCS_HAS_LOCAL_CHANGES)
    set(VCS_HAS_LOCAL_CHANGES "true")
else()
    set(VCS_HAS_LOCAL_CHANGES "false")
endif()
if(NOT VCS_COMMIT_HASH)
    set(VCS_COMMIT_HASH "unknown")
endif()
if(NOT VCS_BRANCH_NAME)
    set(VCS_BRANCH_NAME "[detached]")
endif()
if(NOT VCS_ORIGIN_URL)
    set(VCS_ORIGIN_URL "unknown")
endif()

configure_file(${SRC} ${DST} @ONLY)
