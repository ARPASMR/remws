indexing

	description:

		"Base class for (almost) all callback targets in glib based libraries"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:31 $"
	revision: "$Revision: 1.4 $"

class G_CLOSURE

inherit

	ANY

	G_SHARED_CLOSURE_MARSHAL_DISPATCHER
		export
			{NONE} all
		end

	GCLOSURE_STRUCT
		export
			{NONE} all
		redefine
			item,
			exists
		end

	GCLOSURE_FUNCTIONS_EXTERNAL
		export {NONE} all end

feature {NONE} -- Initialization

	make is
		do
			create managed_data.make_default_pointer
		ensure
			not_exists: not exists
		end

feature {G_SHARED_CLOSURE_MARSHAL_DISPATCHER}

	on_command (a_parameters: G_VALUE_ARRAY) is
			-- This routine will be called from G_CLOSURE_SHARED_MARSHAL_DISPATCHER
			-- if a command is triggered (signal without return value)
			-- Redefine this in decendants
		do
		end

	on_query (a_return_value: G_VALUE; a_parameters: G_VALUE_ARRAY) is
			-- This routine will be called from G_CLOSURE_SHARED_MARSHAL_DISPATCHER
			-- if a quert is triggered (signal with return value)
			-- Redefine this in decendants
		require
			a_return_value_not_void: a_return_value /= Void
		do
		end

feature {G_OBJECT, G_SOURCE, G_SHARED_CLOSURE_MARSHAL_DISPATCHER}

	exists: BOOLEAN is
		do
			Result := Precursor
		end

	item: POINTER is
		do
			Result := Precursor
		end

	set_existent is
			-- Let `Current' be connected to a GTK closure
			-- and the GTK->Eiffel Marshaller
			-- As long as `Current' `exist's it cannot be collected
		require
			not_exists: not exists
		do
			make_shared (g_closure_new_simple_external (sizeof, Default_pointer))
			set_data (external_garbage_collector.eif_adopt (Current))
			g_closure_set_marshal_external (item, g_closure_dispatcher.c_dispatcher)
			g_closure_add_finalize_notifier_external (item, data,
													  g_closure_notify_dispatcher.c_dispatcher);
		ensure
			exists: exists
		end

	set_inexistent is
			-- Disconnect `Current' from the GTK closure
			-- and the GTK->Eiffel Marshaller
			-- After that, `Current' can be collected by the GC again.
			-- You want to call this feature when the GTK closure is being
			-- finalized.
			-- When a G_CLOSURE goes inexistent, you can still connect it
			-- to widgets and sources, just make sure to call
			-- `set_existent' before.
		require
			exists: exists
		do
			external_garbage_collector.eif_wean (data)
			create managed_data.make_default_pointer
		ensure
			not_exists: not exists
		end

feature {NONE} -- Implementation

	add_reference is
		local
			p: POINTER
		do
			p := g_closure_ref_external (item)
		end

	remove_reference is
		do
			g_closure_unref_external (item)
		end

feature {ANY} -- Garbage Collector routines

invariant

	shared: exists implies is_shared

end
