
FIND_PROGRAM (BISON
  NAMES bison
  PATHS /usr/bin/ /usr/local/bin
  DOC "Parser Generator"
  )


FIND_PROGRAM (FLEX
  NAMES flex
  PATHS /usr/bin /usr/local/bin
  DOC "Lexer Generator"
  )

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include/reason/parser")

include_directories("${CMAKE_CURRENT_BINARY_DIR}/include")
ADD_CUSTOM_COMMAND(
  OUTPUT  "${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp"
          "${CMAKE_CURRENT_BINARY_DIR}/include/reason/parser/lexer.h"
  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/lexer.l"

  COMMAND
  ${FLEX} 
  --header-file="${CMAKE_CURRENT_BINARY_DIR}/include/reason/parser/lexer.h"
  -o${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp
  "${CMAKE_CURRENT_SOURCE_DIR}/lexer.l"
  )

ADD_CUSTOM_COMMAND(
  OUTPUT  "${CMAKE_CURRENT_BINARY_DIR}/parser.cpp"
          "${CMAKE_CURRENT_BINARY_DIR}/include/reason/parser/parser.h"
  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/parser.y"
  COMMAND
  ${BISON}
  --defines=${CMAKE_CURRENT_BINARY_DIR}/include/reason/parser/parser.h
  -o${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/parser.y
)

add_library(ReasonParser 
  node.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
)