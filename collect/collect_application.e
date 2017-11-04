note
	description : "collect application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	COLLECT_APPLICATION

inherit
	MSG_CONSTANTS
	ERROR_CODES
	EXCEPTIONS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line,
			launch as env_launch,
			arguments as environment_arguments
		end
	PROCESS_INFO_IMP
		rename
			command_line as env_command_line,
			launch as env_launch
		end
	ARGUMENTS
	LOG_PRIORITY_CONSTANTS
	LOGGING_I
	DEFAULTS
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end
	MEMORY
		redefine
			dispose
		end
	UNIX_SIGNALS
		rename
			meaning as sig_meaning,
			catch   as sig_catch,
			ignore  as sig_ignore
		end
	SYSLOG_UNIX_OS
		rename
			log_alert as syslog_alert,
			log_warning as syslog_warning,
			log_notice as syslog_notice,
			log_debug as syslog_debug
		export
			{COLLECT_APPLICATION} all
		redefine
			dispose
		end

create
	make_and_launch

feature {NONE} -- Initialization

	init
			-- internal initialization
		do
			catch_signals

			init_gc

			init_format_integer

			create session.make ("")

			-- login management
			is_logged_in := false
			create login_request.make
			create logout_request.make
			create login_response.make
			create logout_response.make

			create content_type.make_empty
			create token.make
			create error_message.make_empty

			read_credentials

			-- Parsing
			create xml_parser_factory
			xml_parser := xml_parser_factory.new_standard_parser
			create json_parser.make_with_string ("{}")

			-- Up time
			start_time := create {DATE_TIME}.make_now

			-- Check DLTS
			one_hour  := create {DATE_TIME_DURATION}.make (0, 0, 0, 1, 0, 0)

			-- syslog
			open_log ("collect", log_pid, log_user)
		end

	initialize
			-- Initialize current service
		local
			idx:  INTEGER
		do
			init
			init_log

			log_display("Collect application started @ " + start_time.formatted_out(default_date_time_format), log_information, true, true, true)

			idx := index_of_word_option ("h")
			if idx > 0 then
				usage
				die (0)
			end

			idx := index_of_word_option ("p")
			if idx > 0 then
				port := argument (idx + 1).to_integer
			else
				port := default_port
			end
			set_service_option ("port", port)

			idx := index_of_word_option ("fst")
			if idx > 0  then
				set_service_option ("force_single_threaded", true)
			end

			idx := index_of_word_option ("l")
			if idx > 0 then
				log_level := argument (idx + 1).to_integer
				if     log_level = log_debug       then file_logger.enable_debug_log_level          -- 7
				elseif log_level = log_information then file_logger.enable_information_log_level    -- 6
				elseif log_level = log_notice      then file_logger.enable_notice_log_level         -- 5
				elseif log_level = log_warning     then file_logger.enable_warning_log_level        -- 4
				elseif log_level = log_error       then file_logger.enable_error_log_level          -- 3
				elseif log_level = log_critical    then file_logger.enable_critical_log_level       -- 2
				elseif log_level = log_alert       then file_logger.enable_alert_log_level          -- 1
				elseif log_level = log_emergency   then file_logger.enable_emergency_log_level      -- 0
				else
					file_logger.enable_error_log_level -- 3
				end
			else
				log_level := log_error
				file_logger.enable_error_log_level -- 3
			end

			idx := index_of_word_option ("t")
			if idx > 0 then
				use_testing_ws := true
			else
				use_testing_ws := false
			end

			idx := index_of_word_option ("u")
			if idx > 0 then
				is_utc_set := true
			else
				is_utc_set := false
			end

			idx := index_of_word_option ("v")
			if idx > 0 then
				set_service_option ("verbose", true)
			end

			idx := index_of_word_option ("gcm")
			if idx > 0 then
				is_gc_monitoring_active := true
				gc_monitoring_message_number := argument (idx + 1).to_integer
			else
				is_gc_monitoring_active := false
				gc_monitoring_message_number := default_gc_monitoring_message_number
			end

			-- must check if `COLLECT_APPLICATION' is logged in remws
			if not is_logged_in then
				-- do login
				if not do_login then
					log_display ("FATAL error: unable to login", log_critical, true, true, true)
					die(0)
				else
					is_logged_in := true
					log_display ("logged in with token " +
					             token.id +
					             " expiring upon " +
					             token.expiry.formatted_out (default_date_time_format),
					             log_information, true, true, false)
				end
			end
		end

	init_gc
			-- GC settings
		do
			-- garbage collection
			allocate_compact
			set_memory_threshold (40000000)
			set_max_mem (160000000)
			set_collection_period (1)
			set_coalesce_period (2)
			collection_on
		end

	init_format_integer
			-- Initialize `format_integer'
		do
			create format_integer.make (2)
			format_integer.zero_fill
		ensure
			format_integer_attached: attached format_integer
		end

