indexing

	description:
		"The GTK_ALIGNMENT widget controls the alignment and size of its child widget."
		"It has four settings: `x_scale', `y_scale', `x_align', and `y_align'."
		"The scale settings are used to specify how much the child widget should expand to"
		"fill the space allocated to the GTK_ALIGNMENT. The values can range from 0 (meaning"
		"the child doesn't expand at all) to 1 (meaning the child expands to fill all of the"
		"available space)."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/09/21 22:45:24 $"
	revision: "$Revision: 1.1 $"

class GTK_ALIGNMENT

inherit
	
	GTK_BIN
	
	GTKALIGNMENT_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make
	
feature {NONE} -- Initialization

	make (a_x_align, a_y_align, a_x_scale, a_y_scale: REAL) is
			-- Creates a new object of type GTK_ALIGNMENT.
			--
			-- `a_x_align' is the horizontal alignment of the child widget,
			-- from `0' (left) to `1' (right).
			-- `a_y_align' is the vertical alignment of the child widget, from
			-- `0' (top) to `1' (bottom).
			-- `a_x_scale' is the amount that the child widget expands horizontally to
			-- fill up unused space, from `0' to `1'. A value of `0' indicates that
			-- the child widget should never expand. A value of `1' indicates that the
			-- child widget will expand to fill all of the space allocated for the
			-- `Current' widget.
			-- `a_y_scale' is the amount that the child widget expands vertically to fill up
			-- unused space from `0' to `1'. The values are similar to `a_x_scale'.
		require
			a_x_align_valid: a_x_align >= 0.0 and a_x_align <= 1.0
			a_y_align_valid: a_y_align >= 0.0 and a_y_align <= 1.0
			a_x_scale_valid: a_x_scale >= 0.0 and a_x_scale <= 1.0
			a_y_scale_valid: a_y_scale >= 0.0 and a_y_scale <= 1.0
		do
			make_shared (gtk_alignment_new_external (a_x_align, a_y_align, a_x_scale, a_y_scale))
		end

feature

	set (a_x_align, a_y_align, a_x_scale, a_y_scale: REAL) is
			-- Sets alignment values.
			--
			-- `a_x_align' is the horizontal alignment of the child widget,
			-- from `0' (left) to `1' (right).
			-- `a_y_align' is the vertical alignment of the child widget, from
			-- `0' (top) to `1' (bottom).
			-- `a_x_scale' is the amount that the child widget expands horizontally to
			-- fill up unused space, from `0' to `1'. A value of `0' indicates that
			-- the child widget should never expand. A value of `1' indicates that the
			-- child widget will expand to fill all of the space allocated for the
			-- `Current' widget.
			-- `a_y_scale' is the amount that the child widget expands vertically to fill up
			-- unused space from `0' to `1'. The values are similar to `a_x_scale'.
		require
			a_x_align_valid: a_x_align >= 0.0 and a_x_align <= 1.0
			a_y_align_valid: a_y_align >= 0.0 and a_y_align <= 1.0
			a_x_scale_valid: a_x_scale >= 0.0 and a_x_scale <= 1.0
			a_y_scale_valid: a_y_scale >= 0.0 and a_y_scale <= 1.0
		do
			gtk_alignment_set_external (item, a_x_align, a_y_align, a_x_scale, a_y_scale)
		end

end
