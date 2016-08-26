indexing

	description:

		"GTK+ 2 example demostrating the use of labels"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:07 $"
	revision: "$Revision: 1.3 $"

class GTK_LABEL_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

	GTK_JUSTIFICATION_ENUM_EXTERNAL
		export {NONE} all end

creation

	make

feature -- Initialisation

	make is
		local
			window: GTK_WINDOW
			hbox: GTK_HBOX
			vbox: GTK_VBOX
			label: GTK_LABEL
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
			window.set_title (window_title)
			window.connect_destroy_signal_receiver_agent (agent on_destroy)

				-- Create vbox and hbox
			create vbox.make (5);
			create hbox.make (5);

				-- The hbox will divide the window horizontally in two panes
			window.add (hbox);
			hbox.pack_start (vbox, False, False, 0)
			window.set_border_width (5);

				-- Add ordinary label
			create frame.make_with_label ("Normal Label")
			create label.make ("This is a normal label")
			frame.add (label)
			vbox.pack_start (frame, False, False, 0)

				-- Add multi-line label
			create frame.make_with_label ("Multi-line Label")
			create label.make ("This is a Multi-line label.%NSecond line%NThird Line")
			frame.add (label)
			vbox.pack_start (frame, False, False, 0)

				-- Add left-justified label
			create frame.make_with_label ("Left Justified Label")
			create label.make ("This is a Left-Justified%NMulti-line label.%NThird line, (j,k)")
			label.set_justify (Gtk_justify_left)
			frame.add (label)
			vbox.pack_start (frame, False, False, 0)

				-- Add right-justified label
			create frame.make_with_label ("Right Justified Label")
			create label.make ("This is a Right-Justified%NMulti-line label.%NThird line, (j,k)")
			label.set_justify (Gtk_justify_right)
			frame.add (label)
			vbox.pack_start (frame, False, False, 0)

				-- Add line-wrapped label
			create vbox.make (5)
			hbox.pack_start (vbox, False, False, 0)
			create frame.make_with_label ("Line wrapped label")
			create label.make ("This is an example of a line-wrapped label. It " +
								"should not be taking up the entire             " +
																-- big space to test spacing
								"width allocated to it, but automatically " +
								"wraps the words to fit.  " +
								"The time has come, for all good men, to come to " +
								"the aid of their party.  " +
								"The sixth sheik's six sheep's sick.%N" +
								"     It supports multiple paragraphs correctly, " +
								"and  correctly   adds " +
								"many          extra  spaces. ")

			label.enable_line_wrap
			frame.add (label)
			vbox.pack_start (frame, False, False, 0)

				-- Add filled and line-wrapped label
			create frame.make_with_label ("Filled, wrapped label")
			create label.make ("This is an example of a line-wrapped, filled label.  " +
								"It should be taking " +
								"up the entire              width allocated to it.  " +
								"Here is a sentence to prove " +
								"my point.  Here is another sentence. " +
								"Here comes the sun, do de do de do.%N" +
								"    This is a new paragraph.%N" +
								"    This is another newer, longer, better "  +
								"paragraph.  It is coming to an end, " +
								"unfortunately.")

			label.set_justify (Gtk_justify_fill)
			label.enable_line_wrap
			frame.add (label)
			vbox.pack_start (frame, False, False, 0)


				-- Add label whith underlined text
			create frame.make_with_label ("Underlined label")
			create label.make ("This label is underlined!%N" +
								"This one is underlined in quite a funky fashion")

			label.set_justify (Gtk_justify_left)
			label.set_pattern ("_________________________ _ _________ _ ______     __ _______ ___")
			frame.add (label)
			vbox.pack_start (frame, False, False, 0)

				-- Show the window
			window.show_all

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Agents

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("on destroy has been called%N")
			gtk_main.quit_main_loop
		end

feature -- Constants

	window_title: STRING is "GTK Label Demo"
			-- Text top level window title

end
