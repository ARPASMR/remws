	note
	description: "Summary description for {REALTIME_DATA_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

			create json_representation.make_empty
			create xml_representation.make_empty
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization for `Current' from json string
		do
			create token_id.make_empty
			create sensors_list.make (0)

			create json_representation.make_empty
			create xml_representation.make_empty

			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `REALTIME_DATA_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			create sensors_list.make (0)
			--	parnum := realtime_data_request_parnum_token

			create json_representation.make_empty
			create xml_representation.make_empty
		end

feature -- Access

	id: INTEGER
			-- message id
		do
			Result := realtime_data_request_id
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
			l_sensors_list:  STRING
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
				Result.replace_substring_all ("$tokenid", l_token_id)
			end

			create l_sensors_list.make_empty

			from i := 1
			until i = sensors_list.count + 1
			loop
				l_sensors_list.append ("<Sensore>%N")
				l_sensors_list.append ("  <IdSensore>" + sensors_list.i_th (i).sensor_id.out + "</IdSensore>%N")
				l_sensors_list.append ("  <IdFunzione>" + sensors_list.i_th (i).function_code.out + "</IdFunzione>%N")
				l_sensors_list.append ("  <IdOperatore>" + sensors_list.i_th (i).applied_operator.out + "</IdOperatore>%N")
				l_sensors_list.append ("  <IdPeriodo>" + sensors_list.i_th (i).time_granularity.out + "</IdPeriodo>%N")
				l_sensors_list.append ("  <DataInizio>" + sensors_list.i_th (i).start.formatted_out (default_date_time_format) + "</DataInizio>%N")
				l_sensors_list.append ("  <DataFine>" + sensors_list.i_th (i).finish.formatted_out (default_date_time_format) + "</DataFine>%N")
				l_sensors_list.append ("</Sensore>%N")

				i := i + 1
			end

			Result.replace_substring_all ("$sensors", l_sensors_list)

			xml_representation := Result
			l_token_id.wipe_out
			l_sensors_list.wipe_out
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
			l_rt_req_data: SENSOR_REALTIME_REQUEST_DATA
			l_start_time: DATE_TIME
			l_finish_time: DATE_TIME
		do
			sensors_list.wipe_out

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
					and then attached {JSON_ARRAY} j_data.item ("sensors_list") as j_sensors
				then

					from i:= 1
					until i = j_sensors.count + 1
					loop
						if attached {JSON_OBJECT} j_sensors.i_th (i) as j_sensor
							and then attached {JSON_NUMBER} j_sensor.item ("sensor_id") as j_id
							and then attached {JSON_NUMBER} j_sensor.item ("function_id") as j_function
							and then attached {JSON_NUMBER} j_sensor.item ("operator_id") as j_operator
							and then attached {JSON_NUMBER} j_sensor.item ("granularity") as j_granularity
							and then attached {JSON_STRING} j_sensor.item ("start") as j_start
							and then attached {JSON_STRING} j_sensor.item ("finish") as j_finish
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

							sensors_list.extend (l_rt_req_data)
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
			json_representation.append ("%"sensors_list%": [")
			from i := 1
			until i = sensors_list.count + 1
			loop
				if i > 1 then
					json_representation.append (",")
				end
				json_representation.append ("{%"sensor_id%": "  + sensors_list.i_th (i).sensor_id.out                                   + ",")
				json_representation.append ("%"function_id%": " + sensors_list.i_th (i).function_code.out                               + ",")
				json_representation.append ("%"operator_id%": " + sensors_list.i_th (i).applied_operator.out                            + ",")
				json_representation.append ("%"granularity%": " + sensors_list.i_th (i).time_granularity.out                            + ",")
				json_representation.append ("%"start%": %""     + sensors_list.i_th (i).start.formatted_out (default_date_time_format)  + "%",")
				json_representation.append ("%"finish%": %""    + sensors_list.i_th (i).finish.formatted_out (default_date_time_format) + "%"}")
				i := i + 1
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
			Result := create {REALTIME_DATA_RESPONSE}.make
		end

feature -- Dispose

	dispose
			--
		do
			json_representation.wipe_out
			xml_representation.wipe_out
			sensors_list.wipe_out
		end

feature {NONE} -- Object implementation

	token_id: STRING
			--
	sensors_list: ARRAYED_LIST[SENSOR_REALTIME_REQUEST_DATA]
			--

feature {NONE} -- Utilities implementation

	json_representation: STRING
	xml_representation:  STRING

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
			Result := "SOAPAction: " + remws_uri + "/" + dataws_interface + "/" + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := "RendiDatiTempoReale"
		end

	xml_request_template: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
          <s:Body>
            <RendiDatiTempoReale xmlns="http://tempuri.org/">
              <xInput>
                <RendiDatiTempoReale xmlns="">
                  <Token>
                    <Id>$tokenid</Id>
                  </Token>
                  $sensors
                </RendiDatiTempoReale>
              </xInput>
            </RendiDatiTempoReale>
          </s:Body>
        </s:Envelope>
	]"

invariant
	invariant_clause: True -- Your invariant here

end
