indexing

	description:

		"GTKGL2 example configure event signal receiver"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/07/23 18:51:02 $"
	revision: "$Revision: 1.1 $"

class SHAPES_CONFIGURE_EVENT_SIGNAL_RECEIVER

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

	make (a_gl_widget: like gl_widget; the_arcball: TRACKBALL) is
		require
			a_gl_widget_not_void: a_gl_widget /= Void
		do
			gl_widget := a_gl_widget
			make_gtk_expose_event_signal_receiver
			arcball := the_arcball
		ensure
			gl_widget_set: gl_widget = a_gl_widget
			arcball_set: arcball = the_arcball
		end

	
feature {NONE}

	gl_widget: GTKGL_WIDGET

	arcball: TRACKBALL

	on_configure_event (a_widget: GTK_WIDGET; a_event: GDK_CONFIGURE_EVENT): BOOLEAN is
			-- Called when we need to redraw the drawing area
		local
			aspect: REAL
		do
			io.put_string ("Configure%N")
			if gl_widget.gl_begin and a_event /= Void then
				gl_viewport (0, 0, a_widget.allocation.width, a_widget.allocation.height)
				gl_matrix_mode (ewg_get_constant_gl_projection)
				gl_load_identity

				if a_widget.allocation.width >  a_widget.allocation.height then
					aspect := (a_widget.allocation.width / a_widget.allocation.height).truncated_to_real
					gl_frustum (-aspect, aspect, -1.0, 1.0, 5.0, 60.0)
				else
					aspect := (a_widget.allocation.height / a_widget.allocation.width).truncated_to_real
					gl_frustum (-1.0, 1.0, -aspect, aspect, 5.0, 60.0)
				end

				gl_matrix_mode (ewg_get_constant_gl_modelview)
				gl_widget.gl_end
			end
			
			arcball.set_width (a_widget.allocation.width)
			arcball.set_height (a_widget.allocation.height)
			
			Result := true
		end	
invariant

	gl_widget_not_void: gl_widget /= Void

end
