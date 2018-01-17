note
	description : "Summary description for {MUNICIPALITY_LIST_REQUEST}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

--| ----------------------------------------------------------------------------
--| This is the message structure for the municipalities list message, for the
--| time being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--|
--| {
--|   "header": {
--|     "id":                <municipality_list_request_id>
--|   },
--|   "data": {
--|     "provinces_list": [{"province": "P1"},
--|                        {"province": "P2"},
--|                        ...,
--|                        {"province": "Pn"}]
--|   }
--| }
--|
--| ----------------------------------------------------------------------------

class
	MUNICIPALITY_LIST_REQUEST

inherit
	REQUEST_I

create
	make,
	make_from_json_string,
	make_from_token

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create token_id.make_empty
			create provinces_list.make (0)
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create token_id.make_empty
			create provinces_list.make (0)

			from_json (json, parser)
		end

	make_from_token (a_token: STRING)
			-- Build a `MUNICIPALITY_LIST_REQUEST' with `token_id' = `a_token'
		do
			create token_id.make_from_string (a_token)
			create provinces_list.make (0)
		end

feature -- Access

	id: INTEGER
			-- message id
		do
			Result := municipality_list_request_id
		end

	token: detachable STRING
			-- Access to `token_id'
		do
			Result := token_id
		end

	provinces: ARRAYED_LIST[STRING]
			-- Access to `provinces_list'
		do
			Result := provinces_list
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
			token_id := a_token.twin
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		local
			l_p_list: detachable STRING
		do
			create l_p_list.make_empty
			--create Result.make_from_string (xml_request_template)
			Result := xml_request_template.twin
			if attached token_id as l_token_id then
				if l_token_id.is_empty then
					Result.replace_substring_all (stag_start + it_xml_token + stag_end,   null)
					Result.replace_substring_all (etag_start + it_xml_token + etag_end,   null)
					Result.replace_substring_all (stag_start + it_xml_id + stag_end,      null)
					Result.replace_substring_all (etag_start + it_xml_id + etag_end,      null)
					Result.replace_substring_all (it_tokenid,                             null)
				else
					Result.replace_substring_all (it_tokenid, l_token_id)
				end

				across
					provinces_list as p
				loop
					l_p_list.append (stag_start + it_xml_province + stag_end)
					l_p_list.append (p.item)
					l_p_list.append (etag_start + it_xml_province + etag_end + lf_s)
				end

				Result.replace_substring_all (it_provinces_list, l_p_list)
			end
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
					and then attached {JSON_ARRAY} j_data.item (json_provinces_list_tag) as j_provinces
				then
					provinces_list.wipe_out
					from j_provinces.array_representation.start
					until j_provinces.array_representation.after
					loop
						if attached {JSON_OBJECT} j_provinces.array_representation.item as j_prov
							and then attached {JSON_STRING} j_prov.item (json_province_tag) as j_p
						then
							provinces_list.extend (create {STRING}.make_from_string (j_p.item))
						end

						j_provinces.array_representation.forth
					end

				end
			end
		end

	to_json: STRING
			-- json representation
		do
			create Result.make_empty

			Result.append (left_brace)
			Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + municipality_list_request_id.out + right_brace)
			Result.append (comma + double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
			Result.append (double_quotes + json_provinces_list_tag + double_quotes + colon + space + left_bracket)

			from provinces_list.start
			until provinces_list.after
			loop
				Result.append (left_brace + double_quotes + json_province_tag + double_quotes + colon + double_quotes + provinces_list.item + double_quotes + right_brace)
				if not provinces_list.islast then
					Result.append (comma)
				end
				provinces_list.forth
			end
			Result.append (right_bracket + right_brace + right_brace)
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
			Result := create {MUNICIPALITY_LIST_RESPONSE}.make
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
			Result := anaws_url
		end

	ws_test_url: STRING
			-- Testing web service URL
		do
			Result := anaws_test_url
		end

	soap_action_header:  STRING
			-- SOAP action header
		do
			Result := remws_uri + url_path_separator + anaws_interface + url_path_separator + name
		end

	name: STRING
			-- Request `name' to be passed to remws
		do
			Result := municipality_list_endpoint_name
		end

	xml_request_template: STRING
			-- XML `Current' message request template
		do
--			Result := "[
--		      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--                <s:Body>
--                  <ElencoComuni xmlns="http://tempuri.org/">
--                    <xInput>
--                      <ElencoComuni xmlns="">
--                        <Token>
--                          <Id>$tokenid</Id>
--                        </Token>
--                        <Province>
--                          $provinces_list
--                        </Province>
--                      </ElencoComuni>
--                    </xInput>
--                  </ElencoComuni>
--                </s:Body>
--              </s:Envelope>
--	        ]"
			create Result.make_empty
			Result.append (stag_start + xmlns_s + colon + soap_envelope + space + xmlns + colon + xmlns_s + Eq_s + double_quotes + xmlsoap + double_quotes + stag_end + lf_s)
			  Result.append (double_space + stag_start + xmlns_s + colon + body + stag_end + lf_s)
			    Result.append (double_space + double_space + stag_start + municipality_list_endpoint_name + space +
			                   xmlns + eq_s + double_quotes + remws_uri + url_path_separator + double_quotes + stag_end + lf_s)
			      Result.append (double_space + double_space + double_space + stag_start + xinput + stag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + stag_start + municipality_list_endpoint_name + space + xmlns + Eq_s + double_quotes + double_quotes + stag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_token + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_id + stag_end + it_tokenid +
			                           etag_start + it_xml_id + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_token + etag_end + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + stag_start + it_xml_provinces + stag_end + lf_s)
			            Result.append (double_space + double_space + double_space + double_space + double_space + double_space + it_provinces_list + lf_s)
			          Result.append (double_space + double_space + double_space + double_space + double_space + etag_start + it_xml_provinces + etag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + etag_start + municipality_list_endpoint_name + etag_end + lf_s)
			      Result.append (double_space + double_space + double_space + etag_start + xinput + etag_end + lf_s)
			    Result.append (double_space + double_space + etag_start + municipality_list_endpoint_name + etag_end + lf_s)
			  Result.append (etag_start + xmlns_s + colon + body + etag_end + lf_s)
			Result.append (etag_start + xmlns_s + colon + soap_envelope + etag_end + lf_s)
		end

feature {NONE} -- Implementation

	token_id: detachable STRING
	provinces_list:ARRAYED_LIST[STRING]

invariant
	invariant_clause: True -- Your invariant here

end
