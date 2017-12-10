note
	description : "unlog application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	UNLOG_REMWS_APPLICATION

inherit
	ERROR_CODES
	UNLOG_REMWS_CONSTANTS
	ARGUMENTS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line
		end
	SYSLOG_UNIX_OS
		export
			{UNLOG_REMWS_APPLICATION} all
		redefine
			dispose
		end
	EXCEPTIONS
	UNIX_SIGNALS
		rename
			meaning as sig_meaning,
			catch   as sig_catch,
			ignore  as sig_ignore
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			idx: INTEGER
		do
			-- syslog
			open_log (program_name, log_pid, log_user)

			idx := index_of_word_option ("t")
			if idx > 0 then
				use_remwstest := true
			end

			last_token := read_last_token

			create logout_request.make
			create session.make ("")
			create xml_parser_factory
			if attached xml_parser_factory as l_factory then
				xml_parser := l_factory.new_standard_parser
			else
				sys_log (log_emerg, "UNLOGREMWS: unable to create xml parser")
				die (1)
			end

			if do_logout then
				sys_log (log_notice, "UNLOGREMWS: successfully logged out from remws")
			else
				sys_log (log_notice, "UNLOGREMWS: unable to log out from remws")
			end
		end

feature -- Operations

	read_last_token: like last_token
			-- Read `last_token' from `last_token_file'
		do
			if attached last_token_file_path as l_path then
				create last_token_file.make_open_read (l_path)
				if attached last_token_file as l_file then
					l_file.read_line
					Result := l_file.laststring
					l_file.close
				else
					sys_log (log_emerg, "UNLOGREMWS: " + l_path + " doesn't exist")
				end
			else
				sys_log (log_emerg, "UNLOGREMWS: unable to read last token file")
			end
		end

	post(a_request: detachable REQUEST_I) : detachable STRING
			-- Post `a_request' to remws using `LIBCURL_HTTP_CLIENT'
		local
			l_context: detachable HTTP_CLIENT_REQUEST_CONTEXT
			l_res: HTTP_CLIENT_RESPONSE
		do
			Result := ""
			if attached a_request as l_request then

				session.headers.wipe_out
				session.add_header ("content-type", "text/xml;charset=utf-8")
				session.add_header ("SOAPAction", l_request.soap_action_header)
				session.add_header ("Accept-Encoding", "gzip, deflate")
				if use_remwstest then
					l_res := session.post (l_request.ws_test_url, l_context, l_request.to_xml)
					io.put_string (l_request.to_xml)
					io.put_new_line
				else
					l_res := session.post (l_request.ws_url, l_context, l_request.to_xml)
				end

				if attached l_res.body as r then
					Result := r
					io.put_string (Result)
					io.put_new_line
				end
			else
				sys_log (log_emerg, "UNLOGREMWS.post: trying to post a Void request")
			end
		end

	do_logout: BOOLEAN
			-- Execute logout
		local
			l_xml_str: detachable STRING
		do
			if attached last_token as l_token then

				if attached logout_request as l_request then
					l_request.set_token_id (l_token)
				else
					sys_log (log_emerg, "UNLOGREMWS: logout request not attached")
				end

				l_xml_str := post (logout_request)

				if attached l_xml_str as l_xml then
					logout_response := create {LOGOUT_RESPONSE}.make
					if attached logout_response as l_response then
						l_response.from_xml (l_xml, xml_parser)
						Result := l_response.outcome = success
					else
						sys_log (log_emerg, "UNLOGREMWS: logout response not attached")
					end
				else
					sys_log (log_emerg, "UNLOGREMWS: Void response from server")
				end
			else
				Result := false
			end
		end

feature -- Dispose

	dispose
			-- Call `Precursor'
		do
			Precursor {SYSLOG_UNIX_OS}
		end

feature {NONE} -- Signals

	catch_signals
			-- Catch UNIX signals
		do
			sig_catch (sighup)
			sig_catch (sigint)
			sig_catch (sigsegv)
			sig_catch (sigkill)
			sig_catch (sigterm)
		end

	handle_signals
			-- Handle UNIX signals
		do
			if is_signal then
				if is_caught (sighup) then
--					sys_log (priority, a_string)
--					log_display ("SIGHUP "  + sighup.out  + " caught", log_emergency, true, true, true)
				elseif is_caught (sigint) then
--					log_display ("SIGINT "  + sigint.out  + " caught", log_emergency, true, true, true)
				elseif is_caught (sigsegv) then
--					log_display ("SIGSEGV " + sigsegv.out + " caught", log_emergency, true, true, true)
--					log_display ("Dying ...", log_emergency, true, true, true)
--					if do_logout then
--						log_display ("Logged out", log_emergency, true, true, true)
--					else
--						log_display ("Unable to log out", log_emergency, true, true, true)
--					end
					die(sigsegv)
				elseif is_caught (sigkill) then
--					log_display ("SIGKILL " + sigkill.out + " caught", log_emergency, true, true, true)
--					log_display ("Killing myself", log_emergency, true, true, true)
--					if do_logout then
--						log_display ("Logged out", log_emergency, true, true, true)
--					else
--						log_display ("Unable to log out", log_emergency, true, true, true)
--					end
					die (sigkill)
				elseif is_caught (sigterm) then
--					log_display ("SIGTERM " + sigterm.out + " caught", log_emergency, true, true, true)
				else
--					log_display ("UNKNOWN signal caught", log_emergency, true, true, true)
				end
			end
		end

feature {NONE} -- Implementation

	use_remwstest: BOOLEAN
			-- Use remwstest WS

	last_token_file_path: detachable STRING
			-- last token file name full path
		do
			create Result.make_empty
			if attached home_directory_path as l_home then
				Result := l_home.out + "/.collect/last_token"
			end
		end

	last_token_file: detachable PLAIN_TEXT_FILE
			-- Text file containing the last remws token
	last_token: detachable READABLE_STRING_8
			-- Last remws token

	session: LIBCURL_HTTP_CLIENT_SESSION
			-- HTTP session
	logout_request: detachable LOGOUT_REQUEST
			-- The logout request
	logout_response: detachable LOGOUT_RESPONSE
			-- The logout response

	xml_parser_factory: detachable XML_PARSER_FACTORY
			-- Global xml parser factory
	xml_parser:         XML_STANDARD_PARSER
			-- Global xml parser
end
