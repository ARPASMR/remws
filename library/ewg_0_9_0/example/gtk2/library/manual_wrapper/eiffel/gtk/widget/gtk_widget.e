indexing

	description:

		"Base class for all widgets"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/04/30 12:43:15 $"
	revision: "$Revision: 1.12 $"

class GTK_WIDGET

inherit

	GTK_OBJECT

	GTK_WIDGET_AGENT

	G_SHARED_OBJECT_MANAGER
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTKWIDGET_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTK_WIDGET_STRUCT_EXTERNAL
		rename
			sizeof_external as sizeof_gtk_widget_external
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

	KL_IMPORTED_STRING_ROUTINES
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

feature {ANY} -- Basic access

	window: GDK_WINDOW is
			-- TODO:
		local
			p: POINTER
		do
			p := get_window_external (item)
			if g_object_manager.is_g_object_marked (p) then
				Result ?= g_object_manager.g_object_wrapper_from_marked_g_object (p)
					check
						result_not_void: Result /= Void
					end
			else
				create Result.make_shared (p)
			end
		ensure
			result_not_void: Result /= Void
		end

	style: GTK_STYLE is
			-- Simply an accessor function that returns widget->style.
		local
			p: POINTER
		do
			p := gtk_widget_get_style_external (item)
			if g_object_manager.is_g_object_marked (p) then
				Result ?= g_object_manager.g_object_wrapper_from_marked_g_object (p)
					check
						result_not_void: Result /= Void
					end
			else
				create Result.make_shared (p)
			end
		ensure
			result_not_void: Result /= Void
		end

	events: INTEGER is
			-- Event mask for the widget (a bitfield containing flags
			-- from GDK_EVENT_MASK_ENUM_EXTERNAL). These are the events
			-- that the widget will receive.
		do
			Result := gtk_widget_get_events_external (item)
		end

	allocation: GDK_RECTANGLE is
		do
			if
				allocation_cache = Void or else
				ewg_gtk_widget_get_allocation_external (item) /= allocation_cache.item
			then
				create allocation_cache.make_shared (ewg_gtk_widget_get_allocation_external (item))
			end
			Result := allocation_cache
		ensure
			allocation_not_void: Result /= Void
		end

	state: INTEGER is
			-- Current widget state. See GTK_STATE_TYPE_ENUM_EXTERNAL for
			-- possible values.
		do
			Result := ewg_gtk_widget_get_state_external (item)
		ensure
			valid_state_value: is_valid_state_type (Result)
		end

