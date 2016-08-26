indexing

	description:

		"A base class for box containers"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 13:28:22 $"
	revision: "$Revision: 1.2 $"

class GTK_BOX

inherit

	GTK_CONTAINER

	GTKBOX_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

feature {ANY} -- Basic operations


	pack_start_defaults (a_child: GTK_WIDGET) is
			-- Adds `a_child' to current box, packed with reference
			-- to the start of box. The child is packed after any other
			-- child packed with reference to the start of box.
			--
			-- Parameters for how to pack the child widget, expand, fill, and padding
			-- in GtkBoxChild, are given their default values, `True', `True' and `0', respectively.
		require
			a_child_not_void: a_child /= Void
		do
			gtk_box_pack_start_defaults_external (item, a_child.item)
		ensure
			child_added: True -- TODO:
		end
	
	pack_start (a_child: GTK_WIDGET; a_expand: BOOLEAN; a_fill: BOOLEAN; a_padding: INTEGER) is
			-- Adds `a_child' to current box, packed with reference to the start of current box.
			-- The child is packed after any other child packed with reference to the start of current box.
			--
			-- `a_child':	the GTK_WIDGET to be added to box.
			-- `a_expand':	`True' if the new child is to be given extra space allocated to box.
			--					The extra space will be divided evenly between all children of
			--					box that use this option.
			-- `a_fill':	`True' if space given to child by the expand option is actually allocated
			--					to child, rather than just padding it. This parameter has no effect
			--					if expand is set to FALSE. A child is always allocated the full height
			--					of a GtkHBox and the full width of a GtkVBox. This option affects the
			--					other dimension.
			-- `a_padding':	extra space in pixels to put between this child and its neighbors, over and
			--					above the global amount specified by spacing in GtkBox. If child is a
			--					widget at one of the reference ends of box, then padding pixels are also
			--					put between child and the reference edge of box.
		require
			a_child_not_void: a_child /= Void
		local
			a_expand_int: INTEGER
			a_fill_int: INTEGER
		do
			if a_expand then
				a_expand_int := 1
			end
			if a_fill then
				a_fill_int := 1
			end
			gtk_box_pack_start_external (item, a_child.item, a_expand_int, a_fill_int, a_padding)
		ensure
			child_added: True -- TODO:
		end

	pack_end_defaults (a_child: GTK_WIDGET) is
			-- Adds `a_child' to current box, packed with reference to the end of box.
			-- The child is packed after (away from end of) any other child packed with
			-- reference to the end of box.
			--
			-- Parameters for how to pack the child widget, expand, fill, and padding in
			-- GtkBoxChild, are given their default values, `True', `True', and `0', respectively.
		require
			a_child_not_void: a_child /= Void
		do
			gtk_box_pack_end_defaults_external (item, a_child.item)
		ensure
			child_added: True -- TODO:
		end

	pack_end (a_child: GTK_WIDGET; a_expand: BOOLEAN; a_fill: BOOLEAN; a_padding: INTEGER) is
			-- Adds `a_child' to box, packed with reference to the end of box. The child is
			-- packed after (away from end of) any other child packed with reference to the
			-- end of box.
			--
			-- `a_child':	the GTK_WIDGET to be added to box.
			-- `a_expand':	`True' if the new child is to be given extra space allocated to box.
			--					The extra space will be divided evenly between all children of
			--					box that use this option.
			-- `a_fill':	`True' if space given to child by the expand option is actually allocated
			--					to child, rather than just padding it. This parameter has no effect
			--					if expand is set to FALSE. A child is always allocated the full height
			--					of a GtkHBox and the full width of a GtkVBox. This option affects the
			--					other dimension.
			-- `a_padding':	extra space in pixels to put between this child and its neighbors, over and
			--					above the global amount specified by spacing in GtkBox. If child is a
			--					widget at one of the reference ends of box, then padding pixels are also
			--					put between child and the reference edge of box.
		require
			a_child_not_void: a_child /= Void
		local
			a_expand_int: INTEGER
			a_fill_int: INTEGER
		do
			if a_expand then
				a_expand_int := 1
			end
			if a_fill then
				a_fill_int := 1
			end
			gtk_box_pack_end_external (item, a_child.item, a_expand_int, a_fill_int, a_padding)
		ensure
			child_added: True -- TODO:
		end

end
