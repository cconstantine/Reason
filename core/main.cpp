#include <iostream>
#include <stdio.h>
#include <reason/parser/node.h>
#include <reason/compiler/codegen.h>

#include <llvm/Function.h>
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

extern int yyparse();
extern NCons *programBlock;

typedef int (MainFunc)();

using namespace llvm;

int main(int argc, char* argv[])
{
  std::cout <<  "> ";
  yyparse();
  if (programBlock)
    {
      programBlock->toString(std::cout);
      std::cout << std::endl;

      llvm::InitializeNativeTarget();

      llvm::LLVMContext c = getGlobalContext();
      llvm::Module module(StringRef(name), c);
      /*
      llvm::Function* func = 
	cast<Function>(module.getOrInsertFunction(name.c_str(),
						  Type::getInt32Ty(c),
						  (Type*)0));

      CodeGenContext cgc(m, func);

      /***** Create dummy buildtin '+' ******
      Function *plus = 
	cast<Function>(module.getOrInsertFunction("+",
						  Type::getInt32Ty(c),
						  Type::getInt32Ty(c),
						  Type::getInt32Ty(c),
						  (Type *)0));
      
      Function::ArgumentListType& args = plus->getArgumentList();
      
      Function::ArgumentListType::iterator iter = args.begin();
      Argument& arg1 = *iter;iter++;
      Argument& arg2 = *iter;
      
      BasicBlock *BB = BasicBlock::Create(c, "EntryBlock", plus);
      Instruction *Add = BinaryOperator::CreateAdd(&arg1, &arg2, "addresult", BB);
      ReturnInst::Create(c, Add, BB);
      plus->dump();
      /**************************************
      
      

      BasicBlock::Create(c, "EntryBlock", func);

      Value *val = programBlock->compile(cgc);
      
      ReturnInst::Create(c, val, &func->back());

      ExecutionEngine *ee =  EngineBuilder(&module).create();
      MainFunc* main_func = (MainFunc*)(ee->getPointerToFunction(func));

      int ret = (*main_func)();
      std::cout << "Code was run: " << ret << std::endl;
      */
      return 1;//ret;
    }

  return 1;
}
