#include <stack>
#include <map>

class Node;

namespace llvm {
  class BasicBlock;
  class Function;
};

class CodeGenBlock {
public:
  llvm::BasicBlock *block;
  std::map<std::string , Value*> locals;
};

class CodeGenContext {
public:
    llvm::Module *module;
    CodeGenContext();

    void generateCode(Node& root);
    GenericValue runCode();
    void pushBlock(BasicBlock *block);
    void popBlock();

    std::stack<CodeGenBlock  *> blocks;
    llvm::Function *mainFunction;
};

