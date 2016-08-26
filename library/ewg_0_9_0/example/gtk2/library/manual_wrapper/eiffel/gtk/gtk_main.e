indexing

	description:

		"Provides routines to manage the GTK main loop."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.5 $"

class GTK_MAIN

inherit

	ANY

	GTKMAIN_FUNCTIONS_EXTERNAL
		export {NONE} all end

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export {NONE} all end

	KL_SHARED_ARGUMENTS
		export {NONE} all end

creation {GTK_SHARED_MAIN}

	make

feature {NONE} -- Initialization

	make is
		do
		end

feature {ANY} -- Status

	is_toolkit_initialized: BOOLEAN
			-- Has the GTK toolkit been sucessfully initialized?
			-- Only if `is_toolkit_initialized' is `True' you may
			-- call GTK routines other than `initialize_toolkit',
			-- `initialize_toolkit_and_exit_on_error' and `set_locale'.

	environment_locale: STRING
			-- Name of the locale the enironment is configured to.
			-- This string will be set by `set_locale'.

feature {ANY} -- Initialization

	set_locale is
			-- Sets the current locale according to the program environment.
			-- This is the same as calling the libc function
			-- setlocale(LC_ALL, "") but also takes care of the locale specific
			-- setup of the windowing system used by GDK.
			-- You should call this function before `initialize_toolkit' to
			-- support internationalization of your GTK+ applications.
			-- NOTE: This routine also sets `environment_locale' to contain the
			-- name of the locale set.
		require
			toolkit_is_not_initialized: not is_toolkit_initialized
		local
			p: POINTER
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			p := gtk_set_locale_external
			create cstr.make_shared (p)
				-- `cstr.item' will be freed by GTK on exit.
			environment_locale := cstr.string
		ensure
			environment_locale_not_void: environment_locale /= Void
		end

	initialize_toolkit is
			-- This routine does the same work as `initialize_toolkit_and_exit_on_error'
			-- with only a single change: It does not terminate the program if the GUI
			-- can't be initialized. Instead it sets `is_toolkit_initialized' to `False' on failure.
			-- If it succesfully initialized the toolkit, it will set `is_toolkit_initialized' to `True'.
			-- This way the application can fall back to some other means of communication with the user
			-- for example a curses or command line interface.
		require
			toolkit_not_yet_initialized: not is_toolkit_initialized
		local
			i: INTEGER
		do
			create_argv_and_argc
			i := gtk_init_check_external (argument_count_pointer.item, argument_vector_pointer_pointer.item)
			if i = 1 then
				is_toolkit_initialized := True
			end
		end

	initialize_toolkit_and_exit_on_error is
			-- Call this function before using any other GTK functions
			-- in your GUI applications. It will initialize everything
			-- needed to operate the toolkit and parses some standard
			-- command line options.
			-- NOTE: This routine will terminate your program if it was
			-- unable to initialize the GUI for some reason. If you want
			-- your program to fall back to a textual interface you want
			-- to call `initialize_toolkit' instead.
			-- TODO: Pass real command line arguments and make the modified (origninal
			-- arguments minus gtk arguments) available.
		require
			toolkit_not_yet_initialized: not is_toolkit_initialized
		do
			create_argv_and_argc
			gtk_init_external (argument_count_pointer.item, argument_vector_pointer_pointer.item)
			is_toolkit_initialized := True
		ensure
			toolkit_is_initialized: is_toolkit_initialized
		end

feature {ANY} -- Termination

	exit (a_error_code: INTEGER) is
			-- Terminate the program and return `a_error_code' to the caller.
			-- This routine will shut down the GUI and free all resources allocated
			-- The meaning of `a_error_code' is dependend on the target system
			-- but at least on Unix systems `0' means success
		require
			toolkit_is_initialized: is_toolkit_initialized
		do
			gtk_exit_external (a_error_code)
		end

feature {ANY} -- Main Loop

	run_main_loop is
			-- Runs the main loop until `quit_main_loop' is called. You can nest
			-- calls to `run_main_loop'. In that case `quit_main_loop' will make
			-- the innerst invocation of the main loop return.
		require
			toolkit_is_initialized: is_toolkit_initialized
		do
			gtk_main_external
		end

	quit_main_loop is
			-- Makes the innermost invocation of the main loop return when it regains control.
		require
			toolkit_is_initialized: is_toolkit_initialized
		do
			gtk_main_quit_external
		end

feature {ANY} -- Status queries

	current_event_time: INTEGER is
			-- If there is a current event and it has a timestamp,
			-- return that timestamp, otherwise return GDK_CURRENT_TIME (TODO: what is this?).
		do
			Result := gtk_get_current_event_time_external
		end


feature {NONE} -- Implementation

	argument_count_pointer: EWG_MANAGED_POINTER
			-- argc pointer
	argument_vector_pointer: EWG_POINTER_ARRAY
			-- argv pointer
	argument_vector_pointer_pointer: EWG_MANAGED_POINTER
			-- argv pointer pointer
	argument_c_string_list: DS_LINKED_LIST [EWG_ZERO_TERMINATED_STRING]
			-- list object to store refrences to c string
			-- so they wont be collected to early


	create_argv_and_argc is
		local
			i: INTEGER
			cstr: EWG_ZERO_TERMINATED_STRING
				-- temporary string object to convert eiffel to c strings
		do
			-- TODO: Me thinks, we need to create all this memory unshared,
			-- but when I do so, ISE crashes in debug mode...
			create argument_count_pointer.make_new_shared (external_memory.sizeof_int_external)
			argument_count_pointer.put_integer (Arguments.argument_count + 1, 0)
			create argument_vector_pointer.make_new_shared (Arguments.argument_count + 1)
			create argument_c_string_list.make
			from
				i := 0
			until
				i > Arguments.argument_count
			loop
				create cstr.make_shared_from_string (Arguments.argument (i))
				argument_c_string_list.put_last (cstr)
				argument_vector_pointer.put (cstr.item, i)
				i := i + 1
			end
			create argument_vector_pointer_pointer.make_new_shared (external_memory.sizeof_pointer_external)
			argument_vector_pointer_pointer.put_pointer (argument_vector_pointer.array_address, 0)
		ensure
			argument_count_pointer_not_void: argument_count_pointer /= Void
			argument_vector_pointer_not_void: argument_vector_pointer /= Void
			argument_c_strings_list_not_void: argument_c_string_list /= Void
		end

end
