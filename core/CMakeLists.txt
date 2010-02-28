include_directories(
  parser/include
  compiler/include
)

add_subdirectory(parser)
add_subdirectory(compiler)

add_llvm_executable(reason main.cpp)

target_link_libraries(reason ReasonParser ReasonCompiler)
