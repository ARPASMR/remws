note
	description : "[
		nmarzi application root class
	    Acts as a clone of the old nmarzi cygwin client.
    ]"
	copyright: "Copyright (c) 2015-2017, ARPA Lombardia"
	license:   "General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)"
	source: "[
		Luca Paganotti <luca.paganotti (at) gmail.com>
		Via dei Giardini, 9
		21035 Cunardo (VA)
	]"
	date: "$Date: 2017-11-23 14:52:50 +0100 (Thu, 23 Nov 2017) $"
	revision: "$Revision: 48 $"

class
	NMARZI_APPLICATION

inherit
	DEFAULTS
	ARGUMENTS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line
		end
	MEMORY
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
	SYSLOG_UNIX_OS
		redefine
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			i: INTEGER
		do
			sig_ignore (sighup)
			sig_ignore (sigint)
			sig_ignore (sigkill)
			sig_ignore (sigterm)

			init_gc

			-- HTTP session
			create session.make ("")
			session.add_header ("content-type", "text/json;charset=utf-8")
			session.add_header ("Accept-Encoding", "gzip, deflate")

			--| Add your code here
			display_line ("NMARZI", true, false)
			display_line ("NMARZI simulator for Agenzia Regionale per l'Ambiente della Lombardia", true, false)

			init
			init_preferences
			init_sensors_list

			if not write_files then
				display_line ("{NMARZI} Error writing files", true, false)
			end
			if not_found_sensor_list.count > 0 then
				display_line ("{NMARZI} " + not_found_sensor_list.count.out + " requests with  no data", true, false)
				from i := 1
				until i > not_found_sensor_list.count
				loop
					display_line (not_found_sensor_list.i_th (i), true, false)
					i := i + 1
				end
			end

		rescue
			if is_signal then
				if is_caught (sighup) then
					display_line ("SIGHUP "  + sighup.out  + " caught", true, true)
				elseif is_caught (sigint) then
					display_line ("SIGINT "  + sigint.out  + " caught", true, true)
				elseif is_caught (sigkill) then
					display_line ("SIGKILL " + sigkill.out + " caught", true, true)
					display_line ("Killing myself", true, true)
					die (sigkill)
				elseif is_caught (sigterm) then
					display_line ("SIGTERM " + sigterm.out + " caught", true, true)
				else
					display_line ("UNKNOWN signal caught", true, true)
				end
			end
		end

	init
			-- general initialization
		do
			create response.make_empty
			create realtime_data_res.make

			create one_week.make (0, 0, -7, 0, 0, 0)
			create one_day.make (0, 0, 0, -24, 0, 0)
			create one_hour.make (0, 0, 0, 1, 0, 0)
			create two_hours.make (0, 0, 0, 2, 0, 0)

			create sensors_list.make (0)
			create not_found_sensor_list.make (0)

			-- Parsing
			create json_parser.make_with_string ("{}")

			-- syslog
			open_log (app_name, log_pid, log_user)
		end

	init_gc
			-- GC settings
		do
			-- garbage collection
			allocate_compact
			set_memory_threshold (40000000)
			set_max_mem (160000000)
			set_collection_period (1)
			set_coalesce_period (2)
			collection_on
		end

	init_preferences
			-- Init `PREFERENCES' object
		local
			factory: detachable BASIC_PREFERENCE_FACTORY
		do
			display_line ("{NMARZI} Init preferences ...", true, false)

			create preferences_storage.make_with_location ("/home/buck/.nmarzi/nmarzi.preferences.xml")
			create preferences.make_with_storage (preferences_storage)
			preferences_manager := preferences.new_manager ("nmarzi")
			create factory

			sensor_list_file := factory.new_string_preference_value (preferences_manager,  "nmarzi.SensorListFile", "/home/meteo/.nmarzi/sensors.csv")
			output_dir       := factory.new_string_preference_value (preferences_manager,  "nmarzi.OutputFolder",   "/home/meteo/.nmarzi/out/")
			host             := factory.new_string_preference_value (preferences_manager,  "nmarzi.host",           "localhost")
			port             := factory.new_integer_preference_value (preferences_manager, "nmarzi.port",           9090)

			display_line ("{NMARZI} sensor list file: " + sensor_list_file.value, true, false)
			display_line ("{NMARZI} output dir: " + output_dir.value, true, false)
			display_line ("{NMARZI} host: " + host.value, true, false)
			display_line ("{NMARZI} port: " + port.value.out, true, false)
			display_line ("{NMARZI} Done.", true, false)
			--preferences.save_preferences

		end

	init_sensors_list
			-- Initialize sensors list from file
		local
			l_file:   detachable PLAIN_TEXT_FILE
			l_line:   detachable STRING
			l_sensor: SENSOR_PARAMETERS
			l_tokens: LIST[STRING]
			i,f,o,g:  INTEGER
		do
			create l_file.make_with_name (sensor_list_file.value)
			l_file.open_read_write

			from l_file.start
			until l_file.end_of_file
			loop
				l_file.readline
				if not l_file.last_string.is_empty then
					l_line := l_file.last_string.twin
					if not l_line.starts_with ("#") then
						l_tokens := l_line.split (';')
						i        := l_tokens.i_th (1).to_integer
						f        := l_tokens.i_th (2).to_integer
						o        := l_tokens.i_th (3).to_integer
						g        := l_tokens.i_th (4).to_integer

					    create l_sensor.make_with_parameters (i, f, o, g)
					    sensors_list.extend (l_sensor)
					end
				end
			end

			l_file.close
		end

feature -- Display

	display_line (a_line: STRING; nl, to_syslog: BOOLEAN)
			-- Display `a_line' on screen with a new line if `nl' is True
		local
			dt: detachable DATE_TIME
		do
			dt := create {DATE_TIME}.make_now_utc
			io.put_string (dt.formatted_out (default_date_time_format) + " " + a_line)
			if nl then
				io.put_new_line
			end
			if to_syslog then
				sys_log (log_notice, a_line)
			end
		end

