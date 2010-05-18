#include <llvm/Module.h>
#include <llvm/LLVMContext.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/Support/IRBuilder.h>

#include <stack>
#include <map>

namespace llvm {
  class Value;
}

//typedef llvm::Value*(*GenFunc)(CodeGenContext* cgc, NCons*);
//typedef std::map<std::string, GenFunc> gen_tbl;

typedef std::map<std::string, llvm::Value*> SymbolTable;

class CodeGenContext {
public:
  llvm::Module* module;
  llvm::Function * func;

  CodeGenContext(llvm::Module* m, llvm::Function*f);
  
  SymbolTable symbols;
  //  gen_tbl special_gen;
};

