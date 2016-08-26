// VC extension
// must parse without error when cl extensions are turned on

extern __declspec(dllexport) void foo1(void);
extern __declspec(dllimport) void foo2(void);
extern __declspec(dllexport) void __cdecl foo3(void);
extern __declspec(dllexport) void* __cdecl foo4(void);

