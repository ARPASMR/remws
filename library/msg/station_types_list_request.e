note
	description: "Summary description for {STATION_TYPES_LIST_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the login message, for the time being only
--| json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--|
--| {
--|   "header": {
--|     "id":                <station_types_list_msg_id>
--|   },
--|   "data": {}
--| }
--|
--| ----------------------------------------------------------------------------

class
	STATION_TYPES_LIST_REQUEST

inherit
	REQUEST_I

create
	make,
	make_from_json_string,
	make_from_token

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create token_id.make_empty

			create json_representation.make_empty
			create xml_representation.make_empty
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create token_id.make_empty

			create json_representation.make_empty
			create xml_representation.make_empty

			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `STATION_TYPES_LIST_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			--parnum := station_status_list_request_parnum_token

			create json_representation.make_empty
			create xml_representation.make_empty
		end

feature -- Access

	id: INTEGER
			-- message id
		do
			Result := station_types_list_request_id
		end

	token: STRING
			-- Access to `token_id'
		do
			Result := token_id
		end

feature -- Status setting

	set_logger (a_logger: LOG_LOGGING_FACILITY)
			-- Set the logger
		require
			logger_not_void: a_logger /= Void
		do
			logger := a_logger
		ensure
			logger_not_void: logger /= Void
		end

	set_token_id (a_token: STRING)
			-- Set `token_id'
		do
			token_id.copy (a_token)
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		local
			l_token_id: STRING
		do
			create l_token_id.make_from_string (token_id)
			create Result.make_from_string (xml_request_template)
			if token_id.is_empty then
				Result.replace_substring_all ("<Token>",   "")
				Result.replace_substring_all ("</Token>",  "")
				Result.replace_substring_all ("<Id>",      "")
				Result.replace_substring_all ("</Id>",     "")
				Result.replace_substring_all ("$tokenid",  "")
			else
				--l_token_id.replace_substring_all ("-", "")
				Result.replace_substring_all ("$tokenid", l_token_id)
			end
			xml_representation := Result
			l_token_id.wipe_out
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
			json_representation.copy (json)
		 	--create json_parser.make_with_string (json)
		 	parser.reset_reader
		 	parser.reset
		 	parser.set_representation (json)

			create key.make_from_string ("header")
			parser.parse_content
			if parser.is_valid and then attached parser.parsed_json_value as jv then
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_header
					and then attached {JSON_NUMBER} j_header.item ("id") as j_id
					--and then attached {JSON_NUMBER} j_header.item ("parameters_number") as j_parnum
				then
					print ("Message: " + j_id.integer_64_item.out + "%N") --", " + j_parnum.integer_64_item.out + "%N")
				else
					print ("The header was not found!%N")
				end

				key := "data"
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_data
					--and then attached {JSON_STRING} j_data.item ("tokenid") as j_tokenid
				then
					--token_id := j_tokenid.item
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

			json_representation.wipe_out

			json_representation.append ("{")
			json_representation.append ("%"header%": {")
			json_representation.append ("%"id%": " + station_status_list_request_id.out)
			json_representation.append (",%"parameters_number%": " + station_status_list_request_parnum_token.out + "}")
			json_representation.append (",%"data%": {}}")

			Result.copy (json_representation)
		end

	from_xml (xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse xml message
		do
			-- should never be called from request messages
		end

feature -- Basic operations

	init_response: RESPONSE_I
			--
		do
			Result := create {STATION_TYPES_LIST_RESPONSE}.make
		end

feature {DISPOSANLE}

	dispose
			--
		do
			json_representation.wipe_out
			xml_representation.wipe_out
		end

feature {NONE} -- Object implementation

	token_id: STRING
			--
	--parnum:   INTEGER
			--

feature {NONE} -- Utilities implementation

	json_representation: STRING
	xml_representation:  STRING

	ws_url: STRING
			-- Web service URL
		do
			Result := anaws_url
		end

	ws_test_url: STRING
			-- Testing web service URL
		do
			Result := anaws_test_url
		end

	soap_action_header:  STRING
			-- SOAP action header
		do
			Result := "SOAPAction: " + remws_uri + "/" + anaws_interface + "/" + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := "ElencoTipiStazione"
		end

	xml_request_template: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
          <s:Body>
            <ElencoTipiStazione xmlns="http://tempuri.org/">
              <xInput>
                <ElencoTipiStazione xmlns="">
                  <Token>
                    <Id>$tokenid</Id>
                  </Token>
                </ElencoTipiStazione>
              </xInput>
            </ElencoTipiStazione>
          </s:Body>
        </s:Envelope>
	]"

invariant
	invariant_clause: True -- Your invariant here

end
