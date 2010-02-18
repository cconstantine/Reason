%{
#include <stdio.h>
#include <string>
#include "node.h"
#include "parser.h"
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)
extern "C" int yywrap() { return 1;}
%}

%%

[ \t\n]                 ;
[a-zA-Z_][a-zA-Z0-9_]*  SAVE_TOKEN; return TIDENTIFIER;
[0-9]+                  SAVE_TOKEN; return TINTEGER;
\(                      return OPEN_PARAN_TOKEN;
\)                      return CLOSE_PARAN_TOKEN;
.                       fprintf(stderr, "Unknown token: %s\n", yytext); yyterminate();

%%