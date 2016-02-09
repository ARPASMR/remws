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
		do
			--| Add your code here
			print ("NMARZI%N")

			init
			init_default_sensors_list
			init_preferences
			if not write_files then
				io.put_string ("Error writing files")
				io.put_new_line
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
		end

	init_preferences
			-- Init `PREFERENCES' object
		local
			factory: BASIC_PREFERENCE_FACTORY
			i, n: INTEGER
		do
			io.put_string ("Init preferences ...")
			io.put_new_line

			create preferences_storage.make_with_location ("/home/buck/.nmarzi/nmarzi.preferences.xml")
			create preferences.make_with_storage (preferences_storage)
			preferences_manager := preferences.new_manager ("nmarzi")
			create factory

			sensors_list := factory.new_array_preference_value (preferences_manager,   "nmarzi.Sensors", default_sensors_list.to_array)
			output_dir   := factory.new_string_preference_value (preferences_manager,  "nmarzi.OutputFolder", "~/.nmarzi/out/")
			host         := factory.new_string_preference_value (preferences_manager,  "nmarzi.host", "localhost")
			port         := factory.new_integer_preference_value (preferences_manager, "nmarzi.port", 9090)

			n := sensors_list.value_as_list_of_text.count

			io.put_string (n.out + " sensors")
			io.put_new_line
			io.put_string ("output dir: " + output_dir.value)
			io.put_new_line
			io.put_string ("host: " + host.value)
			io.put_new_line
			io.put_string ("port: " + port.value.out)
			io.put_new_line
			io.put_string ("Done.")
			io.put_new_line
			--preferences.save_preferences

		end

	init_default_sensors_list
			-- Default sensors list
		do
			create default_sensors_list.make (0)

			default_sensors_list.extend ("1")
			default_sensors_list.extend ("2")
			default_sensors_list.extend ("3")
			default_sensors_list.extend ("4")
			default_sensors_list.extend ("5")
			default_sensors_list.extend ("6")
			default_sensors_list.extend ("7")
			default_sensors_list.extend ("8")
			default_sensors_list.extend ("15")
			default_sensors_list.extend ("16")
			default_sensors_list.extend ("17")
			default_sensors_list.extend ("18")
			default_sensors_list.extend ("24")
			default_sensors_list.extend ("63")
			default_sensors_list.extend ("64")
			default_sensors_list.extend ("65")
			default_sensors_list.extend ("66")
			default_sensors_list.extend ("67")
			default_sensors_list.extend ("68")
			default_sensors_list.extend ("69")
			default_sensors_list.extend ("70")
			default_sensors_list.extend ("71")
			default_sensors_list.extend ("72")
			default_sensors_list.extend ("73")
			default_sensors_list.extend ("74")
			default_sensors_list.extend ("81")
			default_sensors_list.extend ("84")
			default_sensors_list.extend ("87")
			default_sensors_list.extend ("92")
			default_sensors_list.extend ("95")
			default_sensors_list.extend ("98")
			default_sensors_list.extend ("101")
			default_sensors_list.extend ("104")
			default_sensors_list.extend ("106")
			default_sensors_list.extend ("109")
			default_sensors_list.extend ("111")
			default_sensors_list.extend ("114")
			default_sensors_list.extend ("117")
			default_sensors_list.extend ("120")
			default_sensors_list.extend ("123")
			default_sensors_list.extend ("139")
			default_sensors_list.extend ("151")
			default_sensors_list.extend ("180")
			default_sensors_list.extend ("203")
			default_sensors_list.extend ("205")
			default_sensors_list.extend ("207")
			default_sensors_list.extend ("1326")
			default_sensors_list.extend ("1368")
			default_sensors_list.extend ("1399")
			default_sensors_list.extend ("1422")
			default_sensors_list.extend ("1434")
			default_sensors_list.extend ("1437")
			default_sensors_list.extend ("1438")
			default_sensors_list.extend ("2096")
			default_sensors_list.extend ("2270")
			default_sensors_list.extend ("2414")
			default_sensors_list.extend ("3002")
			default_sensors_list.extend ("3003")
			default_sensors_list.extend ("3019")
			default_sensors_list.extend ("3032")
			default_sensors_list.extend ("3033")
			default_sensors_list.extend ("3046")
			default_sensors_list.extend ("3049")
			default_sensors_list.extend ("3092")
			default_sensors_list.extend ("3093")
			default_sensors_list.extend ("3106")
			default_sensors_list.extend ("3109")
			default_sensors_list.extend ("3118")
			default_sensors_list.extend ("3119")
			default_sensors_list.extend ("5969")
			default_sensors_list.extend ("6175")
			default_sensors_list.extend ("6992")
			default_sensors_list.extend ("8007")
			default_sensors_list.extend ("8009")
			default_sensors_list.extend ("8014")
			default_sensors_list.extend ("8017")
			default_sensors_list.extend ("8020")
			default_sensors_list.extend ("8024")
			default_sensors_list.extend ("8028")
			default_sensors_list.extend ("8056")
			default_sensors_list.extend ("8082")
			default_sensors_list.extend ("8093")
			default_sensors_list.extend ("8099")
			default_sensors_list.extend ("8101")
			default_sensors_list.extend ("8105")
			default_sensors_list.extend ("8107")
			default_sensors_list.extend ("8110")
			default_sensors_list.extend ("8112")
			default_sensors_list.extend ("8113")
			default_sensors_list.extend ("8114")
			default_sensors_list.extend ("8116")
			default_sensors_list.extend ("8117")
			default_sensors_list.extend ("8118")
			default_sensors_list.extend ("8119")
			default_sensors_list.extend ("8120")
			default_sensors_list.extend ("8121")
			default_sensors_list.extend ("8124")
			default_sensors_list.extend ("8125")
			default_sensors_list.extend ("8128")
			default_sensors_list.extend ("8129")
			default_sensors_list.extend ("8132")
			default_sensors_list.extend ("8141")
			default_sensors_list.extend ("8142")
			default_sensors_list.extend ("8143")
			default_sensors_list.extend ("8144")
			default_sensors_list.extend ("8147")
			default_sensors_list.extend ("8148")
			default_sensors_list.extend ("8153")
			default_sensors_list.extend ("8154")
			default_sensors_list.extend ("8156")
			default_sensors_list.extend ("8158")
			default_sensors_list.extend ("8164")
			default_sensors_list.extend ("8175")
			default_sensors_list.extend ("8177")
			default_sensors_list.extend ("8180")
			default_sensors_list.extend ("8181")
			default_sensors_list.extend ("8186")
			default_sensors_list.extend ("8192")
			default_sensors_list.extend ("8196")
			default_sensors_list.extend ("8203")
			default_sensors_list.extend ("8205")
			default_sensors_list.extend ("8207")
			default_sensors_list.extend ("8210")
			default_sensors_list.extend ("8223")
			default_sensors_list.extend ("8380")
			default_sensors_list.extend ("8381")
			default_sensors_list.extend ("8382")
			default_sensors_list.extend ("8383")
			default_sensors_list.extend ("8384")
			default_sensors_list.extend ("8385")
			default_sensors_list.extend ("8386")
			default_sensors_list.extend ("8389")
			default_sensors_list.extend ("8391")
			default_sensors_list.extend ("8394")
			default_sensors_list.extend ("8481")
			default_sensors_list.extend ("8511")
			default_sensors_list.extend ("8512")
			default_sensors_list.extend ("8513")
			default_sensors_list.extend ("8521")
			default_sensors_list.extend ("8522")
			default_sensors_list.extend ("8545")
			default_sensors_list.extend ("8546")
			default_sensors_list.extend ("8573")
			default_sensors_list.extend ("8574")
			default_sensors_list.extend ("8576")
			default_sensors_list.extend ("8581")
			default_sensors_list.extend ("8593")
			default_sensors_list.extend ("8618")
			default_sensors_list.extend ("8693")
			default_sensors_list.extend ("8701")
			default_sensors_list.extend ("9035")
			default_sensors_list.extend ("9036")
			default_sensors_list.extend ("9037")
			default_sensors_list.extend ("9038")
			default_sensors_list.extend ("9039")
			default_sensors_list.extend ("9040")
			default_sensors_list.extend ("9041")
			default_sensors_list.extend ("9042")
			default_sensors_list.extend ("9043")
			default_sensors_list.extend ("9044")
			default_sensors_list.extend ("9079")
			default_sensors_list.extend ("9081")
			default_sensors_list.extend ("9082")
			default_sensors_list.extend ("9083")
			default_sensors_list.extend ("9084")
			default_sensors_list.extend ("9086")
			default_sensors_list.extend ("9087")
			default_sensors_list.extend ("9842")
			default_sensors_list.extend ("11099")
			default_sensors_list.extend ("11165")
			default_sensors_list.extend ("11988")
			default_sensors_list.extend ("14021")
			default_sensors_list.extend ("14024")
			default_sensors_list.extend ("14129")
			default_sensors_list.extend ("14170")
			default_sensors_list.extend ("14178")
			default_sensors_list.extend ("14205")
			default_sensors_list.extend ("14227")
			default_sensors_list.extend ("14252")
			default_sensors_list.extend ("14279")
			default_sensors_list.extend ("14301")
			default_sensors_list.extend ("14304")
			default_sensors_list.extend ("14307")
			default_sensors_list.extend ("14310")
			default_sensors_list.extend ("14313")
			default_sensors_list.extend ("14364")
			default_sensors_list.extend ("14497")
			default_sensors_list.extend ("14565")
			default_sensors_list.extend ("14624")
			default_sensors_list.extend ("14758")
			default_sensors_list.extend ("14759")
			default_sensors_list.extend ("14760")
			default_sensors_list.extend ("30523")

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

	ask_sensor(sensor: INTEGER; start: DATE_TIME; finish: DATE_TIME; last24: BOOLEAN): ARRAYED_LIST[STRING]
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
			io.put_string ("{NMARZI} Asks for realtime data, sensor: " + sensor.out)
			io.put_new_line

			create Result.make (0)
			create r.make_empty
			create l_finish.make_now
			create l_start.make_now

			create fd.make (6, 1)
			fd.right_justify

			if last24 then
				l_start := l_finish + one_day
			else
				l_start := l_finish + one_week
			end

			io.put_string ("From: " + l_start.formatted_out (default_date_time_format) + " to: " + l_finish.formatted_out (default_date_time_format))
			io.put_new_line

			r.copy (realtime_data_request_nmarzi_template)

			r.replace_substring_all ("$sensor", sensor.out)
			r.replace_substring_all ("$start",  l_start.formatted_out (default_date_time_format))
			r.replace_substring_all ("$finish", l_finish.formatted_out (default_date_time_format))

			--io.put_string ("{NMARZI} >>> " + r)
			--io.put_new_line

			response := post (r)

			--io.put_string ("{NMARZI} <<< " + response)
			--io.put_new_line


			if attached response as res then
				realtime_data_res.sensor_data_list.wipe_out
				realtime_data_res.from_json (res)
				io.put_string ("{NMARZI} Found " + realtime_data_res.sensor_data_list.count.out + " sensors list data")
				io.put_new_line
				if realtime_data_res.sensor_data_list.count = 0 then
					io.put_string ("Sensor " + sensor.out + " NOT FOUND!!!")
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

	make_output_filepath(sensor: INTEGER; last24: BOOLEAN): STRING
			-- format output file name
		do
			Result := output_dir.value + sensor.out + "_"
			if last24 then
				Result := Result + "24"
			end
			Result := Result + "R.txt"
		end

	make_file(sensor: INTEGER; data: ARRAYED_LIST[STRING]; last24:BOOLEAN)
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
			create fd.make (6, 1)
			filepath := make_output_filepath (sensor, last24)
			create file.make_create_read_write (filepath)

			from i := 1
			until i > data.count
			loop
				l_line   := data.i_th (i)
				l_tokens := l_line.split (';')

				l_row    := sensor.out + "%T" + l_tokens.i_th (1) + ".000%T" +
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
			sensor:     INTEGER
			l_filepath: STRING
			l_data:     ARRAYED_LIST[STRING]
			l_start:    DATE_TIME
			l_finish:   DATE_TIME
			fd:         FORMAT_DOUBLE
		do
			create fd.make (6, 0)
			create l_finish.make_now
			create l_start.make_now

			from i := 1
			until i > sensors_list.value_as_list_of_text.count
			loop
				sensor := sensors_list.value_as_list_of_text.i_th (i).to_integer

				io.put_string ("-- Iteration : " + fd.formatted (i) + " ----------------------------------------------------------")
				io.put_new_line
				io.put_string ("--------------------------------------------------------------------------------")
				io.put_new_line
				io.put_string ("Ask one week data for sensor: " + sensor.out)
				io.put_new_line
				l_start := l_finish + one_week
				l_filepath := make_output_filepath (sensor, false)
				l_data     := ask_sensor (sensor, l_start, l_finish, false)
				if l_data.count <= 0 then
					io.put_string ("NO DATA found for sensor " + sensor.out)
					io.put_new_line
				end
				make_file (sensor, l_data, false)
				io.put_string ("Write one week file for sensor: " + sensor.out + " to " + l_filepath)
				io.put_new_line

				l_data.wipe_out

				io.put_string ("Ask one day data for sensor: " + sensor.out)
				io.put_new_line
				l_start := l_finish + one_day
				l_filepath := make_output_filepath (sensor, true)
				l_data     := ask_sensor (sensor, l_start, l_finish, true)
				make_file (sensor, l_data, true)
				io.put_string ("Write one day file for sensor: " + sensor.out + " to " + l_filepath)
				io.put_new_line

				io.put_string ("--------------------------------------------------------------------------------")
				io.put_new_line

				sleep (500000000)

				i := i + 1
			end

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
                              "function_id": 1,
                              "operator_id": 1,
                              "granularity": 1,
                              "start": "$start",
                              "finish": "$finish"
                            } ]
                }
		}
	]"



feature -- Preferences

	output_dir:   STRING_PREFERENCE
			-- <sensor_id>_R.txt files output directory
	sensors_list: ARRAY_PREFERENCE
		-- sensors id list
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

	one_week: DATE_TIME_DURATION
	one_day:  DATE_TIME_DURATION


feature {NONE} -- sensors list

	default_sensors_list: ARRAYED_LIST[STRING]
		-- default sensors list

end
