indexing

	description:

		"The base class of the GTK+ type hierarchy."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/08/01 21:36:24 $"
	revision: "$Revision: 1.5 $"

class GTK_OBJECT

inherit

	G_OBJECT

	GTK_OBJECT_AGENT
	
	GTK_SHARED_MAIN
		undefine
			is_equal,
			copy
		end
		
	GTKOBJECT_FUNCTIONS_EXTERNAL
		undefine
			is_equal,
			copy
		end

	GTK_OBJECT_STRUCT_EXTERNAL
		rename
			sizeof_external as sizeof_gtkobject_external
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
		
	
feature {ANY} -- Basic Operations

	destroy is
			-- Emits the "destroy" signal notifying all reference holders that
			-- they should release the G_OBJECT. 
			-- The memory for the object itself won't be deleted until its reference
			-- count actually drops to 0; `destroy' merely asks reference holders to
			-- release their references, it does not free the object. 
		do
			gtk_object_destroy_external (item)
		end

	flags: INTEGER is
			-- TODO:
		do
			Result := get_flags_external (item)
		end
	
feature {ANY} -- Signals

	connect_destroy_signal_receiver (a_receiver: GTK_DESTROY_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

end
