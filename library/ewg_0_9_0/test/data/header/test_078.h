
typedef void (*foo) (void);

// (ve) glue code for calling function
// 'bar' had paramerter 'foo* anonymous_1' instead of (the correct) 'foo anonymous_1'
void bar (foo);
