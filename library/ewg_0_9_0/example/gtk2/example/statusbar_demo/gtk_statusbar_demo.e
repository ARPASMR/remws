indexing

	description:

		"GTK+ 2 example demostrating the use of labels"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:46 $"
	revision: "$Revision: 1.2 $"

class GTK_STATUSBAR_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

creation

	make

feature -- GUI elements
	window: GTK_WINDOW
	hbox: GTK_HBOX
	vbox: GTK_VBOX
	push_button,pop_button: GTK_BUTTON
	statusbar: GTK_STATUSBAR

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
			create push_button.make_with_label ("Push a message")
			create pop_button.make_with_label ("Pop last message")
			create statusbar.new
			statusbar.push (once "Startup message")
			create vbox.make(5)
			create hbox.make(5)
			-- Connect "clicked" signals of the buttons to callbacks
			push_button.connect_clicked_signal_receiver_agent (agent on_push_clicked (?))
			pop_button.connect_clicked_signal_receiver_agent (agent on_pop_clicked (?))
			--	Pack and show all our widgets
			push_button.show; pop_button.show
			hbox.pack_start(push_button,True,True,10)
			hbox.pack_start(pop_button,True,True,10)
			hbox.show
			vbox.pack_start(hbox,True,True,0)
			statusbar.show
			vbox.pack_start(statusbar,True,True,0)
			vbox.show
			window.add(vbox)
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature counter: INTEGER
feature -- Agents

	on_push_clicked (a_button: GTK_BUTTON) is
		do
			counter:=counter+1
			print ("Pushing message n."+counter.out+"%N")
			statusbar.push(once "This is message number "+counter.out)
		end
	on_pop_clicked (a_button: GTK_BUTTON) is
		do
			if statusbar.is_empty then
				print ("Statusbar empty: cannot pop any message%N")
			else
				print ("Popping last message%N")
				statusbar.pop
			end
		end

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("on destroy has been called%N")
			gtk_main.quit_main_loop
		end

feature -- Constants
	window_title: STRING is "Eiffel GTK Staturbar demo"
end
