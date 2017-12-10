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

feature -- Status reporting

	json_pretty_out: STRING
			-- JSON pretty out
		local
			printer: detachable JSON_PRETTY_STRING_VISITOR
		do
			create printer.make_custom (to_json, 2, 1)
			Result := printer.output.to_string_8
		end

	xml_pretty_out:  STRING deferred end

feature -- Basic operations

	init_response: detachable RESPONSE_I
			-- Create the associated response message
		deferred
		end

end
