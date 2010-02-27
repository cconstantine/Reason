#include <ostream>
#include <vector>
#include <llvm/Value.h>

class CodeGenContext;
class NExpression;

class Node {
public:
    virtual ~Node() {}
    virtual void toString(std::ostream& s) = 0;
};

class NInteger : public Node {
 public:
  std::string value;
  NInteger(const std::string& value);

  virtual void toString(std::ostream& s);
};

class NIdentifier : public Node {
public:
    std::string name;
    NIdentifier(const std::string& name);
    virtual void toString(std::ostream& s);
};

class NExpression : public Node {
public:
  Node * first;
  Node * rest;
  NExpression(Node * first, Node * rest);
  virtual void toString(std::ostream& s);
};
