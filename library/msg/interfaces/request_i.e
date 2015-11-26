note
	description: "Summary description for {REQUEST_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_I

inherit
	MSG

feature -- Access

	ws_url:               STRING deferred end
	ws_test_url:          STRING deferred end
	xml_request_template: STRING deferred end
	soap_action_header:   STRING deferred end
	name:                 STRING deferred end

feature -- Status setting

	set_token_id (a_token_id: STRING)
			-- Sets `token'
		deferred
		end

--	set_parameters_number (pn: INTEGER)
--			-- Sets `parameters_number'
--		deferred
--		end

feature -- Basic operations

	init_response: RESPONSE_I
			-- Create the associated response message
		deferred
		end

	generate_http_headers (a_curl: CURL_EXTERNALS): POINTER
			-- Generate http header for the `Current' message
		require
			a_curl_not_void: a_curl /= Void
		do
			create Result
			Result := a_curl.slist_append (Result.default_pointer, "")
			Result := a_curl.slist_append (Result, "content-type: text/xml;charset=utf-8")
			Result := a_curl.slist_append (Result, soap_action_header)
			Result := a_curl.slist_append (Result, "Accept-Encoding: gzip, deflate")
		end

end
