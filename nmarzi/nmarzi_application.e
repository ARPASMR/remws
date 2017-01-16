note
	description : "nmarzi application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	NMARZI_APPLICATION

inherit
	DEFAULTS
	ARGUMENTS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			i: INTEGER
		do
			--| Add your code here
			print ("NMARZI%N")

			init
			init_preferences
			init_sensors_list

			if not write_files then
				io.put_string ("{NMARZI} Error writing files")
				io.put_new_line
			end
			if not_found_sensor_list.count > 0 then
				io.put_string ("{NMARZI} " + not_found_sensor_list.count.out + " requests with  no data")
				io.put_new_line
				from i := 1
				until i > not_found_sensor_list.count
				loop
					io.put_string (not_found_sensor_list.i_th (i))
					io.put_new_line
					i := i + 1
				end
			end
		end

feature -- Initialization

	init
			-- general initialization
		do
			create response.make_empty
			create realtime_data_res.make
			create curl_buffer.make_empty

			create one_week.make (0, 0, -7, 0, 0, 0)
			create one_day.make (0, 0, 0, -24, 0, 0)
			create one_hour.make (0, 0, 0, 1, 0, 0)
			create two_hours.make (0, 0, 0, 2, 0, 0)

			create sensors_list.make (0)
			create not_found_sensor_list.make (0)

			-- Parsing
			create json_parser.make_with_string ("{}")
		end

	init_preferences
			-- Init `PREFERENCES' object
		local
			factory: BASIC_PREFERENCE_FACTORY
			--i, n: INTEGER
		do
			io.put_string ("{NMARZI} Init preferences ...")
			io.put_new_line

			create preferences_storage.make_with_location ("/home/buck/.nmarzi/nmarzi.preferences.xml")
			create preferences.make_with_storage (preferences_storage)
			preferences_manager := preferences.new_manager ("nmarzi")
			create factory

			--sensors_list := factory.new_array_preference_value (preferences_manager,   "nmarzi.Sensors", default_sensors_list.to_array)
			sensor_list_file := factory.new_string_preference_value (preferences_manager,  "nmarzi.SensorListFile", "/home/buck/.nmarzi/sensors.csv")
			output_dir       := factory.new_string_preference_value (preferences_manager,  "nmarzi.OutputFolder",   "/home/buck/.nmarzi/out/")
			host             := factory.new_string_preference_value (preferences_manager,  "nmarzi.host",           "localhost")
			port             := factory.new_integer_preference_value (preferences_manager, "nmarzi.port",           9090)

			--n := sensors_list.value_as_list_of_text.count
			--n := sensors_list.count

			io.put_string ("{NMARZI} sensor list file: " + sensor_list_file.value)
			io.put_new_line
			io.put_string ("{NMARZI} output dir: " + output_dir.value)
			io.put_new_line
			io.put_string ("{NMARZI} host: " + host.value)
			io.put_new_line
			io.put_string ("{NMARZI} port: " + port.value.out)
			io.put_new_line
			io.put_string ("{NMARZI} Done.")
			io.put_new_line
			--preferences.save_preferences

		end

	init_sensors_list
			-- Initialize sensors list from file
		local
			l_file:   PLAIN_TEXT_FILE
			l_line:   STRING
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
					l_line   := l_file.last_string.twin
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

feature -- Operations

	post(msg: STRING): STRING
			--
		local
			l_result:   INTEGER
		do
			curl_buffer.wipe_out

			curl.global_init

			if curl_easy.is_dynamic_library_exists then
				curl_handle := curl_easy.init
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,           "http://" + host.value + ":" + port.value.out)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)

				--headers := curl.slist_append (headers.default_pointer, "")
				--headers := curl.slist_append (headers, "content-type: text/xml;charset=utf-8")
				--headers := curl.slist_append (headers, "SOAPAction: http://tempuri.org/IAutenticazione/Login")
				--headers := curl.slist_append (headers, "Accept-Encoding: gzip, deflate")

				--curl_easy.setopt_slist   (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpheader,    headers)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_post,          1)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, msg.count)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_verbose,       0)
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_useragent,     "NMarzi curl testclient")
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields,    msg)

				--curl_easy.set_curl_function (curl_function)
				curl_easy.set_write_function (curl_handle)
				-- We pass our `curl_buffer''s object id to the callback function */
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata,     curl_buffer.object_id)

				l_result := curl_easy.perform (curl_handle)

				if l_result /= {CURL_CODES}.curle_ok then
					io.put_string ("{NMARZI} cURL perfom returned: " + l_result.out)
				end
				--io.put_new_line

				curl_easy.cleanup (curl_handle)
			else
				io.put_string ("{NMARZI} cURL library not found")
				io.put_new_line
			end

			curl.global_cleanup

			Result := curl_buffer.string
		end

	--ask_sensor(sensor: INTEGER; start: DATE_TIME; finish: DATE_TIME; last24: BOOLEAN): ARRAYED_LIST[STRING]
	ask_sensor(sensor: SENSOR_PARAMETERS; start: DATE_TIME; finish: DATE_TIME; last24: BOOLEAN): ARRAYED_LIST[STRING]
			-- Ask `sensor' data
		local
			l_start:  DATE_TIME
			l_finish: DATE_TIME

			fd:       FORMAT_DOUBLE
			r:        STRING
			j,k:      INTEGER
			l_line:   STRING
			l_tokens: LIST[STRING]
		do
			-- Now try a realtime data request for one nmarzi sensor
			io.put_string ("{NMARZI} Asks for realtime data, sensor: " + sensor.id.out)
			io.put_new_line

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

			io.put_string ("{NMARZI} From: " + l_start.formatted_out (default_date_time_format) + " to: " + l_finish.formatted_out (default_date_time_format))
			io.put_new_line

			r.copy (realtime_data_request_nmarzi_template)

--			r.replace_substring_all ("$sensor", sensor.out)
--			r.replace_substring_all ("$function", "1")
--			r.replace_substring_all ("$operator", "1")
--			r.replace_substring_all ("$granularity", "1")
			r.replace_substring_all ("$sensor",      sensor.id.out)
			r.replace_substring_all ("$function",    sensor.function.out)
			r.replace_substring_all ("$operator",    sensor.operator.out)
			r.replace_substring_all ("$granularity", sensor.granularity.out)
			r.replace_substring_all ("$start",  l_start.formatted_out (default_date_time_format))
			r.replace_substring_all ("$finish", l_finish.formatted_out (default_date_time_format))

			--io.put_string ("{NMARZI} >>> " + r)
			--io.put_new_line

			response := post (r)

			--io.put_string ("{NMARZI} <<< " + response)
			--io.put_new_line


			if attached response as res then
				realtime_data_res.sensor_data_list.wipe_out
				realtime_data_res.from_json (res, json_parser)
				io.put_string ("{NMARZI} Found " + realtime_data_res.sensor_data_list.count.out + " sensors list data")
				io.put_new_line
				if realtime_data_res.sensor_data_list.count = 0 then
					io.put_string ("{NMARZI} Sensor " + sensor.id.out + " NOT FOUND!!!")
					io.put_new_line
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

						Result.extend (l_line)
						k := k + 1

--						l_tokens := l_line.split (';')
--						io.put_string (sensor.out + "%T" + l_tokens.i_th (1) + ".000%T" +
--						                fd.formatted (l_tokens.i_th (2).to_double))
--						io.put_new_line

					end
					j := j + 1
				end
			end
		end

	--make_output_filepath(sensor: INTEGER; last24: BOOLEAN): STRING
	make_output_filepath(sensor: SENSOR_PARAMETERS; last24: BOOLEAN): STRING
			-- format output file name
		do
			Result := output_dir.value + sensor.id.out + "_"
			if last24 then
				Result := Result + "24"
			end
			Result := Result + "R.txt"
		end

	--make_file(sensor: INTEGER; data: ARRAYED_LIST[STRING]; last24:BOOLEAN)
	make_file(sensor: SENSOR_PARAMETERS; data: ARRAYED_LIST[STRING]; last24:BOOLEAN)
			-- Make
		local
			filepath: STRING
			file:     PLAIN_TEXT_FILE
			i:        INTEGER
			fd:       FORMAT_DOUBLE
			l_line:   STRING
			l_row:    STRING
			l_tokens: LIST[STRING]
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
			--sensor:     INTEGER
			sensor:     SENSOR_PARAMETERS
			l_filepath: STRING
			l_data:     ARRAYED_LIST[STRING]
			l_start:    DATE_TIME
			l_finish:   DATE_TIME
			fd:         FORMAT_DOUBLE
			--dat_file:   PLAIN_TEXT_FILE
		do
			create fd.make (6, 0)
			create l_finish.make_now
			create l_start.make_now

			--create dat_file.make_create_read_write ("/home/buck/.nmarzi/sensors.csv")

			from i := 1
			--until i > sensors_list.value_as_list_of_text.count
			until i > sensors_list.count
			loop
				--sensor := sensors_list.value_as_list_of_text.i_th (i).to_integer
				sensor := sensors_list.i_th (i)

				--dat_file.put_string (sensor.out + ";1;1;1")
				--dat_file.put_new_line

				io.put_string ("-- Iteration : " + fd.formatted (i) + " ----------------------------------------------------------")
				io.put_new_line
				io.put_string ("--------------------------------------------------------------------------------")
				io.put_new_line
				io.put_string ("{NMARZI} Ask one week data for sensor: " + sensor.id.out)
				io.put_new_line
				l_start := l_finish + one_week
				l_filepath := make_output_filepath (sensor, false)
				l_data     := ask_sensor (sensor, l_start, l_finish, false)
				if l_data.count <= 0 then
					io.put_string ("{NMARZI} NO DATA found for sensor " + sensor.id.out + " from " +
					                l_start.formatted_out (default_date_time_format) + " to " +
					                l_finish.formatted_out (default_date_time_format))
					io.put_new_line
					not_found_sensor_list.extend (sensor.id.out)
				else
					io.put_string ("{NMARZI} " + l_data.count.out + " data found for sensor " + sensor.id.out)
					io.put_new_line
				end
				make_file (sensor, l_data, false)
				io.put_string ("{NMARZI} Write one week file for sensor: " + sensor.id.out + "[" + l_data.count.out + "] to " + l_filepath)
				io.put_new_line

				sleep (100000000)

				l_data.wipe_out

				io.put_string ("{NMARZI} Ask one day data for sensor: " + sensor.id.out)
				io.put_new_line
				l_start := l_finish + one_day
				l_filepath := make_output_filepath (sensor, true)
				l_data     := ask_sensor (sensor, l_start, l_finish, true)
				if l_data.count <= 0 then
					io.put_string ("{NMARZI} NO DATA found for sensor " + sensor.id.out + " from " +
					                l_start.formatted_out (default_date_time_format) + " to " +
					                l_finish.formatted_out (default_date_time_format))
					io.put_new_line
					not_found_sensor_list.extend (sensor.id.out + " 24R")
				else
					io.put_string ("{NMARZI} " + l_data.count.out + " data found for sensor " + sensor.id.out)
					io.put_new_line
				end
				make_file (sensor, l_data, true)
				io.put_string ("{NMARZI} Write one day file for sensor: " + sensor.id.out + "[" + l_data.count.out + "] to " + l_filepath)
				io.put_new_line

				io.put_string ("--------------------------------------------------------------------------------")
				io.put_new_line

				sleep (100000000)

				i := i + 1
			end

			--dat_file.close

			Result := true
		end

feature -- Messages

	realtime_data_res: REALTIME_DATA_RESPONSE

	realtime_data_request_nmarzi_template: STRING = "[
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



feature -- Preferences

	output_dir:   STRING_PREFERENCE
			-- <sensor_id>_R.txt files output directory
	--sensors_list: ARRAY_PREFERENCE
			-- sensors id list
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

	one_week:  DATE_TIME_DURATION
	one_day:   DATE_TIME_DURATION
	one_hour:  DATE_TIME_DURATION
	two_hours: DATE_TIME_DURATION

feature -- Parsing

	json_parser: JSON_PARSER


feature {NONE} -- sensors list

	sensors_list: ARRAYED_LIST[SENSOR_PARAMETERS]
			-- sensors list

	not_found_sensor_list: ARRAYED_LIST[STRING]
		-- sensors with no data

end
