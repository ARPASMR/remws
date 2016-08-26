indexing

	description:

		"GTK horizontal separator, used to group the widgets within a window"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/08/01 21:36:25 $"
	revision: "$Revision: 1.1 $"

class GTK_HSEPARATOR

inherit

	GTK_SEPARATOR

	GTKHSEPARATOR_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make

feature {NONE} -- Creation

	make is
			-- Creates new horizontal separator
		do
			make_shared (gtk_hseparator_new_external)
		end

end
