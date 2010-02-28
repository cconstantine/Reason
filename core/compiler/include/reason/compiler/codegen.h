#include <llvm/Module.h>
#include <llvm/LLVMContext.h>
#include <llvm/ExecutionEngine/GenericValue.h>

#include <stack>
#include <map>

class Node;

namespace llvm {
  class BasicBlock;
  class Function;
  class Value;
  struct GenericValue;
}

class CodeGenContext {
public:
  llvm::LLVMContext& c;
  llvm::Module module;

  CodeGenContext();
  
  llvm::GenericValue runCode(Node& root);
 private:
  llvm::Function* generateCode(Node& root);
};

