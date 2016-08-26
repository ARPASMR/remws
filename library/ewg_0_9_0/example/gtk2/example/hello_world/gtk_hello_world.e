indexing

	description:

		"GTK+ 2 example hello world application"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:46 $"
	revision: "$Revision: 1.2 $"

class GTK_HELLO_WORLD

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

				-- Create a signal receiver for the 'destroy' signal
			create destroy_event_signal_receiver.make

				-- Connect signal receiver to `window'
			window.connect_destroy_signal_receiver (destroy_event_signal_receiver)

				-- Set the border width of our new window to 10
			window.set_border_width (10)

				-- Create a GTK button with a text
			create button.make_with_label (hello_world_string)

				-- Create a signal receiver for the 'clicked' signal
				-- This receiver when called will destroy
				-- `window'. Thats why we need to pass it here.
			create clicked_signal_receiver.make (window)

				-- Connect the signal receiver to the button
				-- This means that everytime `button' emits
				-- a 'clicked' signal, `clicked_signal_receiver.on_clicked' will be called
			button.connect_clicked_signal_receiver (clicked_signal_receiver)

				-- Add the GTK button to the GTK window
			window.add (button)

				-- Show the button
			button.show

				-- Show the window
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Attributes

	window: GTK_WINDOW
			-- Wrapper for GTK window

	button: GTK_BUTTON
			-- Wrapper for GTK button

	clicked_signal_receiver: GTK_HELLO_WORLD_CLICKED_SIGNAL_RECEIVER
			-- Receiver for 'clicked' signal

	destroy_event_signal_receiver: GTK_HELLO_WORLD_DESTROY_SIGNAL_RECEIVER
			-- Receiver for 'destroy' signal

feature -- Constants

	hello_world_string: STRING is "Hello World"
			-- Text for the GTK button

end
