indexing

	description:

		"SDL Hello World Example"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/18 01:07:11 $"
	revision: "$Revision: 1.5 $"

class SDL_HELLO_WORLD

inherit

	KL_SHARED_EXCEPTIONS
		export
			{NONE} all
		end
	
	SDL_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	SDL_VIDEO_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	
	SDL_IMAGE_FUNCTIONS
		export
			{NONE} all
		end
	
	SDL_TIMER_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	STDLIB_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

creation

	make
	
feature

	make is
			-- Creates an SDL window and displays
			-- an image in it. Waits a bit and quits.
		local
			i: INTEGER
			p: POINTER
		do
				-- Initialise SDL for video support
			i := sdl_init_external (Sdl_init_video)
			if i < 0 then
				print ("Unable to init SDL%N")
				Exceptions.die (1)
			end

				-- Register the function `SDL_Quit' to
				-- be called when the application quits.
			i := atexit_external (sdl_quit_address_external)
			if i /= 0 then
				print ("Unable to register SDL_Quit%N")
				Exceptions.die (1)
			end

				-- Set the video mode
			p := sdl_set_video_mode_external (640, 480, 16, Sdl_swsurface)
			if p = default_pointer then
				print ("Unable to set 640x480 video%N")
				Exceptions.die (1)
			end

				-- Create C structure wrapper to hold a display handle
			create display.make_unshared (p)

				-- Load the Image into a image buffer
			p := img_load (image_file_name)
			if p = default_pointer then
				print ("Couldn't load " + image_file_name + "%N")
				Exceptions.die (1)
			end

				-- Create a structure wrapper from the returned image handle.
				-- We create it unshared, because we are free to free this
				-- structure anytime we want (usually when `image' gets collected)
			create image.make_shared (p)

				-- Copy the image into our display buffer
			i := sdl_upper_blit_external (image.item, default_pointer, display.item, default_pointer)

				-- Display the display buffer on the screen
			i := sdl_flip_external (display.item)

				-- Give the user some time to look at the image
			sdl_delay_external (3000)
			
				-- Free the image buffer
			sdl_free_surface_external (image.item)

				-- We do not need to explicitly free resources wrapped by
				-- `c_string' or `display'. The wrappers were created in
				-- the 'unshared' mode. Which makes the wrappers responsible
				-- for freeing them.
		end

	display: SDL_SURFACE_STRUCT
			-- Struct wrapper for an SDL display handle

	image: SDL_SURFACE_STRUCT
			-- Struct wrapper for an SDL image handle

feature {NONE} -- macro constants (not yet generated)
	
	Sdl_init_video: INTEGER is 32

	Sdl_swsurface: INTEGER is 0

feature {NONE}

	image_file_name: STRING is "../../../resource/tux.jpg"
			-- Name of image we want to display

end
