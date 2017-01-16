note
	description: "Summary description for {QUERY_TOKEN_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the query_token request message,
--| for the time being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--|
--| {
--|   "header": {
--|     "id":                <query_token_msg_id>
--|   },
--|   "data": {
--|     "outcome": an_integer,
--|     "message": "a_string"
--|     "id":      "a_string",
--|     "expiry":  "a_date_time"
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

class
	QUERY_TOKEN_RESPONSE

inherit
	RESPONSE_I
	ANY
	undefine
		out
	end


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
			create token.make
			create message.make_empty
		end

feature -- Access

	id:                  INTEGER do Result := realtime_data_response_id end

	outcome:             INTEGER
	message:             STRING

	token:               TOKEN

feature -- Status setting

	set_id (an_id: STRING)
			-- Sets token id
		do
			token.set_id (an_id)
		end

	set_expiry (a_dt: DATE_TIME)
			-- Sets expiry date time
		do
			token.set_expiry (a_dt)
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

	reset
			-- reset contents
		do
			outcome := 0
			message.wipe_out
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
			json_representation.wipe_out
			if is_error_response then
				json_representation.append ("{")
				json_representation.append ("%"header%": {")
				json_representation.append ("%"id%": " + query_token_response_id.out)
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
				json_representation.append ("%"id%": " + query_token_response_id.out)
				json_representation.append ("},")
				json_representation.append ("%"data%": {")
				json_representation.append ("%"outcome%": "   + outcome.out)
				json_representation.append (",%"message%": %"" + message + "%"")
				json_representation.append (",%"id%": %"" + token.id + "%"")
				json_representation.append (",%"expiry%": %"" + token.expiry.formatted_out (default_date_time_format) + "%"")
				json_representation.append ("}")
				json_representation.append ("}")
			end

			Result := json_representation
		end

	from_xml(xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse XML message
	do
		-- Should never be called
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
			key:            JSON_STRING
			key1:           JSON_STRING
			key2:           JSON_STRING
			dt:             DATE_TIME

		do
		 	parser.reset_reader
		 	parser.reset
		 	parser.set_representation (json)

			create key.make_from_string ("header")
			create key1.make_from_string ("id")
			create key2.make_from_string ("expiry")
			create dt.make_now

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
				then
					key := "sensor_data_list"

					if attached {JSON_STRING} j_data.item (key1) as j_id
					   and then attached {JSON_STRING} j_data.item (key2) as j_expiry then
						token.set_id (j_id.item)
						token.set_expiry (dt)
					end
				end
			else
				print ("json parser error: " + parser.errors_as_string + "%N")
			end
			parser.reset_reader
			parser.reset
			key.item.wipe_out
			key1.item.wipe_out
			key2.item.wipe_out
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
		end

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
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
		end

feature -- Dispose

	dispose
			--
		do
			json_representation.wipe_out
			xml_representation.wipe_out
			current_tag.wipe_out
			content.wipe_out
			message.wipe_out
		end



feature -- Implementation

    json_representation: STRING
			-- message json representation

	xml_representation:  STRING
			-- message xml representation

	current_tag:         STRING
			-- used by `XML_CALLBACKS' features
	content:             STRING
			-- used by `XML_CALLBACKS' features


end