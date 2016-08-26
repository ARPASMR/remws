note
	description : "eschedulerd application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	ESCHEDULERD

inherit

	EXCEPTIONS

	POSIX_SIGNAL_HANDLER

    POSIX_CONSTANTS
        export
            {NONE} all
        end

	POSIX_DAEMON

	SOCKET_RESOURCES

	ARGUMENTS

	STORABLE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			system: SUS_SYSTEM
		do

			print ("eschedulerd application%N")
			create system
			create address_factory
			print ("Running on " + system.host_name)
			print (" at " + address_factory.create_from_name (system.host_name).host_address + "%N")

			create_preferences
			load_preferences
			setup_logger
			create_schedulers

			preferences.save_preferences

			-- Register start date time
			create start_date_time.make_now
			create scheduler.make

			if argument_count = 1 and then argument (1).is_equal("-d") then
            	detach
            else
                execute
            end

			print("Main process pid: " + pid.out + " >> " + start_date_time.formatted_out ("yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss.ff<6>") + "%N")
			print("Last child pid:   " + last_child_pid.out + " >> " + start_date_time.formatted_out ("yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss.ff<6>") + "%N")

		end

feature -- Status

     is_exit: BOOLEAN
             -- Should we exit?

feature {NONE} -- Callbacks

     signalled (signal_value: INTEGER)
     		-- We received a signal.
        do
        	if signal_value = SIGTERM then
            	is_exit := True
            end
     end

feature -- Operations

	execute
			--
		local
			now:            DATE_TIME
			dt:             DATE_TIME_DURATION
            signal_handler: POSIX_SIGNAL
            client:         NETWORK_STREAM_SOCKET
		do
			create signal_handler.make (SIGTERM)
			signal_handler.set_handler (Current)
            signal_handler.apply

			create now.make_now
			create dt.make_definite (0, 0, 0, 1)

			print("Start date time: " + start_date_time.formatted_out ("yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss.ff<6>") + "%N")
			print("Log path:        " + log_path_preference.value + "%N")
			print("Listening on:    " + command_port_preference.value.out + "%N")

			create command_channel.make_server_by_port (command_port_preference.value)
			command_channel.listen (5)

			from

            until
            	false
            loop

                client := accept

                from

                until
                	client = Void or client.is_closed
                loop
                	process_command (client) -- See below
                end
            end
        rescue
            if command_channel /= Void then
                command_channel.cleanup
            end
		end

	accept: NETWORK_STREAM_SOCKET
			--
		do
			command_channel.accept
			if attached command_channel.accepted as sock then
				io.put_string ("Connection accepted: " +
								sock.address.host_address.host_address + ":" +
							    sock.address.port.out + " on " +
								sock.address.host_address.host_name + "%N")
				Result := sock
			end
		end

	process_command (sock: NETWORK_STREAM_SOCKET)
            -- Receive a message
        local
        	failed:  BOOLEAN
        	msg:     detachable MESSAGE
        	process: EPX_EXEC_PROCESS
        do
            if( not failed ) then
                if attached {MESSAGE} sock.retrieved as new_msg then
                    io.putstring ("Received message: " + new_msg.out)
                    io.new_line

                    inspect new_msg.type
                    when {MESSAGE_TYPES}.noop then
						-- not yet implemented
					when {MESSAGE_TYPES}.start_scheduler then
						-- not yet implemented
						raise("Not yet implemented")
					when {MESSAGE_TYPES}.stop_scheduler then
						sock.cleanup
					when {MESSAGE_TYPES}.put then
						if attached {TASK} new_msg.task then
							scheduler.put (new_msg.task)
						end
					when {MESSAGE_TYPES}.remove then
						if attached {TASK} new_msg.task then
							scheduler.remove (new_msg.task)
						end
					when {MESSAGE_TYPES}.update then
						if attached {TASK} new_msg.task then
							scheduler.replace (new_msg.task)
						end
					when {MESSAGE_TYPES}.list then
						-- not yet implemented
						raise("Not yet implemented")
					when {MESSAGE_TYPES}.execute then
						create process.make_capture_output (new_msg.command, <<"-1", ".">>)
                    	--create process.make_from_command_line (msg.command)
                    	print("Arguments count: " + process.argument_count.out + "%N")
                    	process.execute
                    	print("Process pid: " + process.pid.out + "%N")
                    	from
							process.fd_stdout.read_string (512)
						until
						process.fd_stdout.end_of_input
						loop
							print (process.fd_stdout.last_string)
							process.fd_stdout.read_string (512)
						end
						-- close captured io
						process.fd_stdout.close
						-- wait for process
						process.wait_for (true)
                    	print(new_msg.command + " exit code: " + process.exit_code.out + "%N")
					when {MESSAGE_TYPES}.abort then
						if attached {TASK} new_msg.task then
							if new_msg.task.is_running then
								-- not yet implemented
							end
						end
					when {MESSAGE_TYPES}.change_priority then
						-- not yet implemented
					when {MESSAGE_TYPES}.take_online then
						if attached {TASK} new_msg.task then
							scheduler.search (new_msg.task)
							if attached {TASK} scheduler.found then
								scheduler.found.take_online
							end
						end
					when {MESSAGE_TYPES}.take_offline then
						if attached {TASK} new_msg.task then
							scheduler.search (new_msg.task)
							if attached {TASK} scheduler.found then
								scheduler.found.take_online
							end
						end
                    else
						io.put_string ("Invalid message received")
                		io.put_new_line
                    end
                else
					io.put_string ("Not a message")
                	io.put_new_line
                end
            end

            rescue
        	    io.put_string ("Exception code: " + exception.out + "%N")

			    if( assertion_violation ) then
				    io.put_string ("Assertion violation:" + original_class_name + ": " + original_exception.out + " " + recipient_name)
			    else
			    	if( is_developer_exception ) then
				    	io.put_string ("Developer exception: " + original_class_name + ": " + original_exception.out + " " + recipient_name)
			    	else
			    		if( is_system_exception ) then
				    		io.put_string ("System exception:" + original_class_name + ": " + original_exception.out + " " + recipient_name)
			    		else
			    			if( is_signal ) then
				    			io.put_string ("Signal:" + signal_code.out + " " + original_class_name + ": " + original_exception.out + " " + recipient_name)
			    			end
			    		end
			    	end
			    end

			    io.put_new_line

			    inspect exception
			    when io_exception then
			    	io.put_string ("IO exception")
			    when retrieve_exception then
			    	io.put_string ("Retrieve exception")
			    when runtime_io_exception then
			    	io.put_string ("Runtime IO exception")
			    else
			    	io.put_string ("Unknown exception")
			    end

				io.put_new_line
				io.put_string (original_class_name + ": " + original_exception.out + " " + recipient_name)
			    io.put_new_line

			    sock.close
			    sock.cleanup

			    failed := true
			    retry
        end


