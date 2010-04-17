#include <ostream>

namespace llvm {
  class Value;
}

class CodeGenContext;

class Node {
public:
  virtual ~Node() {}
  virtual llvm::Value* compile(CodeGenContext& cgc) = 0;
  virtual void toString(std::ostream& s) = 0;
};

class NInteger : public Node {
 public:
  std::string value;
  NInteger(const std::string& value);

  virtual llvm::Value* compile(CodeGenContext& cgc);
  virtual void toString(std::ostream& s);
};

class NIdentifier : public Node {
public:
  std::string name;
  NIdentifier(const std::string& name);
  
  virtual llvm::Value* compile(CodeGenContext& cgc);
  virtual void toString(std::ostream& s);
};

class NString : public Node {
public:
    std::string name;
    NString(const std::string& name);

    virtual llvm::Value* compile(CodeGenContext& cgc){return NULL;}
    virtual void toString(std::ostream& s);
};

class NCons : public Node
{
public:
  Node * m_first;
  Node * m_rest;
  NCons(Node * first, Node * rest);

  virtual const Node* first() const;
  virtual const Node* rest() const;

  virtual llvm::Value* compile(CodeGenContext& cgc);
  virtual void toString(std::ostream& s);
};
