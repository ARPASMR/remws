indexing

	description:

		"SDL Timer Example"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 21:42:24 $"
	revision: "$Revision: 1.1 $"

class SDL_TIMER_DEMO

inherit

	KL_SHARED_EXCEPTIONS
		export
			{NONE} all
		end
	
	SDL_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	SDL_TIMER_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	SDL_NEW_TIMER_CALLBACK_CALLBACK
	
creation

	make
	
feature

	make is
		local
			i: INTEGER
			p: POINTER
		do
			create timer_dispatcher.make (Current)
			i := sdl_init_external (Sdl_init_timer)
			if i < 0 then
				print ("Unable to init SDL%N")
				Exceptions.die (1)
			end

			p := sdl_add_timer_external (100, timer_dispatcher.c_dispatcher, Default_pointer)
			if p = Default_pointer then
				print ("Could not create timer%N")
			end

			from
			until
				counter >= Max_counter
			loop
				sdl_delay_external (50)
			end

			i := sdl_remove_timer_external (p)
			if i = 0 then
				print ("could not remove timer%N")
			end
		end

feature {NONE} -- Implementation

	timer_dispatcher: SDL_NEW_TIMER_CALLBACK_DISPATCHER

	counter: INTEGER

	Max_counter: INTEGER is 10

feature {SDL_NEW_TIMER_CALLBACK_DISPATCHER} -- Callback

	on_callback (interval: INTEGER; param: POINTER): INTEGER is 
		do
			print ("timer " + interval.out + ", " + param.out + ", " + counter.out + "%N")
			Result := interval
			counter := counter + 1
		end


feature {NONE} -- macro constants (not yet generated)
	
	Sdl_init_timer: INTEGER is 1

end
