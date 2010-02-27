add_subdirectory(parser)

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}/parser/include
  parser/include
)


add_executable(main main.cpp)

target_link_libraries(main ReasonParser)