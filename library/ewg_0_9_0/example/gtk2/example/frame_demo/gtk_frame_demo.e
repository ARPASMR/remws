indexing

	description:

		"GTK+ 2 example hello world application using a frame"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:06 $"
	revision: "$Revision: 1.4 $"

class GTK_FRAME_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

	GTK_SHADOW_TYPE_ENUM_EXTERNAL
		export {NONE} all end

creation

	make

feature -- Initialisation

	make is
		local
			window: GTK_WINDOW
			frame: GTK_FRAME

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

				-- Make the window a bit bigger
			window.request_size (300, 300);

				-- Set the border width of our new window to 10
			window.set_border_width (10)

				-- Create a frame without a label
			create frame.make

				-- Add the frame as single child to the window
			window.add (frame)

				-- Now set a label for the frame
			frame.set_label (frame_label_string)

				-- Align the label at the right of the frame
			frame.set_label_alignment (1.0, 0.0)

				-- Set the style of the frame
			frame.set_shadow_type (gtk_shadow_etched_out)

				-- Show the frame
			frame.show

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

	window_title_string: STRING is "Frame Example"
			-- Title for top level window

	frame_label_string: STRING is "GTK Frame Widget"
			-- Label text for frame

end
