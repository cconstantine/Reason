include_directories(
  parser/include
  compiler/include
  datastructures/include
)


add_subdirectory(parser)
add_subdirectory(compiler)


#Build temp ui
add_executable(reason main.cpp)
target_link_libraries(reason ReasonParser ReasonCompiler)
