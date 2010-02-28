#include <reason/parser/node.h>
#include <reason/parser/codegen.h>
#include <reason/parser/parser.h>

/* Compile the AST into a module */
void CodeGenContext::generateCode(NExpression& root)
{
    std::cout << "Generating code...\n";

    /* Create the top level interpreter function to call as entry */
    vector<const type*> argTypes;
    FunctionType *ftype = FunctionType::get(Type::VoidTy, argTypes, false);
    mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", &module);
    BasicBlock *bblock = BasicBlock::Create(c, mainFunction, 0);

    /* Push a new variable/block context */
    pushBlock(bblock);
    //    root.codeGen(*this); /* emit bytecode for the toplevel block */
    ReturnInst::Create(bblock);
    popBlock();

    /* Print the bytecode in a human-readable format
       to see if our program compiled properly
     */
    std::cout << "Code is generated.\n";
    PassManager pm;
    pm.add(createPrintModulePass(&outs()));
    pm.run(module);
}

/* Executes the AST by running the main function */
GenericValue CodeGenContext::runCode() {
    std::cout << "Running code...\n";
    ExistingModuleProvider *mp = new ExistingModuleProvider(module);
    ExecutionEngine *ee = ExecutionEngine::create(mp, false);
    vector<genericvalue> noargs;
    GenericValue v = ee->runFunction(mainFunction, noargs);
    std::cout << "Code was run.\n";
    return v;
}
