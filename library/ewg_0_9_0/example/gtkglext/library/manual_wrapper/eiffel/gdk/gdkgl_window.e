indexing

	description:

		"Objects represent Onscreen display areas in the target window system."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 13:28:22 $"
	revision: "$Revision: 1.2 $"

class GDKGL_WINDOW

inherit

	GDK_DRAWABLE

	GDKGLWINDOW_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make_shared
		
feature {ANY} -- Status

end
