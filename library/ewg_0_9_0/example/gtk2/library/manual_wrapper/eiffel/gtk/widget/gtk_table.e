indexing

	description:

		"Pack widgets in regular patterns."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/09/21 22:45:24 $"
	revision: "$Revision: 1.2 $"

class GTK_TABLE

inherit

	GTK_CONTAINER
	
	GTKTABLE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make,
	make_homogenous

feature {NONE} -- Creation

	make (a_rows, a_columns: INTEGER) is
			-- Creates a new table widget. An initial size must be given by
			-- specifying how many rows and columns the table should have, although
			-- this can be changed later with `resize'.
		require
			a_rows_big_enough: a_rows >= 0
			a_rows_small_enough: a_rows <= 65535
			a_columns_big_enough: a_rows >= 0
			a_columns_small_enough: a_columns <= 65535
		do
			make_shared (gtk_table_new_external (a_rows, a_columns, 0))
		ensure
			exists: exists
			not_homogenous: not is_homogenous
			--TODO:
		end

	make_homogenous (a_rows, a_columns: INTEGER) is
			-- Creates a new table widget. An initial size must be given by
			-- specifying how many rows and columns the table should have, although
			-- this can be changed later with `resize'.
			-- Table cells are resized to the size of the cell containing the
			-- largest widget.
		require
			a_rows_big_enough: a_rows >= 0
			a_rows_small_enough: a_rows <= 65535
			a_columns_big_enough: a_rows >= 0
			a_columns_small_enough: a_columns <= 65535
		do
			make_shared (gtk_table_new_external (a_rows, a_columns, 1))
		ensure
			exists: exists
			is_homogenous: is_homogenous
			--TODO:
		end

feature {ANY} -- Status Access


	is_homogenous: BOOLEAN is
			-- Are the table cells all constrained to the same width and height?
		do
			Result := gtk_table_get_homogeneous_external (item) /= 0
		end
	
feature {ANY} -- Status Settings

	resize  (a_rows, a_columns: INTEGER) is
			-- If you need to change a table's size after it has been created,
			-- this function allows you to do so.
		require
			a_rows_big_enough: a_rows >= 0
			a_rows_small_enough: a_rows <= 65535
			a_columns_big_enough: a_rows >= 0
			a_columns_small_enough: a_columns <= 65535
		do
			gtk_table_resize_external (item, a_rows, a_columns)
		ensure
			--TODO:
		end

	attach_defaults (a_child: GTK_WIDGET; a_left_attach, a_right_attach: INTEGER;
					 a_top_attach: INTEGER; a_bottom_attach: INTEGER) is
			-- As there are many options associated with `table_attach', this convenience
			-- function provides the programmer with a means to add children to a table with
			-- identical padding and expansion options.
			--
			-- `a_left_attach':	The column number to attach the left side of the child widget to.
			-- `a_right_attach': The column number to attach the right side of the child widget to.
			-- `a_top_attach': The row number to attach the top of the child widget to.
			-- `a_bottom_attach': The row number to attach the bottom of the child widget to.
		require
			-- TODO: 
		do
			gtk_table_attach_defaults_external (item, a_child.item, a_left_attach, a_right_attach,
												a_top_attach, a_bottom_attach)
		ensure
			-- TODO:
		end

	attach (a_child: GTK_WIDGET; a_left_attach, a_right_attach: INTEGER;
			  a_top_attach: INTEGER; a_bottom_attach: INTEGER;
			  a_x_options: INTEGER; a_y_options: INTEGER;
			  a_x_padding: INTEGER; a_y_padding: INTEGER) is
			-- Adds a widget to a table. The number of 'cells' that a widget will
			-- occupy is specified by `a_left_attach', `a_right_attach', `a_top_attach'
			-- and `a_bottom_attach'. These each represent the leftmost, rightmost,
			-- uppermost and lowest column and row numbers of the table.
			-- (Columns and rows are indexed from zero).
			-- For `a_x_options' and `a_y_options' see class GTK_ATTACH_OPTIONS_ENUM_EXTERNAL
			--
			-- `a_left_attach':	The column number to attach the left side of the child widget to.
			-- `a_right_attach': The column number to attach the right side of the child widget to.
			-- `a_top_attach': The row number to attach the top of the child widget to.
			-- `a_bottom_attach': The row number to attach the bottom of the child widget to.
			-- `a_x_options':	Used to specify the properties of the child widget when the table is resized.
			-- `a_y_options':	The same as xoptions, except this field determines behaviour of vertical resizing.
			-- `a_x_padding':	An integer value specifying the padding on the left and right of the
			-- widget being added to the table.
			-- `a_y_padding':	The amount of padding above and below the child widget.
		require
			-- TODO: 
		do
			gtk_table_attach_external (item, a_child.item, a_left_attach, a_right_attach,
												a_top_attach, a_bottom_attach, a_x_options, a_y_options,
												a_x_padding, a_y_padding)
		ensure
			-- TODO:
		end
	
end
