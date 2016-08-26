indexing

	description:

		"GTK+ 2 example hello world application using paned container"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/05/08 20:21:44 $"
	revision: "$Revision: 1.3 $"

class GTK_PANED_DEMO

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
			button1,button2,quitbutton: GTK_BUTTON
			vpaned: GTK_VPANED
			hpaned: GTK_HPANED
		do
			gtk_main.set_locale
			gtk_main.initialize_toolkit
			if not gtk_main.is_toolkit_initialized then
				print ("Unable to init GTK%N")
				Exceptions.die (1)
			end

			create window.make_top_level
			create vpaned.make
			create hpaned.make
			create button1.make_with_label (button_1_string)
			create button2.make_with_label (button_2_string)
			create quitbutton.make_with_label (quit_button_string)

			vpaned.add_first (button1)
			vpaned.add_second(quitbutton)
			hpaned.add_first (button2)
			hpaned.add_second(vpaned)
			window.add (hpaned)

				check
					correct_first_and_second_implementation:
					((vpaned.first_child  = button1) and
					 (vpaned.second_child = quitbutton) and
					 (hpaned.first_child  = button2) and
					 (hpaned.second_child = vpaned))
				end

			if ((vpaned.first_child  = button1) and
				 (vpaned.second_child = quitbutton) and
				 (hpaned.first_child  = button2) and
				 (hpaned.second_child = vpaned))
			then
				print ("Implementation of first_child and second_child is correct. Nice%N")
			else
				print ("Implementation of first_child and second_child is NOT correct! Shame on Tybor!%N")
			end

			button1.connect_clicked_signal_receiver_agent (agent on_clicked (button_1_string, ?))
			button2.connect_clicked_signal_receiver_agent (agent on_clicked (button_2_string, ?))
			quitbutton.connect_clicked_signal_receiver_agent (agent on_quit)

			window.set_title (window_title_string)
			window.connect_delete_event_signal_receiver_agent (agent on_delete)
			window.set_border_width (10)

			button1.show
			button2.show
			quitbutton.show
			vpaned.show
			hpaned.show
			Window.show

			gtk_main.run_main_loop -- Run the GTK main loop
		end

feature -- Agents
	
	on_clicked (a_message: STRING; a_button: GTK_BUTTON) is
		require a_message_not_void: a_message /= Void
		do
			print (a_message + " pressed%N")
		end

	on_delete (a_gtk_object: GTK_WIDGET): BOOLEAN is
		do
			gtk_main.quit_main_loop
		end

	on_quit (a_gtk_object: GTK_BUTTON) is
		do
			gtk_main.quit_main_loop
		end

feature -- Constants

	window_title_string: STRING is "Paned demo"
			-- Title for top level window

	button_1_string: STRING is "Button 1"
			-- Text for 1st button

	button_2_string: STRING is "Button 2"
			-- Text for 2st button

	quit_button_string: STRING is "Quit"
			-- Text for 'Quit' button

end
