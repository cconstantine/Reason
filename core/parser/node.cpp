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
  :first(first), rest(rest)
{ }

void NExpression::toString(std::ostream& s)
{
  s << "( ";
  NExpression* cur = this;
  while (cur)
    {
      if (cur->first)
	cur->first->toString(s);

      cur = dynamic_cast<NExpression*>(cur->rest);
      s << " ";

    }
  s << ")";    
}







