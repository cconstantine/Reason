include_directories(${CMAKE_MAIN_INCLUDE_DIR})

ADD_LIBRARY(ReasonCompiler
  codegen.cpp
)

target_link_libraries(ReasonCompiler
  ReasonParser
)
