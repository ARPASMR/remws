note
	description: "Summary description for {LOGOUT_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGOUT_REQUEST

inherit
	REQUEST_I
	DISPOSABLE

--| ----------------------------------------------------------------------------
--| This is the message structure for the login message, for the time being only
--| json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for exemple:
--|
--| {
--|   "header": {
--|     "id":                <logout_msg_id>
--|     "parameters_number": <logout_msg_parnum>
--|   },
--|   "data": {
--|     "id": "a_tokenid"
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

create
	make,
	make_from_string,
	make_from_token

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create token_id.make_empty

			create json_representation.make_empty
			create xml_representation.make_empty

			parameters_number := logout_request_parnum
		end

	make_from_string (token: STRING)
			-- make from string token
		require
			token_not_void: token /=Void and not token.is_empty
		do
			token_id := token
			create json_representation.make_empty
			create xml_representation.make_empty

			parameters_number := logout_request_parnum
		end

	make_from_token (token: TOKEN)
			-- make from a `TOKEN'
		require
			token_not_void: token /= Void and then token.id /= Void
		do
			token_id := token.id
			create json_representation.make_empty
			create xml_representation.make_empty

			parameters_number := logout_request_parnum
		end

feature -- Access

	id:                INTEGER do Result := logout_request_id     end
	parameters_number: INTEGER

	token_id:          STRING
			-- Access to `token_id'

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

	set_token_id (a_token_id: STRING)
			-- Set `token_id'
		do
			token_id.copy (a_token_id)
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		require else
			token_id_not_empty: not token_id.is_empty
		do
			create Result.make_from_string (xml_request_template)
			Result.replace_substring_all ("$token_id", token_id)
			xml_representation := Result
		end

	from_json(json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		local
			key:         JSON_STRING
			--json_parser: JSON_PARSER
		do
			--create json_parser.make_with_string (json)
			parser.reset_reader
			parser.reset
			parser.set_representation (json)

			create key.make_from_string ("header")
			parser.parse_content
			if parser.is_valid and then attached parser.parsed_json_value as jv then
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_header
					and then attached {JSON_NUMBER} j_header.item ("id") as j_id
					and then attached {JSON_NUMBER} j_header.item ("parameters_number") as j_parnum
				then
					print ("Message: " + j_id.integer_64_item.out + ", " + j_parnum.integer_64_item.out + "%N")
				else
					print ("The header was not found!%N")
				end

				check parameters_number = {MSG_CONSTANTS}.logout_request_parnum end

				key := "data"
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_data
					and then attached {JSON_STRING} j_data.item ("id") as j_id
				then
					-- set token_id during parsing
					token_id := j_id.item
				end
			end
			parser.reset_reader
			parser.reset
			key.item.wipe_out
		end

	to_json: STRING
			-- json representation
		do
			create Result.make_empty
			json_representation.append ("{")
			json_representation.append ("%"header%": {")
			json_representation.append ("%"id%": " + logout_request_id.out)
			json_representation.append (",%"parameters_number%": " + logout_request_parnum.out)
			json_representation.append ("},")
			json_representation.append ("%"data%": {")
			json_representation.append ("%"tokenid%": %"" + token_id + "%"")
			json_representation.append ("}")
			json_representation.append ("}")
		end

	from_xml (xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse xml message
		do
			-- should never be called in reuest classes
		end

feature -- Basic operations

	init_response: RESPONSE_I
			--
		do
			Result := create {LOGOUT_RESPONSE}.make
		end

feature -- {DISPOSABLE}

	dispose
			--
		do
			if not is_in_final_collect then
				if attached json_representation as l_json_representation then l_json_representation.wipe_out end
				if attached xml_representation  as l_xml_representation  then l_xml_representation.wipe_out  end
			end
		end

feature {NONE} -- Utilities implementation

	json_representation: STRING
	xml_representation:  STRING

	ws_url: STRING
			-- Web service URL
		do
			Result := authws_url
		end

	ws_test_url: STRING
			-- Testing web service URL
		do
			Result := anaws_test_url
		end

	soap_action_header:  STRING
			-- SOAP action header
		do
			--Result := "SOAPAction: " + remws_uri + "/" + authws_interface + "/" + name
			Result := remws_uri + "/" + authws_interface + "/" + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := "Logout"
		end

	xml_request_template: STRING
			-- XML `Current' message request template
		do
			Result := "[
				<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
          		  <s:Body>
                    <Logout xmlns="http://tempuri.org/">
                      <xElInput>
                        <Logout xmlns="">
                          <Token>
                            <Id>$token_id</Id>
                          </Token>
                        </Logout>
                      </xElInput>
                    </Logout>
                  </s:Body>
                </s:Envelope>
        	]"
		end

invariant
	invariant_clause: True -- Your invariant here

end
