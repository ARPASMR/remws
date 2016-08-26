indexing

	description:

		"GTK+ 2 example hello world application using expander container"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/03/06 13:25:56 $"
	revision: "$Revision: 1.4 $"

class GTK_EXPANDER_DEMO

inherit

	GTK_SHARED_MAIN
		-- NOTE: inheriting privately GTK_SHARED_MAIN seems to upset SE 
		-- 2.1 (Paolo 2005-03-04)
		-- export {NONE} all end
	
	KL_SHARED_EXCEPTIONS
		export {NONE} all end


		
creation

	make
	
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
			create expander.make(expander_title)
			create button.make_with_label (quit_button_string)
			
			expander.add(button)
			expander.connect_activate_signal_receiver_agent (agent on_activate)
			window.add (expander)
			
			button.connect_clicked_signal_receiver_agent (agent on_quit)
			
			window.set_title (window_title_string)
			window.connect_delete_event_signal_receiver_agent (agent on_delete)
			window.set_border_width (10)

			button.show
			expander.show
			window.show
			
			gtk_main.run_main_loop -- Run the GTK main loop
		end

feature -- Widgets
	
	window: GTK_WINDOW
			-- Main window
	
	expander: GTK_EXPANDER
			-- Expander widget
	
	button: GTK_BUTTON
			-- Quit button contained in the expander
	
feature -- Agents

	on_activate (a_widget: GTK_WIDGET) is
		do
			if expander.is_expanded then
				print ("Expander widget shows its content.%N")
			else 
				print ("Expander widget hides its content.%N")
			end
		end
	
	on_delete (a_gtk_object: GTK_WIDGET): BOOLEAN is
		do 
			gtk_main.quit_main_loop
		end

	on_quit (a_gtk_object: GTK_BUTTON) is
		do
			if expander.is_expanded then
				print ("Expander widget was showing its content.%N")
			else 
				print ("Expander widget was hiding its content.%N")
			end
			
			check
				cliccking_on_quit_requires_expanded_expander: expander.is_expanded
			end
			gtk_main.quit_main_loop
		end

feature -- Constants
	
	window_title_string: STRING is "Expander demo"
	
	expander_title: STRING is "An expander"
	
	quit_button_string: STRING is "Quit"
end
