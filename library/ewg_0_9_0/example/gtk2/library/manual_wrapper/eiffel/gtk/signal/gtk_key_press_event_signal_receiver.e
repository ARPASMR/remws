indexing

	description:

		"Closure for gtk 'key-press-event' signal"

	copyright: "Copyright (c) 2004, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/30 21:03:56 $"
	revision: "$Revision: 1.1 $"

deferred class GTK_KEY_PRESS_EVENT_SIGNAL_RECEIVER

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
		local
			widget: GTK_WIDGET
			event: GDK_KEY_EVENT
		do
				check
					parameters_not_void: a_parameters /= Void
					correct_parameters_count: a_parameters.count = 2
					first_param_is_g_object: g_type_routines.is_type_g_object (a_parameters.item (0).type_number)
					first_param_is_marked: g_object_manager.is_g_object_marked (a_parameters.item (0).g_object)
					second_param_is_gdk_event: g_type_routines.is_type_gdk_event (a_parameters.item (1).type_number)
				end
			widget ?= a_parameters.item (0).marked_g_object
				check
					widget_not_void: widget /= Void
				end
			event ?= a_parameters.item (1).gdk_event
				check
					event_not_void: event /= Void
				end
			a_return_value.set_boolean (on_key_press_event (widget, event))
		end

feature {G_OBJECT}

	signal_name: STRING is
		once
			Result := "key-press-event"
		end

feature {NONE}

	on_key_press_event (a_widget: GTK_WIDGET; a_event: GDK_KEY_EVENT): BOOLEAN is
		require
			a_widget_not_void: a_widget /= Void
			a_event_not_void: a_event /= Void
		deferred
		end

end
