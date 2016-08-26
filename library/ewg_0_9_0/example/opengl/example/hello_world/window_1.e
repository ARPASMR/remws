indexing

	description:

		"TODO:"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/04/19 00:55:10 $"
	revision: "$Revision: 1.2 $"

class WINDOW_1

inherit

	EWG_OPENGL_WINDOW
	
creation

	make
	
feature

	on_display is
		do
			gl_clear_color_external(0, 1, 0, 0)
			gl_clear_external(ewg_get_constant_gl_color_buffer_bit)
			gl_flush_external
		end

end

	
