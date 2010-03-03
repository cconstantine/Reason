set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake
)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
include(ReasonCommands)



add_subdirectory(core)
