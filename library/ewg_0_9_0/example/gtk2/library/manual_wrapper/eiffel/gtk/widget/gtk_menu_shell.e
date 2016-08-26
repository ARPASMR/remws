indexing

	description:

		"A base class for menu objects"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/22 13:42:41 $"
	revision: "$Revision: 1.1 $"

class GTK_MENU_SHELL

inherit

	GTK_CONTAINER

	GTKMENUSHELL_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

feature {ANY} -- Basic Operations

	append (a_child: GTK_MENU_ITEM) is
			-- Adds a new menu item.
		require
			a_child_not_void: a_child /= Void
		do
			gtk_menu_shell_append_external (item, a_child.item)
		ensure
			-- TODO:
		end

end
