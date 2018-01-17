note
	description : "Summary description for {REALTIME_DATA_RESPONSE}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

--| ----------------------------------------------------------------------------
--| This is the message structure for the standard_data response message,
--| for the time being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--|
--| {
--|   "header": {
--|     "id":                <standard_data_response_msg_id>
--|   },
--|   "data": {
--|     "outcome": a_number,
--|     "message": "a_message",
--|     "sensor_data_list": [
--|                           {
--|                             "sensor_id": an_id1,
--|                             "sensor_name: "a_name1",
--|                             "sensor_measure_unit: "a_measure_unit1",
--|                             "function_id: a_function_id1,
--|                             "function_name": "a_funtion_name1",
--|                             "operator_id": an_operator1,
--|                             "operator_name": "an_operator_name1",
--|                             "granularity_id": a_granularity1,
--|                             "granularity_name": "a_granularity_name1",
--|                             "data": {
--|                                       [{"D": "data1", "V":value1, "S": status1},
--|                                        {"D": "data2", "V":value2, "S": status2},
--|                                        ...,
--|                                        {"D": "datan", "V":valuen, "S": statusn}]
--|                                     }
--|                           },
--|                           {
--|                             "sensor_id": an_id2,
--|                             "sensor_name: "a_name2",
--|                             "sensor_measure_unit: "a_measure_unit2",
--|                             "function_id: a_function_id2,
--|                             "function_name": "a_funtion_name2",
--|                             "operator_id": an_operator2,
--|                             "operator_name": "an_operator_name2",
--|                             "granularity_id": a_granularity2,
--|                             "granularity_name": "a_granularity_name2",
--|                             "data": {
--|                                       [{"D": "data1", "V":value1, "S": status1},
--|                                        {"D": "data2", "V":value2, "S": status2},
--|                                        ...,
--|                                        {"D": "datan", "V":valuen, "S": statusn}]
--|                                     }
--|                           },
--|                           ... ,
--|                           {
--|                             "sensor_id": an_idn,
--|                             "sensor_name: "a_namen",
--|                             "sensor_measure_unit: "a_measure_unitn",
--|                             "function_id: a_function_idn,
--|                             "function_name": "a_funtion_namen",
--|                             "operator_id": an_operatorn,
--|                             "operator_name": "an_operator_namen",
--|                             "granularity_id": a_granularityn,
--|                             "granularity_name": "a_granularity_namen",
--|                             "data": {
--|                                       [{"D": "data1", "V":value1, "S": status1},
--|                                        {"D": "data2", "V":value2, "S": status2},
--|                                        ...,
--|                                        {"D": "datan", "V":valuen, "S": statusn}]
--|                                     }
--|                           }
--|                           ]
--|   }
--| }
--|
--| ----------------------------------------------------------------------------
--| XML response
--| ----------------------------------------------------------------------------
--<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--  <s:Body><RendiDatiTempoRealeResponse xmlns="http://tempuri.org/">
--    <RendiDatiTempoRealeResult>
--      <RendiDatiTempoRealeResponse xmlns="">
--        <RendiDatiTempoRealeResult>
--          <Esito>0</Esito>
--          <Sensore
--           IdSensore="4058"
--           NomeSensore="Milano - Parco Nord  Temperatura"
--           UnitaMisura="°C"
--           IdFunzione="1"
--           Funzione="Dato Rilevato"
--           IdOperatore="1"
--           Operatore="Media"
--           IdPeriodo="1"
--           Periodo="10 minuti">
--          <Dati><![CDATA[
--2015-11-21 09:30:00;10.10000000;0
--2015-11-21 09:40:00;10.30000000;0
--2015-11-21 09:50:00;10.50000000;0
--2015-11-21 10:00:00;10.70000000;0
--2015-11-21 10:10:00;10.80000000;0
--2015-11-21 10:20:00;10.90000000;0
--2015-11-21 10:30:00;11.00000000;0
--2015-11-21 10:40:00;11.00000000;0
--2015-11-21 10:50:00;11.10000000;0
--2015-11-21 11:00:00;11.00000000;0
--2015-11-21 11:10:00;11.10000000;0
--2015-11-21 11:20:00;11.10000000;0
--2015-11-21 11:30:00;11.10000000;0
--]]></Dati>
--          </Sensore>
--        </RendiDatiTempoRealeResult>
--      </RendiDatiTempoRealeResponse>
--    </RendiDatiTempoRealeResult>
--  </RendiDatiTempoRealeResponse>
--  </s:Body>
--</s:Envelope>

