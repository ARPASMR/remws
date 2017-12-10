note
	description : "msg_tester application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	MSG_TESTER

inherit
	DEFAULTS
	MSG_CONSTANTS
	FUNCTION_CODES
	APPLIED_OPERATOR_CODES
	TIME_GRANULARITY_CODES
	MSG_TESTER_CONSTANTS
	ERROR_CODES
	EXCEPTIONS
	ARGUMENTS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line
		end
	FILE_UTILITIES

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			init

			parse_cmd_line_arguments

			run
		end

feature {NONE} -- Initialization

	init
			-- Main objects initialization routine
		do
			create session.make ("")
			session.add_header ("content-type", "text/json;charset=utf-8")
			session.add_header ("Accept-Encoding", "gzip, deflate")

			-- Parsing
			create xml_parser_factory
			xml_parser := xml_parser_factory.new_standard_parser
			create json_parser.make_with_string ("{}")

			start_time := create {DATE_TIME}.make_now

			create error_message.make_empty

			init_preferences
		end

feature -- Usage

	usage
			-- Little help on usage.
		do
			print ("remws gateway message tester%N")
			print ("Agenzia Regionale per la Protezione Ambientale della Lombardia%N")
			print ("Autore: Luca Paganotti <luca.paganotti@gmail.com>%N")
			print ("        Released under GPLv2%N")
			print ("msg_tester [-h][-H <host>][-p <host-port>][-c <cycles>][-m <message id>]%N%N")
			print ("%T-h                  prints this help and exits%N")
			print ("%T-H <host>           host running collect%N")
			print ("%T                      default: localhost%N")
			print ("%T-p <host-port>      the port collect il listening on%N")
			print ("%T                      default: 9090%N")
			print ("%T<message id>        is the message identifier to test%N")
			print ("%T                      default: all messages%N%N")
			print ("%TThe available message identifiers are:%N")
			print ("%T  station status list request: message identifier -->  3 (*)%N")
			print ("%T  station types list request:  message identifier -->  4 (*)%N")
			print ("%T  province list request:       message identifier -->  5 (*)%N")
			print ("%T  municipality list request:   message identifier -->  6 (*)%N")
			print ("%T  station list request:        message identifier -->  7 (*)%N")
			print ("%T  sensor types list request:   message identifier -->  8 (*)%N")
			print ("%T  sensor list request:         message identifier -->  9 (*)%N")
			print ("%T  realtime data request:       message identifier --> 10 (*)%N")
			print ("%T  query token request:         message identifier --> 11 (*)%N")
			print ("%T  standard data request:       message identifier --> 12 (*)%N%N")
			print ("REMARKS:%N")
			print ("%TIn case of correct message with message id <ID> the response message id%N")
			print ("%Tmust be equal to 1000 + <ID>%N%N")
			print ("%TPreference file in $HOME/.msg_tester/msg_tester.preferences.xml if home exists%N")
			print ("%Totherwise search for ./.msg_tester in the current folder.%N")
			print ("%T(*) --> implemented%N")
		end

feature -- Arguments parsing

	parse_cmd_line_arguments
			-- Parses command line arguments
		local
			idx: INTEGER
		do
			idx := index_of_word_option ("h")
			if idx > 0 then
				usage
				die (0)
			end

			idx := index_of_word_option ("H")
			if idx > 0 then
				host.set_value (argument (idx + 1))
			else
				host.set_value ("localhost")
			end

			idx := index_of_word_option ("p")
			if idx > 0 then
				port.set_value (argument (idx + 1).to_integer)
			else
				port.set_value (default_port)
			end

			idx := index_of_word_option ("c")
			if idx > 0 then
				cycles := argument (idx + 1).to_integer
			else
				cycles := default_cycles
			end

			idx := index_of_word_option ("m")
			if idx > 0 then
				msg_id := argument (idx + 1).to_integer
			else
				msg_id := all_messages
			end
		end

