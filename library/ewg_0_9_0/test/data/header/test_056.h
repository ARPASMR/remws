// tricky TOK_TYPE_NAME/TOK_IDENTIFIER
// situation, must parse ok

typedef unsigned int foo;
typedef unsigned int foo2;

struct bar
{
  foo foo2;
};

