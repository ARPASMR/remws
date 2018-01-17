note
	description : "Summary description for {SENSOR_LIST_RESPONSE}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

class
	SENSOR_LIST_RESPONSE

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
			create message.make_empty
			create stations_list.make (0)
			inside_station := False
		end

feature -- Access

	id:                  INTEGER do Result := sensor_list_response_id end

	outcome:             INTEGER
	message:             STRING

	stations_list:       ARRAYED_LIST [STATION]

feature -- Status setting

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

	reset
			-- reset contents
		do
			outcome := 0
			message := null
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
		do
			create Result.make_empty
			if is_error_response then
				Result.append (left_brace)
				Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + sensor_list_response_id.out)
				Result.append (right_brace + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes + message + double_quotes)
				Result.append (right_brace)
				Result.append (right_brace)
			else
				Result.append (left_brace)
				Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + sensor_list_response_id.out)
				Result.append (right_brace + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes + message + double_quotes)
				Result.append (comma + double_quotes + json_stations_list_tag + double_quotes + colon + space + left_bracket)

				from stations_list.start
				until stations_list.after
				loop
					Result.append (left_brace + double_quotes + json_id_tag + double_quotes + colon + space + stations_list.item.id.out +
					               comma + double_quotes + json_name_tag + double_quotes + colon + space + double_quotes + stations_list.item.name + double_quotes +
					               comma + double_quotes + json_status_tag + double_quotes + colon + space + stations_list.item.status.id.out)
					Result.append (comma + double_quotes + json_types_tag + double_quotes + colon + space + left_bracket)

					from stations_list.item.types.start
					until stations_list.item.types.after
					loop
						Result.append (stations_list.item.types.item.id.out)
						if not stations_list.item.types.islast then
							Result.append (comma)
						end
						stations_list.item.types.forth
					end
					Result.append (right_bracket + comma)

					Result.append (left_brace + json_municipality_tag + double_quotes + colon + space + stations_list.item.municipality.id.out        + comma)
					Result.append (left_brace + json_address_tag + double_quotes + colon + space + double_quotes + stations_list.item.address         + double_quotes + comma)
					Result.append (left_brace + json_altitude_tag + double_quotes + colon + space + stations_list.item.altitude.out                   + comma)
					Result.append (left_brace + json_gb_north_tag + double_quotes + colon + space + stations_list.item.gb_north.out                   + comma)
					Result.append (left_brace + json_gb_est_tag + double_quotes + colon + space + stations_list.item.gb_est.out                       + comma)
					Result.append (left_brace + json_latitude_tag + double_quotes + colon + space + stations_list.item.latitude.out                   + comma)
					Result.append (left_brace + json_longitude_tag + double_quotes + colon + space + stations_list.item.longitude.out                 + comma)
					Result.append (left_brace + json_latitude_degrees_tag + double_quotes + colon + space + stations_list.item.latitude_degrees.out   + comma)
					Result.append (left_brace + json_latitude_minutes_tag + double_quotes + colon + space + stations_list.item.latitude_minutes.out   + comma)
					Result.append (left_brace + json_latitude_seconds_tag + double_quotes + colon + space  + stations_list.item.latitude_seconds.out  + comma)
					Result.append (left_brace + json_longitude_degrees_tag + double_quotes + colon + space + stations_list.item.longitude_degrees.out + comma)
					Result.append (left_brace + json_longitude_minutes_tag + double_quotes + colon + space + stations_list.item.longitude_minutes.out + comma)
					Result.append (left_brace + json_longitude_seconds_tag + double_quotes + colon + space + stations_list.item.longitude_seconds.out + right_brace)

					stations_list.forth
					if attached stations_list.item and not stations_list.islast then
						Result.append (comma)
					end
				end
				Result.append (right_bracket)
				Result.append (right_brace)
				Result.append (right_brace)
			end
		end

	from_xml(xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse XML message
	do
		stations_list.wipe_out
		parser.set_callbacks (Current)
		set_associated_parser (parser)
		parser.parse_from_string (xml)
		parser.reset
	end

	to_xml: STRING
			-- xml representation
		do
			create Result.make_empty
			-- should never be called for response messages
		end

	from_json (json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		local
			l_status:                 STATION_STATUS
			l_municipality:           MUNICIPALITY
			station:                  STATION
		do
		 	parser.set_representation (json)
			create l_status.make
			create l_municipality.make
			parser.parse_content
			if parser.is_valid and then attached parser.parsed_json_value as jv then
				if not (attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_header_tag) as j_header
					and then attached {JSON_NUMBER} j_header.item (json_id_tag) as j_id)
				then
					print (msg_json_header_not_found)
				end

				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_data_tag) as j_data
				then
					if attached {JSON_ARRAY} j_data.item (json_stations_list_tag) as j_stations_list then

						stations_list.wipe_out

						from j_stations_list.array_representation.start
						until j_stations_list.array_representation.after
						loop
							if       attached {JSON_OBJECT} j_stations_list.array_representation.item as j_station
							and then attached {JSON_NUMBER} j_station.item (json_id_tag)              as j_id
							and then attached {JSON_STRING} j_station.item (json_name_tag)            as j_name
							and then attached {JSON_NUMBER} j_station.item (json_status_tag)          as j_status
							and then attached {JSON_ARRAY}  j_station.item (json_types_tag)           as j_types
							and then attached {JSON_NUMBER} j_station.item (json_municipality_tag)    as j_municipality
							and then attached {JSON_STRING} j_station.item (json_address_tag)         as j_address
							and then attached {JSON_NUMBER} j_station.item (json_altitude_tag)        as j_altitude
							and then attached {JSON_NUMBER} j_station.item (json_gb_north_tag)        as j_gb_north
							and then attached {JSON_NUMBER} j_station.item (json_gb_est_tag)          as j_gb_est
							and then attached {JSON_NUMBER} j_station.item (json_latitude_tag)        as j_latitude
							and then attached {JSON_NUMBER} j_station.item (json_longitude_tag)       as j_longitude
							then
								create station.make
								station.set_id (j_id.integer_64_item.to_integer)
								station.set_name (j_name.item)
								l_status.set_id (j_status.integer_64_item.to_integer)
								station.set_status (l_status)
								from j_types.array_representation.start
								until j_types.array_representation.after
								loop
									if attached {JSON_NUMBER} j_types.array_representation.item as j_type then
										station.types.extend (create {STATION_TYPE}.make_from_id_and_name (j_type.integer_64_item.to_integer, ""))
									end
									j_types.array_representation.forth
								end
								l_municipality.set_id (j_municipality.integer_64_item.to_integer)
								station.set_municipality (l_municipality)
								station.set_address (j_address.item)
								station.set_altitude (j_altitude.item.to_integer)
								station.set_gb_north (j_gb_north.item.to_integer)
								station.set_gb_est (j_gb_est.item.to_integer)
								station.set_latitude (j_latitude.item.to_real)
								station.set_longitude (j_longitude.item.to_real)

								stations_list.extend (station)
							end
							j_stations_list.array_representation.forth
						end
					end
				end
			else
				print (msg_json_parser_error + parser.errors_as_string + lf_s)
			end
		end

