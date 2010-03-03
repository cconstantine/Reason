#include <iostream>
#include <stdio.h>
#include <reason/parser/node.h>
#include <reason/compiler/codegen.h>

extern int yyparse();
extern NExpression *programBlock;

int main(int argc, char* argv[])
{
  std::cout <<  "> ";
  yyparse();
  printf("Parsed input: %p\n", (void*)programBlock);
  if (programBlock)
    {
      programBlock->toString(std::cout);
      std::cout << std::endl;
      {
	CodeGenContext cgc(programBlock);
	return cgc.main();
      }
    }
  return 1;
}
