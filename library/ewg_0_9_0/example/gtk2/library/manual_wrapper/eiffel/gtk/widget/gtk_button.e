indexing

	description:

		"A widget that creates a signal when clicked on."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.10 $"

class GTK_BUTTON

inherit

	GTK_BUTTON_AGENT

	GTK_BIN

	GTKBUTTON_FUNCTIONS_EXTERNAL
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
			-- Creates a new GTK_BUTTON widget.
			-- To add a child widget to the button, `GTK_CONTAINER.add'.
		do
			make_shared (gtk_button_new_external)
		end

	make_with_label (a_label: STRING) is
			-- Creates a GTK_BUTTON widget with a GTK_LABEL child containing
			--  `a_label' as text.
		require
			a_label_not_void: a_label /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_label)
			make_shared (gtk_button_new_with_label_external (cstr.item))
		end

feature {ANY} -- Basic operations

feature {ANY} -- Signals

	connect_clicked_signal_receiver (a_receiver: GTK_CLICKED_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end
end
