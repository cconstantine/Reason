file(MAKE_DIRECTORY ${REASON_ROOT}/lib)
ADD_CUSTOM_TARGET(reason_builtins
  DEPENDS builtins.cpp
  COMMAND clang++ -emit-llvm -c ${CMAKE_CURRENT_SOURCE_DIR}/builtins.cpp -o ${REASON_ROOT}/lib/builtins.o
  
)

add_dependencies(reason reason_builtins)