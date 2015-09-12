note
	description: "Summary description for {STATION_LIST_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATION_LIST_RESPONSE

inherit
	RESPONSE_I

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create content.make_empty
			create current_tag.make_empty
			create xml_representation.make_empty
			create json_representation.make_empty

			create token.make
			create message.make_empty

			create stations_list.make (0)

			inside_station := False
		end

feature -- Access

	id:                  INTEGER once Result := station_list_response_id end
	parameters_number:   INTEGER

	outcome:             INTEGER
	message:             STRING

	token:               TOKEN

	stations_list:       ARRAYED_LIST [STATION]

feature -- Status setting

	set_parameters_number (pn:INTEGER)
			-- Sets `parameters_number'
		do
			parameters_number := pn
		end

	set_outcome (o: INTEGER)
			-- Sets `outcome'
		do
			outcome := o
		end

	set_message (m: STRING)
			-- Sets `message'
		do
			message.copy (m)
		end

	set_logger (a_logger: LOG_LOGGING_FACILITY)
			-- Sets the logger
		require
			logger_not_void: a_logger /= Void
		do
			logger := a_logger
		ensure
			logger_not_void: logger /= Void
		end

feature -- Status report

	is_error_response: BOOLEAN
			-- Tells wether the response contains an error
		do
			Result := outcome /= success
		end

feature -- Conversion

	to_json: STRING
			-- json representation
		local
			i: INTEGER
			j: INTEGER
		do
			json_representation.wipe_out
			if is_error_response then
				json_representation.append ("{")
				json_representation.append ("%"header%": {")
				json_representation.append ("%"id%": " + station_list_response_id.out)
				json_representation.append (",%"parameters_number%": " + station_list_response_parnum.out)
				json_representation.append ("},")
				json_representation.append ("%"data%": {")
				json_representation.append ("%"outcome%": " + outcome.out)
				json_representation.append (",%"message%": %"" + message + "%",")
				json_representation.append ("}")
				json_representation.append ("}")
			else
				parameters_number := station_list_response_parnum
				json_representation.append ("{")
				json_representation.append ("%"header%": {")
				json_representation.append ("%"id%": " + station_list_response_id.out)
				json_representation.append (",%"parameters_number%": " + station_list_response_parnum.out)
				json_representation.append ("},")
				json_representation.append ("%"data%": {")
				json_representation.append ("%"outcome%": "   + outcome.out)
				json_representation.append (",%"message%": %"" + message + "%"")
				json_representation.append (",%"stations_list%": [")
				from i := 1
				until i = stations_list.count + 1
				loop
					if i /= 1 then
						json_representation.append (",")
					end
					json_representation.append ("{%"id%": "        + stations_list.i_th (i).id.out           +
					                            ",%"name%": %""  + stations_list.i_th (i).name        + "%"" +
					                            ",%"status%": "  + stations_list.i_th (i).status.id.out)
					json_representation.append (",%"types%": [")
					from j := 1
					until j = stations_list.i_th (i).types.count + 1
					loop
						if j > 1 then
							json_representation.append (",")
						end
						json_representation.append (stations_list.i_th (i).types.i_th (j).id.out)

						j := j + 1
					end
					json_representation.append ("],")

					json_representation.append ("%"municipality%": "      + stations_list.i_th (i).municipality.id.out   +   ",")
					json_representation.append ("%"address%": %""         + stations_list.i_th (i).address               + "%",")
					json_representation.append ("%"altitude%": "          + stations_list.i_th (i).altitude.out          +   ",")
					json_representation.append ("%"gb_north%": "          + stations_list.i_th (i).gb_north.out          +   ",")
					json_representation.append ("%"gb_est%": "            + stations_list.i_th (i).gb_est.out            +   ",")
					json_representation.append ("%"latitude%": "          + stations_list.i_th (i).latitude.out          +   ",")
					json_representation.append ("%"longitude%": "         + stations_list.i_th (i).longitude.out         +   ",")
					json_representation.append ("%"latitude_degrees%": "  + stations_list.i_th (i).latitude_degrees.out  +   ",")
					json_representation.append ("%"latitude_minutes%": "  + stations_list.i_th (i).latitude_minutes.out  +   ",")
					json_representation.append ("%"latitude_seconds%": "  + stations_list.i_th (i).latitude_seconds.out  +   ",")
					json_representation.append ("%"longitude_degrees%": " + stations_list.i_th (i).longitude_degrees.out +   ",")
					json_representation.append ("%"longitude_minutes%": " + stations_list.i_th (i).longitude_minutes.out +   ",")
					json_representation.append ("%"longitude_seconds%": " + stations_list.i_th (i).longitude_seconds.out +   "}")

					i := i + 1
				end
				json_representation.append ("]")
				json_representation.append ("}")
				json_representation.append ("}")
			end

			Result := json_representation
		end

	from_xml(xml: STRING)
			-- Parse XML message
	local
		parser: XML_STANDARD_PARSER
		factory: XML_PARSER_FACTORY
	do
		create factory
		stations_list.wipe_out
		parser := factory.new_standard_parser
		parser.set_callbacks (Current)
		set_associated_parser (parser)
		parser.parse_from_string (xml)
	end

	to_xml: STRING
			-- xml representation
		do
			create Result.make_empty
			-- should never be called for response messages
		end

	from_json (json: STRING)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
		local
			l_key:                    JSON_STRING
			l_key_id:                 JSON_STRING
			l_key_name:               JSON_STRING
			l_key_status:             JSON_STRING
			l_key_types:              JSON_STRING
			l_key_municipality:       JSON_STRING
			l_key_address:            JSON_STRING
			l_key_altitude:           JSON_STRING
			l_key_gb_north:           JSON_STRING
			l_key_gb_est:             JSON_STRING
			l_key_latitude:           JSON_STRING
			l_key_longitude:          JSON_STRING
--			l_key_latitude_degrees:   JSON_STRING
--			l_key_latitude_minutes:   JSON_STRING
--			l_key_latitude_seconds:   JSON_STRING
--			l_key_longitude_degrees:  JSON_STRING
--			l_key_longitude_minutes:  JSON_STRING
--			l_key_longitude_seconds:  JSON_STRING

			l_status:                 STATION_STATUS
			l_type:                   STATION_TYPE
			l_municipality:           MUNICIPALITY

			json_parser:              JSON_PARSER
			i:                        INTEGER
			j:                        INTEGER

			station:                  STATION
		do
		 	create json_parser.make_with_string (json)

			-- Really not necessary to define all of these strings that could be in clear text
			-- but they can change in the future
			create l_key.make_from_string ("header")
			create l_key_id.make_from_string ("id")
			create l_key_name.make_from_string ("name")
			create l_key_status.make_from_string ("status")
			create l_key_types.make_from_string ("types")
			create l_key_municipality.make_from_string ("municipality")
			create l_key_address.make_from_string ("address")
			create l_key_altitude.make_from_string ("altitude")
			create l_key_gb_north.make_from_string ("gb_north")
			create l_key_gb_est.make_from_string ("gb_est")
			create l_key_latitude.make_from_string ("latitude")
			create l_key_longitude.make_from_string ("longitude")
--			create l_key_latitude_degrees.make_from_string ("latitude_degrees")
--			create l_key_latitude_minutes.make_from_string ("latitude_minutes")
--			create l_key_latitude_seconds.make_from_string ("latitude_seconds")
--			create l_key_longitude_degrees.make_from_string ("longitude_degrees")
--			create l_key_longitude_minutes.make_from_string ("longitude_minutes")
--			create l_key_longitude_seconds.make_from_string ("longitude_seconds")

			create l_status.make
			create l_type.make
			create l_municipality.make

			json_parser.parse_content
			if json_parser.is_valid and then attached json_parser.parsed_json_value as jv then
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (l_key) as j_header
					and then attached {JSON_NUMBER} j_header.item ("id") as j_id
					and then attached {JSON_NUMBER} j_header.item ("parameters_number") as j_parnum
				then
					print ("Message: " + j_id.integer_64_item.out + ", " + j_parnum.integer_64_item.out + "%N")
					set_parameters_number (j_parnum.integer_64_item.to_integer)
				else
					print ("The header was not found!%N")
				end

				check
					parameters_number = station_list_response_parnum
				end

				l_key := "data"
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (l_key) as j_data
				then
					l_key := "stations_list"
					if attached {JSON_ARRAY} j_data.item (l_key) as j_stations_list then

						stations_list.wipe_out

						from i := 1
						until i = j_stations_list.count + 1
						loop
							if       attached {JSON_OBJECT} j_stations_list.i_th (i)                  as j_station
							and then attached {JSON_NUMBER} j_station.item (l_key_id)                 as j_id
							and then attached {JSON_STRING} j_station.item (l_key_name)               as j_name
							and then attached {JSON_NUMBER} j_station.item (l_key_status)             as j_status
							and then attached {JSON_ARRAY}  j_station.item (l_key_types)              as j_types
							and then attached {JSON_NUMBER} j_station.item (l_key_municipality)       as j_municipality
							and then attached {JSON_STRING} j_station.item (l_key_address)            as j_address
							and then attached {JSON_NUMBER} j_station.item (l_key_altitude)           as j_altitude
							and then attached {JSON_NUMBER} j_station.item (l_key_gb_north)           as j_gb_north
							and then attached {JSON_NUMBER} j_station.item (l_key_gb_est)             as j_gb_est
							and then attached {JSON_NUMBER} j_station.item (l_key_latitude)           as j_latitude
							and then attached {JSON_NUMBER} j_station.item (l_key_longitude)          as j_longitude
							then
								create station.make
								station.set_id (j_id.integer_64_item.to_integer)
								station.set_name (j_name.item)
								l_status.set_id (j_status.integer_64_item.to_integer)
								station.set_status (l_status)
								from j := 1
								until j = j_types.count + 1
								loop
									if attached {JSON_NUMBER} j_types.i_th (j) as j_type then
										create l_type.make_from_id_and_name (j_type.integer_64_item.to_integer, "")
										station.types.extend (l_type)
									end
									j := j + 1
								end
								l_municipality.set_id (j_municipality.integer_64_item.to_integer)
								station.set_municipality (l_municipality)
								station.set_address (j_address.item)
								station.set_altitude (j_altitude.item.to_integer)
								station.set_gb_north (j_gb_north.item.to_real)
								station.set_gb_est (j_gb_est.item.to_real)
								station.set_latitude (j_latitude.item.to_real)
								station.set_longitude (j_longitude.item.to_real)

								stations_list.extend (station)
							end
							i := i + 1
						end
					end
				end
			else
				print ("json parser error: " + json_parser.errors_as_string + "%N")
			end
		end

feature -- XML Callbacks

	on_start
			-- Called when parsing starts.
		do
			log ("XML callbacks on_start called. It's the beginning of the whole parsing.", log_debug)
		end

	on_finish
			-- Called when parsing finished.
		do
			log ("XML callbacks on_finish called. The parsing has finished.", log_debug)
		end

	on_xml_declaration (a_version: READABLE_STRING_32; an_encoding: detachable READABLE_STRING_32; a_standalone: BOOLEAN)
			-- XML declaration.
		do
			log ("XML callbacks on_xml_declaration called. Got xml declaration", log_debug)
			if attached a_version as version then
				log ("%TVersion:    " + version, log_debug)
			end
			if attached an_encoding as encoding then
				log ("%TEncoding:   " + encoding, log_debug)
			end
			if attached a_standalone as standalone then
				log ("%TStandalone: " + standalone.out, log_debug)
			end
		end

	on_error (a_message: READABLE_STRING_32)
			-- Event producer detected an error.
		do
			outcome := {ERROR_CODES}.err_xml_parsing_failed
			message := {ERROR_CODES}.msg_xml_parser_failed
			log ("XML callbacks on_error called.", log_debug)
			log ("Got an error: " + a_message, log_debug)
		end

	on_processing_instruction (a_name: READABLE_STRING_32; a_content: READABLE_STRING_32)
			-- Processing instruction.
			--| See http://en.wikipedia.org/wiki/Processing_instruction
		do
			log ("XML callbacks on_processing_instruction called.", log_debug)
			log ("%Tname;    " + a_name, log_debug)
			log ("%Tcontent: " + a_content, log_debug)
		end

	on_comment (a_content: READABLE_STRING_32)
			-- Processing a comment.
			-- Atomic: single comment produces single event
		do
			log ("XML callbacks on_comment called. Got a comment.", log_debug)
			log ("%Tcontent: " + a_content, log_debug)
		end

	on_start_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- Start of start tag.
		local
			l_station: STATION
		do
			log ("XML callbacks on_start_tag called. A tag is starting", log_debug)
			if attached a_namespace as namespace then
				log ("%Tnamespace: " + namespace, log_debug)
			end
			if attached a_prefix as myprefix then
				log ("%Tprefix:    " + myprefix, log_debug)
			end
			log ("%Tlocal part:  " + a_local_part, log_debug)
			current_tag := a_local_part
			if current_tag.is_equal ("Stazione") then
				inside_station := True
				create l_station.make
				stations_list.extend (l_station)
			end
		end

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
		local
			l_type: STATION_TYPE
		do
			log ("XML callbacks on_attribute called. Got an attribute", log_debug)
			if attached a_namespace as namespace then
				log ("%Tnamespace: " + namespace, log_debug)
			end
			if attached a_prefix as myprefix then
				log ("%Tprefix:    " + myprefix, log_debug)
			end
			log ("%Tlocal part:  " + a_local_part, log_debug)
			log ("%Tvalue:       " + a_value, log_debug)
			if inside_station then
				if current_tag.is_equal ("Stato") then
					if a_local_part.is_equal ("IdStato") then
						stations_list.last.status.set_id (a_value.to_integer)
					elseif a_local_part.is_equal ("NomeStato") then
						stations_list.last.set_name (a_value)
					end
				elseif current_tag.is_equal ("TipoStazione") then
					if a_local_part.is_equal ("idTipoStazione") then
						create l_type.make
						stations_list.last.types.extend (l_type)
					elseif a_local_part.is_equal ("NomeTipoStazione") then
						stations_list.last.types.last.set_name (a_value)
					end
				elseif current_tag.is_equal ("Comune") then
					if a_local_part.is_equal ("IdComune") then
						stations_list.last.municipality.set_id (a_value.to_integer)
					elseif a_local_part.is_equal ("NomeComune") then
						stations_list.last.municipality.set_name (a_value)
					end
				end
			end
		end

	on_start_tag_finish
			-- End of start tag.
		do
			log ("XML callbacks on_start_tag_finish called. The start tag is finished.", log_debug)
		end

	on_end_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- End tag.
		do
			log ("XML callbacks on_end_tag called. Got the end tag.", log_debug)
			if a_local_part.is_equal ("Stazione") then
				inside_station := False
			end

		end

	on_content (a_content: READABLE_STRING_32)
			-- Text content.
			-- NOT atomic: two on_content events may follow each other
			-- without a markup event in between.
			--| this should not occur, but I leave this comment just in case
		do
			log ("XML callbacks on_content called. Got tag content", log_debug)
			log ("%Tcontent: " + a_content, log_debug)
			if current_tag.is_equal ("Esito") then
				outcome := a_content.to_integer
			elseif current_tag.is_equal ("Messaggio") then
				message := a_content
			elseif inside_station then
				if current_tag.is_equal ("IdStazione") then
					stations_list.last.set_id (a_content.to_integer)
				elseif current_tag.is_equal ("NomeStazione") then
					stations_list.last.set_name (a_content)
				elseif current_tag.is_equal ("Indirizzo") then
					stations_list.last.set_address (a_content)
				elseif current_tag.is_equal ("Quota") then
					stations_list.last.set_altitude (a_content.to_integer)
				elseif current_tag.is_equal ("CGB_nord") then
					stations_list.last.set_gb_north (a_content.to_real)
				elseif current_tag.is_equal ("CGB_est") then
					stations_list.last.set_gb_est (a_content.to_real)
				elseif current_tag.is_equal ("Lat_dec") then
					stations_list.last.set_latitude (a_content.to_real)
				elseif current_tag.is_equal ("Long_dec") then
					stations_list.last.set_longitude (a_content.to_real)
				end
			end
		end

feature {NONE} -- Implementation

	json_representation: STRING
			-- message json representation

	xml_representation:  STRING
			-- message xml representation

	current_tag:         STRING
			-- used by `XML_CALLBACKS' features
	content:             STRING
			-- used by `XML_CALLBACKS' features
	inside_station:      BOOLEAN
			-- boolean flag, tells if a station tag started

invariant
	invariant_clause: True -- Your invariant here

end
