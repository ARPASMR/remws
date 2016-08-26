indexing

	description:

		"Represents OpenGL window."

	note: "I was told this is a bad abstraction. TODO: refactore"
	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/04/19 00:55:10 $"
	revision: "$Revision: 1.5 $"

deferred class EWG_OPENGL_WINDOW

inherit

	EWG_OPENGL_WINDOW_DISPLAY_LISTENER

	EWG_OPENGL_SHARED_CALLBACKS
		export
			{NONE} all
		end
		
	GL_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	GLUT_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	EWG_OPENGL_CONSTANTS_FUNCTIONS
		export
			{NONE} all
		end

	EWG_OPENGLUT_CONSTANTS_FUNCTIONS
		export
			{NONE} all
		end

feature {NONE} -- Initialisation

	make (a_name: STRING; a_x, a_y, a_width, a_height: INTEGER) is
		require
			a_name_not_void: a_name /= Void
			a_x_greater_zero: a_x > 0
			a_y_greater_zero: a_y > 0
			a_width_greater_zero: a_width > 0
			a_height_greater_zero: a_height > 0
		local
			c_string: EWG_ZERO_TERMINATED_STRING
		do
			glut_init_window_position_external(a_x, a_y)
			glut_init_window_size_external(a_width, a_height)
			glut_init_display_mode_external(ewg_get_constant_glut_single + ewg_get_constant_glut_rgb)
			create c_string.make_unshared_from_string (a_name)
			id := glut_create_window_external(c_string.item)
			glut_display_func_external(display_callback.c_dispatcher)
			display_callback.add_listener (Current, id)
		end

feature {NONE} -- Implementation

	id: INTEGER
	
end
	
