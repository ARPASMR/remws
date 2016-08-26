indexing

	description:

		"A drop down menu widget"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/22 13:42:41 $"
	revision: "$Revision: 1.1 $"

class GTK_MENU

inherit

	GTK_MENU_SHELL

	GTKMENU_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make

feature {NONE} -- Initialization

	make is
			-- Creates a new GTK_MENU object
		do
			make_shared (gtk_menu_new_external)
		ensure
			exists: exists
		end

feature {ANY} -- Basic Operations


	popup (a_button: INTEGER;
		   a_activate_time: INTEGER) is
			-- Displays a menu and makes it available for selection
			-- Applications can use this function to display context-sensitive
			-- menus. The default menu positioning function will position the menu
			-- at the current mouse cursor position.
			--
			-- `a_button' should be the mouse button pressed to initiate the menu popup.
			-- If the menu popup was initiated by somethign other than a mouse button press,
			-- such as a mousebutton release or a keypass, `a_button' should be `0'.
			--
			-- `a_activate_time'  should be the time stamp of the event that initiated the popup.
			-- If such an event is not available, use `GTK_MAIN.current_event_time' instead.
		do
			gtk_menu_popup_external (item, Default_pointer, Default_pointer, Default_pointer, Default_pointer,
									 a_button, a_activate_time)
		end
	
feature {ANY} -- Signals

end
