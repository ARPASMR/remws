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

			create content_type.make_empty
			create token.make
			create error_message.make_empty

			read_credentials
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
				if     log_level = log_debug       then file_logger.enable_debug_log_level
				elseif log_level = log_information then file_logger.enable_information_log_level
				elseif log_level = log_notice      then file_logger.enable_notice_log_level
				elseif log_level = log_warning     then file_logger.enable_warning_log_level
				elseif log_level = log_error       then file_logger.enable_error_log_level
				elseif log_level = log_critical    then file_logger.enable_critical_log_level
				elseif log_level = log_alert       then file_logger.enable_alert_log_level
				elseif log_level = log_emergency   then file_logger.enable_emergency_log_level
				else
					file_logger.enable_error_log_level
				end
			else
				log_level := log_error
				file_logger.enable_error_log_level
			end

			idx := index_of_word_option ("t")
			if idx > 0 then
				use_testing_ws := true
			else
				use_testing_ws := false
			end

			-- must check if `COLLECT_APPLICATION' is logged in remws
			if not is_logged_in then
				-- do login
				if not do_login then
					log ("{COLLECT_APPLICATION} >>> FATAL error: unable to login", log_critical)
					io.put_string ("{COLLECT_APPLICATION} >>> FATAL error: unable to login"); io.put_new_line
					die(0)
				else
					is_logged_in := true
					log ("{COLLECT_APPLICATION} >>> logged in with token " + token.id + " expiring upon " + token.expiry.formatted_out (default_date_time_format), log_information)
					io.put_string ("{COLLECT_APPLICATION} >>> logged in with token " + token.id + " expiring upon " + token.expiry.formatted_out (default_date_time_format))
					io.put_new_line
				end
			end
		end

feature -- Usage

	usage
			-- little help on usage
		do
			print ("collect network remws gateway%N")
			print ("Agenzia Regionale per la Protezione Ambientale della Lombardia%N")
			print ("collect [-p <port_number>][-l <log_level>][-t][-h]%N%N")
			print ("%T<port_number> is the network port on which collect will accept connections%N")
			print ("%T<log_level>   is the logging level that will be used%N")
			print ("%T-t            uses the testing web service%N")
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
		once
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
		end

feature -- Logging

	init_log
			-- Initialize log on file
		local
			path: STRING
			user: STRING
			u:    STRING
		do
			create path.make_from_string ("/home/$USER/dev/eiffel/collect/collect.log")
			create user.make_empty
			create u.make_from_string ("USER")

			if attached item("USER") as s_u then
				user.copy (s_u.to_string_8)
			else
				path.copy ("/home/buck/dev/eiffel/collect/collect.log")
			end

			path.replace_substring_all ("$USER", user)

			create log_path.make_from_string (path)
			create logger.make
			create file_logger.make_at_location (log_path)
			file_logger.enable_debug_log_level
			if attached logger as l_logger then
				l_logger.register_log_writer (file_logger)
				log ("Log system initialized", log_information)
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

feature -- Basic operations

	parse_header (json: STRING): INTEGER
			-- Search message header for message id
		local
			key:         JSON_STRING
			json_parser: JSON_PARSER
		do
			create json_parser.make_with_string (json)

			create key.make_from_string ("header")
			json_parser.parse_content
			if json_parser.is_valid and then attached json_parser.parsed_json_value as jv then
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_header
					and then attached {JSON_NUMBER} j_header.item ("id") as j_id
				then
					log ("id:                " + j_id.integer_64_item.out,     log_debug)
					Result := j_id.integer_64_item.to_integer
				else
					log ("The message header was not found!",       log_error)
					log ("%TThis is probably not a valid message.", log_error)
					error_code    := {ERROR_CODES}.err_invalid_json
					error_message := {ERROR_CODES}.msg_invalid_json
				end
			else
				log ("json parser is not valid!!!", log_critical)
				if json_parser.has_error then
					log ("json parser error: " + json_parser.errors_as_string, log_critical)
				end
				error_code    := {ERROR_CODES}.err_no_json_parser
				error_message := {ERROR_CODES}.msg_no_json_parser
			end
		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
	    local
	    	--l_page_response: STRING

	    	l_val:           STRING
	    	l_raw:           STRING
	    	l_result:        INTEGER

	    	l_req:           REQUEST_I
	    	l_res:           RESPONSE_I
	    	i:               INTEGER
		do

			create l_raw.make (req.content_length_value.to_integer_32)
			create l_val.make_empty

			if not check_login then
				log("{COLLECT_APPLICATION} >>> ##### Changing token #####", log_notice)
				if is_logged_in then
					io.put_string ("Currently logged in, but token expired, need to logout ...%N")
					if do_logout then
						io.put_string ("Logged out%N")
						log("{COLLECT_APPLICATION} >>> Logged out", log_information)
						sleep(1000000000)
					else
						io.put_string ("Unable to logout, but session token expired, don't worry%N")
						log("{COLLECT_APPLICATION} >>> Unable to logout", log_notice)
						io.put_string ("retry logout%N")

						from i := 1
						until do_logout or i = 10
						loop
							io.put_string ("Logout Attempt " + i.out)
							io.put_new_line
							i := i + 1
							io.put_string ("Wait one second and retry...%N")
							sleep(1000000000)
						end
					end
				end
				if use_testing_ws then
					sleep (5000000000)
				else
					sleep (5000000000)
				end
				if do_login then
					io.put_string ("Logged in again%N")
					io.put_string ("{COLLECT_APPLICATION} >>> logged in again with token " + token.id + " expiring upon " + token.expiry.formatted_out (default_date_time_format))
					log("{COLLECT_APPLICATION} >>> logged in again with token " + token.id + " expiring upon " + token.expiry.formatted_out (default_date_time_format), log_information)
				else
					io.put_string ("NOT logged in%N")
					io.put_string ("RETRY LOGIN ...%N")
					from i := 1
					until do_login or i = 10
					loop
						io.put_string ("Attempt " + i.out)
						io.put_new_line
						i := i + 1
						io.put_string ("Wait one second and retry...%N")
						sleep(1000000000)
					end



--					die(0)
				end
			end

			-- read json input
			l_result := req.input.read_to_string (l_raw, 1, req.content_length_value.to_integer_32)
			io.put_string ("{COLLECT_APPLICATION} <<< " + l_raw)
			io.put_new_line
			-- parse the message header
			l_result := parse_header (l_raw)
			io.put_string ("Received message id: " + l_result.out)
			io.put_new_line

--			-- manage token --
--			l_raw.replace_substring_all (token_tag, token.id)
--			-- end manage token

			io.put_string ("{COLLECT_APPLICATION} <<< " + l_raw)
			io.put_new_line


			if l_result = {REQUEST_I}.login_request_id then
				l_req := create {LOGIN_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.logout_request_id then
				l_req := create {LOGOUT_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.station_status_list_request_id then
				l_req := create {STATION_STATUS_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					myreq.set_token_id (token.id)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.station_types_list_request_id then
				l_req := create {STATION_TYPES_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					myreq.set_token_id (token.id)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.province_list_request_id then
				l_req := create {PROVINCE_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					myreq.set_token_id (token.id)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.municipality_list_request_id then
				l_req := create {MUNICIPALITY_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					myreq.set_token_id (token.id)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.station_list_request_id then
				l_req := create {STATION_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					myreq.set_token_id (token.id)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
						log ("**********%N" + l_val + "%N**********%N", log_debug)
					end
				end
			elseif l_result = {REQUEST_I}.sensor_type_list_request_id then
				l_req := create {SENSOR_TYPE_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					myreq.set_token_id (token.id)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.realtime_data_request_id then
				l_req := create {REALTIME_DATA_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					myreq.set_token_id (token.id)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			else
				l_val := internal_error.to_json
			end

			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/json"], ["Content-Length", l_val.count.out]>>)
			res.put_string (l_val)
			io.put_string ("{COLLECT_APPLICATION} >>> " + l_val)
			io.put_new_line
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
				log ("{COLLECT_APPLICATION} >>> " + xml, log_debug)
				io.put_string ("{COLLECT_APPLICATION} >>> " + xml)
				io.put_new_line
				a_curl_easy.setopt_slist   (Result, {CURL_OPT_CONSTANTS}.curlopt_httpheader,    a_request.generate_http_headers (a_curl))
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_post,          1)
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, xml.count)
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_verbose,       1)
				a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_useragent,     "Eiffel curl testclient")
				a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_postfields,    xml)
				--a_curl_easy.set_curl_function (curl_function)
			else
				error_code    := {ERROR_CODES}.err_no_curl_easy_library
				error_message := {ERROR_CODES}.msg_no_curl_easy_library
			end
		end

	post(a_request: REQUEST_I): STRING
			-- Post `a_request' to remws
		local
			l_result:    INTEGER
			curl_buffer: CURL_STRING
		do
			create headers
			create curl_buffer.make_empty

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
			create l_xml_str.make_empty
			Result := a_request.init_response
			l_xml_str := post (a_request)
			log ("Got: " + l_xml_str, log_debug)
			io.put_string ("Got: " + l_xml_str)
			io.put_new_line

			if error_code /= 0 then
				Result.set_outcome (error_code)
				Result.set_message (error_message)
			else
				Result.from_xml (l_xml_str)
			end
			error_code := success
			error_message.wipe_out
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
			elseif l_month > 3 or l_month < 10 then
				-- Siamo in ora legale quindi l'offset rispetto a UTC è di due ore
				Result := l_two_hours
			else
				l_prev_sunday := dt.day - l_dow
				if l_month = 3 then
					if l_prev_sunday >= 25 then
						Result := l_one_hour
					end
				end
				if l_month = 10 then
					if l_prev_sunday < 25 then
						Result := l_two_hours
					end
				end
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

			--create l_interval.make_definite  (0, 0, 30, 0)
			if use_testing_ws then
				create l_interval.make_definite  (0, 0, -28, 0)
			else
				create l_interval.make_definite  (0, 0, -58, 0)
			end

			if attached token then
				--if l_current_dt + l_offset >= token.expiry + l_interval then
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
		do
			if attached username as l_username and attached password as l_password then
				login_request.set_username (l_username)
				login_request.set_password (l_password)

				l_xml_str := post (login_request)
				io.put_string ("do_login response: " + l_xml_str)
				io.put_new_line
				--create l_res.make
				--l_res.from_xml (l_xml_str)
				login_response.from_xml (l_xml_str)

