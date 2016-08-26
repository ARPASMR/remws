This example demonstrates how to use the generated GTK wrapper.
It shows a window with rotating icons, using GDK_PIXBUF.
It has a nice alpha blending effect.

It is an Eiffel adoption of a sample application that comes with
GTK 2.

This example uses agents.

On Windows, for some reason the image loader seems to have issues.
To make the example work copy the dlls from the gtk/bin directory into
the example directory. Then it should work.