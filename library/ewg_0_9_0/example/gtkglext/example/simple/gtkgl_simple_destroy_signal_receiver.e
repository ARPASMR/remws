indexing

	description:

		"GTKGL example clicked signal receiver"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:23:39 $"
	revision: "$Revision: 1.1 $"

class GTKGL_SIMPLE_DESTROY_SIGNAL_RECEIVER

inherit

	GTK_DESTROY_SIGNAL_RECEIVER
		
	GTK_SHARED_MAIN
		export {NONE} all end
	
creation

	make
	
feature {NONE}

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			print ("Received the 'destroy' signal%N")
				-- Quit the application
				-- If we would not do that, only
				-- `a_object' would be destroyed
				-- but the main loop would continue
				-- running.
			gtk_main.quit_main_loop
		end

end
