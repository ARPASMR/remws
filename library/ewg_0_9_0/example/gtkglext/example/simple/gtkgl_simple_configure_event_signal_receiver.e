indexing

	description:

		"GTKGL2 example expose event signal receiver"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:23:39 $"
	revision: "$Revision: 1.1 $"

class GTKGL_SIMPLE_CONFIGURE_EVENT_SIGNAL_RECEIVER

inherit

	GTK_CONFIGURE_EVENT_SIGNAL_RECEIVER
		rename
			make as make_gtk_expose_event_signal_receiver
		end
		
	GL_FUNCTIONS
		export
			{NONE} all
		end

	GLU_FUNCTIONS
		export
			{NONE} all
		end

	EWG_OPENGL_CONSTANTS_FUNCTIONS
		export
			{NONE} all
		end

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export {NONE} all end
		
creation

	make
	
feature {NONE} -- Initialization

	make (a_gl_widget: like gl_widget) is
		require
			a_gl_widget_not_void: a_gl_widget /= Void
		do
			gl_widget := a_gl_widget
			make_gtk_expose_event_signal_receiver
		ensure
			gl_widget_set: gl_widget = a_gl_widget
		end

	
feature {NONE}

	gl_widget: GTKGL_WIDGET
	
	on_configure_event (a_widget: GTK_WIDGET; a_event: GDK_CONFIGURE_EVENT): BOOLEAN is
			-- Called when we need to redraw the drawing area
		do
			io.put_string ("Configure%N")
			if gl_widget.gl_begin and a_event /= Void then
				gl_viewport (0, 0, a_widget.allocation.width, a_widget.allocation.height)
				gl_widget.gl_end
			end
		end
	
invariant

	gl_widget_not_void: gl_widget /= Void

end
