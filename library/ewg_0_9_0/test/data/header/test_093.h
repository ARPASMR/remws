
#ifndef ___TEST_093_H___
#define ___TEST_093_H___

typedef int foo;
void bar (foo foo);

// When a typename (declared via a typedef) is "redeclared" as a
// variable or parameter, the typename is hidden and must not be used
// within the variable/parameter's scope anymore

#endif
