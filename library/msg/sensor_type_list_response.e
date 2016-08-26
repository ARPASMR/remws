note
	description: "Summary description for {SENSOR_TYPE_LIST_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the sensor_type_list response message,
--| for the time being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--|
--| {
--|   "header": {
--|     "id":                <sensor_type_list_msg_id>
--|   },
--|   "data": {
--|     "outcome": a_number,
--|     "message": "a_message",
--|     "sensor_types_list": [{"id": a_number},
--|                           {"id": a_number},
--|                           ... ,
--|                           {"id": a_number}]
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

class
	SENSOR_TYPE_LIST_RESPONSE

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

			create sensor_types_list.make (0)
		end

feature -- Access

	id:                  INTEGER once Result := sensor_type_list_response_id end

	outcome:             INTEGER
	message:             STRING

	token:               TOKEN

	sensor_types_list:   ARRAYED_LIST [SENSOR_TYPE]

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
			i: INTEGER
		do
			json_representation.wipe_out
			if is_error_response then
				json_representation.append ("{")
				json_representation.append ("%"header%": {")
				json_representation.append ("%"id%": " + sensor_type_list_response_id.out)
				json_representation.append ("},")
				json_representation.append ("%"data%": {")
				json_representation.append ("%"outcome%": " + outcome.out)
				json_representation.append (",%"message%": %"" + message + "%",")
				json_representation.append ("}")
				json_representation.append ("}")
			else
				json_representation.append ("{")
				json_representation.append ("%"header%": {")
				json_representation.append ("%"id%": " + sensor_type_list_response_id.out)
				json_representation.append ("},")
				json_representation.append ("%"data%": {")
				json_representation.append ("%"outcome%": "   + outcome.out)
				json_representation.append (",%"message%": %"" + message + "%"")
				json_representation.append (",%"sensor_types_list%": [")
				from i := 1
				until i = sensor_types_list.count + 1
				loop
					if i /= 1 then
						json_representation.append (",")
					end
					json_representation.append ("{%"id%": " + sensor_types_list.i_th (i).id.out + ",%"name%": %"" + sensor_types_list.i_th (i).name + "%"}")
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
		sensor_types_list.wipe_out
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
			key:         JSON_STRING
			key1:        JSON_STRING
			key2:        JSON_STRING

			json_parser: JSON_PARSER
			i:           INTEGER

			sensor_type: SENSOR_TYPE
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
					key := "sensor_types_list"
					if attached {JSON_ARRAY} j_data.item (key) as j_sensor_types_list then

						sensor_types_list.wipe_out

						from i := 1
						until i = j_sensor_types_list.count + 1
						loop
							if attached {JSON_OBJECT} j_sensor_types_list.i_th (i) as j_sensor_type
							and then attached {JSON_NUMBER} j_sensor_type.item (key1) as j_id
							and then attached {JSON_STRING} j_sensor_type.item (key2) as j_name
							then
								create sensor_type.make_from_id_and_name (j_id.item.to_integer, j_name.item)
								sensor_types_list.extend (sensor_type)
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
		end

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
		local
			a_sensor_type: SENSOR_TYPE
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
			if current_tag.is_equal ("TipoSensore") then
				if a_local_part.is_equal ("IdTipoSensore") then
					create a_sensor_type.make_from_id_and_name (a_value.to_integer, "")
					sensor_types_list.extend (a_sensor_type)
				elseif a_local_part.is_equal ("NomeTipoSensore") then
					sensor_types_list.last.set_name (a_value)
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
			log ("XML callbacks on_end_tag called. Got the and tag.", log_debug)
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

invariant
	invariant_clause: True -- Your invariant here

end
