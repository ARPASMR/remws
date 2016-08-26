indexing

	description:

		"Objects wrapping GValue objects"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:31 $"
	revision: "$Revision: 1.4 $"

class G_VALUE

inherit

	ANY

	G_SHARED_TYPE_ROUTINES

	G_SHARED_OBJECT_MANAGER

	GVALUE_STRUCT
		export
			-- Item should be accessible to all g_objects (Paolo
			-- 2005-02-28)
			-- Item must be accessible by EWG_STRUCT_ARRAY, since it is
			-- required by one of its postconditions
			-- {G_OBJECT,EWG_STRUCT_ARRAY} item;
			{G_OBJECT,G_VALUE_ARRAY, EWG_STRUCT_ARRAY} all
		end

	GVALUE_FUNCTIONS -- _EXTERNAL
		export {NONE} all end

	GVALUETYPES_FUNCTIONS -- _EXTERNAL
		export {NONE} all end

	G_TYPE_ROUTINES -- _EXTERNAL
		export {NONE} all end

		
	GTYPE_FUNCTIONS -- _EXTERNAL
		export {NONE} all end

	GOBJECT_FUNCTIONS -- _EXTERNAL
		export {NONE} all end

	GBOXED_FUNCTIONS -- _EXTERNAL
		export {NONE} all end

	GDK_SHARED_EVENT_FACTORY
		export {NONE} all end

creation

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared,

	make_boolean
	--,make_integer,make_double,make_character


feature {ANY} -- Creation
	make_boolean (a_boolean: BOOLEAN) is
			-- create a new boolean G_VALUE
		local ptr: POINTER
		do
			make_new_shared
			ptr := g_value_init (item, g_boolean_type_number)
			-- TODO: check if the pointer ptr is meaningless
			set_boolean (a_boolean)
		ensure
			is_boolean: is_boolean
			value_set: boolean = a_boolean
		end
	
feature {ANY}

	type_number: INTEGER is
		do
			Result := g_type
		end

	type_name: STRING is
			-- Returns type name of value
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_shared (g_type_name_external (type_number))
			Result := cstr.string
		end

feature {ANY}

	is_marked: BOOLEAN is
			-- Is Current value a marked GObject?
		do
			Result := g_object_manager.is_g_object_marked (g_object)
		end

	marked_g_object: G_OBJECT is
			-- If the current value is marked GObject, return its wrapper
		require
			is_g_object: g_type_routines.is_type_g_object (type_number)
			is_marked: g_object_manager.is_g_object_marked (g_object)
		do
			Result := g_object_manager.g_object_wrapper_from_marked_g_object (g_object)
		ensure
			g_object_not_void: Result /= Void
		end

	is_gobject: BOOLEAN is
			-- Is Current value a GObject?
		do
			Result := g_type_routines.is_type_g_object (type_number)
		end

	g_object: POINTER is
			-- If the current value is a GObject, return a pointer to it
		require
			is_gobject:  is_gobject
		do
			Result := g_value_get_object_external (item)
		ensure
			g_object_not_default_pointer: Result /= Default_pointer
		end

	gdk_event: GDK_EVENT is
			-- If the current value is a GdkEvent, return its wrapper.
		require
			is_gdk_event: g_type_routines.is_type_gdk_event (type_number)
		do
			Result := gdk_event_factory.new_event (g_value_get_boxed_external (item))
		ensure
			gdk_event_not_void: Result /= Void
		end

feature {ANY} -- Boolean

	is_boolean: BOOLEAN is
			-- Is current value a boolean?
		do
			Result := g_type_routines.is_type_g_boolean (type_number)
		end

	boolean: BOOLEAN is
			-- If the current value is a boolean, return it
		require
			is_boolean: is_boolean
		do
			Result := g_value_get_boolean_external (item) = 1
		end


	set_boolean (a_value: BOOLEAN) is
			-- If the current value is a boolean, set it.
		require
			is_boolean: is_boolean
		do
			if a_value then
				g_value_set_boolean_external (item, 1)
			else
				g_value_set_boolean_external (item, 0)
			end
		end

feature {ANY} -- Integer

	is_integer: BOOLEAN is
			-- Is current value an integer?
		do
			Result := g_type_routines.is_type_g_integer (type_number)
		end

	integer: INTEGER is
			-- If current value is an integer, returns it
		require
			is_integer: is_integer
		do
			Result := g_value_get_int_external (item)
		end

	set_integer (a_value: INTEGER) is
			-- If the current value is a integer, set it.
		require
			is_integer: is_integer
		do
			g_value_set_int_external (item, a_value)
		end

feature {ANY} -- Double

	is_double: BOOLEAN is
			-- Is current value a double?
		do
			Result := g_type_routines.is_type_g_double (type_number)
		end

	double: DOUBLE is
			-- If current value is an double, returns it
		require
			is_double: is_double
		do
			Result := g_value_get_double_external (item)
		end

	set_double (a_value: DOUBLE) is
			-- If the current value is a double, set it.
		require
			is_double: is_double
		do
			g_value_set_double_external (item, a_value)
		end

feature {ANY} -- Character

	is_character: BOOLEAN is
			-- Is current value a character?
		do
			Result := g_type_routines.is_type_g_character (type_number)
		end

	character: CHARACTER is
			-- If current value is an character, returns it.
		require
			is_character: is_character
		do
			Result := g_value_get_char_external (item)
		end

	set_character (a_value: CHARACTER) is
			-- If the current value is a character, set it.
		require
			is_character: is_character
		do
			g_value_set_char_external (item, a_value)
		end

feature {ANY} -- Pointer

	is_pointer: BOOLEAN is
			-- Is current value a pointer?
		do
			Result := g_type_routines.is_type_g_pointer (type_number)
		end

	pointer: POINTER is
			-- If current value is an character, returns it.
		require
			is_pointer: is_pointer
		do
			Result := g_value_get_pointer_external (item)
		end

	set_pointer (a_value: POINTER) is
			-- If the current value is a pointer, set it.
		require
			is_pointer: is_pointer
		do
			g_value_set_pointer_external (item, a_value)
		end

invariant

	exists: exists

end
