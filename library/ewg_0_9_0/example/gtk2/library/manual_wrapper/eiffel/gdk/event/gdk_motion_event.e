indexing

	description:

		"Objects representing GDK Motion Events."

	copyright: "Copyright (c) 2004, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:31 $"
	revision: "$Revision: 1.2 $"

class GDK_MOTION_EVENT

inherit

	GDK_EVENT

	GDK_EVENT_MOTION_STRUCT
		rename
			is_hint as is_hint_integer,
			window as window_pointer
		undefine
			make_unshared,
			make_shared,
			make_new_unshared,
			make_new_shared
		end

	G_SHARED_OBJECT_MANAGER
		export {NONE} all end

creation

	make
	
feature {NONE} -- Initialization

	make (a_item: POINTER) is
			-- Create new event from `a_item'.
		require
			a_item_not_default_pointer: a_item /= Default_pointer
			a_item_is_event: gdk_event_factory.is_event (a_item)
			a_item_is_expose_event: gdk_event_factory.is_motion_notify_event (a_item)
		do
			make_shared (a_item)
		ensure
			item_not_default_pointer: item /= Default_pointer
			item_set: item = a_item
		end

feature {ANY} -- Access

	is_hint: BOOLEAN is
			-- Is this event just a hint?
		do
			Result := is_hint_integer /= 0
		end

	window: GDK_WINDOW is
			-- Window that received the event.
		local
			p: POINTER
		do
			p := window_pointer
			if g_object_manager.is_g_object_marked (p) then
				Result ?= g_object_manager.g_object_wrapper_from_marked_g_object (p)
			else
				create Result.make_shared (p)
			end
		ensure
			result_not_void: Result /= Void
		end

end

