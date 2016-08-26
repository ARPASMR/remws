indexing

	description:

		"The base object type"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:31 $"
	revision: "$Revision: 1.4 $"

class G_OBJECT

inherit

	GOBJECT_STRUCT
		rename
			sizeof_external as sizeof_gobject_external
		export
			{NONE} all
		undefine
			copy,
			is_equal
		redefine
			exists,
			item,
			make_unshared,
			make_shared,
			make_new_unshared,
			make_new_shared
		end

	GOBJECT_FUNCTIONS
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GSIGNAL_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	G_SHARED_OBJECT_MANAGER
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	G_OBJECT_MANAGER_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	G_SHARED_TYPE_ROUTINES
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	EWG_IDENTIFIED
		redefine
			dispose
		end

feature {NONE} -- Initialization

	make_new_unshared is
			-- G_OBJECTs are always shared, because
			-- they are reference counted
		do
				check
					forbidden: False
				end
		end

	make_new_shared is
			-- G_OBJECTs are always shared, because
			-- they are reference counted
		do
				check
					forbidden: False
				end
		end

	make_unshared (a_item: POINTER) is
			-- G_OBJECTs are always shared, because
			-- they are reference counted
		do
				check
					forbidden: False
				end
		end

	make_shared (a_item: POINTER) is
			-- G_OBJECTs are always shared, because
			-- they are reference counted
		do
			Precursor (a_item)
			mark
		end

feature {NONE} -- Closure

	connect_signal_receiver (a_receiver: G_SIGNAL_RECEIVER) is
			-- Connect `a_closure' to the signal named `a_signal_name'
		require
			a_receiver_not_void: a_receiver /= Void
			signal_supported: True -- TODO
		local
			cstr: EWG_ZERO_TERMINATED_STRING
			i: INTEGER
		do
			create cstr.make_unshared_from_string (a_receiver.signal_name)
				-- TODO: dont use signal names, but signal ids
			if not a_receiver.exists then
				a_receiver.set_existent
			end
			i := g_signal_connect_closure_external (item, cstr.item, a_receiver.item, 0);
		ensure
			--TODO:
		end

feature {G_OBJECT, G_OBJECT_MANAGER, EWG_STRUCT}

	exists: BOOLEAN is
		do
			Result := Precursor
		end

	item: POINTER is
		do
			Result := Precursor
		end

	reference_count: INTEGER is
			-- Number of times the GObject has been referenced
		do
			Result := ref_count
		end

feature {NONE} -- Implementation

	mark is
			-- Mark `Current.item' with `Current'.
		require
			not_marked: data (wrapper_key_constant) = Default_pointer
		do
			add_reference
			set_wrapper_key
		ensure
			is_marked: data (wrapper_key_constant) /= Default_pointer
		end

	unmark is
			-- Remove the mark from `Current.item'.
		require
			is_marked: data (wrapper_key_constant) /= Default_pointer
		do
			steal_wrapper_key
			remove_reference
		ensure
			not_marked: data (wrapper_key_constant) = Default_pointer
		end

feature {NONE} -- Referencing resp. Unreferencing

	add_reference is
			-- Add a reference to `item'.
		local
			p: POINTER
		do
			p := g_object_ref_external (item)
		ensure
			reference_count_increased: reference_count = old reference_count + 1
		end

	remove_reference is
			-- Remove a reference to `item'.
		do
			g_object_unref_external (item)
		ensure
			reference_count_decreased: reference_count = old reference_count - 1
		end

feature {NONE} -- Key/Value data managatment

	set_data (a_key: STRING; a_value: POINTER) is
			-- Add the key named `a_key' with the value
			-- `a_value' to the GObject `item'.
			-- Given the value, the key can later be retrieved
			-- via `data'.
			-- NOTE: The key/data pair is stored directly in GObject
			-- and is thus independent from the Eiffel wrapper object G_OBJECT.
		require
			a_key_not_void: a_key /= Void
			a_key_not_empty: a_key.count > 0
			a_value_not_default_pointer: a_value /= Default_pointer
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_shared_from_string (a_key)
			g_object_set_data_external (item, cstr.item, a_value)
		ensure
			data_set: data (a_key) = a_value
		end

	data (a_key: STRING): POINTER is
			-- Retrieves the data associated with the key `a_key' from
			-- the GObject `item'. See `set_data' for
			-- further information. If `item' does not have `a_key'
			-- this routine returns `Default_pointer'
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_key)
			Result := g_object_get_data_external (item, cstr.item)
		end

	steal_data (a_key: STRING) is
			-- Removes thet key `a_key' from `item'.
			-- See `set_data' for further information.
		local
			cstr: EWG_ZERO_TERMINATED_STRING
			p: POINTER
		do
			create cstr.make_unshared_from_string (a_key)
			p := g_object_steal_data_external (item, cstr.item)
		end

	wrapper_key_c_string_constant_item: POINTER

	set_wrapper_key is
		do
			-- We need to make a local copy of the pointer,
			-- since we need it from within `dispose' later.
			wrapper_key_c_string_constant_item := wrapper_key_c_string_constant.item
			g_object_set_data_external (item, wrapper_key_c_string_constant_item,
										external_memory.integer_to_pointer_external (ewg_object_id))
		ensure
			wrapper_key_c_string_constant_item_not_default_pointer: wrapper_key_c_string_constant_item /= Default_pointer
		end

	steal_wrapper_key is
		require
			wrapper_key_c_string_constant_item_not_default_pointer: wrapper_key_c_string_constant_item /= Default_pointer
		local
			p: POINTER
		do
			p := g_object_steal_data_external (item, wrapper_key_c_string_constant_item)
		end

feature {ANY} -- Garbage Collector routines

	dispose is
		do
			Precursor
			unmark
		end

invariant

	exists: exists

	marked: g_object_manager.is_g_object_wrapper_marked (Current)

	shared: is_shared

	item_is_g_object: g_type_routines.is_g_object (item)

	reference_count_positive: reference_count > 0

end
