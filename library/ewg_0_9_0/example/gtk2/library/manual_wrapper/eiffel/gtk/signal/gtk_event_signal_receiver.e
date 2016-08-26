indexing

	description:

		"Closure for gtk 'event' signal"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:31 $"
	revision: "$Revision: 1.3 $"

deferred class GTK_EVENT_SIGNAL_RECEIVER

inherit

	G_SIGNAL_RECEIVER
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
			-- This routine will be called from G_CLOSURE_SHARED_MARSHAL_DISPATCHER
			-- TODO: handle 2nd parameter of type 'GdkEvent'
		local
			widget: GTK_WIDGET
		do
				check
					parameters_not_void: a_parameters /= Void
					correct_parameters_count: a_parameters.count = 2
					first_param_is_g_object: g_type_routines.is_type_g_object (a_parameters.item (0).type_number)
					first_param_is_marked: g_object_manager.is_g_object_marked (a_parameters.item (0).g_object)
				end
			widget ?= a_parameters.item (0).marked_g_object
				check
					widget_not_void: widget /= Void
				end
			a_return_value.set_boolean (on_event (widget))
		end

feature {G_OBJECT}

	signal_name: STRING is
		once
			Result := "event"
		end

feature {NONE}

	on_event (a_widget: GTK_WIDGET): BOOLEAN is
			-- Called whenever `a_widget' emmits a "event" signal
			-- Return `True' to stop other handlers from being invoked for
			-- the event. `False' to propagate the event further.
		require
			a_widget_not_void: a_widget /= Void
		deferred
		end

end