feature -- Usage

	usage
			-- little help on usage
		do
			print ("collect network remws gateway%N")
			print ("Agenzia Regionale per la Protezione Ambientale della Lombardia%N")
			print ("collect [-p <port_number>][-l <log_level>][-gcm <message_number][-fst][-t][-u][-v][-h]%N%N")
			print ("%T<port_number>    is the network port on which collect will accept connections%N")
			print ("%T<log_level>      is the logging level that will be used%N")
			print ("%T<message_number> check GC parameters every message_number messages")
			print ("%T-gcm             activate GC monitoring%N")
			print ("%T-fst             force Nino single threaded%N")
			print ("%T-t               uses the testing web service%N")
			print ("%T-u               the box running collect is in UTC%N")
			print ("%T-v               nino verbose%N")
			print ("%T-h               prints this text%N")
			print ("%TThe available logging levels are:%N")
			print ("%T%T " + log_debug.out       + " --> debug-level messages%N")
			print ("%T%T " + log_information.out + " --> informational%N")
			print ("%T%T " + log_notice.out      + " --> normal but significant condition%N")
			print ("%T%T " + log_warning.out     + " --> warning conditions%N")
			print ("%T%T " + log_error.out       + " --> error conditions%N")
			print ("%T%T " + log_critical.out    + " --> critical conditions%N")
			print ("%T%T " + log_alert.out       + " --> action must be taken immediately%N")
			print ("%T%T " + log_emergency.out   + " --> system is unusable%N%N")
		end

feature -- Credentials

	username:      detachable STRING
	password:      detachable STRING
	cfg_file:      PLAIN_TEXT_FILE
	cfg_file_name: STRING = "credentials.conf"

	cfg_file_path: STRING
			-- format cfg file name full path
		do
			create Result.make_empty
			if attached home_directory_path as l_home then
				Result := l_home.out + "/.collect/" + cfg_file_name
			end
		end

	read_cfg
			-- Trivial config file --> switch to preferences library
		do
			cfg_file.open_read

			cfg_file.read_line
			username := cfg_file.last_string
			cfg_file.read_line
			password := cfg_file.last_string

			cfg_file.close
		end

	read_credentials
			-- Read wsrem credentials from file
		local
			l_path: detachable STRING
		do
			if not cfg_file_path.is_empty then
				l_path := cfg_file_path
			else
				l_path := "/etc/collect/credentials.conf"
			end

			create cfg_file.make_with_name (l_path)

			read_cfg
		end

