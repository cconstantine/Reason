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

class CodeGenBlock {
public:
  llvm::BasicBlock *block;
  std::map<std::string , llvm::Value*> locals;
};

class CodeGenContext {
public:
  llvm::LLVMContext& c;
  llvm::Module module;

  CodeGenContext();
  ~CodeGenContext();
  
  void generateCode(Node& root);
  void runCode();
  void pushBlock(llvm::BasicBlock *block);
  void popBlock();
  
  std::stack<CodeGenBlock  *> blocks;
  llvm::Function *mainFunction;
};

