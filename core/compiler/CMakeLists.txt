include_directories(${CMAKE_MAIN_INCLUDE_DIR})

set(LLVM_LINK_COMPONENTS core jit interpreter native)

add_llvm_library(ReasonCompiler
  codegen.cpp
)

target_link_libraries(ReasonCompiler
  ReasonParser
)
