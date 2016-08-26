indexing

	description:

		"GTK+ 2 scribble simple example"

	copyright: "Copyright (c) 2004, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:10 $"
	revision: "$Revision: 1.3 $"

class GTK_SCRIBBLE_SIMPLE

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export {NONE} all end

	GDK_EVENT_MASK_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_event_mask_enum
		export
			{NONE} all
		end

	GDK_MODIFIER_TYPE_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_modifier_type_enum
		export
			{NONE} all
		end

creation

	make

feature -- Initialisation

	make is
		local
			vbox: GTK_VBOX
			button: GTK_BUTTON
		do
				-- Setup the locale for GTK and GDK according to the programs
				-- environment
			gtk_main.set_locale
				-- Initialize GTK
			gtk_main.initialize_toolkit
				-- If initialization went wrong for some reason,
				-- quit the application
			if not gtk_main.is_toolkit_initialized then
				print ("Unable to init GTK%N")
				Exceptions.die (1)
			end

				-- Create a GTK window toplevel window
			create window.make_top_level
			window.set_name (window_name_string)

			create vbox.make (0)
			window.add (vbox)
			vbox.show

				-- Connect `on_destroy' to signal 'destroy' of widget `window'
			window.connect_destroy_signal_receiver_agent (agent on_destroy)


			create drawing_area.make
			drawing_area.request_size (200, 200)
			vbox.pack_start (drawing_area, True, True, 0)
			drawing_area.show

			drawing_area.connect_expose_event_signal_receiver_agent (agent on_expose)
			drawing_area.connect_configure_event_signal_receiver_agent (agent on_configure)
			drawing_area.connect_motion_notify_event_signal_receiver_agent (agent on_motion_notify)
			drawing_area.connect_button_press_event_signal_receiver_agent (agent on_button_press)

			drawing_area.set_events (event_flags)

			create button.make_with_label (quit_button_label_string)
			vbox.pack_start (button, False, False, 0);

			button.connect_clicked_signal_receiver_agent (agent on_quit_button_clicked)

			button.show

				-- Show the window
			window.show

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

		event_flags: INTEGER is
		do
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (gdk_exposure_mask, gdk_leave_notify_mask)
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (Result, gdk_button_press_mask)
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (Result, gdk_pointer_motion_mask)
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (Result, gdk_pointer_motion_hint_mask)
		end

feature -- Agents

	on_destroy (a_gtk_object: GTK_OBJECT) is
		do
			gtk_main.quit_main_loop
		end

	on_expose (a_widget: GTK_WIDGET; a_expose_event: GDK_EXPOSE_EVENT): BOOLEAN is
		do
			a_widget.window.draw_drawable (a_widget.style.fg_gc (a_widget.state),
													 pixmap,
													 a_expose_event.area.x,
													 a_expose_event.area.y,
													 a_expose_event.area.x,
													 a_expose_event.area.y,
													 a_expose_event.area.width,
													 a_expose_event.area.height);
		end

	on_configure (a_widget: GTK_WIDGET; a_configure_event: GDK_CONFIGURE_EVENT): BOOLEAN is
		do
			create pixmap.make (a_widget.window,
									  a_widget.allocation.width,
									  a_widget.allocation.height,
									  -1)

			pixmap.draw_rectangle_filled (a_widget.style.white_gc,
													0, 0,
													a_widget.allocation.width,
													a_widget.allocation.height)
		end

	on_motion_notify (a_widget: GTK_WIDGET; a_motion_event: GDK_MOTION_EVENT): BOOLEAN is
		local
			x, y: INTEGER
			state: INTEGER
		do
			if a_motion_event.is_hint then
				a_motion_event.window.determine_pointer
				x := a_motion_event.window.last_pointer_x
				y := a_motion_event.window.last_pointer_y
				state := a_motion_event.window.last_pointer_state
			else
				x := a_motion_event.x.rounded
				y := a_motion_event.y.rounded
				state := a_motion_event.state
			end

			if
				pixmap /= Void and
					(EXTERNAL_MEMORY_.bitwise_integer_and_external (state, gdk_button1_mask) /= 0)
			then
				draw_brush (a_widget, x, y)
			end
			Result := True
		end

	on_button_press (a_widget: GTK_WIDGET; a_button_event: GDK_BUTTON_EVENT): BOOLEAN is
		do
			if
				a_button_event.button = 1 and
					pixmap /= Void
			then
				draw_brush (a_widget, a_button_event.x.rounded, a_button_event.y.rounded)
			end
			Result := True
		end

	on_quit_button_clicked (a_button: GTK_BUTTON) is
		do
			window.destroy
		end

	draw_brush (a_widget: GTK_WIDGET; a_x, a_y: INTEGER) is
		require
			a_widget_not_void: a_widget /= Void
			pixmap_not_void: pixmap /= Void
		local
			update_rectangle: GDK_RECTANGLE
		do
			create update_rectangle.make_new_unshared
			update_rectangle.set_x (a_x - 5)
			update_rectangle.set_y (a_y - 5)
			update_rectangle.set_width (10)
			update_rectangle.set_height (10)

			pixmap.draw_rectangle_filled (a_widget.style.black_gc,
													update_rectangle.x, update_rectangle.y,
													update_rectangle.width, update_rectangle.height)
			a_widget.queue_draw_area (update_rectangle.x, update_rectangle.y,
													update_rectangle.width, update_rectangle.height)
		end

feature -- Attributes

	window: GTK_WINDOW
			-- Wrapper for GTK window

	drawing_area: GTK_DRAWING_AREA
			-- Area that the user can draw in with the mouse

	pixmap: GDK_PIXMAP

feature -- Constants

	window_name_string: STRING is "Test Input"
			-- Text for the GTK button

	quit_button_label_string: STRING is "Quit"
			-- Label text for quit button

end
