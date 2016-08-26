indexing

	description:

		"Widget used for item in menus"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/04/30 12:43:15 $"
	revision: "$Revision: 1.3 $"

class GTK_MENU_ITEM

inherit

	GTK_ITEM

	GTK_MENU_ITEM_AGENT

	GTKMENUITEM_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
	
creation

	make,
	make_with_label

feature {NONE} -- Initialization

	make is
			-- Create a new GTK_MENU_ITEM object
		do
			make_shared (gtk_menu_item_new_external)
		ensure
			exists: exists
		end
	
	make_with_label (a_label: STRING) is
			-- Creates a new menu item whose child is a GTK_LABEL.
		require
			a_label_not_void: a_label /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_label)
			make_shared (gtk_menu_item_new_with_label_external (cstr.item))
		ensure
			exists: exists
				-- TODO:
		end

feature {ANY} -- Basic Operations

	set_submenu (a_submenu: GTK_MENU) is
			-- Makes `a_sub_menu' the sub menu of `Current'
		require
			a_submenu_not_void: a_submenu /= Void
		do
			gtk_menu_item_set_submenu_external (item, a_submenu.item)
		ensure
			-- TODO:
		end

end
