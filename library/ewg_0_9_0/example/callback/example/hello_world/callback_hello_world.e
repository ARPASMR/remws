indexing

	description:

		"Example demonstrating the use of callbacks"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/07/13 17:48:11 $"
	revision: "$Revision: 1.7 $"

class CALLBACK_HELLO_WORLD

inherit

	CALLBACK_FUNCTIONS_EXTERNAL
		export {NONE} all end

	EWG_CALLBACK_CALLBACK_C_GLUE_CODE_FUNCTIONS_EXTERNAL
		export {NONE} all end

	SAMPLE_CALLBACK_TYPE_CALLBACK

creation

	make

feature

	make is
		local
			function_table: FUNCTION_TABLE_STRUCT
			i: INTEGER
		do
				-- Create the callback dispatcher and
				-- tell him to dispatch calls to `Current.on_callback'
				-- Note that there must be at most one dispatcher object
				-- per callback type in every system.
				-- It is a good idea to make it a singleton.
			create dispatcher.make (Current)
				-- Trigger a callback event without the dispatcher connected
				-- to the c library. You will notice that `on_callback'
				-- will not be called.
			trigger_event_external (27)
				-- Now lets register the dispatcher with the c library.
			register_callback_external (dispatcher.c_dispatcher, Default_pointer)
				-- This time the triggering will yield a call to `on_callback'.
			trigger_event_external (28)

				-- This demonstrates how to call function pointers as members of structs
				-- Get a struct with a function pointer member
			create function_table.make_shared (get_function_table_external)
				-- Call it using the appropriate caller
			i := call_int_int_int_anonymous_callback_external (function_table.callme, 7, 10)
				-- The c function we called should have added the integers
			print ("result of callme: " + i.out + "%N")
		end

	dispatcher: SAMPLE_CALLBACK_TYPE_DISPATCHER
			-- The dispatcher is on the one side connected to a C function,
			-- that can be given to the C library as a callback target
			-- and on the other hand to an Eiffel object with a feature
			-- `on_callback'. Whenn its C function gets called, the dispatcher
			-- calls `on_callback' in the connected Eiffel object


	on_callback (a_data: POINTER; a_event_type: INTEGER) is
			-- Callback target. This feature gets called
			-- anytime somebody calls `trigger_event_external'
		do
			print ("on_callback has been called with: " + a_data.out + ", " + a_event_type.out + "%N")
		end

end
