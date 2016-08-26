indexing

	description:

		"Dispatches 'display' events to interested Eiffel objects"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:09 $"
	revision: "$Revision: 1.6 $"

class EWG_OPENGL_DISPLAY_CALLBACK

inherit

	GLUT_FUNCTIONS_EXTERNAL

	GLUFUNCPTR_CALLBACK

creation

	make

feature {NONE} -- Initialisation

	make is
		do
			create listener_map.make (initial_listener_map_size)
			create dispatcher.make (Current)
		end

feature {ANY}

	add_listener (a_window_listener: EWG_OPENGL_WINDOW_DISPLAY_LISTENER; a_window_id: INTEGER) is
		require
			a_window_listener_not_void: a_window_listener /= Void
		do
			listener_map.force (a_window_listener, a_window_id)
		end

feature {GLUFUNCPTR_DISPATCHER}

	on_callback is
		local
			current_id: INTEGER
		do
			current_id := glut_get_window_external
			if listener_map.has (current_id) then
				listener_map.item (current_id).on_display
			end
		end

feature {EWG_OPENGL_WINDOW}
	
	c_dispatcher: POINTER is
		do
			Result := dispatcher.c_dispatcher
		end

feature {NONE} -- Constants

	initial_listener_map_size: INTEGER is 5

feature {NONE} -- Implementation

	dispatcher:  GLUFUNCPTR_DISPATCHER

	listener_map: DS_HASH_TABLE [EWG_OPENGL_WINDOW_DISPLAY_LISTENER, INTEGER]
	
end
	
