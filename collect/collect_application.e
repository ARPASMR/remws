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
--	LOGGING_I
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
		local
			cfg_location: PATH
		do
			if attached separate_word_option_value ("-config") as cfg_loc then
				create cfg_location.make_from_string (cfg_loc)
			elseif attached home_directory_path as l_home then
				create cfg_location.make_from_string (l_home.out + "/.collect/")
			else
				create cfg_location.make_empty
			end
			create config.make (cfg_location)

			read_credentials

			init_log


			-- login management
			if attached username as u and attached password as p then
				create remws_session.make (u, p, config, logger)
			else
				io.error.put_string ("Missing username and password for remws service!")
				die (0)
			end

--			create login_request.make
--			create logout_request.make
--			create login_response.make
--			create logout_response.make

--			-- cURL objects
--			create curl
--			create curl_easy
--			create curl_buffer.make_empty

			create content_type.make_empty
--			create token.make
			create error_message.make_empty

			-- Parsing
--			create xml_parser_factory
--			xml_parser := xml_parser_factory.new_standard_parser
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
			log_level:    INTEGER -- Log level
		do
			init

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
				logger.set_log_level (log_level)
--				if     log_level = log_debug       then file_logger.enable_debug_log_level          -- 7
--				elseif log_level = log_information then file_logger.enable_information_log_level    -- 6
--				elseif log_level = log_notice      then file_logger.enable_notice_log_level         -- 5
--				elseif log_level = log_warning     then file_logger.enable_warning_log_level        -- 4
--				elseif log_level = log_error       then file_logger.enable_error_log_level          -- 3
--				elseif log_level = log_critical    then file_logger.enable_critical_log_level       -- 2
--				elseif log_level = log_alert       then file_logger.enable_alert_log_level          -- 1
--				elseif log_level = log_emergency   then file_logger.enable_emergency_log_level      -- 0
--				else
--					file_logger.enable_error_log_level -- 3
--				end
			else
				logger.set_log_level (log_error)
