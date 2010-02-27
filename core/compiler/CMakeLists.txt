
ADD_LIBRARY(ReasonCompiler
  codegen.cpp
)

target_link_libraries(ReasonCompiler
  ReasonParser
)