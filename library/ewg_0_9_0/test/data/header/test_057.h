// tricky TOK_TYPE_NAME/TOK_IDENTIFIER
// situation, must parse ok

typedef int foo;
typedef int (*cb) (foo a, foo b);
