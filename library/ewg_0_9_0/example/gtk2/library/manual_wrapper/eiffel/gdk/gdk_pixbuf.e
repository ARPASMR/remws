indexing

	description:

		"Objects representing Pixel Buffer"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 13:28:22 $"
	revision: "$Revision: 1.2 $"

class GDK_PIXBUF

inherit

	G_OBJECT

	GDKPIXBUF_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GDK_PIXBUF_CORE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GDK_PIXBUF_TRANSFORM_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation {GDK_PIXBUF_FACTORY}

	make_shared

feature {ANY} -- Status

	width: INTEGER is
			-- Width of pixel buffer in pixels
		do
			Result := gdk_pixbuf_get_width_external (item)
		ensure
			widht_greater_equal_zero: Result >= 0
		end

	height: INTEGER is
			-- Height of pixel buffer in pixels
		do
			Result := gdk_pixbuf_get_height_external (item)
		ensure
			height_greater_equal_zero: Result >= 0
		end

	rowstride: INTEGER is
			-- Rowstride of a pixbuf (number of bytes between rows)
		do
			Result := gdk_pixbuf_get_rowstride_external (item)
		end

	pixels: POINTER is
			-- Pointer pointing to pixel data
		do
			Result := gdk_pixbuf_get_pixels_external (item)
		end

feature	{ANY} -- Basic Routines

	copy_area_to (a_source_x, a_source_y, a_source_width, a_source_height: INTEGER;
				  a_target_pixbuf: GDK_PIXBUF; a_target_x, a_target_y: INTEGER) is
			-- Copy an area (`a_surce_x', `a_source_y', `a_source_width', `a_source_height'
			-- from `Current' to `a_target_pixbug' at `a_target_x', `a_target_y'.
		require
			a_target_pixbuf_not_void: a_target_pixbuf /= Void
			a_source_x_greater_equal_zero: a_source_x >= 0
			a_source_y_greater_equal_zero: a_source_y >= 0
			a_source_width_greater_equal_zero: a_source_width >= 0
			a_source_height_greater_equal_zero: a_source_height >= 0
			a_target_x_greater_equal_zero: a_target_x >= 0
			a_target_x_greater_equal_zero: a_target_y >= 0
			a_source_x_small_enough: a_source_x <= width
			a_source_y_small_enough: a_source_y <= height
			a_source_height_small_enough: a_source_height <= a_source_x + height
			a_source_width_small_enough: a_source_width <= a_source_y + width
			a_target_x_small_enough: a_target_x <= a_target_pixbuf.width
			a_target_y_small_enough: a_target_y <= a_target_pixbuf.height
			a_target_width_big_enough: a_target_x + a_source_width <= a_target_pixbuf.width
			a_target_height_big_enough: a_target_y + a_source_height <= a_target_pixbuf.height
		do
			gdk_pixbuf_copy_area_external (item, a_source_x, a_source_y, a_source_width, a_source_height,
											a_target_pixbuf.item, a_target_x, a_target_y)
		end

	copy_to (a_target_pixbuf: GDK_PIXBUF; a_target_x, a_target_y: INTEGER) is
			-- Copy an area (`a_surce_x', `a_source_y', `width', `height'
			-- from `Current' to `a_target_pixbug' at `a_target_x', `a_target_y'.
		require
			a_target_pixbuf_not_void: a_target_pixbuf /= Void
			a_target_x_greater_equal_zero: a_target_x >= 0
			a_target_x_greater_equal_zero: a_target_y >= 0
			a_target_x_small_enough: a_target_x <= a_target_pixbuf.width
			a_target_y_small_enough: a_target_y <= a_target_pixbuf.height
			a_target_width_big_enough: a_target_x + width <= a_target_pixbuf.width
			a_target_height_big_enough: a_target_y + height <= a_target_pixbuf.height
		do
			copy_area_to (0, 0, width, height, a_target_pixbuf, a_target_x, a_target_y)
		end


	composite (a_target: GDK_PIXBUF;
				a_target_x, a_target_y, a_target_width, a_target_height: INTEGER;
				a_x_offset, a_y_offset, a_x_scale_factor, a_y_scale_factor: DOUBLE;
				a_interpolation_type: INTEGER; a_overal_alpha: INTEGER) is
			-- Create a transformation of the `Current' image by scaling by `a_x_scale_factor' and
			-- `a_y_scale_factor' then translating by `a_x_offset' and `a_y_offset', then composites
			-- the rectangle (`a_target_x', `a_target_y', `a_target_width', `a_target_height') of the
			-- resulting image onto `a_target'.
			--
			-- `a_interpolation_type' :	One of GDK_INTERP_TYPE_ENUM_EXTERNAL
			-- `a_overal_alpha':	overall alpha for source image (0..255)
		require
			-- TODO:
		do
			gdk_pixbuf_composite_external (item, a_target.item, a_target_x, a_target_y,
											a_target_width, a_target_height, a_x_offset,
											a_y_offset, a_x_scale_factor, a_y_scale_factor,
											a_interpolation_type, a_overal_alpha)
		end

end
