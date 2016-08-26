indexing

	description:

		"GTK+ 2 example demostrating the use of labels"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/05/08 20:21:44 $"
	revision: "$Revision: 1.3 $"

class GTK_TOOLTIPS_DEMO

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
			tips: GTK_TOOLTIPS
			window: GTK_WINDOW
			hbox: GTK_HBOX
			label: GTK_LABEL
			button: GTK_BUTTON
		do
			gtk_main.set_locale
			gtk_main.initialize_toolkit
			if not gtk_main.is_toolkit_initialized then
				print ("Unable to init GTK%N")
				Exceptions.die (1)
			end
			create hbox.make (2)
			create tips.make
			create window.make_top_level
			window.set_title (window_title)
			window.connect_destroy_signal_receiver_agent (agent on_destroy)

			-- Add ordinary label
			create label.make ("A label")
			create button.make_with_label ("Foo! A button")
			tips.set_tooltip (button,
									"A brief tip for a button",
									"A longer explanation for a button")
			tips.set_tooltip (label,
									"A brief tip for a label",
									"A longer explanation for a label")
			tips.enable
			window.add (hbox)
			hbox.pack_start(label, True,True,0)
			hbox.pack_start(button, True,True,0)

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
	window_title: STRING is "GTK Tooltips Demo"
			-- Text top level window title

end
