include_directories(
  parser/include
  compiler/include
  datastructures/include
)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${REASON_ROOT}/bin )

add_subdirectory(parser)
add_subdirectory(compiler)

#Build temp ui
add_executable(reason main.cpp)
set (LLVM_LIBS llvmbitreader)
target_link_libraries(reason LLVMBitReader ReasonParser ReasonCompiler)

