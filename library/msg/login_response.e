note
	description: "Summary description for {LOGIN_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGIN_RESPONSE

inherit
	RESPONSE_I
	ERROR_CODES

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create current_tag.make_empty
			create content.make_empty
			create message.make_empty
			create token.make
		end

feature -- Access

	id:                  INTEGER do Result := login_request_id + response_id_offset end

	outcome:             INTEGER
	message:             STRING

	token:               TOKEN

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

			Result.append (left_brace)
			Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + login_response_id.out)
			Result.append (right_brace + comma)
			Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
			if not is_error_response then
				Result.append (double_quotes + json_tokenid_tag + double_quotes + colon + space + double_quotes + token.id + double_quotes)
				Result.append (comma + double_quotes + json_expiry_tag + double_quotes + colon + space + double_quotes + token.expiry.formatted_out (default_date_time_format) + double_quotes+ comma)
			end
			Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
			Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes+ message + double_quotes)
			Result.append (right_brace)
			Result.append (right_brace)
		end

	from_xml(xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse XML message
	do
		parser.set_callbacks (Current)
		set_associated_parser (parser)
		parser.parse_from_string (xml)
		parser.reset
	end

	to_xml: STRING
			-- xml representation
		do
			-- should never be called in response classes
			create result.make_empty
		end

	from_json (json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
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
					and then attached {JSON_STRING} j_data.item (json_tokenid_tag) as j_token
					and then attached {JSON_STRING} j_data.item (json_expiry_tag) as j_expiry
					and then attached {JSON_NUMBER} j_data.item (json_outcome_tag) as j_outcome
					and then attached {JSON_STRING} j_data.item (json_message_tag) as j_message
				then
					token.set_id (j_token.item)
					token.set_expiry (create {DATE_TIME}.make_from_string (j_expiry.item, default_date_time_format))
					set_outcome (j_outcome.integer_64_item.to_integer)
					set_message (j_message.item)
				end
			end
		end

feature -- {DISPOSABLE}

	dispose
			-- From `DISPOSABLE'
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
		end

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
		do
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
				if l_current_tag.is_equal (it_xml_id) then
					token.set_id (a_content)
				elseif l_current_tag.is_equal (it_xml_token_expiry) then
					token.set_expiry (create {DATE_TIME}.make_from_string (a_content, default_date_time_format))
				elseif l_current_tag.is_equal (it_xml_outcome) then
					outcome := a_content.to_integer
				elseif l_current_tag.is_equal (it_xml_message) then
					message := a_content
				end
			end
		end

feature {NONE} -- Implementation

	current_tag:         detachable STRING
			-- used by `XML_CALLBACKS' features
	content:             detachable STRING
			-- used by `XML_CALLBACKS' features

invariant
	invariant_clause: True -- Your invariant here

end
