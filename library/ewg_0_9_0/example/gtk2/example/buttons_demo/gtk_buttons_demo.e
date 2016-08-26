indexing

	description:

		"GTK+ 2 example demostrating the use of labels"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:03 $"
	revision: "$Revision: 1.3 $"

class GTK_BUTTONS_DEMO

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
			hbox: GTK_HBOX
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
			window.set_title (window_title)

				-- It is a good idea to do this for all windows
			window.connect_destroy_signal_receiver_agent (agent on_destroy)

				-- Sets the border width of the window
			window.set_border_width (10)

				-- Create new button
			create button.make

				-- Connect "clicked" signal of the button to our callback
			button.connect_clicked_signal_receiver_agent (agent on_clicked (?, "cool button"))

				--	This calls our box creating function
			hbox := new_xpm_label_hbox (image_file_name, "cool button");

				--	Pack and show all our widgets
			hbox.show

			button.add (hbox)

			button.show

			window.add (button)

				-- Show the window
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Helper Routines

	new_xpm_label_hbox (a_image_file_name: STRING; a_label_text: STRING): GTK_HBOX is
		require
			a_image_file_name_not_void: a_image_file_name /= Void
			a_label_text_not_void: a_label_text /= Void
		local
			label: GTK_LABEL
			image: GTK_IMAGE
		do
				-- Create box for image and label
			create result.make (0)
			result.set_border_width (2)

				-- Now on to the image stuff
			create image.make_from_file (a_image_file_name)

				-- Create a label for the button
			create label.make (a_label_text)

				-- Pack the image and label into the box
			result.pack_start (image, False, False, 3)
			result.pack_start (label, False, False, 3)

			image.show
			label.show

		ensure
			result_not_void: Result /= Void
		end

feature -- Agents

	on_clicked (a_button: GTK_BUTTON; a_button_name: STRING) is
		require
			a_button_name_not_void: a_button_name /= Void
		do
			print ("Hello again " + a_button_name + " was pressed%N")
		end

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("on destroy has been called%N")
			gtk_main.quit_main_loop
		end

feature -- Constants

	window_title: STRING is "GTK Pixmap'd Buttons!"
			-- Text top level window title

	image_file_name: STRING is "../../../resource/info.xpm"

end
