indexing

	description:

		"Created GDK_PIXBUF objects"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.2 $"

class GDK_PIXBUF_FACTORY

inherit

	GDK_PIXBUF_CORE_FUNCTIONS_EXTERNAL
		export {NONE} all end

	GDKPIXBUF_FUNCTIONS_EXTERNAL
		export {NONE} all end

	GDK_COLORSPACE_ENUM_EXTERNAL
		export {NONE} all end

creation {GDK_SHARED_PIXBUF_FACTORY}

	make

feature {NONE} -- Initialization

	make is
		do
		end

feature {ANY}

	new_from_file_name (a_file_name: STRING): GDK_PIXBUF is
			-- Create a new pixbuf by loading an image from a
			-- file. The file format is detected automatically.
			-- If `Void' is returned, an error has occured
			-- TODO: make error reason available
		local
			cstr: EWG_ZERO_TERMINATED_STRING
			p: POINTER
		do
			create cstr.make_unshared_from_string (a_file_name)
			p := gdk_pixbuf_new_from_file_external (cstr.item, Default_pointer)
			if p /= Default_pointer then
				create Result.make_shared (p)
			end
		end


	new (a_has_alpha: BOOLEAN; a_bits_per_sample: INTEGER; a_width: INTEGER; a_height: INTEGER): GDK_PIXBUF is
			-- Create a new GDK_PIXBUF structure and allocates a buffer
			-- for it. The buffer has an optimal rowstride. Note that the
			-- buffer is not cleared; you will have to fill it completely
			-- yourself.
			--
			-- `a_has_alpha':	Whether the image should have transparency information.
			-- `a_bits_per_sample':	Number of bits per color sample.
			-- `a_width:	Width of image in pixels.
			-- `a_height:	Height of image in pixels.
			--
			-- If there was not enough memory to create the structure, `Void' is returned.
		require
			a_bits_per_sample_greater_zero: a_bits_per_sample > 0
			a_width_greater_equal_zero: a_width >= 0
			a_height_greater_equal_zero: a_height >= 0
		local
			p: POINTER
			has_alpha_int: INTEGER
		do
			if a_has_alpha then
				has_alpha_int := 1
			end
			p := gdk_pixbuf_new_external (gdk_colorspace_rgb, has_alpha_int, a_bits_per_sample, a_width, a_height)
			if p /= Default_pointer then
				create Result.make_shared (p)
			end
		end

end
