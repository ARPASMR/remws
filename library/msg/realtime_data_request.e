	note
	description : "Summary description for {REALTIME_DATA_REQUEST}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

--| ----------------------------------------------------------------------------
--| This is the message structure for the realtime data message, for the time
--| being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--| stations can be an empty array
--|
--| {
--|   "header": {
--|     "id":  <realtime_data_request_id=10>
--|   },
--|   "data": {
--|     "sensors_list": [{
--|                        "sensor_id": id1,
--|                        "function_id": fid1,
--|                        "operator_id": oid1,
--|                        "granularity": gid1,
--|                        "start": "start_date1",
--|                        "finish": "finish_date1"
--|                      },
--|                      {
--|                        "sensor_id": id2,
--|                        "function_id": fid2,
--|                        "operator_id": oid2,
--|                        "granularity": gid2,
--|                        "start": "start_date2",
--|                        "finish": "finish_date2"
--|                      }
--|                      ...,
--|                      {
--|                        "sensor_id": idn,
--|                        "function_id": fidn,
--|                        "operator_id": oidn,
--|                        "granularity": gidn,
--|                        "start": "start_daten",
--|                        "finish": "finish_daten"
--|                      }]
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

class
	REALTIME_DATA_REQUEST

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
			create sensors_list.make (0)
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization for `Current' from json string
		do
			create token_id.make_empty
			create sensors_list.make (0)

			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `REALTIME_DATA_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			create sensors_list.make (0)
		end

feature -- Access

	id: INTEGER
			-- message id
		do
			Result := realtime_data_request_id
		end

	token: detachable STRING
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
		require else
			token_id_attached: attached token_id
		local
			l_sensors_list:  detachable STRING
		do
			--create Result.make_from_string (xml_request_template)
			Result := xml_request_template.twin
			if attached token_id as l_token_id then
				if l_token_id.is_empty then
					Result.replace_substring_all (stag_start + it_xml_token + stag_end,   null)
					Result.replace_substring_all (etag_start + it_xml_token + etag_end,   null)
					Result.replace_substring_all (stag_start + it_xml_id + etag_end,      null)
					Result.replace_substring_all (etag_start + it_xml_id + etag_end,      null)
					Result.replace_substring_all (it_tokenid,                             null)
				else
					Result.replace_substring_all (it_tokenid, l_token_id)
				end

				create l_sensors_list.make_empty

				across sensors_list
					 as sl
				loop
					l_sensors_list.append (stag_start + it_xml_sensor + stag_end + lf_s)
					l_sensors_list.append (space + space + stag_start + it_xml_sensor_id + stag_end + sl.item.sensor_id.out + etag_start + it_xml_sensor_id + etag_end + lf_s)
					l_sensors_list.append (space + space + stag_start + it_xml_function_id + stag_end + sl.item.function_code.out + etag_start + it_xml_function_id + etag_end + lf_s)
					l_sensors_list.append (space + space + stag_start + it_xml_operator_id + stag_end + sl.item.applied_operator.out + etag_start + it_xml_operator_id + etag_end + lf_s)
					l_sensors_list.append (space + space + stag_start + it_xml_granularity_id + stag_end + sl.item.time_granularity.out + etag_start + it_xml_granularity_id + etag_end + lf_s)
					l_sensors_list.append (space + space + stag_start + it_xml_start_date + stag_end + sl.item.start.formatted_out (default_date_time_format) + etag_start + it_xml_start_date + etag_end + lf_s)
					l_sensors_list.append (space + space + stag_start + it_xml_end_date + stag_end + sl.item.finish.formatted_out (default_date_time_format) + etag_start + it_xml_end_date + etag_end + lf_s)
					l_sensors_list.append (etag_start + it_xml_sensor + etag_end + lf_s)
				end

				Result.replace_substring_all (it_sensors, l_sensors_list)

				l_sensors_list.wipe_out
			end
		end

	from_json(json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		local
			l_rt_req_data: detachable SENSOR_REALTIME_REQUEST_DATA
			l_start_time:  detachable DATE_TIME
			l_finish_time: detachable DATE_TIME
		do
			if attached sensors_list as l_sensors_list then l_sensors_list.wipe_out end

		 	parser.set_representation (json)
			parser.parse_content
			if parser.is_valid and then attached parser.parsed_json_value as jv then
				if not (attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_header_tag) as j_header
					and then attached {JSON_NUMBER} j_header.item (json_id_tag) as j_id)
				then
					print (msg_json_header_not_found)
				end
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_data_tag) as j_data
					and then attached {JSON_ARRAY} j_data.item (json_sensors_list_tag) as j_sensors
				then

					from j_sensors.array_representation.start
					until j_sensors.array_representation.after
					loop
						if attached {JSON_OBJECT} j_sensors.array_representation.item as j_sensor
							and then attached {JSON_NUMBER} j_sensor.item (json_sensor_id_tag) as j_id
							and then attached {JSON_NUMBER} j_sensor.item (json_function_id_tag) as j_function
							and then attached {JSON_NUMBER} j_sensor.item (json_operator_id_tag) as j_operator
							and then attached {JSON_NUMBER} j_sensor.item (json_granularity_tag) as j_granularity
							and then attached {JSON_STRING} j_sensor.item (json_start_tag) as j_start
							and then attached {JSON_STRING} j_sensor.item (json_finish_tag) as j_finish
						then
							create l_rt_req_data.make

							l_rt_req_data.set_sensor_id (j_id.item.to_integer)
							l_rt_req_data.set_function_code (j_function.item.to_integer)
							l_rt_req_data.set_applied_operator (j_operator.item.to_integer)
							l_rt_req_data.set_time_granularty (j_granularity.item.to_integer)
							create l_start_time.make_from_string (j_start.item, default_date_time_format)
							create l_finish_time.make_from_string (j_finish.item, default_date_time_format)
							l_rt_req_data.set_start (l_start_time)
							l_rt_req_data.set_finish (l_finish_time)

							if attached sensors_list as l_sensors_list then l_sensors_list.extend (l_rt_req_data) end
							j_sensors.array_representation.forth
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
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + realtime_data_request_id.out + right_brace)
			Result.append (comma + double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_sensors_list_tag + double_quotes + colon + space + left_bracket)
			from sensors_list.start
			until sensors_list.after
			loop
				Result.append (left_brace + double_quotes + json_sensor_id_tag + double_quotes + colon + space + sensors_list.item.sensor_id.out  + comma)
				Result.append (double_quotes + json_function_id_tag + double_quotes + colon + space + sensors_list.item.function_code.out         + comma)
				Result.append (double_quotes + json_operator_id_tag + double_quotes + colon + space + sensors_list.item.applied_operator.out      + comma)
				Result.append (double_quotes + json_granularity_tag + double_quotes + colon + space + sensors_list.item.time_granularity.out      + comma)
				Result.append (double_quotes + json_start_tag + double_quotes + colon + space + double_quotes + sensors_list.item.start.formatted_out (default_date_time_format)
				             + double_quotes + comma)
				Result.append (double_quotes + json_finish_tag + double_quotes + colon + space + double_quotes + sensors_list.item.finish.formatted_out (default_date_time_format)
				             + double_quotes + right_brace)
				if not sensors_list.islast then
					Result.append (comma)
				end
				sensors_list.forth
			end
			Result.append (right_bracket + right_brace + right_brace)
		end

	from_xml (xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse xml message
		do
			-- should never be called from request messages
		end

feature -- Basic operations

	init_response: detachable RESPONSE_I
			--
		do
			Result := create {REALTIME_DATA_RESPONSE}.make
		end

feature -- Dispose

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

feature -- Object implementation

	token_id: detachable STRING
			--
	sensors_list: ARRAYED_LIST[SENSOR_REALTIME_REQUEST_DATA]
			--

feature {NONE} -- Utilities implementation

	ws_url: STRING
			-- Web service URL
		do
			Result := dataws_url
		end

	ws_test_url: STRING
			-- Testing web service URL
		do
			Result := dataws_test_url
		end

	soap_action_header:  STRING
			-- SOAP action header
		do
			Result := remws_uri + url_path_separator + dataws_interface + url_path_separator + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := realtime_data_endpoint_name
		end

	xml_request_template: STRING
			-- XML `Current' message request template
		do
--			Result := "[
--				<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--	        	  <s:Body>
--	        	    <RendiDatiTempoReale xmlns="http://tempuri.org/">
--	       	          <xInput>
--	                    <RendiDatiTempoReale xmlns="">
--	                      <Token>
--	                        <Id>$tokenid</Id>
--	                      </Token>
--	                      $sensors
--	                    </RendiDatiTempoReale>
--	                  </xInput>
--	                </RendiDatiTempoReale>
--	              </s:Body>
--	            </s:Envelope>
--			]"
			create Result.make_empty
			Result.append (stag_start + xmlns_s + colon + soap_envelope + space + xmlns + colon + xmlns_s + eq_s + double_quotes + xmlsoap + double_quotes + stag_end + lf_s)
			  Result.append (double_space + stag_start + xmlns_s + colon + body + stag_end + lf_s)
			    Result.append (double_space + double_space + stag_start + realtime_data_endpoint_name + space + xmlns + eq_s + double_quotes + remws_uri + url_path_separator + double_quotes + stag_end + lf_s)
			      Result.append (double_space + double_space + double_space + stag_start + xinput + stag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + stag_start + realtime_data_endpoint_name + space +
			                       xmlns + eq_s + double_quotes + double_quotes + stag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_token + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_id + stag_end + it_tokenid +
			                           etag_start + it_xml_id + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_token + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + it_sensors + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + etag_start + realtime_data_endpoint_name + etag_end + lf_s)
			      Result.append (double_space + double_space + double_space + etag_start + xinput + etag_end + lf_s)
			    Result.append (double_space + double_space + etag_start + realtime_data_endpoint_name + etag_end + lf_s)
			  Result.append (double_space + etag_start + xmlns_s + colon + body + etag_end + lf_s)
			Result.append (etag_start + xmlns_s + colon + soap_envelope + etag_end + lf_s)
		end

invariant
	invariant_clause: True -- Your invariant here

end
