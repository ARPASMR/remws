note
	description : "Summary description for {SENSO_LIST_REQUEST}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

--| ----------------------------------------------------------------------------
--| This is the message structure for the sensors list message, for the time
--| being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| `token_id' can be an empty string
--| `municipalities_list' can be an empty array
--| `stations_list' can be an empty array
--| `sensor_types_list' can be an empty array
--| `sensors_list' can be an empty array
--| `sensor_name' can be an empty string or a (partial/complete) sensor name
--|
--| {
--|   "header": {
--|     "id":                <sensor_list_request_id>
--|   },
--|   "data": {
--|     "municipalities_list": [{"municipality": "M1"},
--|                             {"municipality": "M2"},
--|                             ...,
--|                             {"municipality": "Mn"}],
--|     "stations_list":       [{"station": "ST1"},
--|                             {"station": "ST2"},
--|                             ...,
--|                             {"station": "STn"}],
--|     "sensor_types_list"    [{"type":    "T1"},
--|                             {"type":    "T2"},
--|                             ...,
--|                             {"type":    "Tn"}],
--|     "sensors_list":        [{"sensor":  "S1"},
--|                             {"sensor":  "S2"},
--|                             ...,
--|                             {"sensor":  "Sn"}],
--!     "sensor_name":         "a_sensor_name"
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

class
	SENSOR_LIST_REQUEST

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
			create municipalities_list.make (0)
			create stations_list.make (0)
			create sensor_types_list.make (0)
			create sensors_list.make (0)
			create sensor_name.make_empty
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create token_id.make_empty
			create municipalities_list.make (0)
			create stations_list.make (0)
			create sensor_types_list.make (0)
			create sensors_list.make (0)
			create sensor_name.make_empty
			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `MUNICIPALITY_LIST_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			create municipalities_list.make (0)
			create stations_list.make (0)
			create sensor_types_list.make (0)
			create sensors_list.make (0)
			create sensor_name.make_empty
		end

feature -- Access

	id: INTEGER
			-- message id
		do
			Result := station_list_request_id
		end

	token: STRING
			-- Access to `token_id'
		do
			Result := token_id
		end

	municipalities: ARRAYED_LIST[INTEGER]
			-- Access to `municipalities_list'
		do
			Result := municipalities_list
		end

	stations: ARRAYED_LIST[INTEGER]
			-- Access to `stations_list'
		do
			Result := stations_list
		end

	sensor_types: ARRAYED_LIST[INTEGER]
			-- Access to `sensor_types_list'
		do
			Result := sensor_types_list
		end

	sensors: ARRAYED_LIST[INTEGER]
			-- Access to `sensors_list'
		do
			Result := sensors_list
		end

	sensor: STRING
			-- Access to `sensor_name'
		do
			Result := sensor_name
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
			l_p_list:   STRING
			l_m_list:   STRING
			l_t_list:   STRING
			l_s_list:   STRING
			l_st_list:  STRING
		do
			create l_p_list.make_empty
			create l_m_list.make_empty
			create l_t_list.make_empty
			create l_s_list.make_empty
			create l_st_list.make_empty
			--create Result.make_from_string (xml_request_template)

			Result := xml_request_template.twin

			if token_id.is_empty then
				Result.replace_substring_all (stag_start + it_xml_token + stag_end,   null)
				Result.replace_substring_all (etag_start + it_xml_token + etag_end,   null)
				Result.replace_substring_all (stag_start + it_xml_id + stag_end,      null)
				Result.replace_substring_all (etag_start + it_xml_id + etag_end,      null)
				Result.replace_substring_all (it_tokenid, null)
			else
				Result.replace_substring_all (it_tokenid, token_id)
			end

			-- municipalities
			across
				municipalities_list as m
			loop
				l_m_list.append (stag_start + it_xml_municipality_id + stag_end)
				l_m_list.append (m.item.out)
				l_m_list.append (etag_start + it_xml_municipality_id + etag_end + lf_s)
			end

			-- stations
			across
				stations_list as s
			loop
				l_st_list.append (stag_start + it_xml_station_id + stag_end)
				l_st_list.append (s.item.out)
				l_st_list.append (etag_start + it_xml_station_id + etag_end + lf_s)
			end

			-- sensor types
			across
				sensor_types_list as t
			loop
				l_t_list.append (stag_start + it_xml_sensor_type_id + stag_end)
				l_t_list.append (t.item.out)
				l_t_list.append (etag_start + it_xml_sensor_type_id + etag_end + lf_s)
			end

			-- sensors
			across
				sensors_list as s
			loop
				l_p_list.append (stag_start + it_xml_sensor_id + stag_end)
				l_p_list.append (s.item.out)
				l_p_list.append (etag_start + it_xml_sensor_id + etag_end + lf_s)
			end

			Result.replace_substring_all (it_municipalities_list, l_m_list)
			Result.replace_substring_all (it_stations_list, l_st_list)
			Result.replace_substring_all (it_sensor_types_list, l_t_list)
			Result.replace_substring_all (it_sensors_list, l_s_list)
			Result.replace_substring_all (it_sensor_name, null)
		end

	from_json(json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		do
		 	parser.set_representation (json)
			parser.parse_content
			if parser.is_valid and then attached parser.parsed_json_value as jv then
				if not (attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_header_tag) as j_header
					and then attached {JSON_NUMBER} j_header.item (json_id_tag) as j_id)
				then
					print (msg_json_header_not_found)
				end
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_data_tag) as j_data
					and then attached {JSON_ARRAY}  j_data.item (json_municipalities_list_tag) as j_municipalities
					and then attached {JSON_ARRAY}  j_data.item (json_stations_list_tag)       as j_stations
					and then attached {JSON_ARRAY}  j_data.item (json_sensor_types_list_tag)   as j_sensor_types
					and then attached {JSON_ARRAY}  j_data.item (json_sensors_list_tag)        as j_sensors
					and then attached {JSON_STRING} j_data.item (json_sensor_name_tag)         as j_name
				then
					-- municipalities ID
					municipalities_list.wipe_out
					from j_municipalities.array_representation.start
					until j_municipalities.array_representation.after
					loop
						if attached {JSON_OBJECT} j_municipalities.array_representation.item as j_m
							and then attached {JSON_NUMBER} j_m.item (json_municipality_tag) as j_mid
						then
							municipalities_list.extend (j_mid.item.to_integer)
						end
						j_municipalities.array_representation.forth
					end

					-- stations ID
					stations_list.wipe_out
					from j_stations.array_representation.start
					until j_stations.array_representation.after
					loop
						if attached {JSON_OBJECT} j_stations.array_representation.item as j_station
							and then attached {JSON_STRING} j_station.item (json_name_tag) as j_st
						then
							stations_list.extend (j_st.item.to_integer)
						end
						j_stations.array_representation.forth
					end

					-- sensor types ID
					sensor_types_list.wipe_out
					from j_sensor_types.array_representation.start
					until j_sensor_types.array_representation.after
					loop
						if attached {JSON_OBJECT} j_sensor_types.array_representation.item as j_type
							and then attached {JSON_NUMBER} j_type.item (json_type_tag) as j_t
						then
							sensor_types_list.extend (j_t.item.to_integer)
						end
						j_sensor_types.array_representation.forth
					end

					-- sensors ID
					sensors_list.wipe_out
					from j_sensors.array_representation.start
					until j_sensors.array_representation.after
					loop
						if attached {JSON_OBJECT} j_sensors.array_representation.item as j_sensor
							and then attached {JSON_NUMBER} j_sensor.item (json_sensor_tag) as j_s
						then
							sensors_list.extend (j_s.item.to_integer)
						end
						j_sensors.array_representation.forth
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
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + sensor_list_request_id.out + right_brace)
			Result.append (comma + double_quotes + json_data_tag + double_quotes + colon + space + left_brace)

			-- municipalities
			Result.append (double_quotes + json_municipalities_list_tag + double_quotes + colon + space + left_bracket)

			from municipalities_list.start
			until municipalities_list.after
			loop
				Result.append (left_brace + double_quotes + json_municipality_tag + double_quotes + colon + space + municipalities_list.item.out + right_brace)
				if not municipalities_list.islast then
					Result.append (comma)
				end
				municipalities_list.forth
			end
			Result.append (right_bracket + comma)

			-- stations
			Result.append (double_quotes + json_stations_list_tag + double_quotes + colon + space + left_bracket)

			from stations_list.start
			until stations_list.after
			loop
				Result.append (left_brace + double_quotes + json_station_tag + double_quotes + colon + space + double_quotes + stations_list.item.out + double_quotes)
				if not stations_list.islast then
					Result.append (comma)
				end
				stations_list.forth
			end
			Result.append (right_bracket + comma)

			-- sensor types
			Result.append (double_quotes + json_sensor_types_list_tag + double_quotes + colon + space + left_bracket)

			from sensor_types_list.start
			until sensor_types_list.after
			loop
				Result.append (left_brace + double_quotes + json_type_tag + double_quotes + colon + space + double_quotes + sensor_types_list.item.out + double_quotes)
				if not sensor_types_list.islast then
					Result.append (comma)
				end
				sensor_types_list.forth
			end
			Result.append (right_bracket + comma)

			-- sensors
			Result.append (double_quotes + json_sensors_list_tag + double_quotes + colon + space + left_bracket)

			from sensors_list.start
			until sensors_list.after
			loop
				Result.append (left_brace + double_quotes + json_sensor_tag + double_quotes + colon + space + double_quotes + sensors_list.item.out + double_quotes)
				if not sensors_list.islast then
					Result.append (comma)
				end
				sensors_list.forth
			end
			Result.append (right_bracket + comma )

			Result.append (double_quotes + json_sensor_name_tag + double_quotes + colon + space + double_quotes + sensor_name + double_quotes)

			Result.append (right_brace + right_brace)
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
			Result := create {SENSOR_LIST_RESPONSE}.make
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
			Result := sensors_list_endpoint_name
		end

	xml_request_template: STRING
			-- Request template
		do
--			Result := "[
--		                  <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--                            <s:Body>
--                              <ElencoSensori xmlns="http://tempuri.org/">
--                                <xInput>
--                                  <ElencoSensori xmlns="">
--                                    <Token>
--                                      <Id>$tokenid</Id>
--                                    </Token>
--                                    <Comuni>$municipalities_list</Comuni>
--                                    <Stazioni>$stations_list</Stazioni>
--                                    <TipoSensore>$sensor_types_list</TipoSensore>
--                                    <Sensori>$sensors_list</Sensori>
--                                    <NomeSensore>$sensor_name</NomeSensore>
--                                  </ElencoSensori>
--                                </xInput>
--                              </ElencoSensori>
--                            </s:Body>
--                          </s:Envelope>
--	                   ]"

			create Result.make_empty
			Result.append (stag_start + xmlns_s + colon + soap_envelope + space + xmlns + colon + xmlns_s + eq_s + double_quotes + xmlsoap + double_quotes + stag_end + lf_s)
			  Result.append (double_space + stag_start + xmlns_s + colon + body + stag_end + lf_s)
			    Result.append (double_space + double_space + stag_start + sensors_list_endpoint_name + space + xmlns + eq_s + double_quotes + remws_uri + url_path_separator + double_quotes + stag_end + lf_s)
			      Result.append (double_space + double_space + double_space + stag_start + xinput + stag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + stag_start + sensors_list_endpoint_name + space + xmlns + eq_s + double_quotes + double_quotes + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_token + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_id + stag_end + it_tokenid + etag_start + it_xml_id + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_token + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_municipalities + stag_end)
					    Result.append (it_municipalities_list)
					  Result.append (etag_start + it_xml_municipalities + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_stations + stag_end)
					    Result.append (it_stations_list)
					  Result.append (etag_start + it_xml_stations + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_sensor_type + stag_end)
					    Result.append (it_sensor_types_list)
					  Result.append (etag_start + it_xml_sensor_type + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_sensors + stag_end)
					    Result.append (it_sensors_list)
					  Result.append (etag_start + it_xml_sensors + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_sensor_name + stag_end + it_sensor_name +
					                 etag_start + it_xml_sensor_name + etag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + etag_start + sensors_list_endpoint_name + etag_end + lf_s)
			      Result.append (double_space + double_space + double_space + etag_start + xinput + etag_end + lf_s)
			    Result.append (double_space + double_space + etag_start + sensors_list_endpoint_name + etag_end + lf_s)
			  Result.append (double_space + etag_start + xmlns_s + colon + body + etag_end + lf_s)
			Result.append (etag_start + xmlns_s + colon + soap_envelope + etag_end + lf_s)
		end

feature {NONE} -- Implementation

	token_id:            STRING

	municipalities_list: ARRAYED_LIST[INTEGER]
	stations_list:       ARRAYED_LIST[INTEGER]
	sensor_types_list:   ARRAYED_LIST[INTEGER]
	sensors_list:        ARRAYED_LIST[INTEGER]
	sensor_name:         STRING

end
