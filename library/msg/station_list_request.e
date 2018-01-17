note
	description : "Summary description for {STATION_LIST_REQUEST}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

--| ----------------------------------------------------------------------------
--| This is the message structure for the stations list message, for the time
--| being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| `token_id' can be an empty string
--| `municipalities_list' can be an empty array
--| `provinces_list' can be an empty array
--| `types_list' can be an empty array
--| `status_list' can be an empty array
--| `stations_list' can be an empty array
--| `station_name' can be an empty string or a (partial) station name
--|
--| {
--|   "header": {
--|     "id": <station_list_request_id> =
--|   },
--|   "data": {
--|     "municipalities_list": [{"municipality": "M1"},
--|                             {"municipality": "M2"},
--|                             ...,
--|                             {"municipality": "Mn"}],
--|     "provinces_list":      [{"province": "P1"},
--|                             {"province": "P2"},
--|                             ...,
--|                             {"province": "Pn"}],
--|     "types_list":          [{"type": "T1"},
--|                             {"type": "T2"},
--|                             ...,
--|                             {"type": "Tn"}],
--|     "status_list":         [{"status": "S1"},
--|                             {"status": "S2"},
--|                             ...,
--|                             {"status": "Sn"}]
--|     "stations_list":       [{"station": "ST1"},
--|                             {"station": "ST2"},
--|                             ...,
--|                             {"station": "STn"}],
--!     "station_name":         "a_station_name"
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

class
	STATION_LIST_REQUEST

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
			create provinces_list.make (0)
			create types_list.make (0)
			create status_list.make (0)
			create stations_list.make (0)
			create station_name.make_empty
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create token_id.make_empty
			create municipalities_list.make (0)
			create provinces_list.make (0)
			create types_list.make (0)
			create status_list.make (0)
			create stations_list.make (0)
			create station_name.make_empty
			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `MUNICIPALITY_LIST_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			create municipalities_list.make (0)
			create provinces_list.make (0)
			create types_list.make (0)
			create status_list.make (0)
			create stations_list.make (0)
			create station_name.make_empty
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

	provinces: ARRAYED_LIST[STRING]
			-- Access to `provinces_list'
		do
			Result := provinces_list
		end

	types: ARRAYED_LIST[INTEGER]
			-- Access to `types_list'
		do
			Result := types_list
		end

	status: ARRAYED_LIST[INTEGER]
			-- Access to `status_list'
		do
			Result := status_list
		end

	stations: ARRAYED_LIST[INTEGER]
			-- Access to `stations_list'
		do
			Result := stations_list
		end

	station: STRING
			-- Access to `station_name'
		do
			Result := station_name
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
			l_str_list:   detachable STRING
		do
			create l_str_list.make_empty
			--create Result.make_from_string (xml_request_template)
			Result := xml_request_template.twin

			if not attached token_id as l_token_id then
				Result.replace_substring_all (stag_start + it_xml_token + stag_end,  null)
				Result.replace_substring_all (etag_start + it_xml_token + etag_end,  null)
				Result.replace_substring_all (stag_start + it_xml_id + stag_end,     null)
				Result.replace_substring_all (etag_start + it_xml_id + etag_end,     null)
				Result.replace_substring_all (it_tokenid, null)
			else
				Result.replace_substring_all (it_tokenid, l_token_id)
			end

			-- municipalities
			across
				municipalities as m
			loop
				l_str_list.append (stag_start + it_xml_municipality_id + stag_end)
				l_str_list.append (m.item.out)
				l_str_list.append (etag_start + it_xml_municipality_id + etag_end)
			end
			Result.replace_substring_all (it_municipalities_list, l_str_list)
			l_str_list.wipe_out

			-- provinces
			across
				provinces as p
			loop
				l_str_list.append (stag_start + it_xml_province + stag_end)
				l_str_list.append (p.item)
				l_str_list.append (etag_start + it_xml_province + etag_end)
			end
			Result.replace_substring_all (it_provinces_list, l_str_list)
			l_str_list.wipe_out

			-- types
			across
				types_list as t
			loop
				l_str_list.append (stag_start + it_xml_type_id + stag_end)
				l_str_list.append (types_list.item.out)
				l_str_list.append (etag_start + it_xml_type_id + etag_end)
			end
			Result.replace_substring_all (it_types_list, l_str_list)
			l_str_list.wipe_out

			-- status
			across
				status_list as s
			loop
				l_str_list.append (stag_start + it_xml_status_id + stag_end)
				l_str_list.append (s.item.out)
				l_str_list.append (etag_start + it_xml_status_id + etag_end)
			end
			Result.replace_substring_all (it_status_list, l_str_list)
			l_str_list.wipe_out

			-- stations
			across
				stations_list as s
			loop
				l_str_list.append (stag_start + it_xml_station_id + stag_end)
				l_str_list.append (s.item.out)
				l_str_list.append (etag_start + it_xml_station_id + etag_end)
			end
			Result.replace_substring_all (it_stations_list, l_str_list)
			l_str_list.wipe_out

			Result.replace_substring_all (it_station_name, station_name)
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
					and then attached {JSON_ARRAY}  j_data.item (json_provinces_list_tag)      as j_provinces
					and then attached {JSON_ARRAY}  j_data.item (json_types_list_tag)          as j_types
					and then attached {JSON_ARRAY}  j_data.item (json_status_list_tag)         as j_status
					and then attached {JSON_ARRAY}  j_data.item (json_stations_list_tag)       as j_stations
					and then attached {JSON_STRING} j_data.item (json_station_name_tag)        as j_name
				then

					-- municipalities
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

					-- provinces
					provinces_list.wipe_out
					from j_provinces.array_representation.start
					until j_provinces.array_representation.after
					loop
						if attached {JSON_OBJECT} j_provinces.array_representation.item as j_prov
							and then attached {JSON_STRING} j_prov.item (json_province_tag) as j_p
						then
							provinces_list.extend (j_p.item)
						end
						j_provinces.array_representation.forth
					end

					-- types
					types_list.wipe_out
					from j_types.array_representation.start
					until j_types.array_representation.after
					loop
						if attached {JSON_OBJECT} j_types.array_representation.item as j_type
							and then attached {JSON_NUMBER} j_type.item (json_type_tag) as j_t
						then
							types_list.extend (j_t.item.to_integer)
						end
						j_types.array_representation.forth
					end

					-- status
					status_list.wipe_out
					from j_status.array_representation.start
					until j_status.array_representation.after
					loop
						if attached {JSON_OBJECT} j_status.array_representation.item as j_st
							and then attached {JSON_NUMBER} j_st.item (json_status_tag) as j_s
						then
							status_list.extend (j_s.item.to_integer)
						end
						j_status.array_representation.forth
					end

					-- stations
					stations_list.wipe_out
					from j_stations.array_representation.start
					until j_stations.array_representation.after
					loop
						if attached {JSON_OBJECT} j_stations.array_representation.item as j_station
							and then attached {JSON_NUMBER} j_station.item (json_station_tag) as j_st
						then
							status_list.extend (j_st.item.to_integer)
						end
						j_stations.array_representation.forth
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
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + station_list_request_id.out + right_brace)
			Result.append (comma + double_quotes + json_data_tag + double_quotes + colon + space + left_brace)

			-- municipalities
			Result.append (double_quotes + json_municipalities_list_tag + double_quotes + colon + space + left_bracket)

			from municipalities_list.start
			until municipalities_list.after
			loop
				Result.append (left_brace + double_quotes + json_municipality_tag + double_quotes + colon + space + double_quotes + municipalities_list.item.out + double_quotes + right_brace)
				if not municipalities_list.islast then
					Result.append (comma)
				end
				municipalities_list.forth
			end
			Result.append (right_bracket + comma)

			-- provinces
			Result.append (double_quotes + json_provinces_list_tag + double_quotes + colon + space + left_bracket)

			from provinces_list.start
			until provinces_list.after
			loop
				Result.append (left_brace + double_quotes + json_province_tag + double_quotes + colon + space + double_quotes + provinces_list.item + double_quotes + right_brace)
				if not provinces_list.islast then
					Result.append (comma)
				end
				provinces_list.forth
			end
			Result.append (right_bracket + comma)

			-- types
			Result.append (double_quotes + json_types_list_tag + double_quotes + colon + space + left_bracket)

			from types_list.start
			until types_list.after
			loop
				Result.append (left_brace + double_quotes + json_type_tag + double_quotes + colon + space + double_quotes + types_list.item.out + double_quotes + right_brace)
				if not types_list.islast then
					Result.append (comma)
				end
				types_list.forth
			end
			Result.append (right_bracket + comma)

			-- status
			Result.append (double_quotes + json_status_list_tag + double_quotes + colon + space + left_bracket)

			from status_list.start
			until status_list.after
			loop
				Result.append (left_brace + double_quotes + json_status_tag + double_quotes + colon + space + double_quotes + status_list.item.out + double_quotes + right_brace)
				if not status_list.islast then
					Result.append (comma)
				end
				status_list.forth
			end
			Result.append (right_bracket + comma)

			-- stations
			Result.append (double_quotes + json_stations_list_tag + double_quotes + colon + space + left_bracket)

			from stations_list.start
			until stations_list.after
			loop
				Result.append (left_brace + double_quotes + json_station_tag + double_quotes + colon + space + double_quotes + stations_list.item.out + double_quotes + right_brace)
				if not stations_list.islast then
					Result.append (comma)
				end
				stations_list.forth
			end
			Result.append (right_bracket + comma)

			Result.append (double_quotes + json_station_name_tag + double_quotes + colon + space + double_quotes + station_name + double_quotes + right_brace)

			Result.append (right_brace)
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
			Result := create {STATION_LIST_RESPONSE}.make
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
			Result := stations_list_endpoint_name
		end

	xml_request_template: STRING
			-- Request template
		do
--			Result :=  "[
--				<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--          		<s:Body>
--            			<ElencoStazioni xmlns="http://tempuri.org/">
--              			<xInput>
--                				<ElencoStazioni xmlns="">
--                  				<Token>
--                    					<Id>$tokenid</Id>
--                  				</Token>
--                  				<Comuni>
--                    					$municipalities_list
--                  				</Comuni>
--                  				<Province>
--                    					$provinces_list
--                  				</Province>
--                 					<TipiStazione>
--                    					$types_list
--                 					</TipiStazione>
--                 					<StatiStazione>
--                    					$status_list
--                 					</StatiStazione>
--                 					<Stazioni>
--                    					$stations_list
--                 					</Stazioni>
--                 					<NomeStazione>$station_name</NomeStazione>
--                				</ElencoStazioni>
--              			</xInput>
--            			</ElencoStazioni>
--          		</s:Body>
--        		</s:Envelope>
--			]"

			create Result.make_empty
			Result.append (stag_start + xmlns_s + colon + soap_envelope + space + xmlns + colon + xmlns_s + eq_s + double_quotes + xmlsoap + double_quotes + stag_end + lf_s)
			  Result.append (double_space + stag_start + xmlns_s + colon + body + stag_end + lf_s)
			    Result.append (double_space + double_space + stag_start + stations_list_endpoint_name + space + xmlns + eq_s + double_quotes + remws_uri + url_path_separator + double_quotes + stag_end + lf_s)
			      Result.append (double_space + double_space + double_space + stag_start + xinput + stag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + stag_start + stations_list_endpoint_name + space + xmlns + eq_s + double_quotes + double_quotes + stag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_token + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space +
			                           stag_start + it_xml_id + stag_end + it_tokenid + etag_start + it_xml_id + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_token + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_municipalities + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + it_municipalities_list + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_municipalities + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_provinces + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + it_provinces_list)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_provinces + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_station_types + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + it_types_list + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_station_types + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_station_statuss + stag_end + lf_s)
					    Result.append (double_space + double_space + double_space + double_space + double_space + double_space + it_status_list + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_station_statuss + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_stations + stag_end + lf_s)
					    Result.append (double_space + double_space + double_space + double_space + double_space + double_space + it_status_list + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_stations + etag_end + lf_s)
					  Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_station_name + stag_end +
					                 it_station_name + etag_start + it_xml_station_name + etag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + etag_start + stations_list_endpoint_name + etag_end + lf_s)
			      Result.append (double_space + double_space + double_space + etag_start + xinput + etag_end + lf_s)
			    Result.append (double_space + double_space + etag_start + stations_list_endpoint_name + etag_end + lf_s)
			  Result.append (double_space + etag_start + xmlns_s + colon + body + etag_end + lf_s)
			Result.append (etag_start + xmlns_s + colon + soap_envelope + etag_end + lf_s)
		end

feature {NONE} -- Implementation

	token_id:            STRING

	municipalities_list: ARRAYED_LIST[INTEGER]
	provinces_list:      ARRAYED_LIST[STRING]
	types_list:          ARRAYED_LIST[INTEGER]
	status_list:         ARRAYED_LIST[INTEGER]
	stations_list:       ARRAYED_LIST[INTEGER]
	station_name:        STRING

invariant
	invariant_clause: True -- Your invariant here

end
