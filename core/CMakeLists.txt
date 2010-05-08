include_directories(
  parser/include
  compiler/include
  datastructures/include
)


add_subdirectory(parser)
add_subdirectory(compiler)


#Build temp ui
add_executable(reason main.cpp)
set (LLVM_LIBS llvmbitreader)
target_link_libraries(reason LLVMBitReader ReasonParser ReasonCompiler)
