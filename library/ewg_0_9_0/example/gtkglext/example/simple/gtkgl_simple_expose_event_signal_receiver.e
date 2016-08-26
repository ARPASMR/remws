indexing

	description:

		"GTKGL2 example expose event signal receiver"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:23:39 $"
	revision: "$Revision: 1.1 $"

class GTKGL_SIMPLE_EXPOSE_EVENT_SIGNAL_RECEIVER

inherit

	GTK_EXPOSE_EVENT_SIGNAL_RECEIVER
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

	EWG_OPENGLU_CONSTANTS_FUNCTIONS
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
			has_been_exposed := True
		ensure
			gl_widget_set: gl_widget = a_gl_widget
		end

	
feature {NONE}

	gl_widget: GTKGL_WIDGET
	
	on_expose_event (a_widget: GTK_WIDGET; a_event: GDK_EXPOSE_EVENT): BOOLEAN is
			-- Called when we need to redraw the drawing area
		local
			--			pt: ARRAY [REAL]
			--			color: ARRAY [REAL]
			--			p: EXTERNAL_POINTER [REAL]
			pt: EWG_REAL_ARRAY
			color: EWG_REAL_ARRAY
			quadric: POINTER
		do
			io.put_string ("Expose%N")
			
			if gl_widget.gl_begin then
				
				if has_been_exposed then
					--					color := <<1.0, 0.0, 0.0, 1.0>>
					create color.make_new_unshared (4)
					color.put (1.0, 0)
					color.put (0.0, 1)
					color.put (0.0, 2)
					color.put (1.0, 3)
					--					pt := <<1.0, 1.0, 1.0, 0.0>>
					create pt.make_new_unshared (4)
					pt.put (1.0, 0)
					pt.put (1.0, 1)
					pt.put (1.0, 2)
					pt.put (0.0, 3)
					
					gl_lightfv (ewg_get_constant_gl_light0, ewg_get_constant_gl_position, pt.array_address)
					gl_lightfv (ewg_get_constant_gl_light0, ewg_get_constant_gl_diffuse, color.array_address)
					gl_enable (ewg_get_constant_gl_lighting)
					gl_enable (ewg_get_constant_gl_light0)
					gl_enable (ewg_get_constant_gl_depth_test)
					
					gl_clear_color (1.0, 1.0, 1.0, 1.0)
					gl_clear_depth (1.0)
					
					gl_matrix_mode (ewg_get_constant_gl_projection)
					gl_load_identity
					glu_perspective (40, 1, 1, 10)
					
					gl_matrix_mode (ewg_get_constant_gl_modelview)
					gl_load_identity
					glu_look_at (0.0, 0.0, 3.0,
							 0.0, 0.0, 0.0,
							 0.0, 1.0, 0.0)
					gl_translated (0.0, 0.0, -3.0)

					
					gl_clear (EXTERNAL_MEMORY_.bitwise_integer_or_external (ewg_get_constant_gl_color_buffer_bit,
																							  ewg_get_constant_gl_depth_buffer_bit))

					quadric := glu_new_quadric
					glu_quadric_draw_style (quadric, ewg_get_constant_glu_fill)
					gl_new_list (1, ewg_get_constant_gl_compile)
					glu_sphere (quadric, 1.0, 20, 20)
					gl_end_list
					
					has_been_exposed := false
				end
				
				gl_clear (EXTERNAL_MEMORY_.bitwise_integer_or_external (ewg_get_constant_gl_color_buffer_bit,
																						  ewg_get_constant_gl_depth_buffer_bit))
				gl_call_list (1)
				
				if gl_widget.config.is_double_buffered then
					gl_widget.swap_buffers
				else
					gl_flush
				end
				
				gl_widget.gl_end
			end
		end

feature {NONE} -- Implementation

	has_been_exposed: BOOLEAN
	
invariant

	gl_widget_not_void: gl_widget /= Void

end
