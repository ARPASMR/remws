indexing

	description:

		"Objects represent something drawable. It allows for drawing points, %
		%lines, arcs, and text."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/26 21:55:16 $"
	revision: "$Revision: 1.3 $"

class GDK_DRAWABLE

inherit

	G_OBJECT

	GDKDRAWABLE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GDKRGB_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
		
feature {ANY} -- Basic Routines

	draw_rgb_image_dithalign (a_gc: GDK_GC; a_x, a_y, a_width, a_height: INTEGER;
							  a_dither_type: INTEGER; a_rgb_buffer: POINTER; a_rowstride: INTEGER;
							  a_x_dither_offset, a_y_dither_offset: INTEGER) is
			-- Draws an RGB image in the drawable, with an adjustment for dither alignment.
			--
			-- This function is useful when drawing dithered images into a window that may be
			-- scrolled. Pixel (`a_x', `a_y') will be drawn dithered as if its actual location
			-- is (`a_x' + `a_x_dither_offset', `a_y' + `a_y_dither_offset'). Thus, if you draw an
			-- image into a window using zero dither alignment, then scroll up one pixel, subsequent
			-- draws to the window should have `a_y_dither_offset' = `1'.
			--
			-- Setting the dither alignment correctly allows updating of small parts of the screen while
			-- avoiding visible "seams" between the different dither textures.
			--
			-- `a_gc':	The graphics context.
			-- `a_x':	The x coordinate of the top-left corner in the drawable.
			-- `a_y':	The y coordinate of the top-left corner in the drawable.
			-- `a_width':	The width of the rectangle to be drawn.
			-- `a_height':	The height of the rectangle to be drawn.
			-- `a_dither_type':	A GDK_RGB_DITHER_ENUM_EXTERNAL value, selecting the desired dither mode.
			-- `a_rgb_buffer:	The pixel data, represented as packed 24-bit data.
			-- `a_rowstride':	The number of bytes from the start of one row in `a_rgb_buffer' to the start of the next.
			-- `a_x_dither_offset':	An x offset for dither alignment.
			-- `a_y_dither_offset':	A y offset for dither alignment.
		require
			a_gc_not_void: a_gc /= Void
			a_x_big_enough: a_x >= 0
			a_y_big_enough: a_y >= 0
			a_x_small_enough: True -- TODO:
			a_y_small_enough: True -- TODO:
			a_width_big_enough: a_width >= 0
			a_height_big_enough: a_height >= 0
			a_width_small_enough: True -- TODO:
			a_height_small_enough: True -- TODO:
			a_dither_type_is_valid: True -- TODO: one of GDK_RGB_DITHER_ENUM_EXTERNAL
			a_rgb_buffer_not_default_pointer: a_rgb_buffer /= Default_pointer
			a_rowstride_big_enough: a_rowstride >= 0
			a_rowstride_small_enough: True -- TODO:
			a_x_dither_offset_big_enough: a_x_dither_offset >= 0
			a_y_dither_offset_big_enough: a_y_dither_offset >= 0
			a_x_dither_offset_small_enough: True -- TODO:
			a_y_dither_offset_small_enough: True -- TODO:
		do
			gdk_draw_rgb_image_dithalign_external (item, a_gc.item, a_x, a_y, a_width, a_height,
													a_dither_type, a_rgb_buffer, a_rowstride,
													a_x_dither_offset, a_y_dither_offset)
		end

	draw_rectangle (a_gc: GDK_GC; a_x: INTEGER; a_y: INTEGER;
						 a_width: INTEGER; a_height: INTEGER) is
			-- Draws a rectangular outline rectangle, using the
			-- foreground color and other attributes of the
			-- GdkGC.
		require
			a_gc_not_void: a_gc /= Void
			a_x_valid: a_x >= 0
			a_y_valid: a_y >= 0
			a_width_valid: a_width >= 0
			a_heiht_valid: a_height >= 0
		do
			gdk_draw_rectangle_external (item, a_gc.item, 0, a_x, a_y, a_width, a_height)
		end
	
	draw_rectangle_filled (a_gc: GDK_GC; a_x: INTEGER; a_y: INTEGER;
								  a_width: INTEGER; a_height: INTEGER) is
			-- Draws a rectangular outline rectangle, using the
			-- foreground color and other attributes of the GdkGC. A
			-- rectangle drawn filled is 1 pixel smaller in both
			-- dimensions than a rectangle outlined. Calling
			-- `draw_rectangle_filled (window, gc, 0, 0, 20, 20)' results
			-- in a filled rectangle 20 pixels wide and 20 pixels
			-- high. Calling `draw_rectangle (window, gc, 0, 0, 20, 20)'
			-- results in an outlined rectangle with corners at (0, 0),
			-- (0, 20), (20, 20), and (20, 0), which makes it 21 pixels
			-- wide and 21 pixels high.
		require
			a_gc_not_void: a_gc /= Void
			a_width_valid: a_width >= 0
			a_heiht_valid: a_height >= 0
		do
			gdk_draw_rectangle_external (item, a_gc.item, 1, a_x, a_y, a_width, a_height)
		end

	draw_drawable (a_gc: GDK_GC;
						a_source_drawable: GDK_DRAWABLE;
						a_source_x: INTEGER;
						a_source_y: INTEGER;
						a_destination_x: INTEGER;
						a_destination_y: INTEGER;
						a_width: INTEGER;
						a_height: INTEGER) is
			-- Copies the `a_width' x `a_height' region of
			-- `a_source_drawable' at coordinates (`a_source_x,
			-- `a_source_y') to coordinates (`a_destination_x,
			-- a_destination_y') in the current drawable. `a_width'
			-- and/or `a_height' may be given as `-1', in which case the
			-- entire `a_source_drawable' drawable will be copied.
		require
			a_gc_not_void: a_gc /= Void
			a_source_drawable_not_void: a_source_drawable /= Void
			a_source_x_valid: a_source_x >= 0
			a_source_y_valid: a_source_y >= 0
			a_destination_x_valid: a_destination_x >= 0
			a_destination_y_valid: a_destination_y >= 0
			a_width_valid: a_width >= 0 or a_width = -1
			a_height_valid: a_height >= 0 or a_height = -1

		do
			gdk_draw_drawable_external (item,
												 a_gc.item,
												 a_source_drawable.item,
												 a_source_x, a_source_y,
												 a_destination_x, a_destination_y,
												 a_width, a_height)
		end
	

feature {ANY} -- Status

end
