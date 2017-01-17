note
	description: "Summary description for {SENSO_LIST_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
--|     "tokenid":             "a_token_id",
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

			create xml_representation.make_empty
			create json_representation.make_empty

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

			create json_representation.make_empty
			create xml_representation.make_empty

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
			--parnum := station_list_request_parnum_token

			create json_representation.make_empty
			create xml_representation.make_empty

			create municipalities_list.make (0)
			create stations_list.make (0)
			create sensor_types_list.make (0)
			create sensors_list.make (0)

			create sensor_name.make_empty
		end

feature -- Access

	id: INTEGER
			-- message id
		once
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
			token_id.copy (a_token)
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		local
			l_token_id: STRING
			l_m_list:   STRING
			l_p_list:   STRING
			l_t_list:   STRING
			l_s_list:   STRING
			l_st_list:  STRING
			i:          INTEGER
		do
			create l_token_id.make_from_string (token_id)
			create l_p_list.make_empty
			create l_m_list.make_empty
			create l_t_list.make_empty
			create l_s_list.make_empty
			create l_st_list.make_empty
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

			-- municipalities
			from
				i := 1
			until
				i = municipalities_list.count + 1
			loop
				l_m_list.append ("<IdComune>")
				l_m_list.append (municipalities_list.i_th (i).out)
				l_m_list.append ("</IdComune>")
			end

			-- stations
			from
				i := 1
			until
				i = stations_list.count + 1
			loop
				l_st_list.append ("<IdStazione>")
				l_st_list.append (stations_list.i_th (i).out)
				l_st_list.append ("</IdStazione>")
			end

			-- sensor types
			from
				i := 1
			until
				i = sensor_types_list.count + 1
			loop
				l_t_list.append ("<IdTipoSensore>")
				l_t_list.append (sensor_types_list.i_th (i).out)
				l_t_list.append ("</IdTipoSensore>")
			end

			-- sensors
			from
				i := 1
			until
				i = sensors_list.count + 1
			loop
				l_p_list.append ("<IdSensore>")
				l_p_list.append (sensors_list.i_th (i).out)
				l_p_list.append ("</IdSensore>%N")
				i := i + 1
			end

			Result.replace_substring_all ("$municipalities_list", l_m_list)
			Result.replace_substring_all ("$stations_list", l_st_list)
			Result.replace_substring_all ("$sensor_types_list", l_t_list)
			Result.replace_substring_all ("$sensors_list", l_s_list)
			Result.replace_substring_all ("$sensor_name", sensor_name)

			xml_representation := Result

			l_token_id.wipe_out
			l_m_list.wipe_out
			l_p_list.wipe_out
			l_t_list.wipe_out
			l_s_list.wipe_out
			l_st_list.wipe_out

		end

	from_json(json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		local
			key:         JSON_STRING
			key1:        JSON_STRING
			key2:        JSON_STRING
			key3:        JSON_STRING
			key4:        JSON_STRING
			key5:        JSON_STRING
			--json_parser: JSON_PARSER
			i:           INTEGER
			l_m:         STRING
			l_p:         INTEGER
			l_t:         INTEGER
			--l_s:         STRING
			l_st:        STRING
			l_count:     INTEGER
		do
			json_representation.copy (json)
		 	--create json_parser.make_with_string (json)
		 	parser.reset_reader
		 	parser.reset
		 	parser.set_representation (json)

			create key.make_from_string  ("header")
			create key1.make_from_string ("municipality")
			create key2.make_from_string ("station")
			create key3.make_from_string ("type")
			create key4.make_from_string ("sensor")
			create key5.make_from_string ("name")

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
					and then attached {JSON_STRING} j_data.item ("tokenid") as j_tokenid
					and then attached {JSON_ARRAY}  j_data.item ("municipalities_list") as j_municipalities
					and then attached {JSON_ARRAY}  j_data.item ("stations_list")       as j_stations
					and then attached {JSON_ARRAY}  j_data.item ("sensor_types_list")   as j_sensor_types
					and then attached {JSON_ARRAY}  j_data.item ("sensors_list")        as j_sensors
					and then attached {JSON_STRING} j_data.item ("sensor_name")         as j_name
				then
					token_id := j_tokenid.item

					-- municipalities
					municipalities_list.wipe_out
					l_count := j_municipalities.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_municipalities.i_th (i) as j_m
							and then attached {JSON_STRING} j_m.item (key1) as j_mid
						then
							create l_m.make_from_string (j_mid.item)
							municipalities_list.extend (l_m.to_integer)
							l_m.wipe_out
						end
						i := i + 1
					end

					-- stations
					stations_list.wipe_out
					l_count := j_stations.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_stations.i_th (i) as j_station
							and then attached {JSON_STRING} j_station.item (key5) as j_st
						then
							create l_st.make_from_string (j_st.item)
							stations_list.extend (l_st.to_integer)
							l_st.wipe_out
						end
						i := i + 1
					end

					-- sensor types
					sensor_types_list.wipe_out
					l_count := j_sensor_types.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_sensor_types.i_th (i) as j_type
							and then attached {JSON_NUMBER} j_type.item (key3) as j_t
						then
							--create l_t.make_from_string (j_t.item)
							l_t := j_t.item.to_integer
							sensor_types_list.extend (l_t)
						end
						i := i + 1
					end

					-- sensors
					sensors_list.wipe_out
					l_count := j_sensors.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_sensors.i_th (i) as j_prov
							and then attached {JSON_NUMBER} j_prov.item (key2) as j_p
						then
							--create l_p.make_from_string (j_p.item)
							l_p := j_p.item.to_integer
							sensors_list.extend (l_p)
						end
						i := i + 1
					end

				end
			end
			parser.reset_reader
			parser.reset
			key.item.wipe_out
			key1.item.wipe_out
			key2.item.wipe_out
			key3.item.wipe_out
			key4.item.wipe_out
			key5.item.wipe_out
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
			json_representation.append ("%"id%": " + sensor_list_request_id.out)
			json_representation.append (",%"parameters_number%": " + sensor_list_request_parnum_token.out + "}")
			json_representation.append (",%"data%": {")
			json_representation.append ("%"tokenid%": %"" + token_id + "%"},")

			-- municipalities
			json_representation.append ("%"municipalities_list%": [")

			from i := 1
			until i = municipalities_list.count + 1
			loop
				json_representation.append ("{%"municipality%": %"" + municipalities_list.i_th (i).out + "%"")

				if i > 1 then
					json_representation.append (",")
				end
			end
			json_representation.append ("],")

			-- stations
			json_representation.append ("%"stations_list%": [")

			from i := 1
			until i = stations_list.count + 1
			loop
				json_representation.append ("{%"station%": %"" + stations_list.i_th (i).out + "%"")

				if i > 1 then
					json_representation.append (",")
				end
			end
			json_representation.append ("],")

			-- sensor types
			json_representation.append ("%"sensor_types_list%": [")

			from i := 1
			until i = sensor_types_list.count + 1
			loop
				json_representation.append ("{%"type%": %"" + sensor_types_list.i_th (i).out + "%"")

				if i > 1 then
					json_representation.append (",")
				end
			end
			json_representation.append ("],")

			-- sensors
			json_representation.append ("%"sensors_list%": [")

			from i := 1
			until i = sensors_list.count + 1
			loop
				json_representation.append ("{%"sensor%": %"" + sensors_list.i_th (i).out + "%"")

				if i > 1 then
					json_representation.append (",")
				end
			end
			json_representation.append ("],")

			json_representation.append ("%"sensor_name%": " + sensor_name)

			json_representation.append ("}")
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

feature {DISPOSABLE}

	dispose
			--
		do
			json_representation.wipe_out
			xml_representation.wipe_out
			municipalities_list.wipe_out
			stations_list.wipe_out
			sensor_types_list.wipe_out
			sensors_list.wipe_out
		end

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
			Result := "ElencoSensori"
		end

	xml_request_template: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
          <s:Body>
            <ElencoSensori xmlns="http://tempuri.org/">
              <xInput>
                <ElencoSensori xmlns="">
                  <Token>
                    <Id>$tokenid</Id>
                  </Token>
                  <Comuni>
                    $municipalities_list
                  </Comuni>
                  <Stazioni>
                    $stations_list
                  </Stazioni>
                  <TipoSensore>
                    $sensor_types_list
                  </TipoSensore>
                  <Sensori>
                    $sensors_list
                  </Sensori>
                  <NomeSensore>$sensor_name</NomeSensore>
                </ElencoSensori>
              </xInput>
            </ElencoSensori>
          </s:Body>
        </s:Envelope>
	]"

feature {NONE} -- Implementation

	token_id:            STRING
	parnum:              INTEGER

	municipalities_list: ARRAYED_LIST[INTEGER]
	stations_list:       ARRAYED_LIST[INTEGER]
	sensor_types_list:   ARRAYED_LIST[INTEGER]
	sensors_list:        ARRAYED_LIST[INTEGER]
	sensor_name:         STRING

end