--				log_level := log_error
--				file_logger.enable_error_log_level -- 3
			end

			config.use_testing_ws := index_of_word_option ("t") > 0
			config.is_utc_set := index_of_word_option ("u") > 0

			-- must check if `COLLECT_APPLICATION' is logged in remws
			if not remws_session.is_logged_in then
				-- do login
				remws_session.do_login
				if not remws_session.is_logged_in then
					log_display ("FATAL error: unable to login", log_critical, True, True)
					die(0)
				else
					log_display ("logged in with token " +
					             remws_session.token.id +
					             " expiring upon " +
					             remws_session.token.expiry.formatted_out (default_date_time_format),
					             log_information, True, True)
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
			print ("%T--config      configuration location%N")
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

	read_credentials
			-- Read wsrem credentials from file
		local
			cfg_file: PLAIN_TEXT_FILE
		do
			create cfg_file.make_with_path (config.credential_file_path)

				-- Trivial config file --> switch to preferences library
			cfg_file.open_read
			cfg_file.read_line
			username := cfg_file.last_string
			cfg_file.read_line
			password := cfg_file.last_string
			cfg_file.close
		end

feature -- Logging

	logger: APP_LOGGER

	init_log
			-- Initialize log on file
		do
			create logger.make (config.log_path)
		end

	is_logging_enabled: BOOLEAN
			-- Is logging enabled
		do
			Result := attached logger as l_logger and then l_logger.is_logging_enabled
		end

	log (a_string: STRING; priority: INTEGER)
			-- Logs `a_string'
		do
			if attached logger as l_logger then
				l_logger.log (a_string, priority)
			end
		end

	log_display (a_string: STRING; priority: INTEGER; to_file, to_display: BOOLEAN)
			-- Combined file and display log
		do
			if attached logger as l_logger then
				l_logger.log_display (Current, a_string, priority, to_file, to_display)
			end
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
				if
					attached {JSON_OBJECT} jv as j_object and then
					attached {JSON_OBJECT} j_object.item (key) as j_header and then
					attached {JSON_NUMBER} j_header.item ("id") as j_id
				then
					log_display ("message id: " + j_id.integer_64_item.out, log_debug, True, False)
					Result := j_id.integer_64_item.to_integer
				else
					log_display ("The message header was not found!", log_error, True, True)
					log_display ("%TThis is probably not a valid message.", log_error, True, True)
					error_code    := {ERROR_CODES}.err_invalid_json
					error_message := {ERROR_CODES}.msg_invalid_json
				end
			else
				log_display ("json parser is not valid!!!", log_critical, True, True)
				if json_parser.has_error then
					log_display ("json parser error: " + json_parser.errors_as_string, log_critical, True, True)
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

	    	l_req_obj: detachable REQUEST_I
	    	l_res_obj: detachable RESPONSE_I
	    	l_mem_stat:       MEM_INFO
			l_gc_stat:        GC_INFO
			l_qt_res:         QUERY_TOKEN_RESPONSE
		do

			create request.make (req.content_length_value.to_integer_32)
			--request.resize (req.content_length_value.to_integer_32)
			create response.make_empty
			create l_current_time.make_now

			create l_qt_res.make

			if config.is_utc_set then
				l_offset       := remws_session.check_day_light_time_saving (l_current_time)
				log_display ("time_offset     : " + l_offset.second.out, log_debug, True, True);
				l_current_time := l_current_time + l_offset
			end

			log_display ("is logged in    : " + remws_session.is_logged_in.out, log_debug, True, True)
			log_display ("token id        : " + remws_session.token.id, log_debug, True, True)
			log_display ("token expiry    : " + remws_session.token.expiry.formatted_out (default_date_time_format), log_debug, True, True)
			log_display ("current time    : " + l_current_time.formatted_out (default_date_time_format), log_debug, True, True)
			log_display ("is token expired: " + remws_session.is_token_expired.out, log_debug, True, True)

			if remws_session.is_token_expired then
				sleep (1_000_000_000) -- 1 second.
				remws_session.reset
				remws_session.do_login
				if remws_session.is_logged_in then
					log_display ("logged in with new token " +
					             remws_session.token.id +
					             " expiring upon " +
					             remws_session.token.expiry.formatted_out (default_date_time_format),
					             		log_information, True, True)
				else
					log_display("Unable to login", log_error, True, True)
					log_display ("Outcome   : " + remws_session.login_response.outcome.out, log_information, True, True)
					log_display ("Message   : " + remws_session.login_response.message, log_information, True, True)
				end
				sleep (1_000_000_000) -- 1 second.
			end

			-- read json input
			l_received_chars := req.input.read_to_string (request, 1, req.content_length_value.to_integer_32)
			log_display ("Received " + l_received_chars.out + " chars", log_debug, True, True)
			log_display(" <<< " + request, log_debug, True, False)
			-- parse the message header
			l_msg_id := parse_header (request)
			log_display ("Received message id: " + l_msg_id.out, log_debug, True, True)

			if l_msg_id = {REQUEST_I}.login_request_id then
				l_req_obj := create {LOGIN_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_res_obj := remws_session.do_post (l_req_obj)
				if l_res_obj /= Void then
					response := l_res_obj.to_json
				end
			elseif l_msg_id = {REQUEST_I}.logout_request_id then
				l_req_obj := create {LOGOUT_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_res_obj := remws_session.do_post (l_req_obj)
				if l_res_obj /= Void then
					response := l_res_obj.to_json
				end
			elseif l_msg_id = {REQUEST_I}.station_status_list_request_id then
				l_req_obj := create {STATION_STATUS_LIST_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_req_obj.set_token_id (remws_session.token.id)
				l_res_obj := remws_session.do_post (l_req_obj)
				if l_res_obj /= Void then
					response := l_res_obj.to_json
					log_display("Sent message id: " + l_res_obj.id.out + " Station status list", log_information, True, True)
					log_display("Message outcome: " + l_res_obj.outcome.out, log_information, True, True)
					log_display("Message message: " + l_res_obj.message, log_information, True, True)
				end
			elseif l_msg_id = {REQUEST_I}.station_types_list_request_id then
				l_req_obj := create {STATION_TYPES_LIST_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_req_obj.set_token_id (remws_session.token.id)
				l_res_obj := remws_session.do_post (l_req_obj)
				if attached l_res_obj then
					response := l_res_obj.to_json
					log_display("Sent message id: " + l_res_obj.id.out + " Station types list", log_information, True, True)
					log_display("Message outcome: " + l_res_obj.outcome.out, log_information, True, True)
					log_display("Message message: " + l_res_obj.message, log_information, True, True)
				end
			elseif l_msg_id = {REQUEST_I}.province_list_request_id then
				l_req_obj := create {PROVINCE_LIST_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_req_obj.set_token_id (remws_session.token.id)
				l_res_obj := remws_session.do_post (l_req_obj)
				if attached l_res_obj then
					response := l_res_obj.to_json
					log_display("Sent message id: " + l_res_obj.id.out + " Province list", log_information, True, True)
					log_display("Message outcome: " + l_res_obj.outcome.out, log_information, True, True)
					log_display("Message message: " + l_res_obj.message, log_information, True, True)
				end
			elseif l_msg_id = {REQUEST_I}.municipality_list_request_id then
				l_req_obj := create {MUNICIPALITY_LIST_REQUEST}.make

				l_req_obj.from_json (request, json_parser)
				l_req_obj.set_token_id (remws_session.token.id)
				l_res_obj := remws_session.do_post (l_req_obj)
				if attached l_res_obj then
					response := l_res_obj.to_json
					log_display("Sent message id: " + l_res_obj.id.out + " Municipality list", log_information, True, True)
					log_display("Message outcome: " + l_res_obj.outcome.out, log_information, True, True)
					log_display("Message message: " + l_res_obj.message, log_information, True, True)
				end
			elseif l_msg_id = {REQUEST_I}.station_list_request_id then
				l_req_obj := create {STATION_LIST_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_req_obj.set_token_id (remws_session.token.id)
				l_res_obj := remws_session.do_post (l_req_obj)
				if attached l_res_obj then
					response := l_res_obj.to_json
					--log ("**********%N" + l_response + "%N**********%N", log_debug)
					log_display("Sent message id: " + l_res_obj.id.out + " Station list", log_information, True, True)
					log_display("Message outcome: " + l_res_obj.outcome.out, log_information, True, True)
					log_display("Message message: " + l_res_obj.message, log_information, True, True)
				end
			elseif l_msg_id = {REQUEST_I}.sensor_type_list_request_id then
				l_req_obj := create {SENSOR_TYPE_LIST_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_req_obj.set_token_id (remws_session.token.id)
				l_res_obj := remws_session.do_post (l_req_obj)
				if attached l_res_obj then
					response := l_res_obj.to_json
					log_display("Sent message id: " + l_res_obj.id.out + " Sensor types list", log_information, True, True)
					log_display("Message outcome: " + l_res_obj.outcome.out, log_information, True, True)
					log_display("Message message: " + l_res_obj.message, log_information, True, True)
				end
			elseif l_msg_id = {REQUEST_I}.realtime_data_request_id then
				l_req_obj := create {REALTIME_DATA_REQUEST}.make
				l_req_obj.from_json (request, json_parser)
				l_req_obj.set_token_id (remws_session.token.id)
				l_res_obj := remws_session.do_post (l_req_obj)
				if attached l_res_obj then
					response := l_res_obj.to_json
					log_display("Sent message id: " + l_res_obj.id.out + " Realtime data", log_information, True, True)
					log_display("Message outcome: " + l_res_obj.outcome.out, log_information, True, True)
					log_display("Message message: " + l_res_obj.message, log_information, True, True)
				end
			elseif l_msg_id = {REQUEST_I}.query_token_request_id then
				l_qt_res.set_message ("Query token response")
				l_qt_res.set_outcome (0)
				l_qt_res.set_id (remws_session.token.id)
				l_qt_res.set_expiry(remws_session.token.expiry)
				response := l_qt_res.to_json
			else
				response := internal_error.to_json
			end

			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/json"], ["Content-Length", response.count.out]>>)
			res.put_string (response)
			log_display (" >>> " + response, log_information, True, False)

			if l_req_obj /= Void then
				l_req_obj.dispose
			end
			if l_res_obj /= Void then
				l_res_obj.dispose
			end

			msg_number := msg_number + 1
			log_display ("%T Managed message number " + msg_number.out, log_notice, True, True)
			if msg_number = {INTEGER}.max_value then
				msg_number := 1
			end

			if (msg_number \\ 1000) = 0 then
				l_mem_stat := memory_statistics (Total_memory)
				l_gc_stat  := gc_statistics (total_memory)

				full_collect
				full_coalesce
				log_display ("MEMORY STATISTICS " + msg_number.out,              log_alert, True, True)
				log_display ("Total 64:       "   + l_mem_stat.total64.out,      log_alert, True, True)
				log_display ("Total memory:   "   + l_mem_stat.total_memory.out, log_alert, True, True)
				log_display ("Free 64:        "   + l_mem_stat.free64.out,       log_alert, True, True)
				log_display ("Used 64:        "   + l_mem_stat.used64.out,       log_alert, True, True)


				log_display ("GC STATISTICS   "   + msg_number.out,              log_alert, True, True)
				log_display ("Collected:      "   + l_gc_stat.collected.out,     log_alert, True, True)
				log_display ("Total memory:   "   + l_gc_stat.total_memory.out,  log_alert, True, True)
				log_display ("Eiffel memory:  "   + l_gc_stat.eiffel_memory.out, log_alert, True, True)
				log_display ("Memory used:    "   + l_gc_stat.memory_used.out,   log_alert, True, True)

				log_display ("C memory:       "   + l_gc_stat.c_memory.out,      log_alert, True, True)
				log_display ("Cycle count:    "   + l_gc_stat.cycle_count.out,   log_alert, True, True)

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
				Result.from_xml (l_xml_str, remws_session.xml_parser)
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

			if remws_session.config.is_utc_set then
				Result := l_current_dt + l_offset > remws_session.token.expiry
			else
				Result := l_current_dt > remws_session.token.expiry
			end
		end

feature {NONE} -- remws management

	remws_session: REMWS_SESSION





	error_code:     INTEGER
			-- Post error code
	error_message:  STRING
			-- Post error message

	internal_error: ERROR_RESPONSE once create Result.make end


feature -- Attributes

	config: COLLECT_APPLICATION_CONFIG

	port:         INTEGER
			-- Listening port

	content_type: STRING


	msg_number:   INTEGER
			-- parsed messages number

feature -- Parsing

	json_parser: JSON_PARSER
			-- Global json parser

end
