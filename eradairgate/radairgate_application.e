note
	description : "eradairgate application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	RADAIRGATE_APPLICATION

inherit
	EXCEPTIONS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line,
			launch as env_launch
		end
	ARGUMENTS
	LOG_PRIORITY_CONSTANTS
	LOGGING_I
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end
	ADSB_CONSTANTS

create
	make_and_launch

feature {NONE} -- Initialization

	init
			-- internal initialization
		do
			log (command_name + " creating world objects ...", log_information)
			mode_s_port    := default_modes_port
			listening_port := default_listening_port
			commands_port  := default_commands_port
			log_level      := log_information

			-- curl objects
			create curl
			create curl_easy

			log (command_name + " world objects created.", log_information)

--			create content_type.make_empty
		end

	initialize
			-- Initialize current service
		local
			idx:  INTEGER
		do
			init_log
			init

			log (command_name + " initialization ...", log_information)

			idx := index_of_word_option ("h")
			if idx > 0 then
				usage
				die (0)
			end

			log (command_name + " initialization: done:", log_information)

			idx := index_of_word_option ("p")
			if idx > 0 then
				mode_s_port := argument (idx + 1).to_integer
			end
			log (command_name + " mode s port set to: " + mode_s_port.out + "%N", log_information)

			idx := index_of_word_option ("n")
			if idx > 0 then
				listening_port := argument (idx + 1).to_integer
			end
			log (command_name + " listening port set to: " + listening_port.out + "%N", log_information)

			idx := index_of_word_option ("c")
			if idx > 0 then
				commands_port := argument (idx + 1).to_integer
			end
			log (command_name + " commands port set to: " + commands_port.out + "%N", log_information)

			set_service_option ("port", commands_port)

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
			log (command_name + " log level set to: " + log_level.out + "%N", log_information)

			log (command_name + "initialization: done:", log_information)
		end

feature -- Usage

	usage
			-- little help on usage
		do
			print ("radar tracks gateway%N")
			print ("(C) 2015 lp.org%N")
			print ("eradairgate [-p <mode_s_port_number>][-n <listening_port][-c <commands_port][-l <log_level>][-t]%N%N")
			print ("%T<mode_s_port_number> is the network port on which collect will accept connections%N")
			print ("%T<listening_port>     is the listenin port for incoming connections%N")
			print ("%T<commands_port>      is the driving commands port%N")
			print ("%T<log_level>          is the logging level that will be used%N")
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

feature -- Basic operation

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
	    local
	    	--l_page_response: STRING
	    	l_val:           STRING
	    	l_raw:           STRING
	    	l_result:        INTEGER

	    	--l_req:           REQUEST_I
	    	--l_res:           RESPONSE_I
		do

			create l_raw.make (req.content_length_value.to_integer_32)
			create l_val.make_empty

--			-- To send a response we need to setup, the status code and
--			-- the response headers.

--			-- read json input
--			l_result := req.input.read_to_string (l_raw, 1, req.content_length_value.to_integer_32)
--			io.put_string ("{COLLECT_APPLICATION} <<< " + l_raw)
--			io.put_new_line
--			-- parse the message header
--			l_result := parse_header (l_raw)

--			if l_result = {REQUEST_I}.login_request_id then
--				l_req := create {LOGIN_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			elseif l_result = {REQUEST_I}.logout_request_id then
--				l_req := create {LOGOUT_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			elseif l_result = {REQUEST_I}.station_status_list_request_id then
--				l_req := create {STATION_STATUS_LIST_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			elseif l_result = {REQUEST_I}.station_types_list_request_id then
--				l_req := create {STATION_TYPES_LIST_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			elseif l_result = {REQUEST_I}.province_list_request_id then
--				l_req := create {PROVINCE_LIST_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			elseif l_result = {REQUEST_I}.municipality_list_request_id then
--				l_req := create {MUNICIPALITY_LIST_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			elseif l_result = {REQUEST_I}.station_list_request_id then
--				l_req := create {STATION_LIST_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			elseif l_result = {REQUEST_I}.sensor_type_list_request_id then
--				l_req := create {SENSOR_TYPE_LIST_REQUEST}.make
--				if attached l_req as myreq then
--					myreq.from_json (l_raw)
--					l_res := do_post (myreq)
--					if attached l_res as myres then
--						l_val := myres.to_json
--					end
--				end
--			else
--				l_val := internal_error.to_json
--			end

--			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/json"], ["Content-Length", l_val.count.out]>>)
--			res.put_string (l_val)
--			io.put_string ("{COLLECT_APPLICATION} >>> " + l_val)
--			io.put_new_line
		end

feature -- Logging

	init_log
			-- Initialize log on file
		local
			path: STRING
			user: STRING
			u:    STRING
		do
			create path.make_from_string ("/home/$USER/dev/eiffel/eradairgate/rdr.log")
			create user.make_empty
			create u.make_from_string ("USER")

			if attached item("USER") as s_u then
				user.copy (s_u.to_string_8)
			else
				path.copy ("/home/buck/dev/eiffel/eradairgate/rdr.log")
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

feature {NONE} -- Implementation

	log_level:      INTEGER
			-- Logo level: see `LOG_PRIORITY_CONSTANTS'
	log_path:       PATH
			-- Log files destination path
	file_logger:  LOG_WRITER_FILE
			-- File logger
	mode_s_port:    INTEGER
			-- The Mode-S port, usually 30003
	listening_port: INTEGER
			-- The listening port
	commands_port:  INTEGER
			-- The commands port

feature -- cURL

	curl_easy:      CURL_EASY_EXTERNALS
			-- cURL easy externals
	curl:           CURL_EXTERNALS
			-- cURL externals
	curl_handle:    POINTER
			-- cURL handle
end
