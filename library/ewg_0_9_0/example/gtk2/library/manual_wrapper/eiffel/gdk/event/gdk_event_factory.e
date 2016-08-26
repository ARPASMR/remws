indexing

	description:

		"Factory Singleton for GDK Events"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/30 21:03:55 $"
	revision: "$Revision: 1.3 $"

class GDK_EVENT_FACTORY

inherit

	ANY

	EWG_GTK_FUNCTIONS_EXTERNAL
		export {NONE} all end

	GDK_EVENT_TYPE_ENUM_EXTERNAL
		export {NONE} all end

	GDK_EVENT_UNION_EXTERNAL
		export {NONE} all end

creation {GDK_SHARED_EVENT_FACTORY}

	make

feature {NONE} -- Initialization

	make is
		do
		end

feature {ANY}

	new_event (an_event: POINTER): GDK_EVENT is
			-- Create a new event wrapper from an pointer (`an_event') to an event structure.
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			if is_expose_event (an_event) then
				Result := new_expose_event (an_event)
			elseif is_configure_event (an_event) then
				Result := new_configure_event (an_event)
			elseif is_motion_notify_event (an_event) then
				Result := new_motion_event (an_event)
			elseif is_key_press_event (an_event) then
				Result := new_key_event (an_event)
			elseif is_focus_event (an_event) then
				Result := new_focus_event (an_event)
			elseif
				is_button_press_event (an_event) or
					is_2button_press_event (an_event) or
					is_3button_press_event (an_event)
			then
				Result := new_button_event (an_event)
			else
					check
						TODO: False
					end
			end
		ensure
			result_not_void: Result /= Void
		end

	new_expose_event (an_event: POINTER): GDK_EXPOSE_EVENT is
			-- Create new expose event from `an_event'.
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
			an_event_is_expose_event: is_expose_event (an_event)
		do
			create Result.make (an_event)
		ensure
			result_not_void: Result /= Void
		end

	new_configure_event (an_event: POINTER): GDK_CONFIGURE_EVENT is
			-- Create new configure event from `an_event'.
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
			an_event_is_expose_event: is_configure_event (an_event)
		do
			create Result.make (an_event)
		ensure
			result_not_void: Result /= Void
		end

	new_motion_event (an_event: POINTER): GDK_MOTION_EVENT is
			-- Create new motion event from `an_event'.
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
			an_event_is_expose_event: is_motion_notify_event (an_event)
		do
			create Result.make (an_event)
		ensure
			result_not_void: Result /= Void
		end

	new_key_event (an_event: POINTER): GDK_KEY_EVENT is
			-- Create new key event from `an_event'.
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
			an_event_is_expose_event: is_key_press_event (an_event)
		do
			create Result.make (an_event)
		ensure
			result_not_void: Result /= Void
		end

	new_focus_event (an_event: POINTER): GDK_FOCUS_EVENT is
			-- Create new focus event from `an_event'.
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
			an_event_is_expose_event: is_focus_event (an_event)
		do
			create Result.make (an_event)
		ensure
			result_not_void: Result /= Void
		end

	new_button_event (an_event: POINTER): GDK_BUTTON_EVENT is
			-- Create new button event from `an_event'.
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
			an_event_is_expose_event: is_button_press_event (an_event) or
				is_2button_press_event (an_event) or
				is_3button_press_event (an_event)
		do
			create Result.make (an_event)
		ensure
			result_not_void: Result /= Void
		end

feature {ANY}

	is_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to an event?
		require
			an_event_not_default_pointer: an_event /= Default_pointer
		do
			-- TODO:
			Result := True
		end

	is_expose_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to an expose event?
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_expose
		end

	is_configure_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to a configure event?		
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_configure
		end

	is_motion_notify_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to a motion notify event?
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_motion_notify
		end

	is_key_press_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to a key press event?		
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_key_press
		end

	is_focus_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to a focus event?		
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_focus_change
		end

	is_button_press_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to a button press event?
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_button_press
		end

	is_2button_press_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to a 2button press event?
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_2button_press
		end

	is_3button_press_event (an_event: POINTER): BOOLEAN is
			-- Is `an_event' a pointer to a 3button press event?
		require
			an_event_not_default_pointer: an_event /= Default_pointer
			an_event_is_event: is_event (an_event)
		do
			Result := get_type_external (an_event) = gdk_3button_press
		end

end