class
	STANDARD_DATA_RESPONSE

inherit
	RESPONSE_I
	redefine
		dispose
	end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create current_tag.make_empty
			create content.make_empty
			create message.make_empty
			create sensor_data_list.make (0)
		end

feature -- Access

	id:                  INTEGER do Result := realtime_data_response_id end

	outcome:             INTEGER
	message:             detachable STRING

	sensor_data_list:    ARRAYED_LIST [SENSOR_STANDARD_RESPONSE_DATA]

feature -- Status setting

	set_outcome (o: INTEGER)
			-- Sets `outcome'
		do
			outcome := o
		end

	set_message (m: STRING)
			-- Sets `message'
		do
			--message.copy (m)
			message := m.twin
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
			srec: detachable STANDARD_DATA_RECORD
		do
			create Result.make_empty

			if is_error_response then
				Result.append (left_brace)
				Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + standard_data_response_id.out)
				Result.append (right_brace + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes)
				if attached message as l_message then
					Result.append (l_message)
				else
					Result.append (null)
				end
				Result.append (double_quotes)
				Result.append (right_brace)
				Result.append (right_brace)
			else
				Result.append (left_brace)
				Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + standard_data_response_id.out)
				Result.append (right_brace + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes)
				if attached message as l_message then
					Result.append (l_message)
				end
				Result.append (double_quotes)
				Result.append (comma + double_quotes + json_sensor_data_list_tag + double_quotes + colon + space + left_bracket)

				across
					sensor_data_list as s
				loop
					Result.append (left_brace + double_quotes + json_sensor_id_tag + double_quotes + colon + space + s.item.sensor_id.out)
					Result.append (comma + double_quotes + json_sensor_name_tag + double_quotes + colon + space + double_quotes + s.item.sensor_name + double_quotes)
					Result.append (comma + double_quotes + json_sensor_measure_unit_tag + double_quotes + colon + space + double_quotes + s.item.measure_unit + double_quotes)
					Result.append (comma + double_quotes + json_function_id_tag + double_quotes + colon + space + s.item.function_id.out)
					Result.append (comma + double_quotes + json_function_name_tag + double_quotes + colon + space + double_quotes + s.item.function_name + double_quotes)
					Result.append (comma + double_quotes + json_operator_id_tag + double_quotes+ colon + space + s.item.operator_id.out)
					Result.append (comma + double_quotes + json_operator_name_tag + double_quotes + colon + space + double_quotes + s.item.operator_name + double_quotes)
					Result.append (comma + double_quotes + json_granularity_id_tag + double_quotes + colon + space + s.item.granularity_id.out)
					Result.append (comma + double_quotes + json_granularity_name_tag + double_quotes + colon + space + double_quotes + s.item.granularity_description + double_quotes)

					Result.append (comma + double_quotes + json_data_tag + double_quotes + colon + space + left_bracket)

					from s.item.data.start
					until s.item.data.after
					loop
						-- Manage each data row
						srec := s.item.data.item
						if attached srec as l_rec then
							Result.append (left_brace + double_quotes + json_d_tag + double_quotes + colon + space + double_quotes + l_rec.d.formatted_out (default_date_time_format) +
							               comma + double_quotes + json_v_tag + double_quotes + colon + space + l_rec.v.out +
							               comma + double_quotes + json_s_tag + double_quotes + colon + space + l_rec.s.out + right_brace)
						end
						if not s.item.data.islast then
							Result.append (comma)
						end
						s.item.data.forth
					end
					Result.append (right_bracket + right_brace)
				end
				Result.append (right_bracket)
				Result.append (right_brace)
				Result.append (right_brace)
			end
		end

	from_xml(xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse XML message
	do
		sensor_data_list.wipe_out
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
			sensor_data: detachable SENSOR_STANDARD_RESPONSE_DATA
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
				and then

					--if
					attached {JSON_ARRAY} j_data.item (json_sensor_data_list_tag) as j_sensor_data_list then

					if attached sensor_data_list as l_sensor_data_list then l_sensor_data_list.wipe_out end

					from j_sensor_data_list.array_representation.start
					until j_sensor_data_list.array_representation.after
					loop
						if attached {JSON_OBJECT} j_sensor_data_list.array_representation.item as j_sensor_data
						and then attached {JSON_NUMBER} j_sensor_data.item (json_sensor_id_tag) as j_id
						and then attached {JSON_STRING} j_sensor_data.item (json_sensor_name_tag) as j_name
						and then attached {JSON_STRING} j_sensor_data.item (json_sensor_measure_unit_tag) as j_unit
						and then attached {JSON_NUMBER} j_sensor_data.item (json_function_id_tag) as j_function_id
						and then attached {JSON_STRING} j_sensor_data.item (json_function_name_tag) as j_function_name
						and then attached {JSON_NUMBER} j_sensor_data.item (json_operator_id_tag) as j_operator_id
						and then attached {JSON_STRING} j_sensor_data.item (json_operator_name_tag) as j_operator_name
						and then attached {JSON_NUMBER} j_sensor_data.item (json_granularity_id_tag) as j_granularity_id
						and then attached {JSON_STRING} j_sensor_data.item (json_granularity_name_tag) as j_granularity_name
						then
							create sensor_data.make_from_id (j_id.item.to_integer)
							sensor_data.set_sensor_name (j_name.item)
							sensor_data.set_measure_unit (j_unit.item)
							sensor_data.set_function_id (j_function_id.item.to_integer)
							sensor_data.set_function_name (j_function_name.item)
							sensor_data.set_operator_id (j_operator_id.item.to_integer)
							sensor_data.set_operator_name (j_operator_name.item)
							sensor_data.set_granularity_id (j_granularity_id.item.to_integer)
							sensor_data.set_granularity_description (j_granularity_name.item)
							sensor_data_list.extend (sensor_data)

							if attached {JSON_ARRAY} j_sensor_data.item (json_data_tag) as j_sdata
							then
								if attached sensor_data.data as l_data then l_data.wipe_out end
								from
									j_sdata.array_representation.start
								until
									j_sdata.array_representation.after
								loop
									if attached {JSON_OBJECT} j_sdata.array_representation.item as j_rec and then
									   attached {JSON_STRING} j_rec.item (json_d_tag) as j_d and then
									   attached {JSON_NUMBER} j_rec.item (json_v_tag) as j_v and then
									   attached {JSON_NUMBER} j_rec.item (json_s_tag) as j_s then
										sensor_data.data.extend (create {STANDARD_DATA_RECORD}.make_from_parameters (create {DATE_TIME}.make_from_string (j_d.item, default_date_time_format), j_v.item.to_real, j_s.item.to_integer))
									end
									j_sdata.array_representation.forth
								end
--|                             "data": {
--|                                       [{"D": "data1", "V":value1, "S": status1},
--|                                        {"D": "data2", "V":value2, "S": status2},
--|                                        ...,
--|                                        {"D": "datan", "V":valuen, "S": statusn}]
--|                                     }
							end
						end
						j_sensor_data_list.array_representation.forth
					end
				end
			else
				print (msg_json_parser_error + parser.errors_as_string + "%N")
			end
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
			-- se il tag corrente è <Sensor> creare un oggettodi tipo SENSOR_REALTIME_RESPONSE_DATA
			-- e aggiungerlo alla lista dei sensori

			if attached current_tag as l_current_tag then
				if l_current_tag.is_equal (it_xml_sensor) then
					sensor_data_list.extend (create {SENSOR_STANDARD_RESPONSE_DATA}.make)
				elseif l_current_tag.is_equal (it_xml_R) then
					sensor_data_list.last.data.extend (create {STANDARD_DATA_RECORD}.make)
				end
			end
		end

--          <Esito>0</Esito>
--          <Sensore
--           IdSensore="4058"
--           NomeSensore="Milano - Parco Nord  Temperatura"
--           UnitaMisura="°C"
--           IdFunzione="1"
--           Funzione="Dato Rilevato"
--           IdOperatore="1"
--           Operatore="Media"
--           IdPeriodo="1"
--           Periodo="10 minuti">
--          <Dati><![CDATA[
--2015-11-21 09:30:00;10.10000000;0
--2015-11-21 09:40:00;10.30000000;0
--2015-11-21 09:50:00;10.50000000;0
--2015-11-21 10:00:00;10.70000000;0
--2015-11-21 10:10:00;10.80000000;0
--2015-11-21 10:20:00;10.90000000;0
--2015-11-21 10:30:00;11.00000000;0
--2015-11-21 10:40:00;11.00000000;0
--2015-11-21 10:50:00;11.10000000;0
--2015-11-21 11:00:00;11.00000000;0
--2015-11-21 11:10:00;11.10000000;0
--2015-11-21 11:20:00;11.10000000;0
--2015-11-21 11:30:00;11.10000000;0
--]]></Dati>

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
		do
			if attached current_tag as l_current_tag then
				if l_current_tag.is_equal (it_xml_sensor) then
					if a_local_part.is_equal (it_xml_sensor_id) then
						sensor_data_list.last.set_sensor_id (a_value.to_integer)
					elseif a_local_part.is_equal (it_xml_sensor_name) then
						sensor_data_list.last.set_sensor_name (a_value)
					elseif a_local_part.is_equal (it_xml_measure_unit) then
						sensor_data_list.last.set_measure_unit (a_value)
					elseif a_local_part.is_equal (it_xml_function_id) then
						sensor_data_list.last.set_function_id (a_value.to_integer)
					elseif a_local_part.is_equal (it_xml_function) then
						sensor_data_list.last.set_function_name (a_value)
					elseif a_local_part.is_equal (it_xml_operator_id) then
						sensor_data_list.last.set_operator_id (a_value.to_integer)
					elseif a_local_part.is_equal (it_xml_operator) then
						sensor_data_list.last.set_operator_name (a_value)
					elseif a_local_part.is_equal (it_xml_granularity_id) then
						sensor_data_list.last.set_granularity_id (a_value.to_integer)
					elseif a_local_part.is_equal (it_xml_granularity) then
						sensor_data_list.last.set_granularity_description (a_value)
					end
				elseif l_current_tag.is_equal (it_xml_R) then
					if a_local_part.is_equal (it_xml_D) then
						sensor_data_list.last.data.last.set_dt(a_value)
					elseif a_local_part.is_equal (it_xml_V) then
						sensor_data_list.last.data.last.set_value(a_value.to_real)
					elseif a_local_part.is_equal (it_xml_S) then
						sensor_data_list.last.data.last.set_status(a_value.to_integer)
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
				end
			end
		end

feature -- Dispose

	dispose
			--
		do
		end

feature {NONE} -- Implementation


	current_tag:         detachable STRING
			-- used by `XML_CALLBACKS' features
	content:             detachable STRING
			-- used by `XML_CALLBACKS' features

invariant
	invariant_clause: True -- Your invariant here

end
