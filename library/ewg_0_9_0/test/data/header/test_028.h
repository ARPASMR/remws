// shows selfcontaining struct

struct foo
{
  int a;
  struct foo* pfoo;
};
