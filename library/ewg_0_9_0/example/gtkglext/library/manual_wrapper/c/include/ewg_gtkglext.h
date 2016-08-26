#ifndef __EWG_GTKGLEXT__
#define __EWG_GTKGLEXT__

#include <ewg_gtk.h>
#include <gtk/gtkgl.h>
#include <ewg_opengl.h>

GdkGLDrawable* ewg_gtk_widget_get_gl_drawable (GtkWidget *widget);

#endif

