indexing

	description:

		"EWG OpenGL Hello World Example"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:39:13 $"
	revision: "$Revision: 1.1 $"

class OPENGL_HELLO_WORLD

inherit

	EWG_OPENGL_APPLICATION
		rename
			make as make_ewg_opengl_application
		end
		
creation

	make

feature

	make is
		do
			-- Init ewg opengl
			make_ewg_opengl_application

			-- Create Window #1
			create window_1.make (window_1_string, 50, 100, 100, 100)
			-- Create Window #2
			create window_2.make (window_1_string, 170, 100, 100, 100)
			
			glut_main_loop_external

		end

feature {NONE}

	window_1: WINDOW_1

	window_2: WINDOW_2

feature {NONE} -- Constants

	window_1_string: STRING is "Window 1"

	window_2_string: STRING is "Window 2"
	
end
