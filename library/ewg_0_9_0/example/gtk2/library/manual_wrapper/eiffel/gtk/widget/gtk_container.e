indexing

	description:

		"Base class for widgets which contain other widgets"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 13:28:22 $"
	revision: "$Revision: 1.4 $"

class GTK_CONTAINER

inherit

	GTK_WIDGET

	GTKCONTAINER_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

feature {ANY} -- Basic Queries

	border_width: INTEGER is
			-- Retrieves the border width of the container. See `set_border_width'.
		do
			Result := gtk_container_get_border_width_external (item)
		ensure
			border_width_greater_equal_zero: Result >= 0
		end
	
feature {ANY} -- Basic Operations

	set_border_width (a_width: INTEGER) is
			-- Sets the border width of the container.
			-- The border width of a container is the amount of space
			-- to leave around the outside of the container. The only
			-- exception to this is GTK_WINDOW; because toplevel windows
			-- can't leave space outside, they leave the space inside.
			-- The border is added on all sides of the container. To add
			-- space to only one side, one approach is to create a
			-- GTK_ALIGNMENT widget, call `GTK_WIDGET.set_usize' to give it
			-- a size, and place it on the side of the container as a spacer.
		require
			a_width_greater_equal_zero: a_width >= 0
		do
			gtk_container_set_border_width_external (item, a_width)
		ensure
			border_width_set: border_width = a_width
		end

	add (a_widget: GTK_WIDGET) is
			-- Adds widget to container. Typically used for simple containers such
			-- as GTK_WINDOW, GTK_FRAME, or GTK_BUTTON; for more complicated layout
			-- containers such as GTK_BOX or GTK_TABLE, this function will pick default
			-- packing parameters that may not be correct. So consider functions such
			-- as `GTK_BOX.pack_start' and `GTK_TABLE.attach' as an alternative to
			-- `GTK_CONTAINER.add' in those cases. A widget may be added to only one
			-- container at a time; you can't place the same widget inside two different
			-- containers.
		require
			a_widget_not_void: a_widget /= Void
		do
			gtk_container_add_external (item, a_widget.item)
		ensure
			widget_added: -- TODO:
		end
	
end
