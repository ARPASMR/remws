indexing

	description:

		"GTK+ 2 example demostrating the use of scale"

	copyright: "Copyright (c) 2004, Paolo Redaelli"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/05/05 20:46:56 $"
	revision: "$Revision: 1.3 $"

class GTK_SCALE_DEMO

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
	hscale: GTK_HSCALE
	vscale: GTK_VSCALE
	label: GTK_LABEL
	adjustment: GTK_ADJUSTMENT

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

			create adjustment.make(8.5, -- value
										  1.0, -- min
										  11.0, -- max
										  0.5, -- step
										  5.0, -- page
										  6.0 -- pagesize
										  )
			create hscale.make(adjustment)
			create vscale.make_with_range(0.5, 11.0, 0.5)
			create label.make (adjustment.value.out)
			hscale.show
			vscale.show
			label.show
			create vbox.make (2)
			vbox.pack_start (hscale,True,True,10)
			vbox.pack_start (label,True,True,10)
			vbox.show
			create hbox.make (2)
			hbox.pack_start (vscale,True,True,10)
			hbox.pack_start(vbox,True,True,10)
			hbox.show

			window.add(hbox)
			window.show
			-- Connect "clicked" signals of the buttons to callbacks
			-- push_button.connect_clicked_signal_receiver_agent (agent on_push_clicked (?))
			-- pop_button.connect_clicked_signal_receiver_agent (agent on_pop_clicked (?))
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

	window_title: STRING is "Eiffel GTK scales demo"
	
end
