indexing

	description:

		"GTKGL example application"

	copyright: "Copyright (c) 2004, Mark Bolstad, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:23:39 $"
	revision: "$Revision: 1 $"

class
		SHAPES

inherit

	GTK_SHARED_MAIN
		export
			{NONE} all
		undefine
			default_create
		end

	GTKGL_SHARED_INIT
		export
			{NONE} all
		undefine
			default_create
		end
		
	EWG_IMPORTED_EXTERNAL_ROUTINES
		export
			{NONE} all
		end

	KL_SHARED_EXCEPTIONS
		export
			{NONE} all
		undefine
			default_create
		end

	GDK_EVENT_MASK_ENUM_EXTERNAL
		export
			{NONE} all
		end

	GDK_MODIFIER_TYPE_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_event_mask_enum
		export
			{NONE} all
		end

	GL_FUNCTIONS
		export
			{NONE} all
		end
	
creation

	make
	
feature -- Initialisation

	make is
		local
			box: GTK_VBOX
		do
			default_create

			create view_quat.make (1, 4)
			create view_quat_diff.make (1, 4)
			
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

			gtkgl_init.initialize_toolkit
			if not gtkgl_init.is_toolkit_initialized then
				print ("Unable to init GTKGL%N")
				Exceptions.die (1)
			end

			-- Create the default DoubleBuffered, Depth, RGB configuration
			create gl_widget.make
			gl_widget.request_size (300, 300)
			print (gl_widget.config)

			create arcball.make (300, 300)
			create tmp_pt
			create last_pt
			
			-- Create a GTK window toplevel window
			create window.make_top_level
			
			-- Create a signal receiver for the 'destroy' signal
			create destroy_event_signal_receiver.make
			
			-- Connect signal receiver to `window'
			window.connect_destroy_signal_receiver (destroy_event_signal_receiver)
			
			-- Set the border width of our new window to 2
			window.set_border_width (2)

			create box.make (5)

			-- Add the box as single child to the window
			window.add (box)

			box.pack_start (gl_widget, True, True, 0)
			
			-- Create the menu
			create_popup_menu

			-- Add the event handlers
			create expose_event_signal_receiver.make (gl_widget, arcball)
			gl_widget.connect_expose_event_signal_receiver (expose_event_signal_receiver)

			create configure_event_signal_receiver.make (gl_widget, arcball)
			gl_widget.connect_configure_event_signal_receiver (configure_event_signal_receiver)

			gl_widget.connect_button_press_event_signal_receiver_agent (agent on_button_press_event)
			gl_widget.connect_key_press_event_signal_receiver_agent (agent on_key_press_event)
			gl_widget.connect_motion_notify_event_signal_receiver_agent (agent on_motion_notify_event)

			gl_widget.set_events (event_flags)
			
			-- Create a GTK button with a text
			create button.make_with_label (hello_world_string)
			
			-- Create a signal receiver for the 'clicked' signal
			-- This receiver when called will destroy
			-- `window'. Thats why we need to pass it here.
			create clicked_signal_receiver.make (window)
			
			-- Connect the signal receiver to the button
			-- This means that everytime `button' emits
			-- a 'clicked' signal, `clicked_signal_receiver.on_clicked' will be called
			button.connect_clicked_signal_receiver (clicked_signal_receiver)
			
			-- Add the GTK button to the GTK window
			box.pack_start (button, False, False, 0)
			
			-- Show the button
			button.show
			gl_widget.show

			box.show
			
			-- Show the window
			window.show
			
			-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Attributes
	
	window: GTK_WINDOW
			-- Wrapper for GTK window

	gl_widget: GTKGL_WIDGET
	
	button: GTK_BUTTON
			-- Wrapper for GTK button

	clicked_signal_receiver: SHAPES_CLICKED_SIGNAL_RECEIVER
			-- Receiver for 'clicked' signal

	destroy_event_signal_receiver: SHAPES_DESTROY_SIGNAL_RECEIVER
			-- Receiver for 'destroy' signal

feature -- Constants

	hello_world_string: STRING is "Quit"
			-- Text for the GTK button

