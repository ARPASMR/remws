indexing

	description:

		"Represents GTK buttons which retain their state"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.2 $"

class GTK_TOGGLE_BUTTON

inherit

	GTK_BUTTON
		redefine
			make,
			make_with_label
		end

	GTKTOGGLEBUTTON_FUNCTIONS_EXTERNAL
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
			-- Creates a new GTK_TOGGLE_BUTTON widget.
			-- To add a child widget to the button, `GTK_CONTAINER.add'.
		do
			make_shared (gtk_toggle_button_new_external)
		end

	make_with_label (a_label: STRING) is
			-- Creates a GTK_TOGGLE_BUTTON widget with a GTK_LABEL child containing
			--  `a_label' as text.
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_label)
			make_shared (gtk_toggle_button_new_with_label_external (cstr.item))
		end

feature {ANY} -- Basic operations


	is_pressed: BOOLEAN is
			-- Returns `True' if the button is in its "pressed" state,
			-- otherwise `False'.
		local
			int_result: INTEGER
		do
			int_result := gtk_toggle_button_get_active_external (item)
			if int_result /= 0 then
				Result := True
			end
		end

	set_active (a_value: BOOLEAN) is
			-- Sets the status of the toggle button. Set to `True' if you
			-- want the GTK_TOGGLE_BUTTON to be 'pressed in', and `False' to
			-- raise it. This action causes the toggled signal to be emitted.
		do
			if a_value then
				gtk_toggle_button_set_active_external (item, 1)
			else
				gtk_toggle_button_set_active_external (item, 0)
			end
		end
end
