note
	description : "test_collect_json application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	TEST_COLLECT_JSON_APPLICATION

inherit
	ARGUMENTS
	DEFAULTS
	EXECUTION_ENVIRONMENT
	rename
		command_line as env_command_line
	end

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			init
			execute
		end

feature -- Initializaztion

	init
			-- Initialization routine
		do
			port := 9090
			create curl_buffer.make_empty
			create host.make_from_string ("127.0.0.1")
			create response.make_empty
		end

feature -- Operations

	execute
			-- Main application loop
		local
			r: STRING
			qr: QUERY_TOKEN_RESPONSE
			jp: JSON_PARSER
		do
			create qr.make
			create jp.make_with_string ("{}")
			from
			until false
			loop
				r  := post (req)
				if not r.is_empty then
					jp.set_representation (r)
					jp.parse_content
					if jp.is_valid then
						qr.from_json(r, jp)
						io.put_string ("Expiry: " + qr.token.expiry.formatted_out (default_date_time_format) + " Id: " + qr.token.id)
						io.put_new_line
					else
						io.put_new_line
						io.put_string ("ERROR: parsing json: " + r)
						io.put_new_line
					end
				else
					io.put_new_line
					io.put_string ("EMPTY response from collect")
					io.put_new_line
				end
				jp.reset_reader
				jp.reset
				qr.token.id.wipe_out
				sleep (1000)
				--sleep (1000000000)
			end
		end

	post(msg: STRING): STRING
			--
		local
			l_result:   INTEGER
		do
			curl_buffer.wipe_out

			curl.global_init

			if curl_easy.is_dynamic_library_exists then
				curl_handle := curl_easy.init
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,           "http://" + host + ":" + port.out)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)

				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_post,          1)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, msg.count)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_verbose,       0)
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_useragent,     "Test query token curl testclient")
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields,    msg)

				--curl_easy.set_curl_function (curl_function)
				curl_easy.set_write_function (curl_handle)
				-- We pass our `curl_buffer''s object id to the callback function */
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata,     curl_buffer.object_id)

				l_result := curl_easy.perform (curl_handle)

				if l_result /= {CURL_CODES}.curle_ok then
					io.put_string ("{TEST_COLLECT_JSON_APPLICATION} cURL perfom returned: " + l_result.out)
				end
				--io.put_new_line

				curl_easy.cleanup (curl_handle)
			else
				io.put_string ("{TEST_COLLECT_JSON_APPLICATION} cURL library not found")
				io.put_new_line
			end

			curl.global_cleanup

			Result := curl_buffer.string
		end

feature -- Implementation

	response: STRING

	host:         STRING
			-- Host to connect IP or name
	port:         INTEGER
			-- Host port

	curl_easy: CURL_EASY_EXTERNALS
			-- cURL easy externals
		once
			create Result
		end

	curl: CURL_EXTERNALS
			-- cURL externals
		once
			create Result
		end

	curl_handle: POINTER
			-- cURL handle

	curl_buffer: CURL_STRING
			-- response contents

	req: STRING = "[
					{
					  "header": {
					              "id": 11
					            },
					  "data": {}
					}
	]"

end
