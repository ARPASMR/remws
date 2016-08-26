indexing

	description:

		"GTK+ 2 example demostrating the use of entries"

	copyright: "Copyright (c) 2004, Paolo Redaelli"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/05/04 20:25:54 $"
	revision: "$Revision: 1.5 $"

class GTK_ENTRIES_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

creation	make

feature -- GUI elements
	window: GTK_WINDOW
	hbox: GTK_HBOX
	vbox: GTK_VBOX
	label: GTK_LABEL
	entry: DEMO_ENTRY

	--spinbutton: GTK_SPIN_BUTTON
feature make is
		do
			gtk_main.set_locale
			gtk_main.initialize_toolkit
			if not gtk_main.is_toolkit_initialized then
				print ("Unable to init GTK%N")
				Exceptions.die (1)
			end

			create window.make_top_level
			window.set_title (window_title)
			window.connect_destroy_signal_receiver_agent (agent on_destroy)

			create label.make(label_string)
			label.show
			create entry.make
			entry.show
			-- create spinbutton.make_with_range(0.5,11.0,0.5)
			-- spinbutton.set_digits(1)
			-- spinbutton.show
			create hbox.make(2)
			hbox.pack_start(label,True,True,10)
			hbox.pack_start(entry,True,True,10)
			-- hbox.pack_start(spinbutton,True,True,10)
			hbox.show

			window.add(hbox)
			window.show

			-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Agents
	
	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("on destroy has been called%N")
			print ("Demo entry: ")
			print (entry.out) print ("'%N")

			--print("' spin value is:") print (spinbutton.value) print("%N")
			gtk_main.quit_main_loop
		end
	
feature -- Constants
	
	window_title: STRING is "Eiffel GTK entry demo"

	label_string: STRING is "An entry:"
end