feature -- Logging

	init_log
			-- Initialize log on file
		local
			path: detachable STRING
			home: detachable STRING
		do
			create path.make_from_string ("$HOME/log/collect.log")
			create home.make_empty

			if attached item("HOME") as s_h then
				if not s_h.is_empty then
					home.copy (s_h.to_string_8)
					path.replace_substring_all ("$HOME", home)
				end
			else
				path.copy ("/var/log/collect.log")
			end

			create log_path.make_from_string (path)
			create logger.make
			create file_logger.make_at_location (log_path)
			file_logger.set_max_backup_count (10)
			file_logger.set_max_file_size ({NATURAL_64}1 * 1024 * 1024 * 1024)
			file_logger.enable_debug_log_level
			if attached logger as l_logger then
				l_logger.register_log_writer (file_logger)
				log_display ("Log system initialized", log_information, true, true, false)
			end
		end

	is_logging_enabled: BOOLEAN
			-- Is logging enabled
		do
			Result := attached logger
		end

	log (a_string: STRING; priority: INTEGER)
			-- Logs `a_string'
		do
			if attached logger as l_logger then
				if priority = log_debug then l_logger.write_debug (a_string)
					elseif priority = log_emergency   then l_logger.write_emergency (a_string)
					elseif priority = log_alert       then l_logger.write_alert (a_string)
					elseif priority = log_critical    then l_logger.write_critical (a_string)
					elseif priority = log_error       then l_logger.write_error (a_string)
					elseif priority = log_information then l_logger.write_information (a_string)
					elseif priority = log_notice      then l_logger.write_notice (a_string)
					elseif priority = log_warning     then l_logger.write_warning (a_string)
				end
			end
		end

	log_display(a_string: STRING; priority: INTEGER; to_file, to_display, to_syslog: BOOLEAN)
			-- Combined file and display log
		do
			if to_file then
				log (a_string, priority)
			end
			if to_display then
				io.put_string (a_string)
				io.put_new_line
			end
			if to_syslog then
				sys_log (priority, a_string)
			end
		end

	log_gc_parameters
			-- log/display GC parameters
		local
			l_mem_stat: detachable MEM_INFO
			l_gc_stat:  detachable GC_INFO
		do
			if is_gc_monitoring_active then
				log_display ("Checking GC parameters ...", log_debug, true, true, false);

				l_mem_stat := memory_statistics (Total_memory)
				l_gc_stat  := gc_statistics (total_memory)

				log_display ("Displaying GC parameters ...", log_debug, true, true, false);

				log_display ("MEMORY STATISTICS " + msg_number.out,              log_alert, true, true, false)
				log_display ("Total 64:       "   + l_mem_stat.total64.out,      log_alert, true, true, false)
				--log_display ("Total memory:   "   + l_mem_stat.total_memory.out, log_alert, true, true)
				log_display ("Free 64:        "   + l_mem_stat.free64.out,       log_alert, true, true, false)
				log_display ("Used 64:        "   + l_mem_stat.used64.out,       log_alert, true, true, false)


				log_display ("GC STATISTICS   "   + msg_number.out,              log_alert, true, true, false)
				log_display ("Collected:      "   + l_gc_stat.collected.out,     log_alert, true, true, false)
				log_display ("Total memory:   "   + l_gc_stat.total_memory.out,  log_alert, true, true, false)
				log_display ("Eiffel memory:  "   + l_gc_stat.eiffel_memory.out, log_alert, true, true, false)
				log_display ("Memory used:    "   + l_gc_stat.memory_used.out,   log_alert, true, true, false)

				--log_display ("C memory:       "   + l_gc_stat.c_memory.out,      log_alert, true, true)
				log_display ("Cycle count:    "   + l_gc_stat.cycle_count.out,   log_alert, true, true, false)

				log_display ("GC collection parameters displaying end ...", log_debug, true, true, false);
			end
		end


feature -- Basic operations

	parse_header (json: STRING): INTEGER
			-- Search message header for message id
		require
			json_parser_attached: attached json_parser
		local
			key: detachable JSON_STRING
		do
			json_parser.reset_reader
			json_parser.reset
			json_parser.set_representation (json)

			create key.make_from_string ("header")
			json_parser.parse_content
			if json_parser.is_valid and then attached json_parser.parsed_json_value as jv then
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_header
					and then attached {JSON_NUMBER} j_header.item ("id") as j_id
				then
					log_display ("message id: " + j_id.integer_64_item.out, log_debug, true, false, false)
					Result := j_id.integer_64_item.to_integer
				else
					log_display ("The message header was not found!", log_error, true, true, true)
					log_display ("%TThis is probably not a valid message.", log_error, true, true, true)
					error_code    := {ERROR_CODES}.err_invalid_json
					error_message := {ERROR_CODES}.msg_invalid_json
				end
			else
				log_display ("json parser is not valid!!!", log_critical, true, true, true)
				if json_parser.has_error then
					log_display ("json parser error: " + json_parser.errors_as_string, log_critical, true, true, true)
				end
				error_code    := {ERROR_CODES}.err_no_json_parser
				error_message := {ERROR_CODES}.msg_no_json_parser
			end

			json_parser.reset_reader
			json_parser.reset
		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
	    local
	    	l_received_chars:   INTEGER
	    	l_msg_id:           INTEGER
	    	l_current_time:     detachable DATE_TIME

			request:            detachable STRING
    				-- Request as string
	    	response:           detachable STRING
    				-- Response as string

			req_obj:            detachable REQUEST_I
			res_obj:            detachable RESPONSE_I

			l_is_token_expired: BOOLEAN

		do
			log_display ("Entering execute ...", log_debug, true, true, false);
			create request.make (req.content_length_value.to_integer_32)
			create response.make_empty
			create l_current_time.make_now

			up_time := l_current_time.relative_duration (start_time)

			if attached up_time as l_up_time then
				log_display("UP TIME: " +
								l_up_time.day.out + ":" +
								format_integer.formatted (l_up_time.hour) + ":" +
								format_integer.formatted (l_up_time.minute) + ":" +
								format_integer.formatted (l_up_time.second), log_information, true, true, false)
			end

			log_display ("Checking UTC settings ...", log_debug, true, true, false);
			if is_utc_set then
				log_display ("time_offset     : " + one_hour.hour.out, log_debug, true, true, false);
				l_current_time := l_current_time + one_hour
			end

			l_is_token_expired := is_token_expired

			log_display ("is logged in    : " + is_logged_in.out, log_debug, true, true, false)
			log_display ("token id        : " + token.id, log_debug, true, true, false)
			log_display ("token expiry    : " + token.expiry.formatted_out (default_date_time_format), log_debug, true, true, false)
			log_display ("current time    : " + l_current_time.formatted_out (default_date_time_format), log_debug, true, true, false)
			log_display ("is token expired: " + l_is_token_expired.out, log_debug, true, true, false)

			log_display ("Checking token expiration ...", log_debug, true, true, false);
			if l_is_token_expired then
				--sleep (1000000000)
				sleep (500000000)
				login_response.reset

				if not do_login then
					log_display("Unable to login", log_error, true, true, true)
					log_display ("Outcome   : " + login_response.outcome.out, log_information, true, true, true)
					log_display ("Message   : " + login_response.message, log_information, true, true, true)
				else
					is_logged_in := true
					log_display ("logged in with new token " +
					             token.id +
					             " expiring upon " +
					             token.expiry.formatted_out (default_date_time_format),
					             log_information, true, true, false)
				end
				--sleep (1000000000)
				sleep (500000000)
			end

			-- read json input
			log_display ("Reading JSON input ...", log_debug, true, true, false);

			l_received_chars := req.input.read_to_string (request, 1, req.content_length_value.to_integer_32)
			log_display ("Received " + l_received_chars.out + " chars", log_debug, true, true, false)
			log_display(" <<< " + request, log_debug, true, false, false)
			-- parse the message header
			l_msg_id := parse_header (request)
			log_display ("Received message id: " + l_msg_id.out, log_debug, true, true, false)

			log_display ("Checking message type ...", log_debug, true, true, false);
			if l_msg_id = {REQUEST_I}.login_request_id then
				req_obj := create {LOGIN_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
					end
				end
			elseif l_msg_id = {REQUEST_I}.logout_request_id then
				req_obj := create {LOGOUT_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
					end
				end
			elseif l_msg_id = {REQUEST_I}.station_status_list_request_id then
				req_obj := create {STATION_STATUS_LIST_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Station status list", log_information, true, true, false)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true, false)
						log_display("Message message: " + myres.message, log_information, true, true, false)
					end
				end
			elseif l_msg_id = {REQUEST_I}.station_types_list_request_id then
				req_obj := create {STATION_TYPES_LIST_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Station types list", log_information, true, true, false)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true, false)
						log_display("Message message: " + myres.message, log_information, true, true, false)
					end
				end
			elseif l_msg_id = {REQUEST_I}.province_list_request_id then
				req_obj := create {PROVINCE_LIST_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Province list", log_information, true, true, false)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true, false)
						log_display("Message message: " + myres.message, log_information, true, true, false)
					end
				end
			elseif l_msg_id = {REQUEST_I}.municipality_list_request_id then
				req_obj := create {MUNICIPALITY_LIST_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Municipality list", log_information, true, true, false)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true, false)
						log_display("Message message: " + myres.message, log_information, true, true, false)
					end
				end
			elseif l_msg_id = {REQUEST_I}.station_list_request_id then
				req_obj := create {STATION_LIST_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
						--log ("**********%N" + l_response + "%N**********%N", log_debug)
						log_display("Sent message id: " + myres.id.out + " Station list", log_information, true, true, false)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true, false)
						log_display("Message message: " + myres.message, log_information, true, true, false)
					end
				end
			elseif l_msg_id = {REQUEST_I}.sensor_type_list_request_id then
				req_obj := create {SENSOR_TYPE_LIST_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Sensor types list", log_information, true, true, false)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true, false)
						log_display("Message message: " + myres.message, log_information, true, true, false)
					end
				end
			elseif l_msg_id = {REQUEST_I}.realtime_data_request_id then
				req_obj := create {REALTIME_DATA_REQUEST}.make
				if attached req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)

					res_obj := do_post (myreq)
					if attached res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Realtime data", log_information, true, true, false)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true, false)
						log_display("Message message: " + myres.message, log_information, true, true, false)
						--myres.dispose
					end
					--myreq.dispose
				end
			else
				if attached request as l_request then
					log_display ("********** BAD REQUEST " + l_request + " " + req.remote_addr + " " + req.request_uri, log_alert, true, true, true)
					l_request.wipe_out
				end

				log_display ("Resetting JSON parser", log_warning, true, true, true)
				json_parser.reset_reader
				json_parser.reset
				log_display ("JSON parser OK", log_warning, true, true, true)
			end

			log_display ("Returning HTTP status code ...", log_debug, true, true, false);
			if attached res as l_res then
				if l_msg_id /= 0 then
					if attached response as l_response then
						l_res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/json"], ["Content-Length", l_response.count.out]>>)
						log_display ("Returned HTTP status code: " + {HTTP_STATUS_CODE}.ok.out, log_debug, true, true, false)
					end
				else
					if attached response as l_response then
						l_res.put_header ({HTTP_STATUS_CODE}.bad_request, <<["Content-Type", "text/json"], ["Content-Length", l_response.count.out]>>)
						log_display ("Returned HTTP status code: " + {HTTP_STATUS_CODE}.bad_request.out + "Content-Length: " + l_response.count.out, log_error, true, true, false)
					end
				end
				if attached response as l_response then l_res.put_string (l_response) end
			else
				log_display ("UNABLE TO PARSE JSON REQUEST", log_error, true, true, true)
				json_parser.reset_reader
				json_parser.reset
			end
			if attached response as l_response then log_display (" >>> " + l_response, log_information, true, false, false) end

			msg_number := msg_number + 1
			log_display ("%T Managed message number " + msg_number.out, log_notice, true, true, false)

			log_display ("Checking message number ...", log_debug, true, true, false);

			if msg_number = {INTEGER}.max_value - 1 then
				msg_number := 1
				log_display ("Reset message counter to 1", log_notice, true, true, true)
			end

			log_display ("Message number checked", log_debug, true, true, false)

			if (msg_number \\ gc_monitoring_message_number) = 0 then
				log_gc_parameters
			end

			--log_display ("Wiping out request and response variables ...", log_debug, true, true);
			--if attached request  as l_request  then l_request.wipe_out  end
			--if attached response as l_response then l_response.wipe_out end
			log_display ("Exiting execute ...", log_debug, true, true, false)

		rescue
			log_display ("EXCEPTION raised", log_error, true, true, true)
			log_gc_parameters
			handle_signals
			sleep (100)
		end

feature -- dispose

	dispose
			-- `dispose' redefinition
		do
			Precursor {SYSLOG_UNIX_OS} ()
			Precursor {MEMORY} ()
		end

