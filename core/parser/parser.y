%{
#include <stdio.h>
#include <reason/parser/node.h>
  Node *programBlock; /* the top level root node of our final AST */
  
  extern int yylex();
  void yyerror(const char *s) { printf("ERROR: %s\n", s); }
%}

/* Represents the many different ways we can access our data */
%union {
  Node *node;
  NExpression *expr;
  std::string* string;
  int token;
}

/* Define our terminal symbols (tokens). This should
   match our tokens.l lex file. We also define the node type
   they represent.
 */
%token <string> TIDENTIFIER TINTEGER
%token <token> OPEN_PARAN_TOKEN CLOSE_PARAN_TOKEN COMMA_TOKEN;

/* Define the type of node our nonterminal symbols represent.
   The types refer to the %union declaration above. Ex: when
   we call an ident (defined by union type ident) we are really
   calling an (NIdentifier*). It makes the compiler happy.
 */
%type <node> value ident numeric 
%type <expr> expr expr_list


%start program

%%

program : value { programBlock = $1; }
        ;

expr : 
  OPEN_PARAN_TOKEN CLOSE_PARAN_TOKEN { $$ = new NExpression (NULL, NULL);}
| OPEN_PARAN_TOKEN expr_list CLOSE_PARAN_TOKEN { $$ = $2; }
     ;

expr_list : value {$$ = new NExpression($1, NULL);}
| value expr_list { $$ = new NExpression($1, $2); }

value : 
  ident 
| numeric 
  | expr { $$ = $1;}
;

ident : TIDENTIFIER { $$ = new NIdentifier(*$1); delete $1; }
      ;

numeric : TINTEGER { $$ = new NInteger(*$1); delete $1;}
        ;

%%
