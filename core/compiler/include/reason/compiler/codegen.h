#include <llvm/Module.h>
#include <llvm/LLVMContext.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/Support/IRBuilder.h>

#include <stack>
#include <map>

class Node;

namespace llvm {
  class BasicBlock;
  class Function;
  class Value;
  struct GenericValue;
}

typedef llvm::Value*(*GenFunc)(CodeGenContext* cgc, NExpression*);
typedef std::map<std::string, GenFunc> gen_tbl;

class CodeGenContext {
public:
  llvm::LLVMContext& c;
  llvm::Module module;
  llvm::BasicBlock *BB;
  llvm::Function* func;

  CodeGenContext();
  
  llvm::GenericValue runCode(Node* root);
  llvm::Value* codeGen(Node*n);
  gen_tbl special_gen;
 private:
  llvm::Function* generateCode(Node* root, llvm::Function* f);

};

