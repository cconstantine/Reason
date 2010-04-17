#include <string>
#include <iostream>
#include <reason/node.h>
#include <reason/compiler/codegen.h>

using namespace llvm;

NInteger::NInteger(const std::string& value)
  :value(value) 
{ }

llvm::Value* NInteger::compile(CodeGenContext& cgc)
{
  llvm::LLVMContext& c = cgc.module.getContext();

  //TODO THIS IS HORRIBLE!
  unsigned int i = atoi(value.c_str());

  return ConstantInt::get(Type::getInt32Ty(c), i);
}

void NInteger::toString(std::ostream& s)
{
  s << value;
}


NIdentifier::NIdentifier(const std::string& name)
  :name(name) 
{ }

llvm::Value* NIdentifier::compile(CodeGenContext& cgc)
{
  SymbolTable::iterator iter = cgc.symbols.find(name);

  if (iter != cgc.symbols.end())
    return (*iter).second;

  return NULL;
}

void NIdentifier::toString(std::ostream& s)
{
  s << name;
}

NString::NString(const std::string& name)
  :name(name) 
{ }

void NString::toString(std::ostream& s)
{
  s << name;
}


NCons::NCons(Node * first, Node * rest)
  :m_first(first), m_rest(rest)
{ }

const Node * NCons::first() const
{
  return m_first;
}

const Node * NCons::rest() const
{
  return m_rest;
}

llvm::Value* NCons::compile(CodeGenContext& cgc)
{
  NCons *expr = this;
  if (NIdentifier *indent = dynamic_cast<NIdentifier*>(m_first))
    {
      std::string& name = indent->name;
      
      // This is a function call
      if (Function *f = cgc.module.getFunction(name))
	{
	  std::vector<Value*> args;
	  while((expr = dynamic_cast<NCons*>(expr->m_rest)))
	    {
	      args.push_back( expr->m_first->compile(cgc) );
	    }
	  return CallInst::Create(f, args.begin(), args.end(), 
				  name.c_str(), &cgc.func->back());
	}
      else
	{
	  std::cerr <<  std::string("Unable to find function '") <<  name << "'" <<std::endl;
	}
    }
  return NULL;
}


void NCons::toString(std::ostream& s)
{
  s << "( ";
  NCons* cur = this;
  while (cur)
    {
      if (cur->m_first)
	cur->m_first->toString(s);

      cur = dynamic_cast<NCons*>(cur->m_rest);
      s << " ";

    }
  s << ")";    
}







