note
	description: "Summary description for {QUERY_TOKEN_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for the query token request message,
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
--|   "data": {}
--| }
--|
--| ----------------------------------------------------------------------------


class
	QUERY_TOKEN_REQUEST

inherit
	REQUEST_I
	redefine
		out
	end


create
	make,
	make_from_json_string

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			from_json (json, parser)
		end

feature -- Access

	id: INTEGER
			-- message id
		do
			Result := station_list_request_id
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
			-- Should never be called for this message
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		do
			-- Should never be called for this message
			Result := null
		end

	from_json(json: STRING; parser: JSON_PARSER)
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

				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_data_tag) as j_data then
				end
			end
		end

	to_json: STRING
			-- json representation
		do
			create Result.make_empty

			Result.append (left_brace)
			Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + query_token_request_id.out + right_brace)
			Result.append (comma + double_quotes + json_data_tag + double_quotes + colon + space + left_brace + right_brace)
			Result.append (right_brace)
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
			Result := create {QUERY_TOKEN_RESPONSE}.make
		end

feature -- {DISPOSABLE}

	dispose
			--
		do
		end

feature -- Status reporting

	xml_pretty_out:  STRING
			-- XML pretty out
		do
			Result := null
		end

feature {NONE} -- Utilities implementation

	ws_url: STRING
			-- Web service URL
		do
			-- Should never be called for this message
			Result := null
		end

	ws_test_url: STRING
			-- Testing web service URL
		do
			-- Should never be called for this message
			Result := null
		end

	soap_action_header:  STRING
			-- SOAP action header
		do
			-- Should never be called for this message
			Result := null
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			-- Should never be called for this message
			Result := null
		end

	xml_request_template: STRING do Result := null end

feature -- Representation

	out:STRING
			-- String representation
		do
			create Result.make_empty
		end

end
