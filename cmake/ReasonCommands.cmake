
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

  if (REASON_LIBS)
    target_link_libraries(${name}
      ${REASON_LIBS}
      )
  endif()
endmacro(add_reason_lib)