feature {NONE} -- Preferences
	init_preferences
			-- Init `PREFERENCES' object
		local
			factory:  detachable BASIC_PREFERENCE_FACTORY
			location: STRING
		do
			display_line ("{MSG_TESTER} Init preferences ...", true)
			if home_folder /= Void then
				location := home_folder + "/.msg_tester/"
			else
				location := "./.msg_tester/"
			end
			create preferences_storage.make_with_location (location + "msg_tester.preferences.xml")

			create preferences.make_with_storage (preferences_storage)
			preferences_manager := preferences.new_manager ("msg_tester")
			create factory

			host := factory.new_string_preference_value (preferences_manager,  "msg_tester.host", "127.0.0.1")
			port := factory.new_integer_preference_value (preferences_manager, "msg_tester.port", 9090)

			display_line ("{MSG_TESTER} host: " + host.value, true)
			display_line ("{MSG_TESTER} port: " + port.value.out, true)
			display_line ("{MSG_TESTER} Done.", true)

			if not directory_exists (location) then
				create_directory (location)
			end

			preferences.save_preferences
		end

feature {NONE} -- Implementation

	msg_id:         INTEGER
			-- Message identifier to test

	cycles:         INTEGER
			-- Request/Response cycles

	start_time:     DATE_TIME
			-- Application start date time

	error_code:     INTEGER
			-- Post error code
	error_message:  STRING
			-- Post error message

	home_folder: STRING_32
			-- Current user home folder
		once
			if attached item("HOME") as l_home then
				create Result.make_from_string (l_home)
			else
				create Result.make_empty
			end
		end

	generate_json_request (id: INTEGER): STRING
			-- Generate a JSON request given the message id
		local
			request:      REQUEST_I
			rt_data:      detachable SENSOR_REALTIME_REQUEST_DATA
			dt_from:      detachable DATE_TIME
			dt_to:        detachable DATE_TIME
			one_week:     detachable DATE_TIME_DURATION
			two_months:   detachable DATE_TIME_DURATION
			three_months: detachable DATE_TIME_DURATION
		do
			create one_week.make (0, 0, -7, 0, 0, 0)
			create two_months.make (0, -2, 0, 0, 0, 0)
			create three_months.make (0, -3, 0, 0, 0, 0)
			create Result.make_empty
			inspect id
			when station_status_list_request_id then
				request := create {STATION_STATUS_LIST_REQUEST}.make
				if attached {STATION_STATUS_LIST_REQUEST} request as req then
					Result := req.to_json
				end
			when station_types_list_request_id then
				request := create {STATION_TYPES_LIST_REQUEST}.make
				if attached {STATION_TYPES_LIST_REQUEST} request as req then
					Result := req.to_json
				end
			when province_list_request_id then
				request := create {PROVINCE_LIST_REQUEST}.make
				if attached {PROVINCE_LIST_REQUEST} request as req then
					Result := req.to_json
				end
			when municipality_list_request_id then
				request := create {MUNICIPALITY_LIST_REQUEST}.make
				if attached {MUNICIPALITY_LIST_REQUEST} request as req then
					req.provinces.extend ("BG")
					Result := req.to_json
				end
			when station_list_request_id then
				request := create {STATION_LIST_REQUEST}.make
				if attached {STATION_LIST_REQUEST} request as req then
					Result := req.to_json
				end
			when sensor_type_list_request_id then
				request := create {SENSOR_TYPE_LIST_REQUEST}.make
				if attached {SENSOR_TYPE_LIST_REQUEST} request as req then
					Result := req.to_json
				end
			when sensor_list_request_id then
				request := create {SENSOR_LIST_REQUEST}.make
				if attached {SENSOR_LIST_REQUEST} request as req then
					req.municipalities.extend (537)
					Result := req.to_json
				end
			when realtime_data_request_id then
				request := create {REALTIME_DATA_REQUEST}.make
				if attached {REALTIME_DATA_REQUEST} request as req then
					create dt_from.make_now
					create dt_to.make_now
					dt_from := dt_from + one_week

					rt_data := create {SENSOR_REALTIME_REQUEST_DATA}.make
					rt_data.set_sensor_id (19347)
					rt_data.set_function_code (acquired_data)
					rt_data.set_time_granularty (ten_minutes)
					rt_data.set_applied_operator (cumulated)
					rt_data.set_start (dt_from)
					rt_data.set_finish (dt_to)
					req.sensors_list.extend (rt_data)

					Result := req.to_json
				end
			when query_token_request_id then
				request := create {QUERY_TOKEN_REQUEST}.make
				if attached {QUERY_TOKEN_REQUEST} request as req then
					Result := req.to_json
				end
			when standard_data_request_id then
				request := create {STANDARD_DATA_REQUEST}.make
				if attached {STANDARD_DATA_REQUEST} request as req then
					create dt_from.make_now
					create dt_to.make_now
					dt_from := dt_from + three_months
					dt_to   := dt_to + two_months

					rt_data := create {SENSOR_REALTIME_REQUEST_DATA}.make
					rt_data.set_sensor_id (19347)
					rt_data.set_function_code (acquired_data)
					rt_data.set_time_granularty (ten_minutes)
					rt_data.set_applied_operator (cumulated)
					rt_data.set_start (dt_from)
					rt_data.set_finish (dt_to)
					req.sensors_list.extend (rt_data)

					Result := req.to_json
				end
			else
				display_line ("UNKNOWN message", true)
				Result := ""
			end
		end

	run
			-- Do post messages
		local
			i:        INTEGER
		do
			from
				i := 0
			until
				i = cycles
			loop
				if msg_id = all_messages then
					post_request (generate_json_request (station_status_list_request_id))
					sleep (200000000)
					post_request (generate_json_request (station_types_list_request_id))
					sleep (200000000)
					post_request (generate_json_request (province_list_request_id))
					sleep (200000000)
					post_request (generate_json_request (municipality_list_request_id))
					sleep (200000000)
					post_request (generate_json_request (station_list_request_id))
					sleep (200000000)
					post_request (generate_json_request (sensor_type_list_request_id))
					sleep (200000000)
					post_request (generate_json_request (sensor_list_request_id))
					sleep (200000000)
					post_request (generate_json_request (realtime_data_request_id))
					sleep (200000000)
					post_request (generate_json_request (query_token_request_id))
					sleep (200000000)
					post_request (generate_json_request (standard_data_request_id))
					sleep (200000000)
				else
					post_request (generate_json_request (msg_id))
					sleep (200000000)
				end

				i := i + 1
			end
		end

feature -- Display

	display_line (a_line: STRING; nl: BOOLEAN)
			-- Display `a_line' on screen with a new line if `nl' is True
		local
			dt: detachable DATE_TIME
		do
			dt := create {DATE_TIME}.make_now_utc
			io.put_string (dt.formatted_out (default_date_time_format) + " " + a_line)
			if nl then
				io.put_new_line
			end
		end

