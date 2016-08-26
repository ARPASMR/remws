indexing

	description:

		"Routines dealing with GType"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/08/03 21:15:47 $"
	revision: "$Revision: 1.2 $"

class G_TYPE_ROUTINES

inherit

	ANY

	GTYPE_FUNCTIONS_EXTERNAL
		export {NONE} all end

	GDKEVENTS_FUNCTIONS_EXTERNAL
		export {NONE} all end

creation {G_SHARED_TYPE_ROUTINES}

	make

feature {NONE}

	make is
		do
		end

feature {ANY}

	is_g_object (a_g_object: POINTER): BOOLEAN is
			-- Is `a_g_object' really a GObject ?
		require
			a_g_object_not_default_pointer: a_g_object /= Default_pointer
		do
			Result := g_type_check_instance_is_a_external (a_g_object, g_object_type_number) = 1
		end

feature {ANY}

	is_type_g_object (a_type_number: INTEGER): BOOLEAN is
			-- Is `a_type_number' the type number of GObject or the type number of a descendant?
		do
			Result := is_type_instance_of_type (a_type_number, g_object_type_number)
		end

	is_type_g_boolean (a_type_number: INTEGER): BOOLEAN is
			-- Is `a_type_number' the type number of GObject boolean type?
		do
			Result := is_type_instance_of_type (a_type_number, g_boolean_type_number)
		end

	is_type_g_integer (a_type_number: INTEGER): BOOLEAN is
			-- Is `a_type_number' the type number of GObject integer type?
		do
			Result := is_type_instance_of_type (a_type_number, g_type_int)
		end

	is_type_g_double (a_type_number: INTEGER): BOOLEAN is
			-- Is `a_type_number' the type number of GObject double type?
		do
			Result := is_type_instance_of_type (a_type_number, g_type_double)
		end

	is_type_g_character (a_type_number: INTEGER): BOOLEAN is
			-- Is `a_type_number' the type number of GObject char type?
		do
			Result := is_type_instance_of_type (a_type_number, g_type_char)
		end

	is_type_g_pointer (a_type_number: INTEGER): BOOLEAN is
			-- Is `a_type_number' the type number of pointer?
		do
			Result := is_type_instance_of_type (a_type_number, g_type_pointer)
		end

	is_type_gdk_event (a_type_number: INTEGER): BOOLEAN is
			-- Is `a_type_number' the type number of GObject boolean type?
		do
			Result := a_type_number = gdk_event_type_number
		end

feature {ANY}

	is_type_instance_of_type (a_type_number: INTEGER; a_base_type_number: INTEGER): BOOLEAN is
			-- Returns `True' if `a_type_number' is the type number
			-- of an instance of the type with the number `a_base_type_number'.
			-- This means `a_type_number' has either to be `a_base_type' or a descendant.
		do
			Result := fundamental_type_of_type (a_type_number) = a_base_type_number
		end

feature {ANY}

	fundamental_type_of_type (a_type_number: INTEGER): INTEGER is
			-- Return the fundamental type number of `a_type_number'
		do
			Result := g_type_fundamental_external (a_type_number)
		end

feature {ANY}

	g_object_type_number: INTEGER is
			-- Type number of GObject
		do
			Result := 80 -- 20 |<< 2
		end

	g_boolean_type_number: INTEGER is
			-- Type number of BOOLEAN
		do
			Result := 20 -- 5 |<< 2
		end

	gdk_event_type_number: INTEGER is
			-- Type number of GdkEvent
		do
			Result := gdk_event_get_type_external
		end

	g_type_invalid: INTEGER is 0 -- 0 |<<2
	g_type_none: INTEGER is 4 -- 1 |<<2
	g_type_interface: INTEGER is 8 -- 2 |<<2
	g_type_char: INTEGER is 12 -- 3 |<<2
	g_type_uchar: INTEGER is 16 -- 4 |<<2
	g_type_boolean: INTEGER is 20 -- 5 |<<2
	g_type_int: INTEGER is 24 -- 6 |<<2
	g_type_uint: INTEGER is 28 -- 7 |<<2
	g_type_long: INTEGER is 32 -- 8 |<<2
	g_type_ulong: INTEGER is 36 -- 9 |<<2
	g_type_int64: INTEGER is 40 -- 10 |<<2
	g_type_uint64: INTEGER is 44 -- 11 |<<2
	g_type_enum: INTEGER is 48 -- 12 |<<2
	g_type_flags: INTEGER is 52 -- 13 |<<2
	g_type_float: INTEGER is 56 -- 14 |<<2
	g_type_double: INTEGER is 60 -- 15 |<<2
	g_type_string: INTEGER is 64 -- 16 |<<2
	g_type_pointer: INTEGER is 68 -- 17 |<<2
	g_type_boxed: INTEGER is 72 -- 18 |<<2
	g_type_param: INTEGER is 76 -- 19 |<<2
	g_type_object: INTEGER is 80-- 20 |<<2

end
