#include <iostream>
#include <vector>
#include <map>
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

#include <reason/parser/node.h>
#include <reason/compiler/codegen.h>

using namespace llvm;


std::string main_string("main");
CodeGenContext::CodeGenContext()
  : c(getGlobalContext()), module(StringRef(main_string), c), Builder(c)
{
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
}


Value* CodeGenContext::codeGen(Node* n)
{
  if (NInteger *integ = dynamic_cast<NInteger*>(n))
    {
      unsigned int i = atoi(integ->value.c_str());
      return ConstantInt::get(Type::getInt32Ty(c), i);
    }
  else if (NExpression *expr = dynamic_cast<NExpression*>(n))
    {
      Node* first = expr->m_first;
      
      if (NIdentifier *indent = dynamic_cast<NIdentifier*>(first))
	{
	  std::string& name = indent->name;
	  
	  gen_tbl::iterator iter;
	  iter = special_gen.find(name);
	  /* This is a special form */
	  if (iter != special_gen.end())
	    {
	      GenFunc handler = iter->second;
	      return handler(this, expr);
	    }
	  /* This is a function call */
	  else
	    {
	      if (Function *f = module.getFunction(name))
		{
		  std::vector<Value*> args;
		  while((expr = dynamic_cast<NExpression*>(expr->m_rest)))
		    {
		      std::cout << "Arg: ";expr->m_first->toString(std::cout);
		      std::cout << std::endl;
		      args.push_back( codeGen(expr->m_first) );
		    }
		  printf("args: %d\n", (int)args.size());
		  return Builder.CreateCall(f, args.begin(), args.end(), name.c_str());
		}
		else
		  {
		    fprintf(stderr, "Unable to find function '%s'\n", name.c_str());
		  }
	    }
	      
	}
    }
  return NULL;
}


Function* CodeGenContext::generateCode(Node* root)
{
  Function* func = 
      cast<Function>(module.getOrInsertFunction("func",
						Type::getVoidTy(c),
						(Type*)0));
    BasicBlock *BB = BasicBlock::Create(c, "EntryBlock", func);

    // Get pointers to the constant `0'.
    Value *val = codeGen(root); /* emit bytecode for the toplevel block */

    ReturnInst::Create(c, val, BB);
    return func;
}

/* Executes the AST by running the main function */
GenericValue CodeGenContext::runCode(Node* root) {
  InitializeNativeTarget();
  llvm::Function* f = generateCode(root);
  std::cout << "Running code...\n";
  f->dump();
  ExecutionEngine *ee =  EngineBuilder(&module).create();
  
  std::vector<GenericValue> args;
  GenericValue gv = ee->runFunction(f, args);
  std::cout << "Code was run: " << gv.UIntPairVal.second << std::endl;
  return gv;
}
