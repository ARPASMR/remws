note
	description: "Summary description for {QUERY_TOKEN_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the query_token response message,
--| for the time being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--|
--| {
--|   "header": {
--|     "id": <query_token_msg_id>
--|   },
--|   "data": {
--|     "outcome": a_number,
--|     "message": "a_message",
--|     "tokenid": "a_token_id",
--|     "expiry":  "a_date_time"
--|   }
--| }
--|
--| ----------------------------------------------------------------------------


class
	QUERY_TOKEN_RESPONSE

inherit
	RESPONSE_I
	redefine
		out
	end
	XML_CALLBACKS_NULL
	undefine
		make,
		out
	end

create
	make,
	make_from_token

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create token.make
			create message.make_empty
		end

	make_from_token (a_token: TOKEN)
			-- Initialization from a `TOKEN' object
		do
			create token.make
			create message.make_empty
			token.set_id (a_token.id)
			token.set_expiry (a_token.expiry)
		end

feature -- Access

	id:                  INTEGER do Result := query_token_response_id end

	outcome:             INTEGER
	message:             STRING

	token:         		 TOKEN

feature -- Status setting

	set_outcome (o: INTEGER)
			-- Sets `outcome'
		do
			outcome := o
		end

	set_message (m: STRING)
			-- Sets `message'
		do
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
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + query_token_response_id.out)
				Result.append (right_brace + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes + message + double_quotes)
				Result.append (right_brace)
				Result.append (right_brace)
			else
				Result.append (left_brace)
				Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + query_token_response_id.out)
				Result.append (double_quotes + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes + message + double_quotes)
				Result.append (comma + double_quotes + json_tokenid_tag + double_quotes + colon + space + double_quotes + token.id + double_quotes + comma)
				Result.append (double_quotes + json_expiry_tag + double_quotes + colon + space + token.expiry.formatted_out (default_date_time_format) + double_quotes)
				Result.append (right_brace)
				Result.append (right_brace)
			end
		end

	from_xml(xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse XML message
	do
		-- Should never be called for this message
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
				and then attached {JSON_STRING} j_data.item (json_tokenid_tag) as j_token_id
				and then attached {JSON_STRING} j_data.item (json_expiry_tag) as j_expiry then
					token.set_id (j_token_id.item)
					token.set_expiry (create {DATE_TIME}.make_from_string (j_expiry.item, default_date_time_format))
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


feature -- Representation

	out: STRING
			-- Stringrepresentation
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation

	current_tag: detachable STRING
			-- used by `XML_CALLBACKS' features
	content:     detachable STRING
			-- used by `XML_CALLBACKS' features

end
