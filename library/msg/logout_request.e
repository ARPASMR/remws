note
	description : "Summary description for {LOGOUT_REQUEST}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

class
	LOGOUT_REQUEST

inherit
	REQUEST_I

--| ----------------------------------------------------------------------------
--| This is the message structure for the login message, for the time being only
--| json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for exemple:
--|
--| {
--|   "header": {
--|     "id":                <logout_msg_id>
--|   },
--|   "data": {
--|     "id": "a_tokenid"
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

create
	make,
	make_from_string,
	make_from_token

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create token_id.make_empty
		end

	make_from_string (token: STRING)
			-- make from string token
		require
			token_not_void: token /=Void and not token.is_empty
		do
			token_id := token
		end

	make_from_token (token: TOKEN)
			-- make from a `TOKEN'
		require
			token_not_void: token /= Void and then token.id /= Void
		do
			token_id := token.id
		end

feature -- Access

	id:                INTEGER do Result := logout_request_id     end

	token_id:          STRING
			-- Access to `token_id'

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

	set_token_id (a_token_id: STRING)
			-- Set `token_id'
		do
			token_id.copy (a_token_id)
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		require else
			token_id_not_empty: not token_id.is_empty
		do
			--create Result.make_from_string (xml_request_template)
			Result := xml_request_template.twin
			Result.replace_substring_all (it_tokenid, token_id)
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

				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_data_tag) as j_data
					and then attached {JSON_STRING} j_data.item (json_id_tag) as j_id
				then
					-- set token_id during parsing
					token_id := j_id.item
				end
			end
		end

	to_json: STRING
			-- json representation
		do
			create Result.make_empty
			Result.append (left_brace)
			Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + logout_request_id.out)
			Result.append (right_brace + comma)
			Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_tokenid_tag + double_quotes + colon + space + double_quotes + token_id + double_quotes)
			Result.append (right_brace)
			Result.append (right_brace)
		end

	from_xml (xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse xml message
		do
			-- should never be called in reuest classes
		end

feature -- Basic operations

	init_response: detachable RESPONSE_I
			--
		do
			Result := create {LOGOUT_RESPONSE}.make
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
			Result := authws_url
		end

	ws_test_url: STRING
			-- Testing web service URL
		do
			Result := authws_test_url
		end

	soap_action_header:  STRING
			-- SOAP action header
		do
			Result := remws_uri + url_path_separator + authws_interface + url_path_separator + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := logout_endpoint_name
		end

	xml_request_template: STRING
			-- XML `Current' message request template
		do
--			Result := "[
--				<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--          		<s:Body>
--                    <Logout xmlns="http://tempuri.org/">
--                      <xElInput>
--                        <Logout xmlns="">
--                          <Token>
--                            <Id>$tokenid</Id>
--                          </Token>
--                        </Logout>
--                      </xElInput>
--                    </Logout>
--                  </s:Body>
--                </s:Envelope>
--        	]"

			create Result.make_empty
			Result.append (stag_start + xmlns_s + colon + soap_envelope + space + xmlns + colon + xmlns_s + Eq_s + double_quotes + xmlsoap + double_quotes + stag_end + lf_s)
			  Result.append (double_space + stag_start + xmlns_s + colon + body + stag_end + lf_s)
			    Result.append (double_space + double_space + stag_start + logout_endpoint_name + space + xmlns + eq_s + double_quotes + remws_uri + url_path_separator + double_quotes + stag_end + lf_s)
			      Result.append (double_space + double_space + double_space + stag_start + xelinput + stag_end + lf_s)
				    Result.append (double_space + double_space + double_space + double_space + stag_start + logout_endpoint_name + space + xmlns + eq_s + double_quotes + double_quotes + stag_end + lf_s)
				      Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_token + stag_end + lf_s)
				        Result.append (double_space + double_space + double_space + double_space + double_space + double_space +
				                       stag_start + it_xml_id + stag_end + it_tokenid + etag_start + it_xml_id + etag_end + lf_s)
				      Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_token + etag_end + lf_s)
				    Result.append (double_space + double_space + double_space + double_space + etag_start + logout_endpoint_name + etag_end + lf_s)
			      Result.append (double_space + double_space + double_space + etag_start + xelinput + etag_end + lf_s)
			    Result.append (double_space + double_space + etag_start + logout_endpoint_name + etag_end + lf_s)
			  Result.append (double_space + etag_start + xmlns_s + colon + body + etag_end + lf_s)
			Result.append (etag_start + xmlns_s + colon + soap_envelope + etag_end + lf_s)
		end

invariant
	invariant_clause: True -- Your invariant here

end