feature {NONE} -- Network IO

	session: LIBCURL_HTTP_CLIENT_SESSION
			-- HTTP session

	post (a_msg: STRING) : STRING
			-- Post `a_msg' to collect using `LIBCURL_HTTP_CLIENT'
		local
			l_context: detachable HTTP_CLIENT_REQUEST_CONTEXT
			l_res:     detachable HTTP_CLIENT_RESPONSE
		do
			json_parser.set_representation (a_msg)
			json_parser.parse_content
			if json_parser.is_valid then
				display_line ("MSG_TESTER Constructed a valid JSON message", true)
				display_line ("Posting it ...", true)

				l_res := session.post ("http://" + host.value + ":" + port.value.out, l_context, a_msg)
			else
				display_line ("MSG_TESTER Constructed a BAD REQUEST", true)
				display_line (json_parser.errors_as_string, true)
				json_parser.reset_reader
				json_parser.reset
			end

			if attached l_res as res then
				if attached res.body as r then
					display_line ("MSG_TESTER HTTP POST OK", true)
					Result := r
				else
					display_line ("MSG_TESTER HTTP POST KO: HTTP response body not attached", true)
					if l_res.error_occurred then
						display_line ("ERROR: ", false)
						if attached l_res.error_message as err_msg then
							display_line (err_msg, true)
						else
							io.put_new_line
						end
					end
					Result := ""
				end
			else
				display_line ("MSG_TESTER HTTP POST KO: HTTP response not attached", true)
				Result := ""
			end
		end

	post_request (request: detachable STRING)
			-- POST json  `request'
		local
			res_str: detachable STRING
		do
			if attached request as r then
				res_str := post (r.to_string_8)
				display_line ("Sent message >>> " + r, true)
				display_line ("Received message <<< " + res_str, true)
			end
		end

feature -- Parsing

	xml_parser_factory: XML_PARSER_FACTORY
			-- Global xml parser factory
	xml_parser:         XML_STANDARD_PARSER
			-- Global xml parser
	json_parser:        JSON_PARSER
			-- Global json parser

feature -- Preferences

	host:         STRING_PREFERENCE
			-- Host to connect IP or name
	port:         INTEGER_PREFERENCE
			-- Host port

	preferences:         PREFERENCES
			-- `PREFERENCES' object
	preferences_manager: PREFERENCE_MANAGER
			-- Preference manager object
	preferences_storage: PREFERENCES_STORAGE_DEFAULT
			-- Preferences storage

end
