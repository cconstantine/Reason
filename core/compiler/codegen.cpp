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
CodeGenContext::CodeGenContext(Node* root)
  : module(StringRef(main_string), getGlobalContext()), 
    func(NULL)
{
  InitializeNativeTarget();
  /***** Create dummy buildtin '+' ******/
  llvm::LLVMContext& c = module.getContext();
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
  /**************************************/

  func = cast<Function>(module.getOrInsertFunction("func",
						   Type::getInt32Ty(c),
						   (Type*)0));
  BasicBlock::Create(c, "EntryBlock", func);
  generateCode(root, func);
  plus->dump();
}


Value* CodeGenContext::codeGen(Node* n)
{
  llvm::LLVMContext& c = module.getContext();
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
	  // This is a special form 
	  if (iter != special_gen.end())
	    {
	      GenFunc handler = iter->second;
	      return handler(this, expr);
	    }
	  // This is a function call
	  else
	    {
	      if (Function *f = module.getFunction(name))
		{
		  std::vector<Value*> args;
		  while((expr = dynamic_cast<NExpression*>(expr->m_rest)))
		    {
		      args.push_back( codeGen(expr->m_first) );
		    }
		  return CallInst::Create(f, args.begin(), args.end(), name.c_str(), &func->back());
		}
	      else
		{
		  std::cerr <<  std::string("Unable to find function '") <<  name << "'" <<std::endl;
		}
	    }
	      
	}
    }
  return NULL;
}

Function* CodeGenContext::generateCode(Node* root, Function* f)
{
  func = f;
  llvm::LLVMContext& c = module.getContext();
  // Get pointers to the constant `0'.
  Value *val = codeGen(root); /* emit bytecode for the toplevel block */
  
  ReturnInst::Create(c, val, &func->back());
  return func;
}

/* Executes the AST by running the main function */
int CodeGenContext::main()
{
  ExecutionEngine *ee =  EngineBuilder(&module).create();
  
  typedef int (MainFunc)();

  MainFunc* main_func = (MainFunc*)(ee->getPointerToFunction(func));
  int ret = (*main_func)();
  std::cout << "Code was run: " << ret << std::endl;
  return ret;
}
