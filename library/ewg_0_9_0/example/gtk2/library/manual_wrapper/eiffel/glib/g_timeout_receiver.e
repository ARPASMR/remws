indexing

	description:

		"Closure for gtk main loop timeout signal"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/19 19:34:01 $"
	revision: "$Revision: 1.1 $"

deferred class G_TIMEOUT_RECEIVER

inherit

	G_CLOSURE
		redefine
			on_query
		end

	KL_IMPORTED_STRING_ROUTINES
	
	G_SHARED_OBJECT_MANAGER
		export {NONE} all end

	G_SHARED_TYPE_ROUTINES
		export {NONE} all end

feature {G_SHARED_CLOSURE_MARSHAL_DISPATCHER}

	on_query (a_return_value: G_VALUE; a_parameters: G_VALUE_ARRAY) is
			-- This routine will be called from G_SHARED_CLOSURE_MARSHAL_DISPATCHER
		do
				check
					parameters_void: a_parameters = Void
				end
			a_return_value.set_boolean (on_timeout)
		end

feature {NONE}

	on_timeout: BOOLEAN is
			-- Notifies that a given interval has elapsed,
			-- If it returns `True' the notification will
			-- continue, otherwise it will stop.
		deferred
		end

end
