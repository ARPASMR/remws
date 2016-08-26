
#ifndef ___TEST_065_H___
#define ___TEST_065_H___

// struct type with callback as member,
// where callback itself has another callback as parameter

// generated weird c code

typedef struct foo
{
  float* (*bar) (double (*cb) (int));
} *pfoo;

#endif
