note
	description: "Summary description for {SENSOR_TYPE_LIST_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the sensor type list message, for the time
--| being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--| stations can be an empty array
--|
--| {
--|   "header": {
--|     "id":                <sensor_type_list_msg_id>
--|   },
--|   "data": {
--|     "stations_list": [{"id": id1},
--|                       {"id": id2},
--|                       ...,
--|                       {"id": idn}]
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

class
	SENSOR_TYPE_LIST_REQUEST

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
			create stations_list.make (0)

			create json_representation.make_empty
			create xml_representation.make_empty
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create token_id.make_empty
			create stations_list.make (0)

			create json_representation.make_empty
			create xml_representation.make_empty

			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `STATION_STATUS_LIST_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			create stations_list.make (0)
			parnum := sensor_type_list_request_parnum_token

			create json_representation.make_empty
			create xml_representation.make_empty
		end

feature -- Access

	id: INTEGER
			-- message id
		do
			Result := sensor_type_list_request_id
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
			i:               INTEGER
			l_token_id:      STRING
			l_stations_list: STRING
		do
			create l_token_id.make_from_string (token_id)
			create Result.make_from_string (xml_request_template)
			if token_id.is_empty then
				Result.replace_substring_all ("<Token>",   "")
				Result.replace_substring_all ("</Token>",  "")
				Result.replace_substring_all ("<Id>",      "")
				Result.replace_substring_all ("</Id>",     "")
				Result.replace_substring_all ("$tokenid", "")
			else
				--l_token_id.replace_substring_all ("-", "")
				Result.replace_substring_all ("$tokenid", l_token_id)
			end

			create l_stations_list.make_empty

			from i := 1
			until i = stations_list.count + 1
			loop
				l_stations_list.append ("<IdStazione>" + stations_list.i_th (i).out + "</IdStazione>%N")
			end

			Result.replace_substring_all ("$stations", l_stations_list)

			xml_representation := Result

			l_token_id.wipe_out
			l_stations_list.wipe_out
		end

	from_json(json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		local
			i:           INTEGER
			key:         JSON_STRING
			--json_parser: JSON_PARSER
		do
			stations_list.wipe_out

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
				then
					print ("Message: " + j_id.integer_64_item.out + "%N")
				else
					print ("The header was not found!%N")
				end

				key := "data"
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_data
					--and then attached {JSON_STRING} j_data.item ("tokenid") as j_tokenid
					and then attached {JSON_ARRAY} j_data.item ("stations_list") as j_stations
				then
					--token_id := j_tokenid.item

					from i:= 1
					until i = j_stations.count + 1
					loop
						if attached {JSON_OBJECT} j_stations.i_th (i) as j_station_id
							and then attached {JSON_NUMBER} j_station_id.item ("id") as j_id
						then
							stations_list.extend (j_id.item.to_integer)
							i := i + 1
						end
					end
				end
			end
			parser.reset_reader
			parser.reset
			key.item.wipe_out
		end

	to_json: STRING
			-- json representation
		local
			i: INTEGER
		do
			create Result.make_empty
			-- TODO
			json_representation.wipe_out

			json_representation.append ("{")
			json_representation.append ("%"header%": {")
			json_representation.append ("%"id%": " + station_status_list_request_id.out)
			json_representation.append (",%"parameters_number%": " + station_status_list_request_parnum_token.out + "}")
			json_representation.append (",%"data%": {")
			--json_representation.append ("%"tokenid%": %"" + token_id + "%",")
			json_representation.append ("%"stations_list%": [")
			from i := 1
			until i = stations_list.count + 1
			loop
				if i > 1 then
					json_representation.append (",")
				end
				json_representation.append ("{%"id%": " + stations_list.i_th (i).out + "}")
			end
			json_representation.append ("]}}")
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
			Result := create {SENSOR_TYPE_LIST_RESPONSE}.make
		end
feature -- {DISPOSABLE}

	dispose
			--
		do
			json_representation.wipe_out
			xml_representation.wipe_out
			stations_list.wipe_out
		end

feature {NONE} -- Object implementation

	token_id: STRING
			--
	parnum:   INTEGER
			--
	stations_list: ARRAYED_LIST[INTEGER]
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
			--Result := "SOAPAction: " + remws_uri + "/" + anaws_interface + "/" + name
			Result := remws_uri + "/" + anaws_interface + "/" + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := "ElencoTipologieSensore"
		end

	xml_request_template: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
          <s:Body>
            <ElencoTipologieSensore xmlns="http://tempuri.org/">
              <xInput>
                <ElencoTipologieSensore xmlns="">
                  <Token>
                    <Id>$tokenid</Id>
                  </Token>
                  <Stazioni>
                    $stations
                  </Stazioni>
                </ElencoTipologieSensore>
              </xInput>
            </ElencoTipologieSensore>
          </s:Body>
        </s:Envelope>
	]"

invariant
	invariant_clause: True -- Your invariant here

end
