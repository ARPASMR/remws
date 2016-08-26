

// composite struct member may be type name
// must parse

typedef int foo;

struct bar
{

  struct
  {
    foo i;
  } foo;

};
