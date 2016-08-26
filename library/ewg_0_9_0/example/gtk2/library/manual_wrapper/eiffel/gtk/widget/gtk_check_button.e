indexing

	description:

		"Represents GTK discrete toggle button"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.2 $"

class GTK_CHECK_BUTTON

inherit

	GTK_TOGGLE_BUTTON
		redefine
			make,
			make_with_label
		end

	GTKCHECKBUTTON_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make,
	make_with_label

feature {NONE} -- Creation

	make is
			-- Creates a new GTK_CHECK_BUTTON widget.
			-- To add a child widget to the button, `GTK_CONTAINER.add'.
		do
			make_shared (gtk_check_button_new_external)
		end

	make_with_label (a_label: STRING) is
			-- Creates a GTK_CHECK_BUTTON widget with a GTK_LABEL child containing
			--  `a_label' as text.
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_label)
			make_shared (gtk_check_button_new_with_label_external (cstr.item))
		end

feature {ANY} -- Basic operations

end
