#ifndef __EWG_GTK__
#define __EWG_GTK__

#include <gtk/gtk.h>

GdkEventType ewg_gdk_event_get_event_type (GdkEvent* a_event);

GdkRectangle* ewg_gtk_widget_get_allocation (GtkWidget* a_widget);

GdkRectangle* ewg_gtk_event_expose_get_area (GdkEventExpose* a_event);

GtkStateType ewg_gtk_widget_get_state (GtkWidget* a_widget);

GdkGC* ewg_gtk_style_get_fg_gc_array_address (GtkStyle* a_style);

int ewg_gtk_style_get_fg_gc_array_sizeof (GtkStyle* a_style);

#endif

