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
			launch as env_launch
		end
	ARGUMENTS
	LOG_PRIORITY_CONSTANTS
	LOGGING_I
	PAGE_TEMPLATES
	DEFAULTS
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end
	MEMORY

create
	make_and_launch

feature {NONE} -- Initialization

	init
			-- internal initialization
		do
			-- login management
			is_logged_in := false
			create login_request.make
			create logout_request.make
			create login_response.make
			create logout_response.make

			-- cURL objects
			create curl
			create curl_easy
			create curl_buffer.make_empty

			create content_type.make_empty
			create token.make
			create error_message.make_empty

			read_credentials

			-- Parsing
			create xml_parser_factory
			xml_parser := xml_parser_factory.new_standard_parser
			create json_parser.make_with_string ("{}")

			-- garbage collection
			collection_on
			set_memory_threshold (40000000)
			set_collection_period (5)
			set_coalesce_period (5)
			set_max_mem (80000000)
		end

	initialize
			-- Initialize current service
		local
			idx:  INTEGER
		do
			init
			init_log

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

			-- must check if `COLLECT_APPLICATION' is logged in remws
			if not is_logged_in then
				-- do login
				if not do_login then
					log_display ("FATAL error: unable to login", log_critical, true, true)
					die(0)
				else
					is_logged_in := true
					log_display ("logged in with token " +
					             token.id +
					             " expiring upon " +
					             token.expiry.formatted_out (default_date_time_format),
					             log_information, true, true)
				end
			end
		end

feature -- Usage

	usage
			-- little help on usage
		do
			print ("collect network remws gateway%N")
			print ("Agenzia Regionale per la Protezione Ambientale della Lombardia%N")
			print ("collect [-p <port_number>][-l <log_level>][-t][-u][-h]%N%N")
			print ("%T<port_number> is the network port on which collect will accept connections%N")
			print ("%T<log_level>   is the logging level that will be used%N")
			print ("%T-t            uses the testing web service%N")
			print ("%T-u            the box running collect is in UTC%N")
			print ("%T-h			prints this text%N")
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
			l_path: STRING
		do
			if not cfg_file_path.is_empty then
				l_path := cfg_file_path
			else
				l_path := "/etc/collect/credentials.conf"
			end

			create cfg_file.make_with_name (l_path)

			read_cfg

			l_path.wipe_out
		end

feature -- Logging

	init_log
			-- Initialize log on file
		local
			path: STRING
			home: STRING
			h:    STRING
		do
			create path.make_from_string ("$HOME/log/collect.log")
			create home.make_empty
			create h.make_from_string ("HOME")

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
			file_logger.enable_debug_log_level
			if attached logger as l_logger then
				l_logger.register_log_writer (file_logger)
				log_display ("Log system initialized", log_information, true, true)
			end

			path.wipe_out
			home.wipe_out
			h.wipe_out

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

	log_display(a_string: STRING; priority: INTEGER; to_file, to_display: BOOLEAN)
			-- Combined file and display log
		local
			l_string: STRING
		do
			if attached current.class_name as cn then
				l_string := "{" + cn + "} " + a_string
			else
				l_string := "{NO_CLASS_NAME} " + a_string
			end

			if to_file then
				--log (l_string, priority)
			end
			if to_display then
				io.put_string (l_string)
				io.put_new_line
			end

			l_string.wipe_out
		end


feature -- Basic operations

	parse_header (json: STRING): INTEGER
			-- Search message header for message id
		local
			key:         JSON_STRING
			--json_parser: JSON_PARSER
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
					log_display ("message id: " + j_id.integer_64_item.out, log_debug, true, false)
					Result := j_id.integer_64_item.to_integer
				else
					log_display ("The message header was not found!", log_error, true, true)
					log_display ("%TThis is probably not a valid message.", log_error, true, true)
					error_code    := {ERROR_CODES}.err_invalid_json
					error_message := {ERROR_CODES}.msg_invalid_json
				end
			else
				log_display ("json parser is not valid!!!", log_critical, true, true)
				if json_parser.has_error then
					log_display ("json parser error: " + json_parser.errors_as_string, log_critical, true, true)
				end
				error_code    := {ERROR_CODES}.err_no_json_parser
				error_message := {ERROR_CODES}.msg_no_json_parser
			end

			key.item.wipe_out
			json_parser.reset_reader
			json_parser.reset
		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
	    local
	    	l_received_chars: INTEGER
	    	l_msg_id:         INTEGER
	    	l_current_time:   DATE_TIME
	    	l_offset:         DATE_TIME_DURATION

	    	request:        STRING
	    	response:       STRING

	    	l_req_obj:        REQUEST_I
	    	l_res_obj:        RESPONSE_I
	    	l_mem_stat:       MEM_INFO
			l_gc_stat:        GC_INFO
			l_qt_res:         QUERY_TOKEN_RESPONSE
		do

			create request.make (req.content_length_value.to_integer_32)
			--request.resize (req.content_length_value.to_integer_32)
			create response.make_empty
			create l_current_time.make_now

			create l_qt_res.make

			l_req_obj := create {LOGIN_REQUEST}.make
			l_res_obj := create {LOGIN_RESPONSE}.make

			if is_utc_set then
				l_offset       := check_day_light_time_saving (l_current_time)
				log_display ("time_offset     : " + l_offset.second.out, log_debug, true, true);
				l_current_time := l_current_time + l_offset
			end

			log_display ("is logged in    : " + is_logged_in.out, log_debug, true, true)
			log_display ("token id        : " + token.id, log_debug, true, true)
			log_display ("token expiry    : " + token.expiry.formatted_out (default_date_time_format), log_debug, true, true)
			log_display ("current time    : " + l_current_time.formatted_out (default_date_time_format), log_debug, true, true)
			log_display ("is token expired: " + is_token_expired.out, log_debug, true, true)

			if is_token_expired then
				sleep (1000000000)
				login_response.reset
				if not do_login then
					log_display("Unable to login", log_error, true, true)
					log_display ("Outcome   : " + login_response.outcome.out, log_information, true, true)
					log_display ("Message   : " + login_response.message, log_information, true, true)
				else
					is_logged_in := true
					log_display ("logged in with new token " +
					             token.id +
					             " expiring upon " +
					             token.expiry.formatted_out (default_date_time_format),
					             log_information, true, true)
				end
				sleep (1000000000)
			end

			-- read json input
			l_received_chars := req.input.read_to_string (request, 1, req.content_length_value.to_integer_32)
			log_display ("Received " + l_received_chars.out + " chars", log_debug, true, true)
			log_display(" <<< " + request, log_debug, true, false)
			-- parse the message header
			l_msg_id := parse_header (request)
			log_display ("Received message id: " + l_msg_id.out, log_debug, true, true)

			if l_msg_id = {REQUEST_I}.login_request_id then
				l_req_obj := create {LOGIN_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
					end
				end
			elseif l_msg_id = {REQUEST_I}.logout_request_id then
				l_req_obj := create {LOGOUT_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
					end
				end
			elseif l_msg_id = {REQUEST_I}.station_status_list_request_id then
				l_req_obj := create {STATION_STATUS_LIST_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Station status list", log_information, true, true)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true)
						log_display("Message message: " + myres.message, log_information, true, true)
					end
				end
			elseif l_msg_id = {REQUEST_I}.station_types_list_request_id then
				l_req_obj := create {STATION_TYPES_LIST_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Station types list", log_information, true, true)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true)
						log_display("Message message: " + myres.message, log_information, true, true)
					end
				end
			elseif l_msg_id = {REQUEST_I}.province_list_request_id then
				l_req_obj := create {PROVINCE_LIST_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Province list", log_information, true, true)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true)
						log_display("Message message: " + myres.message, log_information, true, true)
					end
				end
			elseif l_msg_id = {REQUEST_I}.municipality_list_request_id then
				l_req_obj := create {MUNICIPALITY_LIST_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Municipality list", log_information, true, true)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true)
						log_display("Message message: " + myres.message, log_information, true, true)
					end
				end
			elseif l_msg_id = {REQUEST_I}.station_list_request_id then
				l_req_obj := create {STATION_LIST_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
						--log ("**********%N" + l_response + "%N**********%N", log_debug)
						log_display("Sent message id: " + myres.id.out + " Station list", log_information, true, true)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true)
						log_display("Message message: " + myres.message, log_information, true, true)
					end
				end
			elseif l_msg_id = {REQUEST_I}.sensor_type_list_request_id then
				l_req_obj := create {SENSOR_TYPE_LIST_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)
					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Sensor types list", log_information, true, true)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true)
						log_display("Message message: " + myres.message, log_information, true, true)
					end
				end
			elseif l_msg_id = {REQUEST_I}.realtime_data_request_id then
				l_req_obj := create {REALTIME_DATA_REQUEST}.make
				if attached l_req_obj as myreq then
					myreq.from_json (request, json_parser)
					myreq.set_token_id (token.id)

					l_res_obj := do_post (myreq)
					if attached l_res_obj as myres then
						response := myres.to_json
						log_display("Sent message id: " + myres.id.out + " Realtime data", log_information, true, true)
						log_display("Message outcome: " + myres.outcome.out, log_information, true, true)
						log_display("Message message: " + myres.message, log_information, true, true)
					end
				end
			elseif l_msg_id = {REQUEST_I}.query_token_request_id then
				l_qt_res.set_message ("Query token response")
				l_qt_res.set_outcome (0)
				l_qt_res.set_id (token.id)
				l_qt_res.set_expiry(token.expiry)
				response := l_qt_res.to_json
			else
				response := internal_error.to_json
			end

			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/json"], ["Content-Length", response.count.out]>>)
			res.put_string (response)
			log_display (" >>> " + response, log_information, true, false)

			l_req_obj.dispose
			l_res_obj.dispose

			msg_number := msg_number + 1
			log_display ("%T Managed message number " + msg_number.out, log_notice, true, true)
			if msg_number = {INTEGER}.max_value then
				msg_number := 1
			end

			if (msg_number \\ 1000) = 0 then
				l_mem_stat := memory_statistics (Total_memory)
				l_gc_stat  := gc_statistics (total_memory)

				full_collect
				full_coalesce
				log_display ("MEMORY STATISTICS " + msg_number.out,              log_alert, true, true)
				log_display ("Total 64:       "   + l_mem_stat.total64.out,      log_alert, true, true)
				log_display ("Total memory:   "   + l_mem_stat.total_memory.out, log_alert, true, true)
				log_display ("Free 64:        "   + l_mem_stat.free64.out,       log_alert, true, true)
				log_display ("Used 64:        "   + l_mem_stat.used64.out,       log_alert, true, true)


				log_display ("GC STATISTICS   "   + msg_number.out,              log_alert, true, true)
				log_display ("Collected:      "   + l_gc_stat.collected.out,     log_alert, true, true)
				log_display ("Total memory:   "   + l_gc_stat.total_memory.out,  log_alert, true, true)
				log_display ("Eiffel memory:  "   + l_gc_stat.eiffel_memory.out, log_alert, true, true)
				log_display ("Memory used:    "   + l_gc_stat.memory_used.out,   log_alert, true, true)

				log_display ("C memory:       "   + l_gc_stat.c_memory.out,      log_alert, true, true)
				log_display ("Cycle count:    "   + l_gc_stat.cycle_count.out,   log_alert, true, true)

				io.put_new_line

			end
			io.put_new_line

			request.wipe_out
			response.wipe_out

		end

feature {NONE} -- Network IO

	init_curl_handle(a_curl_easy: CURL_EASY_EXTERNALS; a_curl: CURL_EXTERNALS; a_request: REQUEST_I): POINTER
			-- Create a curl handle and setup it
		require
			a_curl_easy_not_void: a_curl_easy /= Void
			a_curl_not_void:      a_curl      /= Void
			a_request_not_void:   a_request   /= Void
		local
			--curl_function: CURL_DEFAULT_FUNCTION
			xml:           STRING
		do
			--print( "cURL handle init%N")
			if a_curl_easy.is_dynamic_library_exists then
				Result := a_curl_easy.init
				if use_testing_ws then
					a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_url,       a_request.ws_test_url)
				else
					a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_url,       a_request.ws_url)
				end

				--log ("ws_url: " + a_request.ws_url, log_debug)
				--print ("ws_url: " + a_request.ws_url + "%N")
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)
				xml := a_request.to_xml
				log_display(" >>> " + xml, log_debug, true, false)
				a_curl_easy.setopt_slist   (Result, {CURL_OPT_CONSTANTS}.curlopt_httpheader,    a_request.generate_http_headers (a_curl))
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_post,          1)
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, xml.count)
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_verbose,       0)
				a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_useragent,     "Eiffel curl testclient")
				a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_postfields,    xml)
				--a_curl_easy.set_curl_function (curl_function)
				xml.wipe_out
			else
				error_code    := {ERROR_CODES}.err_no_curl_easy_library
				error_message := {ERROR_CODES}.msg_no_curl_easy_library
			end

		end

	post(a_request: REQUEST_I): STRING
			-- Post `a_request' to remws
		local
			l_result:    INTEGER
			--curl_buffer: CURL_STRING
		do
			--create headers

			curl_buffer.wipe_out
			curl.global_init
			curl_handle := init_curl_handle (curl_easy, curl, a_request)

			if curl_handle /= default_pointer then
				-- We pass our `curl_buffer''s object id to the callback function */
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, curl_buffer.object_id)
				curl_easy.set_write_function (curl_handle)

				l_result := curl_easy.perform (curl_handle)
				if l_result /= 0 then
					-- got a network error?
					error_code    := l_result
					error_message := "This is a cURL error code, refer to cURL docs"
				end
			end

			curl_easy.cleanup (curl_handle)
			curl.global_cleanup

			Result := curl_buffer.to_string_32
		end

	do_post (a_request: REQUEST_I): RESPONSE_I
			-- Do a post to remws
			-- Parse the XML response
			-- Convert the response in json
		require
			a_request_attached: attached a_request
		local
			l_xml_str: STRING
		do
			--create l_xml_str.make_empty
			Result := a_request.init_response
			l_xml_str := post (a_request)
			log_display(" <<< " + l_xml_str, log_debug, true, false)

			if error_code /= 0 then
				Result.set_outcome (error_code)
				Result.set_message (error_message)
			else
				Result.from_xml (l_xml_str, xml_parser)
			end
			error_code := success
			error_message.wipe_out
			l_xml_str.wipe_out
			curl_buffer.wipe_out
		ensure
			result_attached: attached Result
		end

feature {NONE} -- Login management

	login_request: LOGIN_REQUEST
			-- The login request
	logout_request: LOGOUT_REQUEST
			-- The logout request
	login_response: LOGIN_RESPONSE
			-- The login response
	logout_response: LOGOUT_RESPONSE

	last_token_file_path: STRING
			-- last token file name full path
		do
			create Result.make_empty
			if attached home_directory_path as l_home then
				Result := l_home.out + "/.collect/last_token"
			end
		end

	check_day_light_time_saving (dt: DATE_TIME) : DATE_TIME_DURATION
			-- Check for day light time savin on `dt'
		local
			l_date:        DATE
			l_month:       INTEGER
			l_day:         INTEGER
			l_dow:         INTEGER
			l_prev_sunday: INTEGER
			l_one_hour:    DATE_TIME_DURATION
			l_two_hours:   DATE_TIME_DURATION
		do
			create l_one_hour.make (0, 0, 0, 1, 0, 0)
			create l_two_hours.make (0, 0, 0, 2, 0, 0)

			l_day   := dt.day
			l_month := dt.month

			l_date  := dt.date;
			l_dow   := dt.date.day_of_the_week


			create Result.make (0, 0, 0, 1, 0, 0)

			if l_month < 3 or l_month > 10 then
				-- Non siamo in ora legale quindi l'offset rispetto a UTC è di un'ora
				Result := l_one_hour
			elseif l_month > 3 and l_month < 10 then
				-- Siamo in ora legale quindi l'offset rispetto a UTC è di due ore
				Result := l_one_hour
			else
				l_prev_sunday := dt.day - l_dow
				if l_month = 3 then
					if l_prev_sunday >= 25 then
						Result := l_one_hour
					else
						Result := l_one_hour
					end
				end
				if l_month = 10 then
					if l_prev_sunday < 25 then
						Result := l_one_hour
					else
						Result := l_one_hour
					end
				end
			end
		end


	is_token_expired: BOOLEAN
			-- Tells if `token' is expired
		local
			l_current_dt: DATE_TIME
			l_offset:   DATE_TIME_DURATION
		do
			create l_current_dt.make_now
			--create l_interval.make_definite (0, 0, 0, 10)

			l_offset := check_day_light_time_saving (l_current_dt)

			if is_utc_set then
				Result := l_current_dt + l_offset > token.expiry
			else
				Result := l_current_dt > token.expiry
			end
		end



	check_login: BOOLEAN
			-- Check if is system logged in using the current token `expiry'
		local
			l_current_dt: DATE_TIME
			l_interval:   DATE_TIME_DURATION
			l_offset:     DATE_TIME_DURATION
		do
			create l_current_dt.make_now_utc

			l_offset := check_day_light_time_saving (l_current_dt)

			if use_testing_ws then
				create l_interval.make_definite  (0, 0, -28, 0)
			else
				create l_interval.make_definite  (0, 0, -58, 0)
			end

			if attached token then
				if l_current_dt + l_offset >= token.expiry + l_interval then
				    Result := False
			    else
			    	Result := True
				end
			else
				Result := False
			end
		end

	do_login: BOOLEAN
			-- Execute login
		local
			l_xml_str: STRING
			--l_res:     LOGIN_RESPONSE
			last_token_file: PLAIN_TEXT_FILE
		do
			if attached username as l_username and attached password as l_password then
				login_request.set_username (l_username)
				login_request.set_password (l_password)

				l_xml_str := post (login_request)
				log_display("do_login_response: " + l_xml_str, log_debug, true, false)
				login_response.from_xml (l_xml_str, xml_parser)

				log_display("login outcome: " + login_response.outcome.out, log_debug, true, true)
				log_display("login message: " + login_response.message,     log_debug, true, true)

				if login_response.outcome = success then
					token.id.copy (login_response.token.id)
					token.expiry.copy (login_response.token.expiry)
					if token.id.count > 0 then
						is_logged_in := true
						-- save token to text file
						create last_token_file.make_create_read_write (last_token_file_path)
						last_token_file.put_string (token.id)
						last_token_file.put_new_line
						last_token_file.put_string (token.expiry.formatted_out (default_date_time_format))
						last_token_file.put_new_line
						last_token_file.close
					else
						is_logged_in := false
					end
				else
					is_logged_in := false
				end

				l_xml_str.wipe_out
			else
				is_logged_in := False
			end

			Result := is_logged_in
		end

	do_logout: BOOLEAN
			-- Execute logout
		local
			l_xml_str: STRING
			--l_res:     LOGOUT_RESPONSE
		do
			if attached token as l_token then
				logout_request.token_id.copy (token.id)

				l_xml_str := post (logout_request)
				log_display("do_logout response " + l_xml_str, log_debug, true, false)

				log_display("login outcome: " + logout_response.outcome.out, log_debug, true, true)
				log_display("login message: " + logout_response.message,     log_debug, true, true)

				logout_response.from_xml (l_xml_str, xml_parser)

				l_xml_str.wipe_out

				Result := logout_response.outcome = success
			else
				Result := false
			end

		end

	curl_easy:      CURL_EASY_EXTERNALS
			-- cURL easy externals
	curl:           CURL_EXTERNALS
			-- cURL externals
	curl_handle:    POINTER
			-- cURL handle
	headers:        POINTER
			-- headers slist
	curl_buffer: CURL_STRING
			-- cURL buffer





	error_code:     INTEGER
			-- Post error code
	error_message:  STRING
			-- Post error message
	use_testing_ws: BOOLEAN
			-- Must use the testing web service

	internal_error: ERROR_RESPONSE once create Result.make end


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
	file_logger:  LOG_WRITER_FILE
			-- the logger
	msg_number:   INTEGER
			-- parsed messages number

--	request:        STRING
--    response:       STRING

feature -- Parsing

	xml_parser_factory: XML_PARSER_FACTORY
			-- Global xml parser factory
	xml_parser:         XML_STANDARD_PARSER
			-- Global xml parser
	json_parser:        JSON_PARSER
			-- Global json parser

end
