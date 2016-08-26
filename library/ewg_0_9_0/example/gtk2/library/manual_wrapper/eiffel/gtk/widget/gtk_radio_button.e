indexing

	description:

		"A choice from multiple check buttons"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.2 $"

class GTK_RADIO_BUTTON

inherit

	GTK_CHECK_BUTTON
		redefine
			make,
			make_with_label
		end

	GTKRADIOBUTTON_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make,
	make_with_label,
	make_shared
	
feature {NONE} -- Creation

	make is
			-- Create radio button belonging to a new group.
		do
			make_shared (gtk_radio_button_new_external (Default_pointer))
		end

	make_with_label (a_label: STRING) is
			-- Create radio button with `a_label' as child 
			-- belonging to a new group.
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_label)
			make_shared (gtk_radio_button_new_with_label_external (Default_pointer, cstr.item))
		end

end