feature {NONE} -- Signals

	catch_signals
			-- Catch UNIX signals
		do
			sig_catch (sighup)
			sig_catch (sigint)
			sig_catch (sigsegv)
			sig_catch (sigkill)
			sig_catch (sigterm)
		end

	handle_signals
			-- Handle UNIX signals
		do
			if is_signal then
				if is_caught (sighup) then
					log_display ("SIGHUP "  + sighup.out  + " caught", log_emergency, true, true, true)
				elseif is_caught (sigint) then
					log_display ("SIGINT "  + sigint.out  + " caught", log_emergency, true, true, true)
				elseif is_caught (sigsegv) then
					log_display ("SIGSEGV " + sigsegv.out + " caught", log_emergency, true, true, true)
					log_display ("Dying ...", log_emergency, true, true, true)
					if do_logout then
						log_display ("Logged out", log_emergency, true, true, true)
					else
						log_display ("Unable to log out", log_emergency, true, true, true)
					end
					die(sigsegv)
				elseif is_caught (sigkill) then
					log_display ("SIGKILL " + sigkill.out + " caught", log_emergency, true, true, true)
					log_display ("Killing myself", log_emergency, true, true, true)
					if do_logout then
						log_display ("Logged out", log_emergency, true, true, true)
					else
						log_display ("Unable to log out", log_emergency, true, true, true)
					end
					die (sigkill)
				elseif is_caught (sigterm) then
					log_display ("SIGTERM " + sigterm.out + " caught", log_emergency, true, true, true)
				else
					log_display ("UNKNOWN signal caught", log_emergency, true, true, true)
				end
			end
		end