feature {NONE} -- Implementation

	scheduler:           SCHEDULER
	logger:              LOG_LOGGING_FACILITY
	writer:              LOG_WRITER_FILE
	start_date_time:     DATE_TIME

	schedulers:          ARRAY[SCHEDULER]

	setup_logger
			--
		local
			filename: FILE_NAME
		do
			create filename.make_from_string ("/home/buck/eschedulerd.log")
			create writer
			create logger.make

			writer.set_file_name (filename)
			logger.register_log_writer (writer)
			logger.write_information ("eschedulerd started%N")
		end

	host_name: STRING
			-- Get host name
		local
			system: SUS_SYSTEM
		once
			create system
			Result := system.host_name
		end

	create_schedulers
			-- Create and populate `schedulers'.
		do
			create schedulers.make_empty
			load_schedulers
		ensure
			schedulers_initialized: schedulers /= Void
		end

	load_schedulers
			-- Load known scheduler servers from schedulerdb
		do

		end


feature {NONE} -- Database  access

	db:              DATABASE_APPL[MYSQL]
	session_control: DB_CONTROL
	modification:    DB_CHANGE


feature {NONE} -- Network communication

	address_factory: INET_ADDRESS_FACTORY
	command_channel: detachable NETWORK_STREAM_SOCKET

feature {NONE} -- Preferences

	preferences_storage:          PREFERENCES_STORAGE_XML
	preferences:                  PREFERENCES
	preference_manager:           PREFERENCE_MANAGER
	preference_factory:           BASIC_PREFERENCE_FACTORY

	log_path_preference:          STRING_PREFERENCE
	command_port_preference:      INTEGER_PREFERENCE
	database_preference:          STRING_PREFERENCE
	database_server_preference:   STRING_PREFERENCE
	database_user_preference:     STRING_PREFERENCE
	database_password_preference: STRING_PREFERENCE

	create_preferences
			--
		do
			create preferences_storage.make_with_location ("/home/buck/pref.xml")
			create preferences.make_with_storage (preferences_storage)
			preference_manager := preferences.new_manager ("shman")
			create preference_factory
		end

	load_preferences
			--
		require
			storage_not_void:            preferences_storage /= void
			preferences_not_void:        preferences         /= Void
			preference_manager_not_void: preference_manager  /= Void
			preference_factory_not_void: preference_factory  /= Void
		do
			log_path_preference          := preference_factory.new_string_preference_value (preference_manager,  "log_path",          "~/eschedulerd.log")
			command_port_preference      := preference_factory.new_integer_preference_value (preference_manager, "command_port",      6250)
			database_preference          := preference_factory.new_string_preference_value (preference_manager,  "database",          "schedulerdb")
			database_server_preference   := preference_factory.new_string_preference_value (preference_manager,  "database_server",   "127.0.0.1")
			database_user_preference     := preference_factory.new_string_preference_value (preference_manager,  "database_user",     "root")
			database_password_preference := preference_factory.new_string_preference_value (preference_manager,  "database_password", "")
		end


end
