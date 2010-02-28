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

Function* CodeGenContext::generateCode(Node& root)
{
  Function* func = 
      cast<Function>(module.getOrInsertFunction("func",
						Type::getVoidTy(c),
						(Type*)0));
    BasicBlock *BB = BasicBlock::Create(c, "EntryBlock", func);
    //    BasicBlock *BB1 = BasicBlock::Create(c, "InnerBlock", func);

    // Get pointers to the constant `0'.
    Value *val;
    val = ConstantInt::get(Type::getInt32Ty(c), 0);
    //val = root.codeGen(*this); /* emit bytecode for the toplevel block */

    ReturnInst::Create(c, val, BB);
    return func;
}

/* Executes the AST by running the main function */
GenericValue CodeGenContext::runCode(Node& root) {
  InitializeNativeTarget();
  llvm::Function* f = generateCode(root);
  std::cout << "Running code...\n";
  f->dump();
  ExecutionEngine *ee =  EngineBuilder(&module).create();
  
  std::vector<GenericValue> args;
  GenericValue gv = ee->runFunction(f, args);
  std::cout << "Code was run.\n";
  return gv;
}
