note
	description: "Summary description for {REALTIME_DATA_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the realtime_data response message,
--| for the time being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--|
--| {
--|   "header": {
--|     "id":                <realtime_data_response_msg_id>
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
--|                                       ["datarow1": "data1",
--|                                       "datarow2": "data2",
--|                                       ...,
--|                                       "datarown": "datan"]
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
--|                                       ["datarow1": "data1",
--|                                       "datarow2": "data2",
--|                                       ...,
--|                                       "datarown": "datan"]
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
--|                                       ["datarow1": "data1",
--|                                       "datarow2": "data2",
--|                                       ...,
--|                                       "datarown": "datan"]
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
	REALTIME_DATA_RESPONSE

inherit
	RESPONSE_I

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create json_representation.make_empty
			create xml_representation.make_empty
			create current_tag.make_empty
			create content.make_empty
			create message.make_empty
			create token.make
			create cdata_segment.make_empty

			create sensor_data_list.make (0)
		end

feature -- Access

	id:                  INTEGER once Result := realtime_data_response_id end

	outcome:             INTEGER
	message:             STRING

	token:               TOKEN

	sensor_data_list:   ARRAYED_LIST [SENSOR_REALTIME_RESPONSE_DATA]

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
			message := ""
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
			i,j: INTEGER
		do
			json_representation.wipe_out
			if is_error_response then
				json_representation.append ("{")
				json_representation.append ("%"header%": {")
				json_representation.append ("%"id%": " + realtime_data_response_id.out)
				json_representation.append ("},")
				json_representation.append ("%"data%": {")
				json_representation.append ("%"outcome%": " + outcome.out)
				--json_representation.append (",%"message%": %"" + message + "%",")
				json_representation.append (",%"message%": %"" + message + "%"")
				json_representation.append ("}")
				json_representation.append ("}")
			else
				json_representation.append ("{")
				json_representation.append ("%"header%": {")
				json_representation.append ("%"id%": " + realtime_data_response_id.out)
				json_representation.append ("},")
				json_representation.append ("%"data%": {")
				json_representation.append ("%"outcome%": "   + outcome.out)
				json_representation.append (",%"message%": %"" + message + "%"")
				json_representation.append (",%"sensor_data_list%": [")
				from i := 1
				until i = sensor_data_list.count + 1
				loop
					if i /= 1 then
						json_representation.append (",")
					end


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
--|                                       ["datarow1": "data1",
--|                                       "datarow2": "data2",
--|                                       ...,
--|                                       "datarown": "datan"]
--|                                     }
					json_representation.append ("{%"sensor_id%": " + sensor_data_list.i_th (i).sensor_id.out)
					json_representation.append (",%"sensor_name%": %"" + sensor_data_list.i_th (i).sensor_name + "%"")
					json_representation.append (",%"sensor_measure_unit%": %"" + sensor_data_list.i_th (i).measure_unit + "%"")
					json_representation.append (",%"function_id%":" + sensor_data_list.i_th (i).function_id.out)
					json_representation.append (",%"function_name%": %"" + sensor_data_list.i_th (i).function_name + "%"")
					json_representation.append (",%"operator_id%":" + sensor_data_list.i_th (i).operator_id.out)
					json_representation.append (",%"operator_name%": %"" + sensor_data_list.i_th (i).operator_name + "%"")
					json_representation.append (",%"granularity_id%":" + sensor_data_list.i_th (i).granularity_id.out)
					json_representation.append (",%"granularity_name%": %"" + sensor_data_list.i_th (i).granularity_description + "%"")

					json_representation.append (",%"data%": [")


					from j := 1
					until j = sensor_data_list.i_th (i).data.count
					loop
						-- Manage each data row
						if j /= 1  and then not sensor_data_list.i_th (i).data.i_th (j - 1).is_empty
						then
							json_representation.append (",")
						end
						if not sensor_data_list.i_th (i).data.i_th (j).is_empty then
							json_representation.append ("{%"datarow%": %"" + sensor_data_list.i_th (i).data.i_th (j) + "%"}")
						end
						j := j + 1
					end

					json_representation.append ("]}")

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
		sensor_data_list.wipe_out
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
			key:            JSON_STRING
			key1:           JSON_STRING
			key2:           JSON_STRING

			json_parser:    JSON_PARSER
			i,j:            INTEGER

			sensor_rt_data: SENSOR_REALTIME_RESPONSE_DATA
		do
		 	create json_parser.make_with_string (json)

			create key.make_from_string ("header")
			create key1.make_from_string ("id")
			create key2.make_from_string ("name")

			json_parser.parse_content
			if json_parser.is_valid and then attached json_parser.parsed_json_value as jv then
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_header
					and then attached {JSON_NUMBER} j_header.item ("id") as j_id
				then
					print ("Message: " + j_id.integer_64_item.out + "%N")
				else
					print ("The header was not found!%N")
				end

				key := "data"
				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (key) as j_data
				then
					key := "sensor_data_list"
					if attached {JSON_ARRAY} j_data.item (key) as j_sensor_data_list then

						sensor_data_list.wipe_out

						from i := 1
						until i = j_sensor_data_list.count + 1
						loop
							if attached {JSON_OBJECT} j_sensor_data_list.i_th (i) as j_sensor_data
							and then attached {JSON_NUMBER} j_sensor_data.item ("sensor_id") as j_id
							and then attached {JSON_STRING} j_sensor_data.item ("sensor_name") as j_name
							and then attached {JSON_STRING} j_sensor_data.item ("sensor_measure_unit") as j_unit
							and then attached {JSON_NUMBER} j_sensor_data.item ("function_id") as j_function_id
							and then attached {JSON_STRING} j_sensor_data.item ("function_name") as j_function_name
							and then attached {JSON_NUMBER} j_sensor_data.item ("operator_id") as j_operator_id
							and then attached {JSON_STRING} j_sensor_data.item ("operator_name") as j_operator_name
							and then attached {JSON_NUMBER} j_sensor_data.item ("granularity_id") as j_granularity_id
							and then attached {JSON_STRING} j_sensor_data.item ("granularity_name") as j_granularity_name
							then
								create sensor_rt_data.make_from_id (j_id.item.to_integer)
								sensor_rt_data.set_sensor_name (j_name.item)
								sensor_rt_data.set_measure_unit (j_unit.item)
								sensor_rt_data.set_function_id (j_function_id.item.to_integer)
								sensor_rt_data.set_function_name (j_function_name.item)
								sensor_rt_data.set_operator_id (j_operator_id.item.to_integer)
								sensor_rt_data.set_operator_name (j_operator_name.item)
								sensor_rt_data.set_granularity_id (j_granularity_id.item.to_integer)
								sensor_rt_data.set_granularity_description (j_granularity_name.item)
								sensor_data_list.extend (sensor_rt_data)

								if attached {JSON_ARRAY} j_sensor_data.item ("data") as j_cdata
								then
									sensor_rt_data.data.wipe_out

									from j := 1
									until j = j_cdata.count + 1
									loop
										if attached {JSON_OBJECT} j_cdata.i_th (j) as j_data_row
										and then attached {JSON_STRING} j_data_row.item ("datarow") as j_row
										then
											sensor_rt_data.data.extend (j_row.item)
										end
										j := j + 1
									end
								end
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
			a_sensor_rt_data: SENSOR_REALTIME_RESPONSE_DATA
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
			-- se il tag corrente è <Sensor> creare un oggettodi tipo SENSOR_REALTIME_RESPONSE_DATA
			-- e aggiungerlo alla lista dei sensori
			if current_tag.is_equal ("Sensore") then
				create a_sensor_rt_data.make
				sensor_data_list.extend (a_sensor_rt_data)
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
		local
			a_sensor_rt_data: SENSOR_REALTIME_RESPONSE_DATA
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

			if current_tag.is_equal ("Sensore") then
				if a_local_part.is_equal ("IdSensore") then
					sensor_data_list.last.set_sensor_id (a_value.to_integer)
				elseif a_local_part.is_equal ("NomeSensore") then
					sensor_data_list.last.set_sensor_name (a_value)
				elseif a_local_part.is_equal ("UnitaMisura") then
					sensor_data_list.last.set_measure_unit (a_value)
				elseif a_local_part.is_equal ("IdFunzione") then
					sensor_data_list.last.set_function_id (a_value.to_integer)
				elseif a_local_part.is_equal ("Funzione") then
					sensor_data_list.last.set_function_name (a_value)
				elseif a_local_part.is_equal ("IdOperatore") then
					sensor_data_list.last.set_operator_id (a_value.to_integer)
				elseif a_local_part.is_equal ("Operatore") then
					sensor_data_list.last.set_operator_name (a_value)
				elseif a_local_part.is_equal ("IdPeriodo") then
					sensor_data_list.last.set_granularity_id (a_value.to_integer)
				elseif a_local_part.is_equal ("Periodo") then
					sensor_data_list.last.set_granularity_description (a_value)
				end
			elseif current_tag.is_equal ("Dati") then
				cdata_segment:= a_value.twin
				sensor_data_list.last.data.extend (a_value)
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
			log ("XML callbacks on_end_tag called. Got the and tag.", log_debug)
		end

	on_content (a_content: READABLE_STRING_32)
			-- Text content.
			-- NOT atomic: two on_content events may follow each other
			-- without a markup event in between.
			--| this should not occur, but I leave this comment just in case
		local
			i: INTEGER
			words: LIST[STRING]
			str: STRING
		do
			log ("XML callbacks on_content called. Got tag content", log_debug)
			log ("%Tcontent: " + a_content, log_debug)
			if current_tag.is_equal ("Esito") then
				outcome := a_content.to_integer
			elseif current_tag.is_equal ("Messaggio") then
				message := a_content
			elseif current_tag.is_equal ("Dati") then
				cdata_segment := a_content.twin

				words := cdata_segment.split ('%N')
				from i := 1
				until i = words.count + 1
				loop
					str := words.i_th (i)
					sensor_data_list.last.data.extend (str)
					i := i + 1
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
	cdata_segment:       STRING
			-- used by `XML_CALLBACKS' features

invariant
	invariant_clause: True -- Your invariant here

end
