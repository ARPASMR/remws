indexing

	description:

		"Manages G_OBJECTs. Class is singleton"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.3 $"

class G_OBJECT_MANAGER

inherit

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GOBJECT_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTYPE_FUNCTIONS_EXTERNAL
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

	G_SHARED_TYPE_ROUTINES
		undefine
			is_equal,
			copy
		end

	EWG_IDENTIFIED

creation {G_SHARED_OBJECT_MANAGER}

	make

feature {NONE}

	make is
		do
		end

feature {ANY}

	g_object_wrapper_from_marked_g_object (a_g_object: POINTER): G_OBJECT is
			-- Returns a G_OBJECT wrapper from the C GObject pointer
			-- `a_g_object'. You can only call this routine if `a_g_object'
			-- has already been marked.
		require
			a_g_object_not_default_pointer: a_g_object /= Default_pointer
			a_g_object_is_marked: is_g_object_marked (a_g_object)
		local
			pointer: POINTER
		do
			pointer := g_object_get_data (a_g_object, wrapper_key_constant)
				-- Retrieve wrapper, since object has already been marked
			Result ?= ewg_id_object (external_memory.pointer_to_integer_external (pointer))
				check
					result_not_void: Result /= Void
				end
		ensure
			g_object_wrapper_not_void: Result /= Void
			g_object_wrapper_is_corresponding_wrapper: Result.item = a_g_object
			g_object_wrapper_is_marked: is_g_object_wrapper_marked (Result)
		end

feature {ANY} -- Assertions

	is_g_object_wrapper_marked (a_g_object_wrapper: G_OBJECT): BOOLEAN is
			-- Is `a_g_object_wrapper' marked via `mark_g_object_with_wrapper'?
		require
			a_g_object_wrapper_not_void: a_g_object_wrapper /= Void
		do
			Result := is_g_object_marked (a_g_object_wrapper.item)
		ensure
			result_implies_item_is_marked: Result implies is_g_object_marked (a_g_object_wrapper.item)
		end

	is_g_object_marked (a_g_object: POINTER): BOOLEAN is
			-- Is `a_g_object' marked via `mark_g_object_with_wrapper'?
		require
			a_g_object_not_default_pointer: a_g_object /= Default_pointer
			a_g_object_is_g_object: g_type_routines.is_g_object (a_g_object)
		local
			pointer: POINTER
			wrapper: G_OBJECT
		do
			pointer := g_object_get_data (a_g_object,  wrapper_key_constant)
			if pointer /= Default_pointer then
				wrapper ?= ewg_id_object (EXTERNAL_MEMORY_.pointer_to_integer_external (pointer))
				Result := wrapper /= Void
			end
		ensure
			marked: Result implies g_object_get_data (a_g_object,  wrapper_key_constant) /= Default_pointer
		end

feature {NONE} -- Implementation

	g_object_set_data (a_g_object: POINTER; a_key: STRING; a_value: POINTER) is
			-- Add the key named `a_key' with the value
			-- `a_value' to the GObject `a_g_object'.
			-- Given the value, the key can later be retrieved
			-- via `g_object_get_data'.
			-- NOTE: The key/data pair is stored directly in GObject
			-- and is thus independent from the Eiffel wrapper object G_OBJECT.
		require
			a_g_object_not_default_pointer: a_g_object /= Default_pointer
			a_g_object_is_g_object: g_type_routines.is_g_object (a_g_object)
			a_key_not_void: a_key /= Void
			a_key_not_empty: a_key.count > 0
			a_value_not_default_pointer: a_value /= Default_pointer
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_key)
			g_object_set_data_external (a_g_object, cstr.item, a_value)
		ensure
			data_set: g_object_get_data (a_g_object, a_key) = a_value
		end

	g_object_get_data (a_g_object: POINTER; a_key: STRING): POINTER is
			-- Retrieves the data associated with the key `a_key' from
			-- the GObject `a_g_object'. See `g_object_set_data' for
			-- further information. If `a_g_object' does not have `a_key'
			-- this routine returns `Default_pointer'
		require
			a_g_object_not_default_pointer: a_g_object /= Default_pointer
			a_g_object_is_g_object: g_type_routines.is_g_object (a_g_object)
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_key)
			Result := g_object_get_data_external (a_g_object, cstr.item)
		end

	g_object_steal_data (a_g_object: POINTER; a_key: STRING) is
			-- Removes thet key `a_key' from the GObject `a_g_object'.
			-- See `g_object_set_data' for further information.
		require
			a_g_object_not_default_pointer: a_g_object /= Default_pointer
			a_g_object_is_g_object: g_type_routines.is_g_object (a_g_object)
		local
			cstr: EWG_ZERO_TERMINATED_STRING
			p: POINTER
		do
			create cstr.make_unshared_from_string (a_key)
			p := g_object_steal_data_external (a_g_object, cstr.item)
		ensure
			stolen: g_object_get_data (a_g_object, a_key) = Default_pointer
		end

end
