note
	description: "Summary description for {LOGIN_MSG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the login message, for the time being only
--| json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for exemple:
--|
--| {
--|   "header": {
--|     "message_id":        <login_msg_id>
--|     "parameters_number": <login_msg_parnum>
--|   },
--|   "data": {
--|     "user": "a_username",
--|     "pwd":  "a_pwd"
--|   }
--| }
--|
--| The user password is not encrypted, but it could be in the future.
--| ----------------------------------------------------------------------------

class
	LOGIN_REQUEST

inherit
	REQUEST_I

create
	make,
	make_from_json_string

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create usr.make_empty
			create pwd.make_empty

			create json_representation.make_empty
			create xml_representation.make_empty

			parameters_number := login_request_parnum
		end

	make_from_json_string (json: STRING)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create usr.make_empty
			create pwd.make_empty

			create json_representation.make_empty
			create xml_representation.make_empty

			parameters_number := login_request_parnum

			from_json (json)
		end

feature -- Access

	id:                INTEGER once Result := login_request_id     end
	parameters_number: INTEGER

	username: STRING
			-- Access to `usr'
		do
			Result := usr
		end

	password: STRING
			-- Access to `pwd'
		do
			Result := pwd
		end

feature -- Status setting

	set_parameters_number (pn: INTEGER)
			-- Sets `parameters_number'
		do
			parameters_number := pn
		end

	set_logger (a_logger: LOG_LOGGING_FACILITY)
			-- Set the logger
		require
			logger_not_void: a_logger /= Void
		do
			logger := a_logger
		ensure
			logger_not_void: logger /= Void
		end

	set_username (a_username: STRING)
			-- Set `usr'
		do
			usr := a_username
		end

	set_password (a_password: STRING)
			-- Set `pwd'
		do
			pwd := a_password
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		require else
			usr_not_empty: not username.is_empty
			pwd_not_empty: not password.is_empty
		do
			create Result.make_from_string (xml_request_template)
			Result.replace_substring_all ("$usr", usr)
			Result.replace_substring_all ("$pwd", pwd)
			xml_representation := Result
		end

	from_json(json: STRING)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
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
					print ("Message: " + j_id.integer_64_item.out + ", " + j_parnum.integer_64_item.out + "%N")
				else
					print ("The header was not found!%N")
				end

				check parameters_number = {MSG_CONSTANTS}.login_request_parnum end

				key := "data"
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_data
					and then attached {JSON_STRING} j_data.item ("username") as j_usr
					and then attached {JSON_STRING} j_data.item ("password") as j_pwd
				then
					usr := j_usr.item
					pwd := j_pwd.item
				end
			end
		end

	to_json: STRING
			-- json representation
		do
			create Result.make_empty
			json_representation.append ("{")
			json_representation.append ("%"header%": {")
			json_representation.append ("%"id%": " + login_request_id.out)
			json_representation.append (",%"parameters_number%": " + login_request_parnum.out)
			json_representation.append ("},")
			json_representation.append ("%"data%": {")
			json_representation.append ("%"username%": %"" + usr + "%"")
			json_representation.append (",%"password%": %"" + pwd + "%"")
			json_representation.append ("}")
			json_representation.append ("}")
		end

	from_xml (xml: STRING)
			-- Parse xml message
		do
			-- should never be called in reuest classes
		end

feature -- Basic operations

	init_response: RESPONSE_I
			--
		once
			Result := create {LOGIN_RESPONSE}.make
		end

feature {NONE} -- Object implementation

	usr: STRING
	pwd: STRING

feature {NONE} -- Utilities implementation

	json_representation: STRING
	xml_representation:  STRING

	ws_url: STRING
			-- Web service URL
		once
			Result := authws_url
		end

	soap_action_header:  STRING
			-- SOAP action header
		once
			Result := "SOAPAction: " + remws_uri + "/" + authws_interface + "/" + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		once
			Result := "Login"
		end

	xml_request_template: STRING = "[
		  <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
          <s:Body>
            <Login xmlns="http://tempuri.org/">
              <xElInput>
                <Login xmlns="">
                  <Login>$usr</Login>
                  <Password>$pwd</Password>
                </Login>
              </xElInput>
            </Login>
          </s:Body>
        </s:Envelope>
	]"

invariant
	invariant_clause: True -- Your invariant here

end


--feature -- XML Callbacks

--	on_start
--			-- Called when parsing starts.
--		do
--			log ("XML callbacks on_start called. It's the beginning of the whole parsing.", log_debug)
--		end

--	on_finish
--			-- Called when parsing finished.
--		do
--			log ("XML callbacks on_finish called. The parsing has finished.", log_debug)
--		end

--	on_xml_declaration (a_version: READABLE_STRING_32; an_encoding: detachable READABLE_STRING_32; a_standalone: BOOLEAN)
--			-- XML declaration.
--		do
--			log ("XML callbacks on_xml_declaration called. Got xml declaration", log_debug)
--			if attached a_version as version then
--				log ("%TVersion:    " + version, log_debug)
--			end
--			if attached an_encoding as encoding then
--				log ("%TEncoding:   " + encoding, log_debug)
--			end
--			if attached a_standalone as standalone then
--				log ("%TStandalone: " + standalone.out, log_debug)
--			end
--		end

--	on_error (a_message: READABLE_STRING_32)
--			-- Event producer detected an error.
--		do
--			log ("XML callbacks on_error called.", log_debug)
--			log ("Got an error: " + a_message, log_debug)
--		end

--	on_processing_instruction (a_name: READABLE_STRING_32; a_content: READABLE_STRING_32)
--			-- Processing instruction.
--			--| See http://en.wikipedia.org/wiki/Processing_instruction
--		do
--			log ("XML callbacks on_processing_instruction called.", log_debug)
--			log ("%Tname;    " + a_name, log_debug)
--			log ("%Tcontent: " + a_content, log_debug)
--		end

--	on_comment (a_content: READABLE_STRING_32)
--			-- Processing a comment.
--			-- Atomic: single comment produces single event
--		do
--			log ("XML callbacks on_comment called. Got a comment.", log_debug)
--			log ("%Tcontent: " + a_content, log_debug)
--		end

--	on_start_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
--			-- Start of start tag.
--		do
--			log ("XML callbacks on_start_tag called. A tag is starting", log_debug)
--			if attached a_namespace as namespace then
--				log ("%Tnamespace: " + namespace, log_debug)
--			end
--			if attached a_prefix as myprefix then
--				log ("%Tprefix:    " + myprefix, log_debug)
--			end
--			log ("%Tlocal part:  " + a_local_part, log_debug)
--		end

--	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
--			-- Start of attribute.
--		do
--			log ("XML callbacks on_attribute called. Got an attribute", log_debug)
--			if attached a_namespace as namespace then
--				log ("%Tnamespace: " + namespace, log_debug)
--			end
--			if attached a_prefix as myprefix then
--				log ("%Tprefix:    " + myprefix, log_debug)
--			end
--			log ("%Tlocal part:  " + a_local_part, log_debug)
--			log ("%Tvalue:       " + a_value, log_debug)
--		end

--	on_start_tag_finish
--			-- End of start tag.
--		do
--			log ("XML callbacks on_start_tag_finish called. The start tag is finished.", log_debug)
--		end

--	on_end_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
--			-- End tag.
--		do
--			log ("XML callbacks on_end_tag called. Got the and tag.", log_debug)
--		end

--	on_content (a_content: READABLE_STRING_32)
--			-- Text content.
--			-- NOT atomic: two on_content events may follow each other
--			-- without a markup event in between.
--			--| this should not occur, but I leave this comment just in case
--		do
--			log ("XML callbacks on_content called. Got tag content", log_debug)
--			log ("%Tcontent: " + a_content, log_debug)
--		end
