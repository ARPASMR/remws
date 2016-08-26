indexing

	description:

		"GTK+ 2 example demonstrating GTK_PROGRESS_BAR"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:08 $"
	revision: "$Revision: 1.3 $"

class GTK_PROGRESS_BAR_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

	GTK_ATTACH_OPTIONS_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_attach_options_enum
		export
			{NONE} all
		end

	GTK_WIDGET_FLAGS_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_widget_flags_enum
		export
			{NONE} all
		end

	GTK_PROGRESS_BAR_ORIENTATION_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_progress_bar_orientation_enum
		export
			{NONE} all
		end

creation

	make

feature -- Initialisation

	make is
		local
			vbox: GTK_VBOX
			alignment: GTK_ALIGNMENT
			hseparator: GTK_HSEPARATOR
			table: GTK_TABLE
			button: GTK_BUTTON
			check_button: GTK_CHECK_BUTTON
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

				-- Connect `on_destroy' to signal 'destroy' of widget `window'
			window.connect_destroy_signal_receiver_agent (agent on_destroy)

				-- Set the border width of our new window to 0
			window.set_border_width (0)

				-- Make `window' resizable
			window.set_resizable (True)

				-- Create a timer
			create timeout.make (100)
			timeout.set_timeout_receiver_agent (agent on_timeout)
			timeout.attach_to_default_context

				-- Create a vbox
			create vbox.make (5)
			vbox.set_border_width (10)
			window.add (vbox)
			vbox.show

				 -- Create an alignment widget to
				 -- center the progress bar
			create alignment.make (0.5, 0.5, 0.0, 0.0)
			vbox.pack_start (alignment, False, False, 5)
			alignment.show

				-- Ladies and gentlemen, the progressbar
			create progress_bar.make
			alignment.add (progress_bar)
			progress_bar.show

				 -- A little bit of visual distance between the
				 -- progress bar and the buttons
			create hseparator.make
			vbox.pack_start (hseparator, False, False, 0)
			hseparator.show

				-- A table to put the buttons in
			create table.make (2, 3)
			vbox.pack_start (table, False, True, 0)
			table.show

			create check_button.make_with_label ("Show text")
			table.attach (check_button, 0, 1, 0, 1, gtk_expand.bit_or (gtk_fill), gtk_expand.bit_or (gtk_fill),
							  5, 5)
			check_button.connect_clicked_signal_receiver_agent (agent toggle_show_text)
			check_button.show

			create check_button.make_with_label ("Activity mode")
			table.attach (check_button, 0, 1, 1, 2, gtk_expand.bit_or (gtk_fill), gtk_expand.bit_or (gtk_fill),
							  5, 5)
			check_button.connect_clicked_signal_receiver_agent (agent toggle_activity_mode)
			check_button.show

			create check_button.make_with_label ("Right to Left")
			table.attach (check_button, 0, 1, 2, 3, gtk_expand.bit_or (gtk_fill), gtk_expand.bit_or (gtk_fill),
							  5, 5)
			check_button.connect_clicked_signal_receiver_agent (agent toggle_orientation)
			check_button.show

			create button.make_with_label ("close")
			button.connect_clicked_signal_receiver_agent (agent on_close)
			vbox.pack_start (button, False, False, 0)
			button.set_flags (Gtk_Can_default)
			button.grab_default
			button.show

				-- Show the window
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Agents

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			timeout.detatch
			gtk_main.quit_main_loop
		end

	on_close (a_button: GTK_BUTTON) is
		do
			window.destroy
		end

	toggle_show_text (a_button: GTK_BUTTON) is
			-- Enables/disabled text
		do
			if progress_bar.has_text then
				progress_bar.remove_text
			else
				progress_bar.set_text ("some text")
			end
		end

	toggle_activity_mode (a_button: GTK_BUTTON) is
			-- Toggles between progress and activity mode
		do
			if activity_mode then
				activity_mode := False
				progress_bar.set_fraction (0.0)
			else
				activity_mode := True
				progress_bar.pulse
			end
		end

	toggle_orientation (a_button: GTK_BUTTON) is
			-- Toogle the orientation of the progress bar
		do
			if progress_bar.orientation = gtk_progress_left_to_right then
				progress_bar.set_orientation (gtk_progress_right_to_left)
			else
				progress_bar.set_orientation (gtk_progress_left_to_right)
			end
		end

	on_timeout: BOOLEAN is
			-- Called repeatedly.
			-- We use this to drive the "progress" of
			-- the progress bar.
		local
			new_value: DOUBLE
		do
			if activity_mode then
				progress_bar.pulse
			else
				new_value := progress_bar.fraction + 0.01
				if (new_value > 1.0) then
					new_value := 0.0
				end
				progress_bar.set_fraction (new_value)
			end

				-- As this is a timeout agent, return `True' so that
				-- it continues to get called
			Result := True
		end

feature

	activity_mode: BOOLEAN
			-- If `True' then the progressbar will bounce
			-- from one end to the other. If `False' a
			-- traditional progress bar will be shown

	window: GTK_WINDOW
			-- Top level window

	progress_bar: GTK_PROGRESS_BAR
			-- Widget that displays the progress
			-- of some task (we really only have a fake task in
			-- this example)

	timeout: G_TIMEOUT_SOURCE
			-- timer that will drive the "progress" of the
			-- progress bar

feature -- Constants

	window_title_string: STRING is "GtkProgressBar"
			-- Title for top level window

end
