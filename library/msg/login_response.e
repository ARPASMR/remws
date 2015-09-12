note
	description: "Summary description for {LOGIN_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGIN_RESPONSE

inherit
	RESPONSE_I
	ERROR_CODES

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create json_representation.make_empty
			create xml_representation.make_empty
			create current_tag.make_empty
			create content.make_empty
			create message.make_empty
			create token.make
		end

feature -- Access

	id:                  INTEGER once Result := login_request_id + response_id_offset end
	parameters_number:   INTEGER

	outcome:             INTEGER
	message:             STRING

	token:               TOKEN

feature -- Status setting

	set_parameters_number (pn:INTEGER)
			-- Sets `parameters_number'
		do
			parameters_number := pn
		end

	set_outcome (o: INTEGER)
			-- Sets `outcome'
		do
			outcome := o
		end

	set_message (m: STRING)
			-- Sets `message'
		do
			message.copy (m)
		end

	set_logger (a_logger: LOG_LOGGING_FACILITY)
			-- Sets the logger
		require
			logger_not_void: a_logger /= Void
		do
			logger := a_logger
		ensure
			logger_not_void: logger /= Void
		end

feature -- Status report

	is_error_response: BOOLEAN
			-- Tells wether the response contains an error
		do
			Result := outcome /= success
		end

feature -- Conversion

	to_json: STRING
			-- json representation
		do
			json_representation.wipe_out

			json_representation.append ("{")
			json_representation.append ("%"header%": {")
			json_representation.append ("%"id%": " + login_response_id.out)
			json_representation.append (",%"parameters_number%": " + parameters_number.out)
			json_representation.append ("},")
			json_representation.append ("%"data%": {")
			if not is_error_response then
				json_representation.append ("%"tokenid%": %""  + token.id + "%"")
				json_representation.append (",%"expiry%": %""  + token.expiry.formatted_out (default_date_time_format) + "%",")
			end
			json_representation.append ("%"outcome%": " + outcome.out)
			json_representation.append (",%"message%": %"" + message + "%"")
			json_representation.append ("}")
			json_representation.append ("}")

--			if is_error_response then
--				json_representation.append ("{")
--				json_representation.append ("%"header%": {")
--				json_representation.append ("%"id%": " + login_response_id.out)
--				json_representation.append (",%"parameters_number%": " + login_response_error_parnum.out)
--				json_representation.append ("},")
--				json_representation.append ("%"data%": {")
--				json_representation.append ("%"outcome%": " + outcome.out)
--				json_representation.append (",%"message%": %"" + message + "%"")
--				json_representation.append ("}")
--				json_representation.append ("}")
--			else
--				parameters_number := login_response_success_parnum
--				json_representation.append ("{")
--				json_representation.append ("%"header%": {")
--				json_representation.append ("%"id%": " + login_response_id.out)
--				json_representation.append (",%"parameters_number%": " + login_response_error_parnum.out)
--				json_representation.append ("},")
--				json_representation.append ("%"data%": {")
--				json_representation.append ("%"tokenid%": %""  + token.id + "%"")
--				json_representation.append (",%"expiry%": %""  + token.expiry.formatted_out (default_date_time_format) + "%"")
--				json_representation.append (",%"outcome%": "   + outcome.out)
--				json_representation.append (",%"message%": %"" + message + "%"")
--				json_representation.append ("}")
--				json_representation.append ("}")
--			end

			Result := json_representation
		end

--  Login response example
--	<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--	  <s:Body>
--		<Logout xmlns="http://tempuri.org/">
--		  <xElInput>
--			<Logout xmlns="">
--			  <Token>
--				<Id>68444712-A728-4C04-A367-38C47A4B1A6E</Id>
--              <Scadenza>2013-05-20 13:45:00</Scadenza>
--			  </Token>
--			</Logout>
--		  </xElInput>
--		</Logout>
--	  </s:Body>
--	</s:Envelope>

	from_xml(xml: STRING)
			-- Parse XML message
	local
		parser: XML_STANDARD_PARSER
		factory: XML_PARSER_FACTORY
	do
		create factory

		parser := factory.new_standard_parser
		parser.set_callbacks (Current)
		set_associated_parser (parser)
		parser.parse_from_string (xml)
		if token.id.is_empty then
			parameters_number := login_response_error_parnum
		else
			parameters_number := login_response_success_parnum
		end
	end

	to_xml: STRING
			-- xml representation
		do
			-- should never be called in response classes
			create result.make_empty
			if parameters_number = login_response_error_parnum then
				Result.append ("<s:Envelope xmlns:s=%"http://schemas.xmlsoap.org/soap/envelope/%">")
				Result.append ("<s:Body><LoginResponse xmlns=%"http://tempuri.org/%">")
				Result.append ("<LoginResult><LoginResponse xmlns=%"%"><LoginResult>")
				Result.append ("<Esito>" + outcome.out + "</Esito>")
				Result.append ("<Messaggio>" + message + "</Messaggio></LoginResult>")
				Result.append ("</LoginResponse></LoginResult></LoginResponse></s:Body></s:Envelope>")
			elseif parameters_number = login_response_success_parnum then
				Result.append ("<s:Envelope xmlns:s=%"http://schemas.xmlsoap.org/soap/envelope/%">")
				Result.append ("<s:Body><LoginResponse xmlns=%"http://tempuri.org/%">")
				Result.append ("<LoginResult><LoginResponse xmlns=%"%"><LoginResult>")
				Result.append ("<Token><Id>" + token.id + "</Id>")
				Result.append ("<Scadenza>" + token.expiry.formatted_out (default_date_time_format) + "</Scadenza>")
				Result.append ("</Token><Esito>" + outcome.out + "</Esito>")
				Result.append ("<Messaggio>" + message + "</Messaggio></LoginResult>")
				Result.append ("</LoginResponse></LoginResult></LoginResponse></s:Body></s:Envelope>")
			end
		end

	from_json (json: STRING)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
		local
			key:         JSON_STRING
			json_parser: JSON_PARSER
			dt:          DATE_TIME
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
					parameters_number := j_parnum.integer_64_item.to_integer
				else
					print ("The header was not found!%N")
				end

				check
					parameters_number = login_response_error_parnum or
					parameters_number = login_response_success_parnum
				end

				key := "data"
				if parameters_number = login_response_success_parnum then
					if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_data
						and then attached {JSON_STRING} j_data.item ("tokenid") as j_token
						and then attached {JSON_STRING} j_data.item ("expiry") as j_expiry
						and then attached {JSON_NUMBER} j_data.item ("outcome") as j_outcome
						and then attached {JSON_STRING} j_data.item ("message") as j_message
					then
						token.set_id (j_token.item)
						create dt.make_from_string (j_expiry.item, default_date_time_format)
						token.set_expiry (dt)
						set_outcome (j_outcome.integer_64_item.to_integer)
						set_message (j_message.item)
					end
				end
			end
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
			if attached a_version as version then
				log ("%TVersion:    " + version, log_debug)
			end
			if attached an_encoding as encoding then
				log ("%TEncoding:   " + encoding, log_debug)
			end
			if attached a_standalone as standalone then
				log ("%TStandalone: " + standalone.out, log_debug)
			end
		end

	on_error (a_message: READABLE_STRING_32)
			-- Event producer detected an error.
		do
			outcome := {ERROR_CODES}.err_xml_parsing_failed
			message := {ERROR_CODES}.msg_xml_parser_failed
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
			if attached a_namespace as namespace then
				log ("%Tnamespace: " + namespace, log_debug)
			end
			if attached a_prefix as myprefix then
				log ("%Tprefix:    " + myprefix, log_debug)
			end
			log ("%Tlocal part:  " + a_local_part, log_debug)
			current_tag := a_local_part
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
			if current_tag.is_equal ("Id") then
				token.set_id (a_content)
			elseif current_tag.is_equal ("Scadenza") then
				create a_date.make_from_string (a_content, default_date_time_format)
				token.set_expiry (a_date)
			elseif current_tag.is_equal ("Esito") then
				outcome := a_content.to_integer
			elseif current_tag.is_equal ("Messaggio") then
				message := a_content
			end
		end

feature {NONE} -- Implementation

	json_representation: STRING
			-- message json representation

	xml_representation:  STRING
			-- message xml representation

	current_tag:         STRING
			-- used by `XML_CALLBACKS' features
	content:             STRING
			-- used by `XML_CALLBACKS' features

invariant
	invariant_clause: True -- Your invariant here

end
