function(configure_vcs_metadata_header TARGET REL_PATH)
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/generated/${REL_PATH}
    COMMAND ${CMAKE_COMMAND}
      -D SRC=${CMAKE_CURRENT_SOURCE_DIR}/config/${REL_PATH}.in
      -D DST=${CMAKE_CURRENT_BINARY_DIR}/generated/${REL_PATH}
      -P ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/generate_vcs_metadata.cmake
    COMMENT "Configuring ${REL_PATH} "
    VERBATIM
  )
  set(CUSTOM_TARGET ${TARGET}_generate_vcs_metadata)
  add_custom_target(
    ${CUSTOM_TARGET}
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/generated/${REL_PATH}
  )
  add_dependencies(${TARGET} ${CUSTOM_TARGET})
endfunction()

function(configure_header REL_PATH)
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/config/${REL_PATH}.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/${REL_PATH}
    @ONLY
  )
endfunction()
