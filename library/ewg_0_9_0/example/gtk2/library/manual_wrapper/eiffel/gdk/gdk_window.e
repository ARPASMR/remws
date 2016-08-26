indexing

	description:

		"Objects represent Onscreen display areas in the target window system."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/26 21:55:16 $"
	revision: "$Revision: 1.3 $"

class GDK_WINDOW

inherit

	GDK_DRAWABLE

	GDKWINDOW_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make_shared
		
feature {ANY} -- Status

	last_pointer_x: INTEGER
			-- Last x posistion of pointer;
			-- Updated when `determine_pointer' is called.

	last_pointer_y: INTEGER
			-- Last y position of pointer;
			-- Updated when `determine_pointer' is called.
	
	last_pointer_state: INTEGER
			-- Last pointer state;
			-- Updated when `determine_pointer' is called.
			-- For possible values see GDK_MODIFIER_TYPE_ENUM_EXTERNAL

	last_pointer_widget: GTK_WIDGET
			-- Widget the pointer was in the last time
			-- `determine_pointer' was called. If the widget is not know to GDK,
			-- then `last_pointer_widget' will be `Void'.

feature {ANY} -- Basic Routines


	determine_pointer is
			-- Determine current pointer position, modifier state
			-- and window containing the pointer. Updates
			-- `last_pointer_x', `last_pointer_y', `last_pointer_state'
			-- and `last_pointer_widget'.
		local
			x_ref: EWG_MANAGED_POINTER
			y_ref: EWG_MANAGED_POINTER
			mask_ref: EWG_MANAGED_POINTER
			widget_pointer: POINTER
		do
			create x_ref.make_new_unshared (EXTERNAL_MEMORY_.sizeof_int_external)
			create y_ref.make_new_unshared (EXTERNAL_MEMORY_.sizeof_int_external)
			create mask_ref.make_new_unshared (EXTERNAL_MEMORY_.sizeof_int_external)
			widget_pointer := gdk_window_get_pointer_external (item, x_ref.item, y_ref.item, mask_ref.item)
			last_pointer_x := x_ref.read_integer (0)
			last_pointer_y := y_ref.read_integer (0)
			last_pointer_state := mask_ref.read_integer (0)

			if widget_pointer = Default_pointer then
				last_pointer_widget := Void
			else
				if g_object_manager.is_g_object_marked (widget_pointer) then
					last_pointer_widget ?= g_object_manager.g_object_wrapper_from_marked_g_object (widget_pointer)
				else
					create last_pointer_widget.make_shared (widget_pointer)
				end
			end
		end

end
