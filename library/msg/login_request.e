note
	description : "Summary description for {LOGIN_REQUEST}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

--| ----------------------------------------------------------------------------
--| This is the message structure for the login message, for the time being only
--| json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for exemple:
--|
--| {
--|   "header": {
--|     "message_id":        <login_msg_id>
--|     "parameters_number": <login_msg_parnum>
--|   },
--|   "data": {
--|     "user": "a_username",
--|     "pwd":  "a_pwd"
--|   }
--| }
--|
--| The user password is not encrypted, but it could be in the future.
--| ----------------------------------------------------------------------------

class
	LOGIN_REQUEST

inherit
	REQUEST_I

create
	make,
	make_from_json_string

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create usr.make_empty
			create pwd.make_empty
		end

	make_from_json_string (json: STRING; parser: JSON_PARSER)
			-- Initialization of `Current' from a json string
		require
			json_not_void: json /= Void
		do
			create usr.make_empty
			create pwd.make_empty

			from_json (json, parser)
		end

feature -- Access

	id: INTEGER do Result := login_request_id end

	username: STRING
			-- Access to `usr'
		do
			Result := usr
		end

	password: STRING
			-- Access to `pwd'
		do
			Result := pwd
		end

feature -- Status setting

	set_token_id (a_token: STRING)
			-- dummy setter
		do
		end

	set_logger (a_logger: LOG_LOGGING_FACILITY)
			-- Set the logger
		require
			logger_not_void: a_logger /= Void
		do
			logger := a_logger
		ensure
			logger_not_void: logger /= Void
		end

	set_username (a_username: STRING)
			-- Set `usr'
		do
			usr := a_username
		end

	set_password (a_password: STRING)
			-- Set `pwd'
		do
			pwd := a_password
		end

feature -- Conversion

	to_xml: STRING
			-- XML representation
		require else
			usr_not_empty: not username.is_empty
			pwd_not_empty: not password.is_empty
		do
			--create Result.make_from_string (xml_request_template)
			Result := xml_request_template.twin
			Result.replace_substring_all (it_username, usr)
			Result.replace_substring_all (it_password, pwd)
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
					and then attached {JSON_STRING} j_data.item (json_username_tag) as j_usr
					and then attached {JSON_STRING} j_data.item (json_password_tag) as j_pwd
				then
					usr := j_usr.item
					pwd := j_pwd.item
				end
			end
		end

	to_json: STRING
			-- json representation
		do
			create Result.make_empty
			Result.append (left_brace)
			Result.append (double_quotes + json_header_tag + double_quotes + colon + left_brace)
			Result.append (double_quotes + json_id_tag + double_quotes + colon + space + login_request_id.out)
			Result.append (right_brace + comma)
			Result.append (double_quotes + json_data_tag + double_quotes + colon + left_brace)
			Result.append (double_quotes + json_username_tag + double_quotes + colon + space + double_quotes + usr + double_quotes)
			Result.append (comma + double_quotes + json_password_tag + double_quotes + colon + space + double_quotes + pwd + double_quotes)
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
			Result := create {LOGIN_RESPONSE}.make
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

feature {NONE} -- Object implementation

	usr: STRING
	pwd: STRING

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
			Result := login_endpoint_name
		end

	xml_request_template: STRING
			-- XML `Current' message request template
		do
--			Result := "[
--		  		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--          		  <s:Body>
--            	  	<Login xmlns="http://tempuri.org/">
--              	      <xElInput>
--                	    <Login xmlns="">
--                  		  <Login>$usr</Login>
--                  		  <Password>$pwd</Password>
--                        </Login>
--                      </xElInput>
--                    </Login>
--                  </s:Body>
--                </s:Envelope>
--	        ]"

			create Result.make_empty
			Result.append (stag_start + xmlns_s + colon + soap_envelope + space + xmlns + colon + xmlns_s + eq_s + double_quotes + xmlsoap + double_quotes + stag_end + lf_s)
			  Result.append (double_space + stag_start + xmlns_s + colon + body + stag_end + lf_s)
			    Result.append (double_space + double_space + stag_start + login_endpoint_name + space + xmlns + eq_s + double_quotes + remws_uri + url_path_separator + double_quotes + stag_end + lf_s)
			      Result.append (double_space + double_space + double_space + stag_start + xelinput + stag_end + lf_s)
			        Result.append (double_space + double_space + double_space + double_space + stag_start + login_endpoint_name + space + xmlns + eq_s + double_quotes + double_quotes + stag_end + lf_s)
		              Result.append (double_space + double_space + double_space + double_space + double_space +
		                             stag_start + login_endpoint_name + stag_end + it_username + etag_start + login_endpoint_name + etag_end + lf_s)
		              Result.append (double_space + double_space + double_space + double_space + double_space +
		                             stag_start + it_xml_password + stag_end + it_password + etag_start + it_xml_password + etag_end + lf_s)
		            Result.append (double_space + double_space + double_space + double_space + etag_start + login_endpoint_name + etag_end + lf_s)
			      Result.append (double_space + double_space + double_space + etag_start + xelinput + etag_end + lf_s)
			    Result.append (double_space + double_space + etag_start + login_endpoint_name + etag_end + lf_s)
			  Result.append (double_space + etag_start + xmlns_s + colon + body + etag_end + lf_s)
			Result.append (etag_start + xmlns_s + colon + soap_envelope + etag_end + lf_s)
		end

invariant
	invariant_clause: True -- Your invariant here

end
