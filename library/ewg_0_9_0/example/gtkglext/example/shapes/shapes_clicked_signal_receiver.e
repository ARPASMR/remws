indexing

	description:

		"GTK+ 2 example clicked signal receiver"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:23:39 $"
	revision: "$Revision: 1.1 $"

class SHAPES_CLICKED_SIGNAL_RECEIVER

inherit

	GTK_CLICKED_SIGNAL_RECEIVER
		rename
			make as make_gtk_clicked_signal_receiver
		end
		
creation

	make
	
feature {NONE} -- Initialization

	make (a_window: GTK_WINDOW) is
		require
			a_window_not_void: a_window /= Void
		do
			window := a_window
			make_gtk_clicked_signal_receiver
		ensure
			window_set: window = a_window
		end

	
feature {NONE}

	window: GTK_WINDOW
	
	on_clicked (a_button: GTK_BUTTON) is
		do
			print ("Hello World%N")
			window.destroy
		end

invariant

	window_not_void: window /= Void

end