feature {ANY} -- Basic operations

	show is
			-- Flags a widget to be displayed. Any widget that isn't shown will
			-- not appear on the screen. If you want to show all the widgets in
			-- a container, it's easier to call `show_all' on the container, instead
			-- of individually showing the widgets.
			-- Remember that you have to show the containers containing a widget, in
			-- addition to the widget itself, before it will appear onscreen.
			-- When a toplevel container is shown, it is immediately realized and mapped;
			-- other shown widgets are realized and mapped when their toplevel container
			-- is realized and mapped.
		do
			gtk_widget_show_external (item)
		end

	show_all is
			-- Recursively shows a widget, and any child widgets
			-- (if the widget is a container).
		do
			gtk_widget_show_all_external (item)
		end


	request_size (a_width, a_height: INTEGER) is
			-- Sets the minimum size of a widget; that
			-- is, the widget's size request will be `a_width'
			-- by `a_height'. You can use this function to
			-- force a widget to be either larger or smaller
			-- than it normally would be.
			--
			-- In most cases, `set_default_size' is a better
			-- choice for toplevel windows than this function;
			-- setting the default size will still allow users to
			-- shrink the window. Setting the size request will
			-- force them to leave the window at least as large
			-- as the size request. When dealing with window sizes,
			-- `GTK_WINDOW.set_geometry_hints' can be a useful
			-- function as well.
			--
			-- Note the inherent danger of setting any fixed size
			-- - themes, translations into other languages, different
			-- fonts, and user action can all change the appropriate
			-- size for a given widget. So, it's basically impossible
			-- to hardcode a size that will always be correct.
			--
			-- The size request of a widget is the smallest size a widget
			-- can accept while still functioning well and drawing itself
			-- correctly. However in some strange cases a widget may be
			-- allocated less than its requested size, and in many cases
			-- a widget may be allocated more space than it requested.
			--
			-- If the size request in a given direction is `-1' (unset),
			-- then the "natural" size request of the widget will be used instead.
			--
			-- Widgets can't actually be allocated a size less than `1' by `1', but
			-- you can pass `0',`0' to this function to mean "as small as possible."
			--
			-- `a_width':	width widget should request, or `-1' to unset
			-- `a_height':	height widget should request, or `-1' to unset
		do
			gtk_widget_set_size_request_external (item, a_width, a_height);
		end


	queue_draw_area (a_x, a_y, a_width, a_height: INTEGER) is
			-- Invalidates the rectangular area of widget defined by `a_x', `a_y',
			-- `a_width' and `a_height' by calling `GDK_WINDOW.invalidate_rect'
			-- on the widget's window and all its child windows. Once the main loop
			-- becomes idle (after the current batch of events has been processed,
			-- roughly), the window will receive expose events for the union of all
			-- regions that have been invalidated.
			--
			-- Normally you would only use this function in widget implementations.
			-- You might also use it, or `GDK_WINDOW.invalidate_rect' directly, to schedule
			-- a redraw of a GTK_DRAWING_AREA or some portion thereof.
			--
			-- Frequently you can just call `GDK_WINDOW.invalidate_rect' or
			-- `GDK_WINDOW.invalidate_region' instead of this function. Those functions will
			-- invalidate only a single window, instead of the widget and all its children.
			--
			-- The advantage of adding to the invalidated region compared to simply drawing
			-- immediately is efficiency; using an invalid region ensures that you only have
			-- to redraw one time.
		require
			a_widht_big_enough: a_width >= 0
			a_height_big_enough: a_height >= 0
		do
			gtk_widget_queue_draw_area_external (item, a_x, a_y, a_width, a_height)
		end

	queue_draw is
			-- Equivalent to calling `queue_draw_area' for the entire
			-- area of a widget.
		do
			gtk_widget_queue_draw_external (item)
		end

	set_flags (a_flags: INTEGER) is
			-- Turns on certain widget flags.
			-- See GTK_WIDGET_FLAGS_ENUM_EXTERNAL for valid flags
		do
			set_flags_external (item, external_memory.bitwise_integer_or_external (flags, a_flags))
		end

	grab_default is
			-- Causes widget to become the default widget. widget must have
			-- the `GTK_WIDGET_FLAGS_ENUM_EXTERNAL.Gtk_can_default' flag set.
			-- Typically you set this flag yourself by calling `set_flag (Gtk_can_default)
			-- The default widget is activated when the user presses Enter in a window.
			-- Default widgets must be activatable, that is, `activate' should affect them.
		do
			gtk_widget_grab_default_external (item)
		end

	set_name (a_name: STRING) is
			-- Makes `a_name' the new name of this widget.	Widgets can
			-- be named, which allows you to refer to them from a gtkrc
			-- file. You can apply a style to widgets with a particular
			-- name in the gtkrc file.
		require
			a_name_not_void: a_name /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_name)
			gtk_widget_set_name_external (item, cstr.item)
		ensure
			name_set: -- TODO: STRING.same_string (name, a_name)
		end


	set_events (a_value: INTEGER) is
			-- Makes `a_value' the new event mask (see
			-- GDK_EVENT_MASK_ENUM_EXTERNAL) for a widget. The event mask
			-- determines which events a widget will receive. Keep in
			-- mind that different widgets have different default event
			-- masks, and by changing the event mask you may disrupt a
			-- widget's functionality, so be careful. This function must
			-- be called while a widget is unrealized. Consider
			-- `add_events' for widgets that are already realized, or if
			-- you want to preserve the existing event mask. This
			-- function can't be used with GTK_NO_WINDOW widgets; to get
			-- events on those widgets, place them inside a GTK_EVENT_BOX
			-- and receive events on the event box.
		do
			gtk_widget_set_events_external (item, a_value)
		ensure
			events_set: events = a_value
		end

	add_events (a_value: INTEGER) is
			-- Adds the events in the bitfield `a_value' to the event
			-- mask for this widget. See `set_events' for details.
		do
			gtk_widget_add_events_external (item, a_value)
		ensure
			has_events: external_memory.bitwise_integer_and_external (a_value, events) = a_value
		end


feature {ANY} -- Signals

	connect_activate_signal_receiver (a_receiver: GTK_ACTIVATE_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_delete_event_signal_receiver (a_receiver: GTK_DELETE_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_expose_event_signal_receiver (a_receiver: GTK_EXPOSE_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_configure_event_signal_receiver (a_receiver: GTK_CONFIGURE_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_motion_notify_event_signal_receiver (a_receiver: GTK_MOTION_NOTIFY_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_button_press_event_signal_receiver (a_receiver: GTK_BUTTON_PRESS_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_key_press_event_signal_receiver (a_receiver: GTK_KEY_PRESS_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_focus_in_event_signal_receiver (a_receiver: GTK_FOCUS_IN_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_focus_out_event_signal_receiver (a_receiver: GTK_FOCUS_IN_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end

	connect_event_signal_receiver (a_receiver: GTK_EVENT_SIGNAL_RECEIVER) is
			-- Connect `a_receiver' to the current widget
		require
			a_receiver_not_void: a_receiver /= Void
		do
			connect_signal_receiver (a_receiver)
		end


feature {NONE}

	allocation_cache: GDK_RECTANGLE

end
