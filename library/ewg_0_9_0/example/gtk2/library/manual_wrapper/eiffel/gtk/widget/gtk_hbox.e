indexing

	description:

		"Horizontal container box"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/08/01 19:12:35 $"
	revision: "$Revision: 1.3 $"

class GTK_HBOX

inherit

	GTK_BOX

	GTKHBOX_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
	
creation

	make,
	make_homogenous,
	make_shared
	
	
feature -- Intialization

	make (a_spacing: INTEGER) is
			-- Creates a new inhomogenous GTK_HBOX
			--
			-- `a_spacing':	the number of pixels to place by default
			--					between children.
		require
			a_spacing_small_enough: a_spacing >= 0
		do
			make_shared (gtk_hbox_new_external (0, a_spacing))
		end

	make_homogenous (a_spacing: INTEGER) is
			-- Creates a new homogenous GTK_HBOX.
			-- homogenous means that all children are to be given
			-- equal space allotments.
			--
			-- `a_spacing':	the number of pixels to place by default
			--					between children.
		require
			a_spacing_small_enough: a_spacing >= 0
		do
			make_shared (gtk_hbox_new_external (1, a_spacing))
		end

feature {ANY} -- Basic operations

end
