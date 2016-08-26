// must parse ok with cl extensions turned on
// '__cdecl' as part of an anonymous function parameter which is of type pointer to function

int __cdecl atexit(void (__cdecl *)(void));
int atexit2(void (__cdecl *)(void));
