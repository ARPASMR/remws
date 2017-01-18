note
	description: "Summary description for {REMWS_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMWS_SESSION

inherit
	ERROR_CODES

	LOG_PRIORITY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_username, a_password: READABLE_STRING_8; cfg: COLLECT_APPLICATION_CONFIG; a_logger: APP_LOGGER)
		do
			config := cfg
			logger := a_logger
			username := a_username
			password := a_password

			create token.make
			create error_message.make_empty

			create login_request.make
			create logout_request.make
			create login_response.make
			create logout_response.make

			-- cURL objects
			create curl
			create curl_easy
			create curl_buffer.make_empty

			-- Parsing
			create xml_parser_factory
			xml_parser := xml_parser_factory.new_standard_parser
		end

feature -- Access

	config: COLLECT_APPLICATION_CONFIG

	logger: APP_LOGGER

	username: READABLE_STRING_8
	password: READABLE_STRING_8

	is_logged_in: BOOLEAN
			-- is collect logged in remws?

feature -- Access: session

	token:        TOKEN
			-- the current `TOKEN'

	login_request: LOGIN_REQUEST
			-- The login request
	logout_request: LOGOUT_REQUEST
			-- The logout request
	login_response: LOGIN_RESPONSE
			-- The login response
	logout_response: LOGOUT_RESPONSE

	last_token_file_path: PATH
			-- last token file name full path
		do
			Result := config.location.extended ("last_token")
		end

feature -- Parsing

	xml_parser_factory: XML_PARSER_FACTORY
			-- Global xml parser factory
	xml_parser:         XML_STANDARD_PARSER
			-- Global xml parser		

feature -- Status report

	check_day_light_time_saving (dt: DATE_TIME): DATE_TIME_DURATION
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

			if config.is_utc_set then
				Result := l_current_dt + l_offset > token.expiry
			else
				Result := l_current_dt > token.expiry
			end
		end

feature -- Basic operations

	reset
		do
			login_response.reset
		end

	do_login
			-- Execute login
		require
			is_not_logged_in: not is_logged_in
		local
			l_xml_str: STRING
			--l_res:     LOGIN_RESPONSE
			last_token_file: PLAIN_TEXT_FILE
		do
			is_logged_in := False
			if attached username as l_username and attached password as l_password then
				login_request.set_username (l_username)
				login_request.set_password (l_password)

				l_xml_str := post (login_request)
				debug_log_display("do_login_response: " + l_xml_str, True, False)
				login_response.from_xml (l_xml_str, xml_parser)

				debug_log_display("login outcome: " + login_response.outcome.out, True, True)
				debug_log_display("login message: " + login_response.message,     True, True)

				if login_response.outcome = success then
					token.id.copy (login_response.token.id)
					token.expiry.copy (login_response.token.expiry)
					if token.id.count > 0 then
						is_logged_in := True
						-- save token to text file
						create last_token_file.make_with_path (last_token_file_path)
						last_token_file.create_read_write
						last_token_file.put_string (token.id)
						last_token_file.put_new_line
						last_token_file.put_string (token.expiry.formatted_out ({DEFAULTS}.default_date_time_format))
						last_token_file.put_new_line
						last_token_file.close
					end
				end

				l_xml_str.wipe_out
			else
				is_logged_in := False
			end
		end

	do_logout
			-- Execute logout
		local
			l_xml_str: STRING
			--l_res:     LOGOUT_RESPONSE
		do
			if attached token as l_token then
				logout_request.token_id.copy (token.id)

				l_xml_str := post (logout_request)
				debug_log_display("do_logout response " + l_xml_str, True, False)

				debug_log_display("login outcome: " + logout_response.outcome.out, True, True)
				debug_log_display("login message: " + logout_response.message,     True, True)

				logout_response.from_xml (l_xml_str, xml_parser)

				l_xml_str.wipe_out

				if logout_response.outcome = success then
					is_logged_in := False
				end
			else
					-- Check .. should not occur.
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

			if config.use_testing_ws then
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

feature -- Logger

	debug_log_display (a_string: STRING; to_file, to_display: BOOLEAN)
			-- Combined file and display log
		do
			if attached logger as l_logger then
				l_logger.log_display (Current, a_string, log_debug, to_file, to_display)
			end
		end

feature {COLLECT_APPLICATION} -- Network IO

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
				if config.use_testing_ws then
					a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_url,       a_request.ws_test_url)
				else
					a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_url,       a_request.ws_url)
				end

				--log ("ws_url: " + a_request.ws_url, log_debug)
				--print ("ws_url: " + a_request.ws_url + "%N")
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)
				xml := a_request.to_xml
				debug_log_display(" >>> " + xml, True, False)
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
			create headers

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
			debug_log_display(" <<< " + l_xml_str, True, False)

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

feature {NONE} -- cURL

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
--	use_testing_ws: BOOLEAN
--			-- Must use the testing web service

	internal_error: ERROR_RESPONSE once create Result.make end

invariant

end
