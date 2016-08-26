
// anonymous function parameter of type function with anonymoys typedef as parameter
// must parse

typedef int foo;
void (*bar) (void (*)(foo*));

