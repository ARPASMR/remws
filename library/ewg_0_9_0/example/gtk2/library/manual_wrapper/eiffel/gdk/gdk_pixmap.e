indexing

	description:

		"Pixmaps are offscreen drawables. They can be drawn upon with%
		%the standard drawing primitives, then copied to another%
		%drawable (such as a GDK_WINDOW) with `draw'. The%
		%depth of a pixmap is the number of bits per pixels. Bitmaps are%
		%simply pixmaps with a depth of 1. (That is, they are monochrome%
		%bitmaps - each pixel can be either on or off)."
	
	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/26 21:55:16 $"
	revision: "$Revision: 1.1 $"

class GDK_PIXMAP

inherit

	GDK_DRAWABLE

	GDKPIXMAP_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make
		
feature {ANY} -- Status

	make (a_drawable: GDK_DRAWABLE; a_width: INTEGER; a_height: INTEGER;
			a_depth: INTEGER) is
			-- Create a new pixmap with a given width `a_width' and
			-- height `a_height' and the colordepth `a_depth'.
			-- If `a_depth' is `-1' and `a_drawable' is not `Void' then
			-- the colordepth will be equal to that of `a_drawable'.
			-- TODO: we should provide two creation routines, one with custom
			-- color depth and one where it is taken from `a_drawable'.
		require
			a_width_positive: a_width >= 0
			a_height_positive: a_height >= 0
			a_depth_valid: a_depth = -1 or a_depth >= 1
		do
			make_shared (gdk_pixmap_new_external (a_drawable.item,
															  a_width,
															  a_height,
															  a_depth))
		end


end
