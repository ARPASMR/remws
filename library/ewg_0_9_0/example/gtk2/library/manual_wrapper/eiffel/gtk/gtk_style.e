indexing

	description:

		"Base class for all widgets"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/26 21:55:17 $"
	revision: "$Revision: 1.3 $"

class GTK_STYLE

inherit

	G_OBJECT
		redefine
			make_shared
		end


	GTK_STYLE_STRUCT_EXTERNAL
		rename
			sizeof_external as sizeof_gtk_sytle_external
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTKSTYLE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	EWG_GTK_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTK_STATE_TYPE_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_state_type
		undefine
			is_equal,
			copy
		end

creation

	make_shared

feature {NONE} -- Initialization

	make_shared (a_item: POINTER) is
		local
			address: POINTER
			count: INTEGER
		do
			Precursor (a_item)
			address := ewg_gtk_style_get_fg_gc_array_address_external (item)
			count := ewg_gtk_style_get_fg_gc_array_sizeof_external (item) // external_memory.sizeof_pointer_external
			create fg_gc_array.make_shared (address, count)
		end

feature {ANY} -- Basic access


	black_gc: GDK_GC is
			-- TODO: description
		local
			p: POINTER
		do
			p := get_black_gc_external (item)
			if g_object_manager.is_g_object_marked (p) then
				Result ?= g_object_manager.g_object_wrapper_from_marked_g_object (p)
			else
				create Result.make_shared (p)
			end
		ensure
			result_not_void: Result /= Void
		end

	white_gc: GDK_GC is
			-- TODO: description
		local
			p: POINTER
		do
			p := get_white_gc_external (item)
			if g_object_manager.is_g_object_marked (p) then
				Result ?= g_object_manager.g_object_wrapper_from_marked_g_object (p)
			else
				create Result.make_shared (p)
			end
		ensure
			result_not_void: Result /= Void
		end

	fg_gc (a_state: INTEGER): GDK_GC is
			-- "fg_gc" (TODO: What is this thing? A foreground graphical
			-- context?)  for the state `a_state'. See
			-- `GTK_STATE_TYPE_ENUM_EXTERNAL' for possible values for
			-- `a_state'. You can get the state of a widget using the query
			-- `GTK_WIDGET.state'
		require
			valid_a_state: is_valid_state_type (a_state)
		local
			p: POINTER
		do
			p := get_white_gc_external (item)
			if g_object_manager.is_g_object_marked (p) then
				Result ?= g_object_manager.g_object_wrapper_from_marked_g_object (p)
			else
				create Result.make_shared (p)
			end
		ensure
			result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	fg_gc_array: EWG_POINTER_ARRAY
			-- "fg_gc" (TODO: What is this thing? A foreground graphical
			-- context?)  for the state `a_state'. See
			-- `GTK_STATE_TYPE_ENUM_EXTERNAL' for possible indices for
			-- the array.

invariant

	fg_gc_array_not_void: fg_gc_array /= Void
	fg_gc_array_exists: fg_gc_array.exists
	fg_gc_has_correct_address: fg_gc_array.array_address = ewg_gtk_style_get_fg_gc_array_address_external (item)
	fg_gc_has_correct_size: fg_gc_array.count = ewg_gtk_style_get_fg_gc_array_sizeof_external (item) // external_memory.sizeof_pointer_external
	fg_gc_items_marked: True --TODO:

end
