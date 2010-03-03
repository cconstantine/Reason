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
  llvm::Module module;
  llvm::Function* func;

  CodeGenContext(Node*n);
  
  int main();
  llvm::Value* codeGen(Node* root);
  gen_tbl special_gen;
 private:
  llvm::Function* generateCode(Node* root, llvm::Function* f);

};

