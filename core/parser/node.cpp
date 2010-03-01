#include <string>
#include <reason/parser/node.h>



NInteger::NInteger(const std::string& value)
  :value(value) 
{

}

void NInteger::toString(std::ostream& s)
{
  s << value;
}

NIdentifier::NIdentifier(const std::string& name)
  :name(name) 
{ }

void NIdentifier::toString(std::ostream& s)
{
  s << name;
}


NExpression::NExpression(Node * first, Node * rest)
  :m_first(first), m_rest(rest)
{ }

void * NExpression::first() const
{
  return (void*)m_first;
}

void * NExpression::rest() const
{
  return (void*)m_rest;
}

void NExpression::toString(std::ostream& s)
{
  s << "( ";
  NExpression* cur = this;
  while (cur)
    {
      if (cur->m_first)
	cur->m_first->toString(s);

      cur = dynamic_cast<NExpression*>(cur->m_rest);
      s << " ";

    }
  s << ")";    
}







