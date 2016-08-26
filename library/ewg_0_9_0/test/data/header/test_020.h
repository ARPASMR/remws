typedef int    gint;
typedef unsigned int guint32;
typedef unsigned int	guint;


static inline  gint
g_bit_nth_lsf (guint32 mask,
	       gint    nth_bit)
{
  do
    {
      nth_bit++;
      if (mask & (1 << (guint) nth_bit))
	return nth_bit;
    }
  while (nth_bit < 32);
  return -1;
}

