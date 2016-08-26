
// __declspec(align(x) must be accepted when msc extensions are turned on
struct __declspec(align(16)) foo 
{
  int i;
} bar;