feature -- Operations

	post (a_msg: STRING) : STRING
			-- Post `a_msg' to remws using `LIBCURL_HTTP_CLIENT'
		local
			l_context: detachable HTTP_CLIENT_REQUEST_CONTEXT
			l_res: detachable HTTP_CLIENT_RESPONSE
		do
			json_parser.set_representation (a_msg)
			json_parser.parse_content
			if json_parser.is_valid then
				display_line ("NMARZI Constructed a valid JSON message", true, false)
				display_line ("Posting it ...", true, false)
				l_res := session.post ("http://" + host.value + ":" + port.value.out, l_context, a_msg)
			else
				display_line ("NMARZI Constructed a BAD REQUEST", true, false)
				display_line (json_parser.errors_as_string, true, false)
				reset_json_parser
			end

			if attached l_res as res then
				if attached res.body as r then
					display_line ("NMARZI HTTP POST OK", true, false)
					Result := r
				else
					display_line ("NMARZI HTTP POST KO: HTTP response body not attached", true, false)
					Result := ""
				end
			else
				display_line ("NMARZI HTTP POST KO: HTTP response not attached", true, false)
				Result := ""
			end
		end

	ask_sensor(sensor: SENSOR_PARAMETERS; start: DATE_TIME; finish: DATE_TIME; last24: BOOLEAN): ARRAYED_LIST[STRING]
			-- Ask `sensor' data
		local
			l_start:  detachable DATE_TIME
			l_finish: detachable DATE_TIME

			fd:       detachable FORMAT_DOUBLE
			r:        detachable STRING
			j,k:      INTEGER
			l_line:   detachable STRING
		do
			-- Now try a realtime data request for one nmarzi sensor
			display_line ("{NMARZI} Asks for realtime data, sensor: " + sensor.id.out, true, false)

			create Result.make (0)
			create r.make_empty
			create l_finish.make_now
			create l_start.make_now

			l_finish.add (one_hour)

			create fd.make (6, 1)
			fd.right_justify

			if last24 then
				l_start := l_finish + one_day
			else
				l_start := l_finish + one_week
			end

			display_line ("{NMARZI} From: " + l_start.formatted_out (default_date_time_format) + " to: " + l_finish.formatted_out (default_date_time_format), true, false)

			--r.copy (realtime_data_request_nmarzi_template)
			r := realtime_data_request_nmarzi_template

			r.replace_substring_all ("$sensor",      sensor.id.out)
			r.replace_substring_all ("$function",    sensor.function.out)
			r.replace_substring_all ("$operator",    sensor.operator.out)
			r.replace_substring_all ("$granularity", sensor.granularity.out)
			r.replace_substring_all ("$start",       l_start.formatted_out (default_date_time_format))
			r.replace_substring_all ("$finish",      l_finish.formatted_out (default_date_time_format))

			display_line (">>> " + r, true, false)

			response := post (r)

			display_line ("<<< " + response, true, false)

			if attached response as res then
				realtime_data_res.sensor_data_list.wipe_out
				realtime_data_res.from_json (res, json_parser)
				display_line ("{NMARZI} Found " + realtime_data_res.sensor_data_list.count.out + " sensors list data", true, false)
				if realtime_data_res.sensor_data_list.count = 0 then
					display_line ("{NMARZI} Sensor " + sensor.id.out + " NOT FOUND!!!", true, false)
				end
				from j := 1
				until j = realtime_data_res.sensor_data_list.count + 1
				loop
					io.put_string (realtime_data_res.sensor_data_list.i_th (j).out)
					io.put_new_line
					from k := 1
					until k = realtime_data_res.sensor_data_list.i_th (j).data.count + 1
					loop
						l_line := realtime_data_res.sensor_data_list.i_th (j).data.i_th (k).out
						if l_line.count > 0 then
							Result.extend (l_line)
						end
						k := k + 1
					end
					j := j + 1
				end
			end
		end

	make_output_filepath(sensor: SENSOR_PARAMETERS; last24: BOOLEAN): STRING
			-- format output file name
		do
			Result := output_dir.value + sensor.id.out + "_"
			if last24 then
				Result := Result + "24"
			end
			Result := Result + "R.txt"
		end

	make_file(sensor: SENSOR_PARAMETERS; data: ARRAYED_LIST[STRING]; last24:BOOLEAN)
			-- Make
		local
			filepath: detachable STRING
			file:     detachable PLAIN_TEXT_FILE
			i:        INTEGER
			fd:       detachable FORMAT_DOUBLE
			l_line:   detachable STRING
			l_row:    detachable STRING
			l_tokens: detachable LIST[STRING]
		do
			create fd.make (6, 2)
			filepath := make_output_filepath (sensor, last24)
			create file.make_create_read_write (filepath)

			from i := 1
			until i > data.count
			loop
				l_line   := data.i_th (i)
				l_tokens := l_line.split (';')

				l_row    := sensor.id.out + "%T" + l_tokens.i_th (1) + ".000%T" +
						    fd.formatted (l_tokens.i_th (2).to_double)
				file.put_string (l_row)
				file.put_new_line
				i := i + 1
			end

			file.close

		end

	write_files: BOOLEAN
			-- Write output text files
		local
			i:          INTEGER
			sensor:     SENSOR_PARAMETERS
			l_filepath: detachable STRING
			l_data:     detachable ARRAYED_LIST[STRING]
			l_start:    detachable DATE_TIME
			l_finish:   detachable DATE_TIME
			fd:         detachable FORMAT_DOUBLE
		do
			create fd.make (6, 0)
			create l_finish.make_now
			create l_start.make_now

			from i := 1
			until i > sensors_list.count
			loop
				sensor := sensors_list.i_th (i)

				display_line ("-- Iteration : " + fd.formatted (i) + " ----------------------------------------------------------", true, false)
				display_line ("--------------------------------------------------------------------------------", true, false)
				display_line ("{NMARZI} Ask one week data for sensor: " + sensor.id.out, true, false)
				l_start := l_finish + one_week
				l_filepath := make_output_filepath (sensor, false)
				l_data     := ask_sensor (sensor, l_start, l_finish, false)
				if l_data.count <= 0 then
					display_line ("{NMARZI} NO DATA found for sensor " + sensor.id.out + " from " +
					              l_start.formatted_out (default_date_time_format) + " to " +
					              l_finish.formatted_out (default_date_time_format), true, false)
					not_found_sensor_list.extend (sensor.id.out)
				else
					display_line ("{NMARZI} " + l_data.count.out + " data found for sensor " + sensor.id.out, true, false)
				end
				make_file (sensor, l_data, false)
				display_line ("{NMARZI} Write one week file for sensor: " + sensor.id.out + "[" + l_data.count.out + "] to " + l_filepath, true, false)

				sleep (100)

				l_data.wipe_out

				display_line ("{NMARZI} Ask one day data for sensor: " + sensor.id.out, true, false)
				l_start := l_finish + one_day
				l_filepath := make_output_filepath (sensor, true)
				l_data     := ask_sensor (sensor, l_start, l_finish, true)
				if l_data.count <= 0 then
					display_line ("{NMARZI} NO DATA found for sensor " + sensor.id.out + " from " +
					              l_start.formatted_out (default_date_time_format) + " to " +
					              l_finish.formatted_out (default_date_time_format), true, false)
					not_found_sensor_list.extend (sensor.id.out + " 24R")
				else
					display_line ("{NMARZI} " + l_data.count.out + " data found for sensor " + sensor.id.out, true, false)
				end
				make_file (sensor, l_data, true)
				display_line ("{NMARZI} Write one day file for sensor: " + sensor.id.out + "[" + l_data.count.out + "] to " + l_filepath, true, false)
				display_line ("--------------------------------------------------------------------------------", true, false)

				sleep (100)

				i := i + 1
			end

			Result := true
		end

	reset_json_parser
			-- Reset JSON parser
		do
			json_parser.reset_reader
			json_parser.reset
		end

feature -- dispose

	dispose
			-- `dispose' redefinition
		do
			Precursor {SYSLOG_UNIX_OS}
			Precursor {MEMORY}
		end

