indexing

	description:

		"GTK+ 2 example using GDK_PIXBUF"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:04 $"
	revision: "$Revision: 1.7 $"

class GTK_PIXBUF_DEMO

inherit

	ANY

	GTK_SHARED_MAIN
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

	GDK_SHARED_PIXBUF_FACTORY
		export {NONE} all end

	GDK_RGB_DITHER_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_rgb_dither_enum
		export
			{NONE} all
		end

	GDK_INTERP_TYPE_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_interp_type_enum
		export
			{NONE} all
		end

	EWG_DOUBLE_MATH

creation

	make

feature -- Initialisation

	make is
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

				-- Load Images into pixel buffers
			load_pixbufs

				-- Setup our double buffer frame
			frame := gdk_pixbuf_factory.new (False, 8, background_image.width, background_image.height);

				-- Create top level window
			create window.make_top_level
				-- Make it as big as the background image
			window.request_size (background_image.width, background_image.height)
				-- Don't let the user change that size
			window.set_resizable (False)

				-- Let's quit when the window gets destroyed
			window.connect_destroy_signal_receiver_agent (agent on_destroy)

				-- The drawing area will be the widget we copy the frame into
			create drawing_area.make

				-- Connect 'expose_event' signal handler
				-- so we know when we have to redraw
			drawing_area.connect_expose_event_signal_receiver_agent (agent on_expose_event)

				-- Add the drawing area to the top level window
			window.add (drawing_area)

				-- Create a timer, that will force a redraw on a regular
				-- interval
			create timeout_source.make (Frame_delay)

				-- Attach the timer to the glib default context
			timeout_source.attach_to_default_context

				-- Connect handler
			timeout_source.set_timeout_receiver_agent (agent on_timeout)

				-- Show all windows
			window.show_all

				-- Run the GTK main loop
			gtk_main.run_main_loop
		end

