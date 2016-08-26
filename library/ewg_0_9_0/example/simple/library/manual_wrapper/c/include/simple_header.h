#ifndef __EWG_SIMPLE_HEADER__
#define __EWG_SIMPLE_HEADER__

struct foo
{
  int a,b,*pc;
};

typedef union
{
  int a;
} foo1;

typedef enum
{
  red,
  blue,
  green
} colors;

void func1 (int a, int b);

int func2 (int a, int b);

#endif
