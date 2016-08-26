indexing

	description:

		"GTK+ 2 example demostrating the use of menus"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:03 $"
	revision: "$Revision: 1.3 $"

class GTK_MENU_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

creation

	make

feature -- Initialisation

	make is
		local
			window: GTK_WINDOW
			menu: GTK_MENU
			menu_bar: GTK_MENU_BAR
			root_menu_item: GTK_MENU_ITEM
			menu_item: GTK_MENU_ITEM
			vbox: GTK_VBOX
			button: GTK_BUTTON
			i: INTEGER
		do
				-- Setup the locale for GTK and GDK according to the programs
				-- environment
			gtk_main.set_locale
				-- Initialize GTK
			gtk_main.initialize_toolkit
				-- If initialization went wrong for some reason,
				-- quit the application
			if not gtk_main.is_toolkit_initialized then
				print ("Unable to init GTK%N")
				Exceptions.die (1)
			end

				-- Create a GTK window toplevel window
			create window.make_top_level
			window.request_size (200, 100)
			window.set_title (window_title)
			window.connect_destroy_signal_receiver_agent (agent on_destroy)


				-- Create the menu widget, and remember:
				-- NEVER `GTK_WIDGET.show' a menu widget
				-- This is the menu that holds the menu items,
				-- the one that will pop up when you click on the
				-- "Root Menu" in the app
			create menu.make

				-- Next we make a little loop that makes three menu entries for
				-- "test-menu". Notice the call to `GTK_MENU.append'. Here we are
				-- adding a list of menu items to our menu. Normally, we'd also catch
				-- the "clicked" signal on each of the menu items and setup a receiver for
				-- it, but it's ommited here to save space.

			from
				i := 1
			until
				i > 3
			loop
				create menu_item.make_with_label (menu_item_text + i.out)
				menu.append (menu_item)
				menu_item.connect_activate_signal_receiver_agent (agent on_activate (menu_item_text + i.out, ?))
				menu_item.show
				i := i + 1
			end

				-- This is the root menu, and will be the label
				-- displayed on the menu bar. There won't be a signal handler
				-- attached, as it only pops up the rest of the menu
				-- when pressed.
			create root_menu_item.make_with_label (root_menu_text)

			root_menu_item.show

				-- Now we specify that we want our newly created "menu" to
				-- be the menu for the 'Root Menu'
			root_menu_item.set_submenu (menu)

				-- A vbox to put a menu and a button in
			create vbox.make (0)
			window.add (vbox)
			vbox.show

				-- Create a menu-bar to hold the menus and add
				-- it to our main window
			create menu_bar.make
			vbox.pack_start (menu_bar, False, False, 2)
			menu_bar.show

				-- Create a button to which to attach menu as a popup
			create button.make_with_label (button_text)
				-- TODO: in the original GTK 2 example, signal 'event' is used
			button.connect_clicked_signal_receiver_agent (agent on_clicked (menu, ?))

			vbox.pack_end (button, True, True, 2)
			button.show

				-- And finally we append the menu-item to the menu-bar
				-- This is the "root" menu-item.
			menu_bar.append (root_menu_item)

				-- Show the window
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Agents

	on_clicked (a_menu: GTK_MENU; a_button: GTK_BUTTON) is
		require
			a_menu_not_void: a_menu /= Void
		do
			a_menu.popup (0, gtk_main.current_event_time)
		end

	on_activate (a_text: STRING; a_widget: GTK_WIDGET) is
		require
			a_text_not_void: a_text /= Void
		do
			print (a_text + "%N")
		end

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("on destroy has been called%N")
			gtk_main.quit_main_loop
		end

feature -- Constants

	window_title: STRING is "GTK Menu Demo"
			-- Text top level window title

	menu_item_text: STRING is "Test-undermenu - "
			-- Text for menu items

	root_menu_text: STRING is "Root Menu"
			-- Text for 'Root Menu'

	button_text: STRING is "press me"
			-- Text for button

end
