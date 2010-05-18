set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake
)

include(ReasonCommands)
set(REASON_ROOT ${LLVM_BINARY_DIR}/reason )


add_subdirectory(core)
add_subdirectory(builtins)