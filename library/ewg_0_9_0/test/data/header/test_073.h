// due to a bug in C_SYSTEM `struct foo'
// got the parameters of function `bar' as
// members instead of its own.

struct foo {
  int a;
};
typedef int foo;
void bar (foo *) ; // `foo' is an alias for `int' here
struct foo *baz; // `struct foo' means the struct with the name `foo' here
