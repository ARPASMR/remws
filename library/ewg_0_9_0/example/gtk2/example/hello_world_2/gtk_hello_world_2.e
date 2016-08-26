indexing

	description:

		"GTK+ 2 example hello world application using hbox"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:07 $"
	revision: "$Revision: 1.2 $"

class GTK_HELLO_WORLD_2

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
			box: GTK_HBOX

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

				-- Connect `on_delete' to signal 'delete_event' of widget `window'
			window.connect_delete_event_signal_receiver_agent (agent on_delete)

				-- Set the border width of our new window to 10
			window.set_border_width (10)

				-- Create a horizontal box 10 pixels of space between children
				-- A box is a special container that can have more than
				-- one child widget
			create box.make (10)

				-- Add the box as single child to the window
			window.add (box)

				-- Create frist button
			create button.make_with_label (button_1_string)

				-- Connect `on_clicked' to signal 'destroy' of button `button'
			button.connect_clicked_signal_receiver_agent (agent on_clicked (message_1_string, ?))

				-- Add the first button to the box
			box.pack_start (button, True, True, 0)

				-- Show the button
			button.show

				-- Create a second button
			create button.make_with_label (button_2_string)

				-- Connect `on_clicked' to signal 'destroy' of button `button'
			button.connect_clicked_signal_receiver_agent (agent on_clicked (message_2_string, ?))

				-- Add the second button to the box
			box.pack_start (button, True, True, 0)

				-- Show the second button
			button.show

				-- Show the box
			box.show

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
			print (a_message)
		end

	on_delete (a_gtk_object: GTK_WIDGET): BOOLEAN is
		do
			gtk_main.quit_main_loop
		end

feature -- Constants

	button_1_string: STRING is "Button 1"
			-- Label for the first button

	button_2_string: STRING is "Button 2"
			-- Label for the second button

	message_1_string: STRING is "Button 1 has been clicked%N"
			-- Message to print when clicking button 1

	message_2_string: STRING is "Button 2 has been clicked%N"
			-- Message to print when clicking button 2

end