--				token.id.copy (l_res.token.id)
--				token.expiry.copy (l_res.token.expiry)

				if login_response.outcome = success then
					token.id.copy (login_response.token.id)
					token.expiry.copy (login_response.token.expiry)
					if token.id.count > 0 then
						is_logged_in := true
					else
						is_logged_in := false
					end
				else
					is_logged_in := false
				end

--				token.id.copy (login_response.token.id)
--				token.expiry.copy (login_response.token.expiry)



--				if token.id.count > 0 then
--					is_logged_in := True
--				else
--					is_logged_in := False
--				end
			else
				is_logged_in := False
			end

			Result := is_logged_in
		end

	do_logout: BOOLEAN
			-- Execute logout
		local
			l_xml_str: STRING
			l_res:     LOGOUT_RESPONSE
		do
			if attached token as l_token then
				logout_request.token_id.copy (token.id)

				l_xml_str := post (logout_request)
				io.put_string ("{COLLECT_APPLICATION} do logout response <<<  " + l_xml_str)
				io.put_new_line
				--create l_res.make
				--l_res.from_xml (l_xml_str)

				logout_response.from_xml (l_xml_str)

				--Result := l_res.outcome = success
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
	token:        TOKEN

	log_path:     PATH
			-- log path
	file_logger:  LOG_WRITER_FILE
			-- the logger

end
