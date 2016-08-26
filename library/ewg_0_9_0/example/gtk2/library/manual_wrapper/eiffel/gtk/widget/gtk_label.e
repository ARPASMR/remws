indexing

	description:

		"A GTK widget that displays a small to medium amount of text"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.2 $"

class GTK_LABEL

inherit

	GTK_MISC

	GTKLABEL_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTK_JUSTIFICATION_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_justification
		undefine
			is_equal,
			copy
		end

creation

	make,
	make_empty

feature {NONE} -- Creation

	make (a_text: STRING) is
			-- Creates a new label with the given text inside it.
		require
			a_text_not_void: a_text /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_text)
			make_shared (gtk_label_new_external (cstr.item))
		ensure
			a_text_set: True -- TODO:
		end

	make_empty is
			-- Creates a new label with no text.
		do
			make_shared (gtk_label_new_external (Default_pointer))
		ensure
			label_has_no_text: True -- TODO:
		end

feature {ANY} -- Basic operations

	set_text (a_text: STRING) is
			-- Makes `a_text' the new text within the GtkLabel widget.
			-- It overwrites any text that was there before.
			-- This will also clear any previously set mnemonic accelerators.
		require
			a_text_not_void: a_text /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_text)
			gtk_label_set_text_external (item, cstr.item)
		ensure
			a_text_set: True -- TODO:
		end

	set_justify (a_justification_type: INTEGER) is
			-- Sets the alignment of the lines in the text of the label
			-- relative to each other. `Gtk_justify_left' is the default
			-- value when the widget is first created.
			-- If you instead want to set the alignment of the label as a whole,
			-- use `GTK_MISC.set_alignment' instead. `set_justify' has no effect
			-- on labels containing only a single line.
			--
			-- `a_justification_type' must be one of the integers available from
			-- GTK_JUSTIFICATION_ENUM_EXTERNAL
		require
			is_justification_type: is_valid_justification (a_justification_type)
		do
			gtk_label_set_justify_external (item, a_justification_type)
		end


	set_line_wrap (a_value: BOOLEAN) is
			-- Toggles line wrapping within the GTK_LABEL.
			-- `True' makes it break lines if text exceeds the widget's
			-- size. `False' lets the text get cut off by the edge of the widget
			-- if it exceeds the widget size.
		do
			if a_value then
				gtk_label_set_line_wrap_external (item, 1)
			else
				gtk_label_set_line_wrap_external (item, 0)
			end
		ensure
			line_wrap_set: a_value = is_line_wrapping_enabled
		end

	enable_line_wrap is
			-- Enables line wrapping.
			-- See `set_line_wrap'
		do
			set_line_wrap (True)
		ensure
			line_wrapping_enabled: is_line_wrapping_enabled
		end

	disable_line_wrap is
			-- Disables line wrapping.
			-- See `set_line_wrap'
		do
			set_line_wrap (False)
		ensure
			line_wrapping_disable: not is_line_wrapping_enabled
		end

	is_line_wrapping_enabled: BOOLEAN is
			-- Returns whether lines in the label are automatically wrapped.
			-- See `set_line_wrap'.
		local
			int_result: INTEGER
		do
			int_result := gtk_label_get_line_wrap_external (item)
			if int_result /= 0 then
				Result := True
			end
		end


	set_pattern (a_pattern: STRING) is
			-- The pattern of underlines you want under the existing text within the
			-- GTK_LABEL widget. For example if the current text of the label says
			-- "FooBarBaz" passing a pattern of "___ ___" will underline "Foo"
			-- and "Baz" but not "Bar".
		require
			a_pattern_not_void: a_pattern /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_pattern)
			gtk_label_set_pattern_external (item, cstr.item)
		ensure
			a_pattern_set: True -- TODO:
		end

end
