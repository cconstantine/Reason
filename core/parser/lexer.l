%{
#include <stdio.h>
#include <string>
#include <reason/parser/node.h>
#include <reason/parser/parser.h>
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)
extern "C" int yywrap() { return 1;}
%}
%option nounput
%%

[ \t\n]                 ;
[^ \t\n()0-9][a-zA-Z0-9_]*  SAVE_TOKEN; return TIDENTIFIER;
[0-9]+                  SAVE_TOKEN; return TINTEGER;
\(                      return OPEN_PARAN_TOKEN;
\)                      return CLOSE_PARAN_TOKEN;

%%