feature -- {DISPOSABLE}

	dispose
			--
		do
		end

feature -- XML Callbacks

	on_start
			-- Called when parsing starts.
		do
		end

	on_finish
			-- Called when parsing finished.
		do
		end

	on_xml_declaration (a_version: READABLE_STRING_32; an_encoding: detachable READABLE_STRING_32; a_standalone: BOOLEAN)
			-- XML declaration.
		do
		end

	on_error (a_message: READABLE_STRING_32)
			-- Event producer detected an error.
		do
			outcome := {ERROR_CODES}.err_xml_parsing_failed
			message := {ERROR_CODES}.msg_xml_parser_failed
		end

	on_processing_instruction (a_name: READABLE_STRING_32; a_content: READABLE_STRING_32)
			-- Processing instruction.
			--| See http://en.wikipedia.org/wiki/Processing_instruction
		do
		end

	on_comment (a_content: READABLE_STRING_32)
			-- Processing a comment.
			-- Atomic: single comment produces single event
		do
		end

	on_start_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- Start of start tag.
		do
			current_tag := a_local_part
			if attached current_tag as l_current_tag then
				if l_current_tag.is_equal (it_xml_station) then
					inside_station := True
					stations_list.extend (create {STATION}.make)
				end
			end

		end

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
		do
			if inside_station then
				if attached current_tag as l_current_tag then
					if l_current_tag.is_equal (it_xml_status) then
						if a_local_part.is_equal (it_xml_status_id) then
							stations_list.last.status.set_id (a_value.to_integer)
						elseif a_local_part.is_equal (it_xml_status_name) then
							stations_list.last.status.set_name (a_value)
						end
					elseif l_current_tag.is_equal (it_xml_station_type) then
						if a_local_part.is_equal (it_xml_station_type_id) then
							stations_list.last.types.extend (create {STATION_TYPE}.make)
						elseif a_local_part.is_equal (it_xml_station_type_name) then
							stations_list.last.types.last.set_name (a_value)
						end
					elseif l_current_tag.is_equal (it_xml_municipality) then
						if a_local_part.is_equal (it_xml_municipality_id) then
							stations_list.last.municipality.set_id (a_value.to_integer)
						elseif a_local_part.is_equal (it_xml_municipality_name) then
							stations_list.last.municipality.set_name (a_value)
						end
					end
				end
			end
		end

	on_start_tag_finish
			-- End of start tag.
		do
		end

	on_end_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- End tag.
		do
			if a_local_part.is_equal (it_xml_station) then
				inside_station := False
			end

		end

	on_content (a_content: READABLE_STRING_32)
			-- Text content.
			-- NOT atomic: two on_content events may follow each other
			-- without a markup event in between.
			--| this should not occur, but I leave this comment just in case
		do
			if attached current_tag as l_current_tag then
				if l_current_tag.is_equal (it_xml_outcome) then
					outcome := a_content.to_integer
				elseif l_current_tag.is_equal (it_xml_message) then
					message := a_content
				elseif inside_station then
					if l_current_tag.is_equal (it_xml_station_id) then
						stations_list.last.set_id (a_content.to_integer)
					elseif l_current_tag.is_equal (it_xml_station_name) then
						stations_list.last.set_name (a_content)
					elseif l_current_tag.is_equal (it_xml_address) then
						stations_list.last.set_address (a_content)
					elseif l_current_tag.is_equal (it_xml_altitude) then
						stations_list.last.set_altitude (a_content.to_integer)
					elseif l_current_tag.is_equal (it_xml_cgb_nord) then
						stations_list.last.set_gb_north (a_content.to_integer)
					elseif l_current_tag.is_equal (it_xml_cgb_est) then
						stations_list.last.set_gb_est (a_content.to_integer)
					elseif l_current_tag.is_equal (it_xml_latitude) then
						stations_list.last.set_latitude (a_content.to_real)
					elseif l_current_tag.is_equal (it_xml_longitude) then
						stations_list.last.set_longitude (a_content.to_real)
					end
				end
			end
		end

feature {NONE} -- Implementation

	current_tag: detachable STRING
			-- used by `XML_CALLBACKS' features
	content:     detachable STRING
			-- used by `XML_CALLBACKS' features
	inside_station:      BOOLEAN
			-- boolean flag, tells if a station tag started

invariant
	invariant_clause: True -- Your invariant here


end
