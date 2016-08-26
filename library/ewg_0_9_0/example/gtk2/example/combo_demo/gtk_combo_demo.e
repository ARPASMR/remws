indexing

	description:

		"GTK+ 2 example demostrating the use of combo widget"

	copyright: "Copyright (c) 2003, Andreas Leitner, Paolo Redaelli and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/04/03 20:09:01 $"
	revision: "$Revision: 1.3 $"

class GTK_COMBO_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

creation	make

feature -- GUI
	
	window: GTK_WINDOW
	
	hbox: GTK_HBOX
	
	label: GTK_LABEL
	
	combo: GTK_TEXT_COMBO_BOX

feature -- Initialisation
	make is
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
			window.set_border_width (10)

			create label.make(preferred_developer_string)
			label.show

			create combo.make_text
			combo.append_text("Andreas")
			combo.append_text("Paolo")
			combo.append_text("Another")
			combo.show

			create hbox.make(3)
			hbox.pack_start(label,True,True,1)
			hbox.pack_start(combo,True,True,1)
			hbox.show

			window.add (hbox)
			window.show

			gtk_main.run_main_loop
		end

feature -- Agents
	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("on destroy has been called. Combo selected value: n.")
			print (combo.active.out)
			print ("%N")
			gtk_main.quit_main_loop
		end

feature -- Constants

	window_title: STRING is "GTK Combo demo!"
			-- Text top level window title

	preferred_developer_string: STRING is "Preferred developer"
	
end
