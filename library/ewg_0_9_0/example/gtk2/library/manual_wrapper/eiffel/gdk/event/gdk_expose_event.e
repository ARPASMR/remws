indexing

	description:

		"Objects representing GDK Expose Events."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/26 21:55:16 $"
	revision: "$Revision: 1.2 $"

class GDK_EXPOSE_EVENT

inherit

	GDK_EVENT

	GDK_EVENT_EXPOSE_STRUCT
		rename
			area as area_pointer
		export
			{NONE} all
		undefine
			make_unshared,
			make_shared,
			make_new_unshared,
			make_new_shared
		end

	EWG_GTK_FUNCTIONS_EXTERNAL
		export {NONE} all end

creation

	make

feature {NONE} -- Initialization

	make (a_item: POINTER) is
			-- Create new event from `a_item'.
		require
			a_item_not_default_pointer: a_item /= Default_pointer
			a_item_is_event: gdk_event_factory.is_event (a_item)
			a_item_is_expose_event: gdk_event_factory.is_expose_event (a_item)
		do
			make_shared (a_item)
		ensure
			item_not_default_pointer: item /= Default_pointer
			item_set: item = a_item
		end

feature {ANY} -- Basic access

	area: GDK_RECTANGLE is
			-- Exposed area
		do
			if
				area_cache = Void or else
				area_cache.item /= area_pointer
			then
				create area_cache.make_shared (area_pointer)
			end
			Result := area_cache
		ensure
			area_not_void: Result /= Void
			area_exists: Result.exists
		end

feature {NONE}

	area_cache: GDK_RECTANGLE

end
