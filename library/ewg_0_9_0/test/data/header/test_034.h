
// very weird gdkcolor.h macro that shows that just because
// a #define contains a brackets, it does not need to be
// a macro with arguments 

#define GDK_TYPE_COLORMAP              (gdk_colormap_get_type ())
