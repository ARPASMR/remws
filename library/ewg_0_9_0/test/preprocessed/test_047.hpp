# 1 "test_047.h"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "test_047.h"



void foo ()
{
    __asm {
        mov ecx, ShiftCount
        mov eax, dword ptr [Value]
        mov edx, dword ptr [Value+4]
        shld edx, eax, cl
        shl eax, cl
    }
}
