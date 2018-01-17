note
	description : "Summary description for {SENSOR_TYPE_LIST_REQUEST}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

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
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create token_id.make_empty
			create stations_list.make (0)
			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `STATION_STATUS_LIST_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			create stations_list.make (0)
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
			token_id := a_token.twin
		end


feature -- Conversion

	to_xml: STRING
			-- XML representation
		local
			l_stations_list: STRING
		do
			--create Result.make_from_string (xml_request_template)
			Result := xml_request_template.twin
			if not attached token_id as l_token_id then
				Result.replace_substring_all (stag_start + it_xml_token + stag_end,   null)
				Result.replace_substring_all (etag_start + it_xml_token + etag_end,   null)
				Result.replace_substring_all (stag_start + it_xml_id + stag_end,      null)
				Result.replace_substring_all (etag_start + it_xml_id + etag_end,      null)
				Result.replace_substring_all (it_tokenid, null)
			else
				Result.replace_substring_all (it_tokenid, l_token_id)
			end

			create l_stations_list.make_empty

			from stations_list.start
			until stations_list.after
			loop
				l_stations_list.append (stag_start + it_xml_station_id + stag_end + stations_list.item.out + etag_start + it_xml_station_id + etag_end + lf_s)
				stations_list.forth
			end

			Result.replace_substring_all (it_stations, l_stations_list)
		end

	from_json(json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		do
			stations_list.wipe_out
		 	parser.set_representation (json)
			parser.parse_content
			if parser.is_valid and then attached parser.parsed_json_value as jv then
				if not (attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_header_tag) as j_header
					and then attached {JSON_NUMBER} j_header.item (json_id_tag) as j_id)
				then
					print (msg_json_header_not_found)
				end

				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_data_tag) as j_data
					and then attached {JSON_ARRAY} j_data.item (json_stations_list_tag) as j_stations
				then
					from j_stations.array_representation.start
					until j_stations.array_representation.after
					loop
						if attached {JSON_OBJECT} j_stations.array_representation.item as j_station_id
							and then attached {JSON_NUMBER} j_station_id.item (json_id_tag) as j_id
						then
							stations_list.extend (j_id.item.to_integer)
							j_stations.array_representation.forth
						end
					end
				end
			end
		end

	to_json: STRING
			-- json representation
		do
			create Result.make_empty
			Result.append (left_brace)
			Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + sensor_type_list_request_id.out + right_brace)
			Result.append (comma + double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_stations_list_tag + double_quotes + colon + space + left_bracket)
			from stations_list.start
			until stations_list.after
			loop
				Result.append (left_brace + double_quotes + json_id_tag + double_quotes + colon + space + stations_list.item.out + right_brace)
				if not stations_list.islast then
					Result.append (comma)
				end
				stations_list.forth
			end
			Result.append (right_bracket + right_brace + right_brace)
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
		end

feature -- Status reporting

	xml_pretty_out:  STRING
			-- XML pretty out
		do
			Result := null
		end

feature {NONE} -- Object implementation

	token_id: STRING
			--
	stations_list: ARRAYED_LIST[INTEGER]
			--

feature {NONE} -- Utilities implementation

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
			Result := remws_uri + url_path_separator + anaws_interface + url_path_separator + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := sensor_types_list_endpoint_name
		end

	xml_request_template: STRING
			-- Request XML tempalte
		do
--			Result :=  "[
--		                  <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--                            <s:Body>
--                              <ElencoTipologieSensore xmlns="http://tempuri.org/">
--                                <xInput>
--                                  <ElencoTipologieSensore xmlns="">
--                                    <Token>
--                                      <Id>$tokenid</Id>
--                                    </Token>
--                                    <Stazioni>
--                                      $stations
--                                    </Stazioni>
--                                  </ElencoTipologieSensore>
--                                </xInput>
--                              </ElencoTipologieSensore>
--                            </s:Body>
--                          </s:Envelope>
--	                    ]"
			create Result.make_empty
			Result.append (stag_start + xmlns_s + colon + soap_envelope + space + xmlns + colon + xmlns_s + eq_s + double_quotes + xmlsoap + double_quotes + stag_end + lf_s)
			  Result.append (double_space + stag_start + xmlns_s + colon + body + stag_end + lf_s)
			    Result.append (double_space + double_space + stag_start + it_xml_sensor_types_list + space + xmlns + eq_s + double_quotes + remws_uri + url_path_separator + double_quotes + stag_end + lf_s)
			      Result.append (double_space + double_space + double_space + stag_start + xinput + stag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + stag_start + it_xml_sensor_types_list + space + xmlns + eq_s + double_quotes + double_quotes + stag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_token + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_id + stag_end + it_tokenid +
			                           etag_start + it_xml_id + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_token + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + stag_start + it_xml_stations + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + it_stations + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + etag_start + it_xml_stations + etag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + etag_start + it_xml_sensor_types_list + etag_end + lf_s)
			      Result.append (double_space + double_space + double_space + etag_start + xinput + etag_end + lf_s)
			    Result.append (double_space + double_space + etag_start + it_xml_sensor_types_list + etag_end + lf_s)
			  Result.append (double_space + etag_start + xmlns_s + colon + body + etag_end + lf_s)
			Result.append (etag_start + xmlns_s + colon + soap_envelope + etag_end + lf_s)
		end

invariant
	invariant_clause: True -- Your invariant here

end
