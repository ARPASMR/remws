note
	description: "test_http_client application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_HTTP_CLIENT_APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do

		end

feature -- Network I/O

	post (a_request: REQUEST_I): detachable STRING
			-- Post `a_request' to remws
		local
			cl: NET_HTTP_CLIENT
			--cl: DEFAULT_HTTP_CLIENT
			session: HTTP_CLIENT_SESSION
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
		do
			create cl

			session := cl.new_session (a_request.ws_test_url)

			create ctx.make

			a_request.apply_http_headers_to (ctx)
			ctx.set_upload_data (a_request.to_xml)
			if attached session.post ("", ctx, Void) as resp then
				if resp.error_occurred then
					--error_code    := resp.status
					if attached resp.error_message as m then
						--error_message := m
					else
						--error_message := "Request failed!"
					end
				elseif attached resp.body as b then
					Result := b
				else
					check should_not_occur: False end
					--error_code    := {ERROR_CODES}.err_request_failure
					--error_message := {ERROR_CODES}.msg_request_failure
				end
			end
			session.close
		end

feature -- Implementation

end
