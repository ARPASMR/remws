note
	description : "[
						remws_simulator application root class"
						Receives an xml request message and gives back a standard XML
						response message
				   ]"
	date        : "$Date$"
	revision    : "$Revision$"

class
	REMWS_SIMULATOR_APPLICATION

inherit
	STANDARD_RESPONSES
	ERROR_CODES
	EXCEPTIONS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line,
			launch as env_launch
		end
	XML_CALLBACKS
	ARGUMENTS
	LOG_PRIORITY_CONSTANTS
	LOGGING_I
	DEFAULTS
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service
		local
			idx:  INTEGER
		do
			init_log
			set_service_option ("port", 8088)
			set_service_option ("verbose", True)

		end

feature -- Logging

	init_log
			-- Initialize log on file
		do
			if attached item ("REMWS_LOGDIR") as loc then
				log_path := (create {PATH}.make_from_string (loc)).extended ("collect.log")
			elseif attached home_directory_path as loc then
				log_path := loc.extended (".collect").extended ("collect.log")
			else
				log_path := (create {PATH}.make_current).extended (".collect").extended ("collect.log")
			end
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

	parse_xml (xml: STRING): INTEGER
			-- Search message header for message id
		local
			parser: XML_STANDARD_PARSER
			factory: XML_PARSER_FACTORY
		do
			create factory

			parser := factory.new_standard_parser
			parser.set_callbacks (Current)
			set_associated_parser (parser)
			parser.parse_from_string (xml)
--			if token.id.is_empty then
--				parameters_number := login_response_error_parnum
--			else
--				parameters_number := login_response_success_parnum
--			end
		end

--			create json_parser.make_with_string (json)

--			create key.make_from_string ("header")
--			json_parser.parse_content
--			if json_parser.is_valid and then attached json_parser.parsed_json_value as jv then
--				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_header
--					and then attached {JSON_NUMBER} j_header.item ("id") as j_id
--					and then attached {JSON_NUMBER} j_header.item ("parameters_number") as j_parnum
--				then
--					log ("id:                " + j_id.integer_64_item.out,     log_debug)
--					log ("parameters_number: " + j_parnum.integer_64_item.out, log_debug)
--					Result := j_id.integer_64_item.to_integer
--				else
--					log ("The message header was not found!",       log_error)
--					log ("%TThis is probably not a valid message.", log_error)
--					error_code    := {ERROR_CODES}.err_invalid_json
--					error_message := {ERROR_CODES}.msg_invalid_json
--				end
--			else
--				log ("json parser is not valid!!!", log_critical)
--				if json_parser.has_error then
--					log ("json parser error: " + json_parser.errors_as_string, log_critical)
--				end
--				error_code    := {ERROR_CODES}.err_no_json_parser
--				error_message := {ERROR_CODES}.msg_no_json_parser
--			end
--		end

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

--			if not check_login then
--				if do_login then
--					io.put_string ("Logged in%N")
--				else
--					io.put_string ("NOT logged in%N")
--				end
--			end

			-- read XML input
			l_result := req.input.read_to_string (l_raw, 1, req.content_length_value.to_integer_32)
			io.put_string ("{COLLECT_APPLICATION} <<< " + l_raw)
			io.put_new_line

--			 read json input
--			l_result := req.input.read_to_string (l_raw, 1, req.content_length_value.to_integer_32)
--			io.put_string ("{COLLECT_APPLICATION} <<< " + l_raw)
--			io.put_new_line
--			 parse the message header
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

feature -- XML Callbacks

	on_start
			-- Called when parsing starts.
		do
			log ("XML callbacks on_start called. It's the beginning of the whole parsing.", log_debug)
		end

	on_finish
			-- Called when parsing finished.
		do
			log ("XML callbacks on_finish called. The parsing has finished.", log_debug)
		end

	on_xml_declaration (a_version: READABLE_STRING_32; an_encoding: detachable READABLE_STRING_32; a_standalone: BOOLEAN)
			-- XML declaration.
		do
			log ("XML callbacks on_xml_declaration called. Got xml declaration", log_debug)
--			if attached a_version as version then
--				log ("%TVersion:    " + version, log_debug)
--			end
--			if attached an_encoding as encoding then
--				log ("%TEncoding:   " + encoding, log_debug)
--			end
--			if attached a_standalone as standalone then
--				log ("%TStandalone: " + standalone.out, log_debug)
--			end
		end

	on_error (a_message: READABLE_STRING_32)
			-- Event producer detected an error.
		do
--			outcome := {ERROR_CODES}.err_xml_parsing_failed
--			message := {ERROR_CODES}.msg_xml_parser_failed
			log ("XML callbacks on_error called.", log_debug)
			log ("Got an error: " + a_message, log_debug)
		end

	on_processing_instruction (a_name: READABLE_STRING_32; a_content: READABLE_STRING_32)
			-- Processing instruction.
			--| See http://en.wikipedia.org/wiki/Processing_instruction
		do
			log ("XML callbacks on_processing_instruction called.", log_debug)
			log ("%Tname;    " + a_name, log_debug)
			log ("%Tcontent: " + a_content, log_debug)
		end

	on_comment (a_content: READABLE_STRING_32)
			-- Processing a comment.
			-- Atomic: single comment produces single event
		do
			log ("XML callbacks on_comment called. Got a comment.", log_debug)
			log ("%Tcontent: " + a_content, log_debug)
		end

	on_start_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- Start of start tag.
		do
			log ("XML callbacks on_start_tag called. A tag is starting", log_debug)
--			if attached a_namespace as namespace then
--				log ("%Tnamespace: " + namespace, log_debug)
--			end
--			if attached a_prefix as myprefix then
--				log ("%Tprefix:    " + myprefix, log_debug)
--			end
--			log ("%Tlocal part:  " + a_local_part, log_debug)
--			current_tag := a_local_part
		end

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
		do
			log ("XML callbacks on_attribute called. Got an attribute", log_debug)
			if attached a_namespace as namespace then
				log ("%Tnamespace: " + namespace, log_debug)
			end
			if attached a_prefix as myprefix then
				log ("%Tprefix:    " + myprefix, log_debug)
			end
			log ("%Tlocal part:  " + a_local_part, log_debug)
			log ("%Tvalue:       " + a_value, log_debug)
		end

	on_start_tag_finish
			-- End of start tag.
		do
			log ("XML callbacks on_start_tag_finish called. The start tag is finished.", log_debug)
		end

	on_end_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- End tag.
		do
			log ("XML callbacks on_end_tag called. Got the and tag.", log_debug)
		end

	on_content (a_content: READABLE_STRING_32)
			-- Text content.
			-- NOT atomic: two on_content events may follow each other
			-- without a markup event in between.
			--| this should not occur, but I leave this comment just in case
		local
			a_date: DATE_TIME
		do
			log ("XML callbacks on_content called. Got tag content", log_debug)
			log ("%Tcontent: " + a_content, log_debug)
--			if current_tag.is_equal ("Id") then
--				token.set_id (a_content)
--			elseif current_tag.is_equal ("Scadenza") then
--				create a_date.make_from_string (a_content, default_date_time_format)
--				token.set_expiry (a_date)
--			elseif current_tag.is_equal ("Esito") then
--				outcome := a_content.to_integer
--			elseif current_tag.is_equal ("Messaggio") then
--				message := a_content
--			end
		end


feature {NONE} -- Implementation

	log_path:     PATH
	file_logger:  LOG_WRITER_FILE

end