feature {NONE} -- Network IO

	session: LIBCURL_HTTP_CLIENT_SESSION


	post(a_request: REQUEST_I) : STRING
			-- Post `a_request' to remws using `LIBCURL_HTTP_CLIENT'
		local
			l_context: detachable HTTP_CLIENT_REQUEST_CONTEXT
			l_res: HTTP_CLIENT_RESPONSE
		do
			session.headers.wipe_out
			session.add_header ("content-type", "text/xml;charset=utf-8")
			session.add_header ("SOAPAction", a_request.soap_action_header)
			session.add_header ("Accept-Encoding", "gzip, deflate")
			if use_testing_ws then
				l_res := session.post (a_request.ws_test_url, l_context, a_request.to_xml)
			else
				l_res := session.post (a_request.ws_url, l_context, a_request.to_xml)
			end

			if attached l_res.body as r then
				Result := r
			else
				Result := ""
			end
		end


	do_post (a_request: REQUEST_I): RESPONSE_I
			-- Do a post to remws
			-- Parse the XML response
			-- Convert the response in json
		require
			a_request_attached: attached a_request
		local
			l_xml_str: detachable STRING
		do
			Result := a_request.init_response
			l_xml_str := post (a_request)

			log_display(" <<< " + l_xml_str, log_debug, true, false, false)

			if error_code /= 0 then
				Result.set_outcome (error_code)
				Result.set_message (error_message)
			else
				Result.from_xml (l_xml_str, xml_parser)
			end
			error_code := success
			error_message.wipe_out
		ensure
			result_attached: attached Result
		end