feature -- Signals

	on_destroy (a_widget: GTK_OBJECT) is
			-- Called when the top level window gets destroyed
		do
			gtk_main.quit_main_loop
		end

	on_timeout: BOOLEAN is
			-- Called in regular intervalls
			-- Updates the frame
		local
			f: DOUBLE
			i: INTEGER
			xmid: DOUBLE
			ymid: DOUBLE
			radius: DOUBLE
			ang: DOUBLE
			xpos: INTEGER
			ypos: INTEGER
			iw: INTEGER
			ih: INTEGER
			r: DOUBLE
			k: DOUBLE
			r1: GDK_RECTANGLE
			r2: GDK_RECTANGLE
			dest: GDK_RECTANGLE
			alpha: INTEGER
			d: DOUBLE

		do
			-- It would be better to reuse the same
			-- rectangles instead of creating new ones
			-- all the time
			create r1.make_new_unshared
			create r2.make_new_unshared
			create dest.make_new_unshared
			background_image.copy_to (frame, 0, 0)

			d := (frame_number \\ cycle_length)
			f := d / cycle_length
			xmid := background_image.width / 2.0
			ymid := background_image.height / 2.0
			if xmid > ymid then
				radius := ymid / 2.0
			else
				radius := xmid / 2.0
			end

			from
				i := 1
			until
				i > foreground_images.count
			loop
				ang := 2.0 * pi_constant * (i - 1) / foreground_images.count - f * 2.0 * pi_constant
				iw := foreground_images.item (i).width
				ih := foreground_images.item (i).height
				r := radius + (radius / 3.0) * sine (f * 2.0 * pi_constant)
				xpos := (xmid + r * cosine (ang) - iw / 2.0 + 0.5).floor
				ypos := (ymid + r * sine (ang) - ih / 2.0 + 0.5).floor

				if (i - 1) \\ 2 = 0 then
					k := cosine (f * 2.0 * pi_constant)
				else
					k := sine (f * 2.0 * pi_constant)
				end
				k := 2.0 * k * k
				if k < 0.25 then
					k := 0.25
				end

				r1.set_x (xpos)
				r1.set_y (ypos)
				r1.set_width ((iw * k).floor)
				r1.set_height ((ih * k).floor)

				r2.set_x (0)
				r2.set_y (0)
				r2.set_width (background_image.width)
				r2.set_height (background_image.height)
				if r1.intersect (r2, dest) then
					if (i - 1) \\ 2 = 1 then
						alpha := (255 * sine (f * 2.0 * pi_constant)).abs.floor
					else
						alpha := (255 * cosine (f * 2.0 * pi_constant)).abs.floor
					end
					if alpha < 127 then
						alpha := 127
					end
					foreground_images.item (i).composite (frame, dest.x, dest.y,
														  dest.width, dest.height,
														  xpos, ypos,
														  k, k,
														  gdk_interp_nearest,
														  alpha)
				end

				i := i + 1
			end

			drawing_area.queue_draw
			frame_number := frame_number + 1
			Result := True
		end

	on_expose_event (a_widget: GTK_WIDGET; a_event: GDK_EXPOSE_EVENT): BOOLEAN is
			-- Called when we need to redraw the drawing area
		local
			rowstride: INTEGER
			pixels: POINTER
		do
			pixels := frame.pixels
			rowstride := frame.rowstride

			a_widget.window.draw_rgb_image_dithalign (a_widget.style.black_gc,
													  0, 0, background_image.width, background_image.height,
													  gdk_rgb_dither_normal, pixels, rowstride,
													  0, 0)

				-- TODO: we really should only copy the area marked as invalid by `a_event.area'
			Result := True
		end

feature -- Implementation

	load_pixbufs is
			-- Load images into pixel buffers
		local
			i: INTEGER
			pixbuf: GDK_PIXBUF
		do
			background_image := gdk_pixbuf_factory.new_from_file_name (background_image_name)
			if background_image = Void then
				print ("Unable to load image " + background_image_name + "%N")
				Exceptions.die (1)
			end

			create foreground_images.make (1, foreground_image_names.count)
			from
				i := 1
			until
				i > foreground_image_names.count
			loop
				pixbuf := gdk_pixbuf_factory.new_from_file_name (foreground_image_names.item (i))
				if pixbuf /= Void then
					foreground_images.put (pixbuf, i)
				else
					print ("Unable to load image " + foreground_image_names.item (i) + "%N")
					Exceptions.die (1)
				end
				i := i + 1
			end
		end

feature -- Attributes

	window: GTK_WINDOW
			-- Wrapper for GTK window

	background_image: GDK_PIXBUF
			-- Background image

	foreground_images: ARRAY [GDK_PIXBUF]
			-- Foreground images

	frame: GDK_PIXBUF
			-- Double Buffer
			-- We use this buffer to draw our stuff into
			-- and then batch copy into the drawing area.
			-- This way we avoid flickering

	drawing_area: GTK_DRAWING_AREA
			-- The area of the top level window we can draw
			-- in

	Frame_delay: INTEGER is 50
			-- Delay between frame redrawings in milli seconds

	timeout_source: G_TIMEOUT_SOURCE
			-- Timer event source

	cycle_length: INTEGER is 60
			-- Length of one animation cycle

	frame_number: INTEGER
			-- Frame we currently are displaying

feature -- Constants

	background_image_name: STRING is "../../../resource/background.png"
			-- Name of background image

	foreground_image_names: ARRAY [STRING] is
			-- Name of foreground images
		once
			Result := <<"../../../resource/apple-red.png",
						"../../../resource/gnome-applets.png",
						"../../../resource/gnome-calendar.png",
						"../../../resource/gnome-foot.png",
						"../../../resource/gnome-gmush.png",
						"../../../resource/gnome-gimp.png",
						"../../../resource/gnome-gsame.png",
						"../../../resource/gnu-keys.png">>
		ensure
			foreground_image_names_not_void: foreground_image_names /= Void
		end

end
