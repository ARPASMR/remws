indexing

	description:

		"GTK+ 2 example hello world application using table container"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:46 $"
	revision: "$Revision: 1.3 $"

class GTK_TABLE_DEMO

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
			button: GTK_BUTTON
			table: GTK_TABLE

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

				-- Set a window title for the top level window
			window.set_title (window_title_string)

				-- Connect `on_delete' to signal 'delete_event' of widget `window'
			window.connect_delete_event_signal_receiver_agent (agent on_delete)

				-- Set the border width of our new window to 20
			window.set_border_width (20)

				-- Create a frame without a label
			create table.make_homogenous (2, 2)

				-- Add the frame as single child to the window
			window.add (table)

				-- Create first button
			create button.make_with_label (button_1_string)

				-- Connect signal receiver to 1st button
			button.connect_clicked_signal_receiver_agent (agent on_clicked (button_1_string, ?))

				-- Insert button 1 into the upper left quadrant of the table
			table.attach_defaults (button, 0, 1, 0, 1)

				-- Show 1st button
			button.show

				-- Create 2nd button
			create button.make_with_label (button_2_string)

				-- Connect signal receiver to 2st button
			button.connect_clicked_signal_receiver_agent (agent on_clicked (button_2_string, ?))

				-- Insert button 1 into the upper right quadrant of the table
			table.attach_defaults (button, 1, 2, 0, 1)

				-- Show 2st button
			button.show

				-- Create 'Quit' button
			create button.make_with_label (quit_button_string)

				-- Connect signal receiver to 'Quit' button
			button.connect_clicked_signal_receiver_agent (agent on_quit)

				-- Insert 'Quit' button into the both lower
				-- quadrants of the table
			table.attach_defaults (button, 0, 2, 1, 2)

				-- Show 'Quit' button
			button.show

				-- Show the table
			table.show

				-- Show the window
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Agents

	on_clicked (a_message: STRING; a_button: GTK_BUTTON) is
		require
			a_message_not_void: a_message /= Void
		do
			print (a_message + " pressed%N")
		end

	on_delete (a_gtk_object: GTK_WIDGET): BOOLEAN is
		do
			gtk_main.quit_main_loop
		end

	on_quit (a_gtk_object: GTK_BUTTON) is
		do
			gtk_main.quit_main_loop
		end

feature -- Constants

	window_title_string: STRING is "Table"
			-- Title for top level window

	button_1_string: STRING is "Button 1"
			-- Text for 1st button

	button_2_string: STRING is "Button 2"
			-- Text for 2st button

	quit_button_string: STRING is "Quit"
			-- Text for 'Quit' button

end
