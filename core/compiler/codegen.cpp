#include <iostream>
#include <vector>
#include <llvm/Function.h>
#include <llvm/ModuleProvider.h>
#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include <llvm/ExecutionEngine/JIT.h>
#include <llvm/LLVMContext.h>
#include <llvm/Module.h>
#include <llvm/PassManager.h>
#include <llvm/Analysis/Verifier.h>
#include <llvm/Target/TargetData.h>
#include <llvm/Target/TargetSelect.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Support/IRBuilder.h>

#include <reason/parser/node.h>
#include <reason/compiler/codegen.h>

using namespace llvm;

std::string main_string("main");

CodeGenContext::CodeGenContext()
  : c(getGlobalContext()), module(StringRef(main_string), c)
{}

CodeGenContext::~CodeGenContext()
{ }

void CodeGenContext::pushBlock(BasicBlock *block) 
{ 
  blocks.push(new CodeGenBlock()); 
  blocks.top()->block = block; 
}

void CodeGenContext::popBlock() 
{
  CodeGenBlock *top = blocks.top(); 
  blocks.pop(); 
  delete top; 
}

void CodeGenContext::generateCode(Node& root)
{
    std::cout << "Generating code...\n";
    mainFunction = 
      cast<Function>(module.getOrInsertFunction("mainFunction",
						Type::getVoidTy(c),
						(Type*)0));
    BasicBlock *BB = BasicBlock::Create(c, "EntryBlock", mainFunction);

    // Get pointers to the constant `0'.
    Value *val;
    val = ConstantInt::get(Type::getInt32Ty(c), 0);
    //val = root.codeGen(*this); /* emit bytecode for the toplevel block */

    ReturnInst::Create(c, val, BB);

    std::cout << "Code is generated.\n";
}

/* Executes the AST by running the main function */
void CodeGenContext::runCode() {
  InitializeNativeTarget();
  std::cout << "Running code...\n";
  mainFunction->dump();
  ExecutionEngine *ee =  EngineBuilder(&module).create();
  
  std::vector<GenericValue> args;
  ee->runFunction(mainFunction, args);
  std::cout << "Code was run.\n";
}
