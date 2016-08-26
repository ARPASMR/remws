indexing

	description:

		"Closure for gtk 'clicked' signal"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:31 $"
	revision: "$Revision: 1.5 $"

deferred class GTK_CLICKED_SIGNAL_RECEIVER

inherit

	G_SIGNAL_RECEIVER
		redefine
			on_command
		end

	KL_IMPORTED_STRING_ROUTINES
	
	G_SHARED_OBJECT_MANAGER
		export {NONE} all end

	G_SHARED_TYPE_ROUTINES
		export {NONE} all end

feature {G_SHARED_CLOSURE_MARSHAL_DISPATCHER}

	on_command (a_parameters: G_VALUE_ARRAY) is
			-- This routine will be called from G_CLOSURE_SHARED_MARSHAL_DISPATCHER
		local
			button: GTK_BUTTON
		do
				check
					parameters_not_void: a_parameters /= Void
					correct_parameters_count: a_parameters.count = 1
					first_param_is_g_object: g_type_routines.is_type_g_object (a_parameters.item (0).type_number)
					first_param_is_marked: g_object_manager.is_g_object_marked (a_parameters.item (0).g_object)
				end
			button ?= a_parameters.item (0).marked_g_object
				check
					button_not_void: button /= Void
				end
			on_clicked (button)
		end

feature {G_OBJECT}

	signal_name: STRING is
		once
			Result := "clicked"
		end

feature {NONE}

	on_clicked (a_button: GTK_BUTTON) is
			-- Called whenever `a_button' emmits a "clicked" signal
		require
			a_button_not_void: a_button /= Void
		deferred
		end

end
