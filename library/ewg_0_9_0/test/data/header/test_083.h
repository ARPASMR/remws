
// the nested composite type is anonymous
// must not crash while generating

struct foo
{
  struct
  {
    int i;
  } bar;
};
