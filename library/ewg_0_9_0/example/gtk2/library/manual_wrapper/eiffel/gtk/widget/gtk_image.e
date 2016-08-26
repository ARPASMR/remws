indexing

	description:

		"A GTK widget displaying an image"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.2 $"

class GTK_IMAGE

inherit

	GTK_MISC

	GTKIMAGE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make_from_file

feature {NONE} -- Creation

	make_from_file (a_file_name: STRING) is
			-- 	Creates a new GTK_IMAGE displaying the file filename.
			-- If the file isn't found or can't be loaded, the resulting
			-- GTK_IMAGE will display a "broken image" icon.
			--
			-- If the file contains an animation, the image will contain an animation.
			--
			-- If you need to detect failures to load the file, use
			-- `GDK_PIXBUF.make_from_file' to load the file yourself, then create the
			-- GTK_IMAGE from the pixbuf. (Or for animations, use
			-- `GDK_PIXBUF.make_animation_from_file'.
			--
			-- The storage type (`storage_type') of the created image is not defined,
			-- it will be whatever is appropriate for displaying the file.
		require
			a_file_name_not_void: a_file_name /= Void
			a_file_name_not_empty: a_file_name.count > 0
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_file_name)
			make_shared (gtk_image_new_from_file_external (cstr.item))
		end

feature {ANY} -- Basic operations

end
