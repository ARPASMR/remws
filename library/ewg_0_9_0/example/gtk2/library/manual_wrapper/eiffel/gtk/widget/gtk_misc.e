indexing

	description:

		"A GTK base class for widgets with alignments and padding"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/08/24 14:41:58 $"
	revision: "$Revision: 1.2 $"

class GTK_MISC

inherit

	GTK_WIDGET

	GTKMISC_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

feature {ANY} -- Basic Operations


	set_alignment (a_x_alignment, a_y_alignment: REAL) is
			-- Sets the alignment of the widget.
			--
			-- `a_x_alignment': the horizontal alignment, from `0.0' (left) to `1.0' (right).
			-- `a_y_alignment': the vertical alignment, from `0.0' (top) to `1.0' (bottom).
		require
			a_x_alignment_greater_in_range: a_x_alignment >= 0.0 and a_x_alignment <= 1.0
			a_y_alignment_greater_in_range: a_y_alignment >= 0.0 and a_y_alignment <= 1.0
		do
			gtk_misc_set_alignment_external (item, a_x_alignment, a_y_alignment)
		ensure
			a_x_alignment_set: True -- TODO
			a_y_alignment_set: True -- TODO
		end

	set_padding (a_x_padding, a_y_padding: INTEGER) is
			-- Sets the amount of space to add around the widget.
			-- `a_x_padding': the amount of space to add on the left and right of the
			--					widget, in pixels.
			-- `a_y_padding': the amount of space to add on the top and bottom of the
			--					widget, in pixels.
		require
			a_x_padding_greater_equal_zero: a_x_padding >= 0
			a_y_padding_greater_equal_zero: a_y_padding >= 0
		do
			gtk_misc_set_padding_external (item, a_x_padding, a_y_padding)
		ensure
			a_x_padding_set: True -- TODO
			a_y_padding_set: True -- TODO
		end

end
