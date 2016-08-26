// compound statements are ignored.
// because of this, even pathological cases should be parsed without error

typedef int bar;

void foo ()
{
  bar x;
  int bar;
  {
    int i;
  }
}
