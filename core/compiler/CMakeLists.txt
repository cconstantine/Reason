include_directories(${CMAKE_MAIN_INCLUDE_DIR})

set (LLVM_LIBS core jit interpreter native)
set (REASON_LIBS ReasonParser)

add_reason_lib(ReasonCompiler codegen.cpp)


