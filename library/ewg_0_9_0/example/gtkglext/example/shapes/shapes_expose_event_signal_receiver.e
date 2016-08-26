

indexing
    description: "Expose event handler"
    copyright: "Copyright (c) 2004, Mark Bolstad, Andreas Leitner and others"
    license: "Eiffel Forum License v2 (see forum.txt)"
    date: "$DateTime$"
    revision: "$Revision: 1.1 $"
    author: "$Author: renderdude $"
    status: "unreviewed"




class 

	SHAPES_EXPOSE_EVENT_SIGNAL_RECEIVER

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

	GDKGLSHAPES_FUNCTIONS
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

feature -- Initialization

	make (a_gl_widget: like gl_widget; the_arcball: TRACKBALL) is
		require
			a_gl_widget_not_void: a_gl_widget /= Void
		do
			gl_widget := a_gl_widget
			make_gtk_expose_event_signal_receiver
			has_been_exposed := True
			current_shape := cone_shape
			arcball := the_arcball
			first := true
		ensure
			arcball_set: arcball = the_arcball
			gl_widget_set: gl_widget = a_gl_widget
		end

feature -- Access
	
	cone_shape: INTEGER is 0
	cube_shape: INTEGER is 1
	dodecahedron_shape: INTEGER is 2
	icosahedron_shape: INTEGER is 3
	octahedron_shape: INTEGER is 4
	sphere_shape: INTEGER is 5
	teapot_shape: INTEGER is 6
	tetrahedron_shape: INTEGER is 7
	torus_shape: INTEGER is 8

	current_shape: INTEGER

feature -- Element Change

	set_current_shape (new_shape: INTEGER) is
			-- Set `current_shape' to `new_shape'
		require 
			valid_shape: new_shape >= cone_shape and new_shape <= torus_shape
		do
			current_shape := new_shape
		ensure 
			current_shape_set: current_shape = new_shape
		end 

feature {NONE}

	gl_widget: GTKGL_WIDGET

	arcball: TRACKBALL
	
	on_expose_event (a_widget: GTK_WIDGET; a_event: GDK_EXPOSE_EVENT): BOOLEAN is
			-- Called when we need to redraw the drawing area
		local
			pt: EWG_REAL_ARRAY
			color: EWG_REAL_ARRAY
			vals: EWG_DOUBLE_ARRAY
			xform: TRANSFORM
		do
			io.put_string ("Expose%N")
			
			if gl_widget.gl_begin then
				
				if first then
					create color.make_new_unshared (4)
					color.put (1.0, 0)
					color.put (1.0, 1)
					color.put (1.0, 2)
					color.put (1.0, 3)
					
					create pt.make_new_unshared (4)
					pt.put (3.0, 0)
					pt.put (3.0, 1)
					pt.put (3.0, 2)
					pt.put (0.0, 3)
					
					gl_lightfv (ewg_get_constant_gl_light0, ewg_get_constant_gl_position, pt.array_address)
					gl_lightfv (ewg_get_constant_gl_light0, ewg_get_constant_gl_diffuse, color.array_address)

					gl_front_face (ewg_get_constant_gl_cw)
					gl_enable (ewg_get_constant_gl_lighting)
					gl_enable (ewg_get_constant_gl_light0)
					gl_enable (ewg_get_constant_gl_auto_normal)
					gl_enable (ewg_get_constant_gl_normalize)
					gl_enable (ewg_get_constant_gl_depth_test)
					gl_depth_func (ewg_get_constant_gl_less)
					
					gl_clear_color (0.5, 0.5, 0.8, 1.0)
					gl_clear_depth (1.0)
					
					gl_clear (ewg_get_constant_gl_color_buffer_bit | ewg_get_constant_gl_depth_buffer_bit)

					shape_list_base := gl_gen_lists (6)

					gl_new_list (shape_list_base + cone_shape, ewg_get_constant_gl_compile)
					gl_push_matrix
					gl_translatef (0, 0, -1)
					gdk_gl_draw_cone (1, 1.0, 2.0, 30, 30)
					gl_pop_matrix
					gl_end_list

					gl_new_list (shape_list_base + cube_shape, ewg_get_constant_gl_compile)
					gdk_gl_draw_cube (1, 1.5)
					gl_end_list

					gl_new_list (shape_list_base + dodecahedron_shape, ewg_get_constant_gl_compile)
					gl_push_matrix
					gl_scalef (0.7, 0.7, 0.7)
					gdk_gl_draw_dodecahedron (1)
					gl_pop_matrix
					gl_end_list

					gl_new_list (shape_list_base + icosahedron_shape, ewg_get_constant_gl_compile)
					gl_push_matrix
					gl_scalef (0.7, 0.7, 0.7)
					gdk_gl_draw_icosahedron (1)
					gl_pop_matrix
					gl_end_list

					gl_new_list (shape_list_base + octahedron_shape, ewg_get_constant_gl_compile)
					gl_push_matrix
					gl_scalef (0.7, 0.7, 0.7)
					gdk_gl_draw_octahedron (1)
					gl_pop_matrix
					gl_end_list

					gl_new_list (shape_list_base + sphere_shape, ewg_get_constant_gl_compile)
					gdk_gl_draw_sphere (1, 1.0, 30, 30)
					gl_end_list

					gl_new_list (shape_list_base + tetrahedron_shape, ewg_get_constant_gl_compile)
					gl_push_matrix
					gl_scalef (0.7, 0.7, 0.7)
					gdk_gl_draw_tetrahedron (1)
					gl_pop_matrix
					gl_end_list

					gl_new_list (shape_list_base + teapot_shape, ewg_get_constant_gl_compile)
					gdk_gl_draw_teapot (1, 1.0)
					gl_end_list

					gl_new_list (shape_list_base + torus_shape, ewg_get_constant_gl_compile)
					gdk_gl_draw_torus (1, 0.4, 0.8, 30, 30)
					gl_end_list

					first := false
				end
				
				gl_clear (ewg_get_constant_gl_color_buffer_bit | ewg_get_constant_gl_depth_buffer_bit)
				gl_load_identity
				gl_translatef (0.0, 0.0, -10.0)
				xform := arcball.trackball_matrix
				vals := xform.to_array
				gl_mult_matrixd (vals.array_address)
				gl_call_list (shape_list_base + current_shape)
				
				if gl_widget.config.is_double_buffered then
					gl_widget.swap_buffers
				else
					gl_flush
				end
				
				gl_widget.gl_end
			end

			Result := true
		end

feature {NONE} -- Implementation

	has_been_exposed: BOOLEAN
	first: BOOLEAN

	shape_list_base: INTEGER
			-- The base of id of the display lists
	
invariant

	gl_widget_not_void: gl_widget /= Void
	valid_shape: current_shape >= cone_shape and current_shape <= torus_shape
	
end -- SHAPES_EXPOSE_EVENT_SIGNAL_RECEIVER