feature {NONE} -- Implementation

	expose_event_signal_receiver: SHAPES_EXPOSE_EVENT_SIGNAL_RECEIVER
			-- Receiver for 'expose-event' signal

	configure_event_signal_receiver: SHAPES_CONFIGURE_EVENT_SIGNAL_RECEIVER
			-- Receiver for 'configure-event' signal

	tmp_pt, last_pt: POINT2
	view_quat_diff, view_quat: ARRAY [REAL]
	begin_x, begin_y: INTEGER
	
	arcball: TRACKBALL
	root_menu: GTK_MENU

	event_flags: INTEGER is
		do
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (gdk_exposure_mask, gdk_leave_notify_mask)
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (Result, gdk_button_press_mask)
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (Result, gdk_pointer_motion_mask)
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (Result, gdk_pointer_motion_hint_mask)
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (Result, gdk_key_press_mask)
		end

	create_popup_menu is
			-- Create the popup menu
		require 
			toolkit_initialized: gtk_main.is_toolkit_initialized
		local
			menu: GTK_MENU
			menu_item: GTK_MENU_ITEM
		do
			create root_menu.make
			
			create menu.make

			create menu_item.make_with_label ("Cone")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Cone", ?))
			menu_item.show

			create menu_item.make_with_label ("Cube")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Cube", ?))
			menu_item.show

			create menu_item.make_with_label ("Dodecahedron")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Dodecahedron", ?))
			menu_item.show

			create menu_item.make_with_label ("Icosahedron")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Icosahedron", ?))
			menu_item.show

			create menu_item.make_with_label ("Octahedron")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Octahedron", ?))
			menu_item.show

			create menu_item.make_with_label ("Sphere")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Sphere", ?))
			menu_item.show

			create menu_item.make_with_label ("Teapot")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Teapot", ?))
			menu_item.show

			create menu_item.make_with_label ("Tetrahedron")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Tetrahedron", ?))
			menu_item.show

			create menu_item.make_with_label ("Torus")
			menu.append (menu_item)
			menu_item.connect_activate_signal_receiver_agent (agent on_activate ("Torus", ?))
			menu_item.show

			create menu_item.make_with_label ("Shapes")
			menu_item.set_submenu (menu)
			menu_item.show
			
			root_menu.append (menu_item)
		end 

	on_activate (a_text: STRING; a_menu_item: GTK_WIDGET) is
		require
			a_text_not_void: a_text /= Void
		do
			if a_text.is_equal ("Cone") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.cone_shape)
			elseif a_text.is_equal ("Cube") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.cube_shape)
			elseif a_text.is_equal ("Dodecahedron") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.dodecahedron_shape)
			elseif a_text.is_equal ("Icosahedron") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.icosahedron_shape)
			elseif a_text.is_equal ("Octahedron") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.octahedron_shape)
			elseif a_text.is_equal ("Sphere") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.sphere_shape)
			elseif a_text.is_equal ("Teapot") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.teapot_shape)
			elseif a_text.is_equal ("Tetrahedron") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.tetrahedron_shape)
			elseif a_text.is_equal ("Torus") then
				expose_event_signal_receiver.set_current_shape (expose_event_signal_receiver.torus_shape)
			end
		end

	on_key_press_event (a_widget: GTK_WIDGET; a_event: GDK_KEY_EVENT): BOOLEAN is
			-- Called when a key is pressed
		do
			io.put_string ("Key Press%N")

			Result := true
		end
	
	on_motion_notify_event (a_widget: GTK_WIDGET; a_motion_event: GDK_MOTION_EVENT): BOOLEAN is
			-- Called when the mouse button is moved
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

			if EXTERNAL_MEMORY_.bitwise_integer_and_external (state, gdk_button1_mask) /= 0 then
				tmp_pt.make (x, y)
				arcball.rotate_event (tmp_pt)

				a_widget.queue_draw
			end
			
			Result := true
		end
	
	on_button_press_event (a_widget: GTK_WIDGET; a_event: GDK_BUTTON_EVENT): BOOLEAN is
			-- Called when a mouse button is pressed
		do
			if a_event.button = 3 then
				io.put_string ("Button Menu Press%N")
				root_menu.popup (a_event.button, GTK_MAIN.current_event_time)
			else
				last_pt.make (a_event.x, a_event.y)
				arcball.start_motion (last_pt)
			end

			Result := true
		end
		
end
