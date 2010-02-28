include_directories(
  parser/include
  compiler/include
)

macro(add_reason_lib name)

  add_library(${name}
    ${ARGN}
    )
  
  if(LLVM_LIBS)
    llvm_config(${name} ${LLVM_LIBS})
  endif()
  get_system_libs(llvm_system_libs)
  if( llvm_system_libs )
    target_link_libraries(${name} ${llvm_system_libs})
  endif()
  
  target_link_libraries(${name}
    ${REASON_LIBS}
    )
endmacro(add_reason_lib)


add_subdirectory(parser)
add_subdirectory(compiler)


#Build temp ui
add_executable(reason main.cpp)
target_link_libraries(reason ReasonParser ReasonCompiler)
