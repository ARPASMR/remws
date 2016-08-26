indexing

	description:

		"GTK+ 2 example hello world application using agents"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:06 $"
	revision: "$Revision: 1.2 $"

class GTK_HELLO_WORLD_AGENT

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

				-- Connect `on_destroy' to signal 'destroy' of widget `window'
			window.connect_destroy_signal_receiver_agent (agent on_destroy)

				-- Set the border width of our new window to 10
			window.set_border_width (10)

				-- Create a GTK button with a text
			create button.make_with_label (hello_world_string)

				-- Connect `on_clicked' to signal 'destroy' of button `button'
			button.connect_clicked_signal_receiver_agent (agent on_clicked)

				-- Add the GTK button to the GTK window
			window.add (button)

				-- Show the button
			button.show

				-- Show the window
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Agents

	on_clicked (a_button: GTK_BUTTON) is
		do
			print ("Hello World%N")
			window.destroy
		end

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("on destroy has been called%N")
			gtk_main.quit_main_loop
		end

feature -- Attributes

	window: GTK_WINDOW
			-- Wrapper for GTK window

	button: GTK_BUTTON
			-- Wrapper for GTK button

feature -- Constants

	hello_world_string: STRING is "Hello World"
			-- Text for the GTK button

end