feature -- Messages

	realtime_data_res: REALTIME_DATA_RESPONSE

	realtime_data_request_nmarzi_template: STRING
			-- nmarzi request
		do
			Result := "[
		                 {
                           "header": {
                             "id": 10
                           },
                           "data": {
                             "sensors_list": [ {
                               "sensor_id": $sensor,
                               "function_id": $function,
                               "operator_id": $operator,
                               "granularity": $granularity,
                               "start": "$start",
                               "finish": "$finish"
                             } ]
                           }
		                 }
	                   ]"
		end

feature -- Preferences

	output_dir:   STRING_PREFERENCE
			-- <sensor_id>_R.txt files output directory
	sensor_list_file: STRING_PREFERENCE
			-- sensors list file
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

feature -- Implementation

	response: STRING

	one_week:  DATE_TIME_DURATION
	one_day:   DATE_TIME_DURATION
	one_hour:  DATE_TIME_DURATION
	two_hours: DATE_TIME_DURATION

	session: LIBCURL_HTTP_CLIENT_SESSION

	app_name: STRING
			-- `Current' application name
		do
			Result := "nmarzi"
		end

feature -- Parsing

	json_parser: JSON_PARSER


feature {NONE} -- sensors list

	sensors_list: ARRAYED_LIST[SENSOR_PARAMETERS]
			-- sensors list

	not_found_sensor_list: ARRAYED_LIST[STRING]
		-- sensors with no data

end
