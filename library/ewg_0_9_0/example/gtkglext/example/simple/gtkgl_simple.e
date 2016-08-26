indexing

	description:

		"GTK+ 2 with GTKGL example simple application"

	copyright: "Copyright (c) 2004, Mark Bolstad, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:23:39 $"
	revision: "$Revision: 1.0 $"

class
	GTKGL_SIMPLE
	
inherit

	GTK_SHARED_MAIN
		export
			{NONE} all
		end

	GTKGL_SHARED_INIT
		export
			{NONE} all
		end
		
	EWG_IMPORTED_EXTERNAL_ROUTINES
		export
			{NONE} all
		end

	KL_SHARED_EXCEPTIONS
		export
			{NONE} all
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

	GTK_WIDGET_FLAGS_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_gtk_flags_enum
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
			gl_widget.request_size (200, 200)
			print (gl_widget.config)

			-- Create a GTK window toplevel window
			create window.make_top_level
			
			-- Create a signal receiver for the 'destroy' signal
			create destroy_event_signal_receiver.make
			
			-- Connect signal receiver to `window'
			window.connect_destroy_signal_receiver (destroy_event_signal_receiver)
			
			-- Set the border width of our new window to 10
			window.set_border_width (10)

			create box.make (5)

			-- Add the box as single child to the window
			window.add (box)

			create expose_event_signal_receiver.make (gl_widget)
			gl_widget.connect_expose_event_signal_receiver (expose_event_signal_receiver)

			create configure_event_signal_receiver.make (gl_widget)
			gl_widget.connect_configure_event_signal_receiver (configure_event_signal_receiver)

			window.connect_key_press_event_signal_receiver_agent (agent on_key_press_event)

			gl_widget.connect_focus_in_event_signal_receiver_agent (agent on_focus_in_event)
			gl_widget.connect_focus_out_event_signal_receiver_agent (agent on_focus_out_event)

			gl_widget.set_flags (gtk_can_focus)

			box.pack_start (gl_widget, True, True, 0)
			
			-- Create a GTK button with a text
			create button.make_with_label (quit_string)
			
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

	clicked_signal_receiver: GTKGL_SIMPLE_CLICKED_SIGNAL_RECEIVER
			-- Receiver for 'clicked' signal

	destroy_event_signal_receiver: GTKGL_SIMPLE_DESTROY_SIGNAL_RECEIVER
			-- Receiver for 'destroy' signal

	expose_event_signal_receiver: GTKGL_SIMPLE_EXPOSE_EVENT_SIGNAL_RECEIVER
			-- Receiver for 'expose-event' signal

	configure_event_signal_receiver: GTKGL_SIMPLE_CONFIGURE_EVENT_SIGNAL_RECEIVER
			-- Receiver for 'configure-event' signal

feature -- Constants

	quit_string: STRING is "Quit Me!"
			-- Text for the GTK button

feature {NONE} -- Implementation

	flags: INTEGER
	
	event_flags: INTEGER is
		do
			Result := EXTERNAL_MEMORY_.bitwise_integer_or_external (gdk_button_press_mask, gdk_key_press_mask)
		end
	
	on_key_press_event (a_widget: GTK_WIDGET; a_event: GDK_KEY_EVENT): BOOLEAN is
			-- Called when a key is pressed
		do
			io.put_string ("Key Press%N")

			Result := true
		end
	
	on_focus_in_event (a_widget: GTK_WIDGET; a_event: GDK_FOCUS_EVENT): BOOLEAN is
			-- Called when `a_widget' receives focus
		do
			io.put_string ("Focus In%N")

			Result := false
		end
	
	on_focus_out_event (a_widget: GTK_WIDGET; a_event: GDK_FOCUS_EVENT): BOOLEAN is
			-- Called when `a_widget' loses focus
		do
			io.put_string ("Focus Out%N")

			Result := false
		end
	
end
