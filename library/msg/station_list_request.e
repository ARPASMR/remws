note
	description: "Summary description for {STATION_LIST_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

			create xml_representation.make_empty
			create json_representation.make_empty

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

			create json_representation.make_empty
			create xml_representation.make_empty

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

			create json_representation.make_empty
			create xml_representation.make_empty

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
				Result.replace_substring_all ("<Token>",  "")
				Result.replace_substring_all ("</Token>", "")
				Result.replace_substring_all ("<Id>",     "")
				Result.replace_substring_all ("</Id>",    "")
				Result.replace_substring_all ("$tokenid", "")
			else
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
				i := i + 1
			end

			-- provinces
			from
				i := 1
			until
				i = provinces_list.count + 1
			loop
				l_p_list.append ("<Provincia>")
				l_p_list.append (provinces_list.i_th (i))
				l_p_list.append ("</Provincia>")
				i := i + 1
			end

			-- types
			from
				i := 1
			until
				i = types_list.count + 1
			loop
				l_t_list.append ("<IdTipo>")
				l_t_list.append (types_list.i_th (i).out)
				l_t_list.append ("</IdTipo>")
				i := i + 1
			end

			-- status
			from
				i := 1
			until
				i = status_list.count + 1
			loop
				l_s_list.append ("<IdStato>")
				l_s_list.append (status_list.i_th (i).out)
				l_s_list.append ("</IdStato>")
				i := i + 1
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
				i := i + 1
			end

			Result.replace_substring_all ("$municipalities_list", l_m_list)
			Result.replace_substring_all ("$provinces_list", l_p_list)
			Result.replace_substring_all ("$types_list", l_t_list)
			Result.replace_substring_all ("$status_list", l_s_list)
			Result.replace_substring_all ("$stations_list", l_st_list)
			Result.replace_substring_all ("$station_name", station_name)

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
			l_m:         INTEGER
			l_p:         STRING
			l_t:         INTEGER
			l_s:         INTEGER
			l_st:        INTEGER
			l_count:     INTEGER
		do
			json_representation.copy (json)
		 	--create json_parser.make_with_string (json)
		 	parser.reset_reader
		 	parser.reset
		 	parser.set_representation (json)

			create key.make_from_string  ("header")
			create key1.make_from_string ("municipality")
			create key2.make_from_string ("province")
			create key3.make_from_string ("type")
			create key4.make_from_string ("status")
			create key5.make_from_string ("station")

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
					and then attached {JSON_ARRAY}  j_data.item ("municipalities_list") as j_municipalities
					and then attached {JSON_ARRAY}  j_data.item ("provinces_list")      as j_provinces
					and then attached {JSON_ARRAY}  j_data.item ("types_list")          as j_types
					and then attached {JSON_ARRAY}  j_data.item ("status_list")         as j_status
					and then attached {JSON_ARRAY}  j_data.item ("stations_list")       as j_stations
					and then attached {JSON_STRING} j_data.item ("station_name")        as j_name
				then

					-- municipalities
					municipalities_list.wipe_out
					l_count := j_municipalities.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_municipalities.i_th (i) as j_m
							and then attached {JSON_NUMBER} j_m.item (key1) as j_mid
						then
							--create l_m.make_from_string (j_mid.item)
							l_m := j_mid.item.to_integer
							municipalities_list.extend (l_m)
						end
						i := i + 1
					end

					-- provinces
					provinces_list.wipe_out
					l_count := j_provinces.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_provinces.i_th (i) as j_prov
							and then attached {JSON_STRING} j_prov.item (key2) as j_p
						then
							create l_p.make_from_string (j_p.item)
							provinces_list.extend (l_p)
						end
						i := i + 1
					end

					-- types
					types_list.wipe_out
					l_count := j_types.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_types.i_th (i) as j_type
							and then attached {JSON_NUMBER} j_type.item (key3) as j_t
						then
							--create l_t.make_from_string (j_t.item)
							l_t := j_t.item.to_integer
							types_list.extend (l_t)
						end
						i := i + 1
					end

					-- status
					status_list.wipe_out
					l_count := j_status.count
					from i := 1
					until i = l_count + 1
					loop
						if attached {JSON_OBJECT} j_status.i_th (i) as j_st
							and then attached {JSON_NUMBER} j_st.item (key4) as j_s
						then
							--create l_s.make_from_string (j_s.item)
							l_s := j_s.item.to_integer
							status_list.extend (l_s.to_integer)
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
							and then attached {JSON_NUMBER} j_station.item (key5) as j_st
						then
							--create l_st.make_from_string (j_st.item)
							l_st := j_st.item.to_integer
							status_list.extend (l_st.to_integer)
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
			json_representation.append ("%"id%": " + station_list_request_id.out)
			json_representation.append (",%"data%": {")

			-- municipalities
			json_representation.append ("%"municipalities_list%": [")

			from i := 1
			until i = municipalities_list.count + 1
			loop
				if i > 1 then
					json_representation.append (",")
				end

				json_representation.append ("{%"municipality%": %"" + municipalities_list.i_th (i).out + "%"")
				i := i + 1
			end
			json_representation.append ("],")

			-- provinces
			json_representation.append ("%"provinces_list%": [")

			from i := 1
			until i = provinces_list.count + 1
			loop
				if i > 1 then
					json_representation.append (",")
				end

				json_representation.append ("{%"province%": %"" + provinces_list.i_th (i) + "%"")

				i := i + 1
			end
			json_representation.append ("],")

			-- types
			json_representation.append ("%"types_list%": [")

			from i := 1
			until i = types_list.count + 1
			loop
				if i > 1 then
					json_representation.append (",")
				end

				json_representation.append ("{%"type%": %"" + types_list.i_th (i).out + "%"")
				i := i + 1
			end
			json_representation.append ("],")

			-- status
			json_representation.append ("%"status_list%": [")

			from i := 1
			until i = status_list.count + 1
			loop
				if i > 1 then
					json_representation.append (",")
				end

				json_representation.append ("{%"status%": %"" + status_list.i_th (i).out + "%"")
				i := i + 1
			end
			json_representation.append ("],")

			-- stations
			json_representation.append ("%"stations_list%": [")

			from i := 1
			until i = stations_list.count + 1
			loop
				if i > 1 then
					json_representation.append (",")
				end

				json_representation.append ("{%"station%": %"" + stations_list.i_th (i).out + "%"")
				i := i + 1
			end
			json_representation.append ("],")

			json_representation.append ("%"station_name%": " + station_name)

			json_representation.append ("}")

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
			Result := create {STATION_LIST_RESPONSE}.make
		end

feature -- {DISPOSABLE}

	dispose
			--
		do
			json_representation.wipe_out
			xml_representation.wipe_out
			municipalities_list.wipe_out
			provinces_list.wipe_out
			types_list.wipe_out
			status_list.wipe_out
			stations_list.wipe_out
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
			--Result := "SOAPAction: " + remws_uri + "/" + anaws_interface + "/" + name
			Result := remws_uri + "/" + anaws_interface + "/" + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := "ElencoStazioni"
		end

	xml_request_template: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
          <s:Body>
            <ElencoStazioni xmlns="http://tempuri.org/">
              <xInput>
                <ElencoStazioni xmlns="">
                  <Token>
                    <Id>$tokenid</Id>
                  </Token>
                  <Comuni>
                    $municipalities_list
                  </Comuni>
                  <Province>
                    $provinces_list
                  </Province>
                  <TipiStazione>
                    $types_list
                  </TipiStazione>
                  <StatiStazione>
                    $status_list
                  </StatiStazione>
                  <Stazioni>
                    $stations_list
                  </Stazioni>
                  <NomeStazione>$station_name</NomeStazione>
                </ElencoStazioni>
              </xInput>
            </ElencoStazioni>
          </s:Body>
        </s:Envelope>
	]"

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