feature {NONE} -- Login management

	one_hour:    DATE_TIME_DURATION
			-- One hour fixed `DATE_TIME_DURATION'
	login_request: LOGIN_REQUEST
			-- The login request
	logout_request: LOGOUT_REQUEST
			-- The logout request
	login_response: LOGIN_RESPONSE
			-- The login response
	logout_response: LOGOUT_RESPONSE
			-- The logout response

	last_token_file_path: STRING
			-- last token file name full path
		do
			create Result.make_empty
			if attached home_directory_path as l_home then
				Result := l_home.out + "/.collect/last_token"
			end
		end

	is_token_expired: BOOLEAN
			-- Tells if `token' is expired
		require
			token_attached: attached token
		local
			l_current_dt: detachable DATE_TIME
		do
			log_display("Entering is_token_expired ...", log_debug, true, true, false)

			l_current_dt := create {DATE_TIME}.make_now_utc

			log_display("%Tis_token_expired: check day light time saving...", log_debug, true, true, false)
			log_display("%Tis_token_expired: check day light time saving done.", log_debug, true, true, false)
			log_display("%Tis_token_expired: checking if UTC is set ...", log_debug, true, true, false)
			if is_utc_set then
				Result := l_current_dt + one_hour > token.expiry
			else
				Result := l_current_dt > token.expiry
			end
			log_display("Exiting is_token_expired: Result = " + Result.out + " ...", log_debug, true, true, false)
			l_current_dt := Void
		end

	do_login: BOOLEAN
			-- Execute login
		require
			token_attached: attached token
		local
			l_xml_str:       detachable STRING
			last_token_file: detachable PLAIN_TEXT_FILE
		do
			if attached username as l_username and attached password as l_password then
				login_request.set_username (l_username)
				login_request.set_password (l_password)

				l_xml_str := post (login_request)
				log_display("do_login_response: " + l_xml_str, log_debug, true, false, false)
				login_response.from_xml (l_xml_str, xml_parser)

				log_display("login outcome: " + login_response.outcome.out, log_debug, true, true, false)
				log_display("login message: " + login_response.message,     log_debug, true, true, false)

				if login_response.outcome = success then
					token.id.copy (login_response.token.id)
					token.expiry.copy (login_response.token.expiry)
					--token := login_response.token
					if token.id.count > 0 then
						is_logged_in := true
						-- save token to text file
						create last_token_file.make_create_read_write (last_token_file_path)
						last_token_file.put_string (token.id)
						last_token_file.put_new_line
						last_token_file.put_string (token.expiry.formatted_out (default_date_time_format))
						last_token_file.put_new_line
						last_token_file.put_integer (process_id)
						last_token_file.put_new_line
						last_token_file.flush
						last_token_file.close
					else
						is_logged_in := false
					end
				else
					is_logged_in := false
				end
			else
				is_logged_in := False
			end

			Result := is_logged_in
		end

	do_logout: BOOLEAN
			-- Execute logout
		local
			l_xml_str: detachable STRING
		do
			if attached token as l_token then
				--logout_request.token_id.copy (token.id)
				logout_request.set_token_id (token.id)

				l_xml_str := post (logout_request)
				log_display("do_logout response " + l_xml_str, log_debug, true, false, false)

				log_display("login outcome: " + logout_response.outcome.out, log_debug, true, true, false)
				log_display("login message: " + logout_response.message,     log_debug, true, true, false)

				logout_response.from_xml (l_xml_str, xml_parser)

				Result := logout_response.outcome = success
			else
				Result := false
			end

		end

	error_code:     INTEGER
			-- Post error code
	error_message:  STRING
			-- Post error message
	use_testing_ws: BOOLEAN
			-- Must use the testing web service

	internal_error: ERROR_RESPONSE do create Result.make end


feature -- Attributes

	port:         INTEGER
			-- Listening port
	log_level:    INTEGER
			-- Log level
	content_type: STRING

	is_logged_in: BOOLEAN
			-- is collect logged in remws?
	is_utc_set:   BOOLEAN
			-- is the running box in UTC?
	token:        TOKEN
			-- the current `TOKEN'
	log_path:     PATH
			-- log path
	file_logger:  LOG_ROLLING_WRITER_FILE
			-- the logger
	msg_number:   INTEGER
			-- parsed messages number
	is_gc_monitoring_active: BOOLEAN
			-- log/display gc parameters
	gc_monitoring_message_number: INTEGER
			-- Monitor gc parameters every `gc_monitoring_message_number'
			-- if `is_gc_monitoring_active' is true
	start_time: DATE_TIME
			-- Application start date time
	up_time: detachable DATE_TIME_DURATION
			-- Global applcation up time

feature -- Parsing

	xml_parser_factory: XML_PARSER_FACTORY
			-- Global xml parser factory
	xml_parser:         XML_STANDARD_PARSER
			-- Global xml parser
	json_parser:        JSON_PARSER
			-- Global json parser

feature -- Formatting

	format_integer: FORMAT_INTEGER

end
