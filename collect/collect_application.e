note
	description : "collect application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	COLLECT_APPLICATION

inherit
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
			create curl
			create curl_easy

			create content_type.make_empty
			create token.make
			create error_message.make_empty
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
		end

feature -- Usage

	usage
			-- little help on usage
		do
			print ("collect network remws gateway%N")
			print ("Agenzia Regionale per la Protezione Ambientale della Lombardia%N")
			print ("collect [-p <port_number>][-l <log_level>][-h]%N%N")
			print ("%T<port_number> is the network port on which collect will accept connections%N")
			print ("%T<log_level>   is the logging level that will be used%N")
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

feature -- Logging

	init_log
			-- Initialize log on file
		do
			create log_path.make_from_string ("/home/buck/dev/eiffel/collect/collect.log")
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
					and then attached {JSON_NUMBER} j_header.item ("parameters_number") as j_parnum
				then
					log ("id:                " + j_id.integer_64_item.out,     log_debug)
					log ("parameters_number: " + j_parnum.integer_64_item.out, log_debug)
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
		do

			create l_raw.make (req.content_length_value.to_integer_32)
			create l_val.make_empty

			-- To send a response we need to setup, the status code and
			-- the response headers.

			if not check_login then
				if do_login then
					io.put_string ("Logged in%N")
				else
					io.put_string ("NOT logged in%N")
				end
			end

			-- read json input
			l_result := req.input.read_to_string (l_raw, 1, req.content_length_value.to_integer_32)
			io.put_string ("{COLLECT_APPLICATION} <<< " + l_raw)
			io.put_new_line
			-- parse the message header
			l_result := parse_header (l_raw)

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
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.station_types_list_request_id then
				l_req := create {STATION_TYPES_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.province_list_request_id then
				l_req := create {PROVINCE_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.municipality_list_request_id then
				l_req := create {MUNICIPALITY_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
					l_res := do_post (myreq)
					if attached l_res as myres then
						l_val := myres.to_json
					end
				end
			elseif l_result = {REQUEST_I}.station_list_request_id then
				l_req := create {STATION_LIST_REQUEST}.make
				if attached l_req as myreq then
					myreq.from_json (l_raw)
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
			print( "cURL handle init%N")
			--create curl_function.make
			if a_curl_easy.is_dynamic_library_exists then
				Result := a_curl_easy.init
				a_curl_easy.setopt_string  (Result, {CURL_OPT_CONSTANTS}.curlopt_url,           a_request.ws_url)
				log ("ws_url: " + a_request.ws_url, log_debug)
				--print ("ws_url: " + a_request.ws_url + "%N")
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
				a_curl_easy.setopt_integer (Result, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)
				xml := a_request.to_xml
				log ("{COLLECT_APPLICATION} >>> " + xml, log_debug)
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
			-- Post `a_msg' to remws
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
			--print ("Got: " + l_xml_str + "%N")
			if error_code /= 0 then
				Result.set_parameters_number ({MSG_CONSTANTS}.internal_error_parnum)
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

	check_login: BOOLEAN
			-- Is system logged in
		local
			l_current_dt: DATE_TIME
			l_interval:   DATE_TIME_DURATION
		do
			create l_current_dt.make_now
			create l_interval.make_definite (0, 1, 0, 0)

			if attached token then
				if l_current_dt > token.expiry + l_interval then
					if not do_logout then
						log ("Unable to logout", log_error)
					end
					result := False
				end
			else
				Result := False
			end
		end

	do_login: BOOLEAN
			-- Execute login
		do
			Result := False
		end

	do_logout: BOOLEAN
			-- Execute logout
		do
			Result := False
		end

	curl_easy:     CURL_EASY_EXTERNALS
			-- cURL easy externals
	curl:          CURL_EXTERNALS
			-- cURL externals
	curl_handle:   POINTER
			-- cURL handle
	headers:       POINTER
			-- headers slist

	error_code:    INTEGER
			-- Post error code
	error_message: STRING
			-- Post error message

	internal_error: ERROR_RESPONSE once create Result.make end


feature -- Attributes

	port:         INTEGER
	log_level:    INTEGER
	content_type: STRING

	token:        TOKEN

	log_path:     PATH
	file_logger:  LOG_WRITER_FILE

end


--			if curl_easy.is_dynamic_library_exists then


--				curl_handle := curl_easy.init
--				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,           "http://remws.arpa.local/Autenticazione.svc")
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)

--				headers := curl.slist_append (headers.default_pointer, "")
--				headers := curl.slist_append (headers, "content-type: text/xml;charset=utf-8")
--				headers := curl.slist_append (headers, "SOAPAction: http://tempuri.org/IAutenticazione/Login")
--				headers := curl.slist_append (headers, "Accept-Encoding: gzip, deflate")

--				curl_easy.setopt_slist   (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpheader,    headers)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_post,          1)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, a_msg.count)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_verbose,       1)
--				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_useragent,     "Eiffel curl testclient")
--				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields,    a_msg)
--				curl_easy.set_curl_function (curl_function)
--				-- We pass our `curl_buffer''s object id to the callback function */
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata,     curl_buffer.object_id)

--				io.put_string ("response: " + curl_buffer.string)

--				l_result := curl_easy.perform (curl_handle)

--				curl.slist_free_all (headers.item)
--				curl_easy.cleanup (curl_handle)
--			else
--				io.put_string ("cURL library not found")
--				io.put_new_line
--			end


-- test_xml_parser
--			-- Test XML parser
--		do
--			--create login_msg.make

--			--login_msg.set_logger (log_facility)
--			--login_msg.from_xml (login_msg.login_response)
--		end

--	test_parser
--		local
--			json_parser: JSON_PARSER
--			key:         JSON_STRING
--			amsg:        LOGIN_REQUEST
--		do
--			create amsg.make

--			amsg.set_username ("a_usr")
--			amsg.set_password ("a_pwd")

--			-- print ("Login message as json string: " + amsg.to_json)
--			print ("Login message as xml  string: " + amsg.to_xml)

--			create json_parser.make_with_string ("[
--				{
--					"interval": 34,
--					"expiry": "2015-08-07 23:45:13"
--				}
--			]")

--			create key.make_from_string ("interval")
--			json_parser.parse_content
--			if json_parser.is_valid and then attached json_parser.parsed_json_value as jv then
--				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_NUMBER} j_object.item (key) as j_interval
--					and then attached {JSON_STRING} j_object.item ("expiry") as j_expiry
--				then
--					print ("interval: " + j_interval.integer_64_item.out + "%N")
--					print ("expiry:   " + j_expiry.unescaped_string_8 + "%N")
--				else
--					print ("The interval was not found!%N")
--				end
--			end
--		end

-- execute body example
--			create l_page_response.make_from_string (main_template)

--			io.put_string ("Server URL: " + req.server_url)
--			l_page_response.replace_substring_all ("$url", req.server_url)
--			io.put_new_line
--			if attached req.content_type as t then
--				l_val := "Content type: " + t.string
--				-- if content type is json give back info in json
--				-- only json supported for the time being
--			else
--				l_val := "No content type header"
--				-- must give back info in html
--			end
--			io.put_string(l_val)
--			l_page_response.replace_substring_all ("$ctype", l_val)
--			io.put_new_line

--			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_page_response.count.out]>>)
--			res.put_string (l_page_response)
