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
	MEMORY
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
			print ("NMARZI%N")
			print ("NMARZI simulator for Agenzia Regionale per l'Ambiente della Lombardia%N")

			init
			init_preferences
			init_sensors_list
			init_default_sensors_list

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

		rescue
			if is_signal then
				if is_caught (sighup) then
					print ("SIGHUP "  + sighup.out  + " caught%N")
				elseif is_caught (sigint) then
					print ("SIGINT "  + sigint.out  + " caught%N")
				elseif is_caught (sigkill) then
					print ("SIGKILL " + sigkill.out + " caught%N")
					print ("Killing myself%N")
					die (sigkill)
				elseif is_caught (sigterm) then
					print ("SIGTERM " + sigterm.out + " caught%N")
				else
					print ("UNKNOWN signal caught%N")
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
			io.put_string ("{NMARZI} Init preferences ...")
			io.put_new_line

			create preferences_storage.make_with_location ("/home/meteo/.nmarzi/nmarzi.preferences.xml")
			create preferences.make_with_storage (preferences_storage)
			preferences_manager := preferences.new_manager ("nmarzi")
			create factory

			sensor_list_file := factory.new_string_preference_value (preferences_manager,  "nmarzi.SensorListFile", "/home/meteo/.nmarzi/sensors.csv")
			output_dir       := factory.new_string_preference_value (preferences_manager,  "nmarzi.OutputFolder",   "/home/meteo/.nmarzi/out/")
			host             := factory.new_string_preference_value (preferences_manager,  "nmarzi.host",           "localhost")
			port             := factory.new_integer_preference_value (preferences_manager, "nmarzi.port",           9090)

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

	init_default_sensors_list
			-- Default sensors list
		local
			s: SENSOR_PARAMETERS
		do
			create default_sensors_list.make (0)

			create s.make_with_parameters (1, 1, 1, 1);     default_sensors_list.extend (s)
			--default_sensors_list.extend ("2")
			create s.make_with_parameters (3, 1, 1, 1);     default_sensors_list.extend (s)
			--default_sensors_list.extend ("4")
			--default_sensors_list.extend ("5")
			create s.make_with_parameters (6, 1, 1, 1);     default_sensors_list.extend (s)
			create s.make_with_parameters (7, 1, 1, 1);     default_sensors_list.extend (s)
			--default_sensors_list.extend ("8")
			create s.make_with_parameters (15, 1, 1, 1);    default_sensors_list.extend (s)
			create s.make_with_parameters (16, 1, 1, 1);    default_sensors_list.extend (s)
			create s.make_with_parameters (17, 1, 1, 1);    default_sensors_list.extend (s)
			create s.make_with_parameters (18, 1, 1, 1);    default_sensors_list.extend (s)
			--default_sensors_list.extend ("24")
			--default_sensors_list.extend ("63")
			create s.make_with_parameters (64, 1, 1, 1);    default_sensors_list.extend (s)
			--default_sensors_list.extend ("65")
			create s.make_with_parameters (66, 1, 1, 1);    default_sensors_list.extend (s)
			create s.make_with_parameters (67, 1, 1, 1);    default_sensors_list.extend (s)
			create s.make_with_parameters (68, 1, 1, 1);    default_sensors_list.extend (s)
			--default_sensors_list.extend ("69")
			create s.make_with_parameters (70, 1, 1, 1);    default_sensors_list.extend (s)
			--default_sensors_list.extend ("71")
			--default_sensors_list.extend ("72")
			create s.make_with_parameters (73, 1, 1, 1);    default_sensors_list.extend (s)
			create s.make_with_parameters (74, 1, 1, 1);    default_sensors_list.extend (s)
			--default_sensors_list.extend ("81")
			create s.make_with_parameters (84, 1, 1, 1);    default_sensors_list.extend (s)
			--default_sensors_list.extend ("87")
			create s.make_with_parameters (92, 1, 1, 1);    default_sensors_list.extend (s)
			--default_sensors_list.extend ("95")
			create s.make_with_parameters (98, 1, 1, 1);    default_sensors_list.extend (s)
			create s.make_with_parameters (101, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (104, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (106, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (109, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (111, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (114, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (117, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (120, 1, 1, 1);   default_sensors_list.extend (s)
			--default_sensors_list.extend ("123")
			create s.make_with_parameters (139, 1, 1, 1);   default_sensors_list.extend (s)
			--default_sensors_list.extend ("151")
			--default_sensors_list.extend ("180")
			create s.make_with_parameters (203, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (205, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (207, 1, 1, 1);   default_sensors_list.extend (s)
			create s.make_with_parameters (1326, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (1368, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (1399, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (1422, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (1434, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (1437, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (1438, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (2270, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (2270, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (2414, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3002, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3003, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3019, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3032, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3033, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3046, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3049, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3092, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3093, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3106, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3109, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3118, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (3119, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (5969, 1, 1, 1);  default_sensors_list.extend (s)
			create s.make_with_parameters (6175, 1, 1, 1);  default_sensors_list.extend (s)

--			default_sensors_list.extend ("6992")
--			default_sensors_list.extend ("8007")
--			default_sensors_list.extend ("8009")
--			default_sensors_list.extend ("8014")
--			default_sensors_list.extend ("8017")
--			default_sensors_list.extend ("8020")
--			default_sensors_list.extend ("8024")
--			default_sensors_list.extend ("8028")
--			--default_sensors_list.extend ("8056")
--			--default_sensors_list.extend ("8082")
--			default_sensors_list.extend ("8093")
--			default_sensors_list.extend ("8099")
--			default_sensors_list.extend ("8101")
--			default_sensors_list.extend ("8105")
--			default_sensors_list.extend ("8107")
--			default_sensors_list.extend ("8110")
--			default_sensors_list.extend ("8112")
--			default_sensors_list.extend ("8113")
--			default_sensors_list.extend ("8114")
--			--default_sensors_list.extend ("8116")
--			--default_sensors_list.extend ("8117")
--			default_sensors_list.extend ("8118")
--			default_sensors_list.extend ("8119")
--			default_sensors_list.extend ("8120")
--			default_sensors_list.extend ("8121")
--			default_sensors_list.extend ("8124")
--			default_sensors_list.extend ("8125")
--			default_sensors_list.extend ("8128")
--			default_sensors_list.extend ("8129")
--			--default_sensors_list.extend ("8132")
--			default_sensors_list.extend ("8141")
--			--default_sensors_list.extend ("8142")
--			default_sensors_list.extend ("8143")
--			--default_sensors_list.extend ("8144")
--			default_sensors_list.extend ("8147")
--			default_sensors_list.extend ("8148")
--			default_sensors_list.extend ("8153")
--			default_sensors_list.extend ("8154")
--			--default_sensors_list.extend ("8156")
--			default_sensors_list.extend ("8158")
--			default_sensors_list.extend ("8164")
--			--default_sensors_list.extend ("8175")
--			default_sensors_list.extend ("8177")
--			default_sensors_list.extend ("8180")
--			default_sensors_list.extend ("8181")
--			--default_sensors_list.extend ("8186")
--			default_sensors_list.extend ("8192")
--			default_sensors_list.extend ("8196")
--			--default_sensors_list.extend ("8203")
--			--default_sensors_list.extend ("8205")
--			default_sensors_list.extend ("8207")
--			default_sensors_list.extend ("8210")
--			default_sensors_list.extend ("8223")
--			default_sensors_list.extend ("8380")
--			--default_sensors_list.extend ("8381")
--			default_sensors_list.extend ("8382")
--			default_sensors_list.extend ("8383")
--			default_sensors_list.extend ("8384")
--			default_sensors_list.extend ("8385")
--			default_sensors_list.extend ("8386")
--			--default_sensors_list.extend ("8389")
--			--default_sensors_list.extend ("8391")
--			default_sensors_list.extend ("8394")
--			--default_sensors_list.extend ("8481")
--			--default_sensors_list.extend ("8511")
--			--default_sensors_list.extend ("8512")
--			--default_sensors_list.extend ("8513")
--			default_sensors_list.extend ("8521")
--			default_sensors_list.extend ("8522")
--			default_sensors_list.extend ("8545")
--			default_sensors_list.extend ("8546")
--			default_sensors_list.extend ("8573")
--			default_sensors_list.extend ("8574")
--			default_sensors_list.extend ("8576")
--			default_sensors_list.extend ("8581")
--			--default_sensors_list.extend ("8593")
--			default_sensors_list.extend ("8618")
--			--default_sensors_list.extend ("8693")
--			--default_sensors_list.extend ("8701")
--			default_sensors_list.extend ("9035")
--			--default_sensors_list.extend ("9036")
--			--default_sensors_list.extend ("9037")
--			--default_sensors_list.extend ("9038")
--			--default_sensors_list.extend ("9039")
--			default_sensors_list.extend ("9040")
--			default_sensors_list.extend ("9041")
--			default_sensors_list.extend ("9042")
--			default_sensors_list.extend ("9043")
--			default_sensors_list.extend ("9044")
--			default_sensors_list.extend ("9079")
--			--default_sensors_list.extend ("9081")
--			default_sensors_list.extend ("9082")
--			default_sensors_list.extend ("9083")
--			default_sensors_list.extend ("9084")
--			--default_sensors_list.extend ("9086")
--			default_sensors_list.extend ("9087")
--			default_sensors_list.extend ("9842")
--			default_sensors_list.extend ("11099")
--			default_sensors_list.extend ("11165")
--			default_sensors_list.extend ("11988")
--			default_sensors_list.extend ("14021")
--			default_sensors_list.extend ("14024")
--			default_sensors_list.extend ("14129")
--			default_sensors_list.extend ("14170")
--			default_sensors_list.extend ("14178")
--			default_sensors_list.extend ("14205")
--			default_sensors_list.extend ("14227")
--			default_sensors_list.extend ("14252")
--			default_sensors_list.extend ("14279")
--			default_sensors_list.extend ("14301")
--			default_sensors_list.extend ("14304")
--			default_sensors_list.extend ("14307")
--			default_sensors_list.extend ("14310")
--			default_sensors_list.extend ("14313")
--			default_sensors_list.extend ("14364")
--			default_sensors_list.extend ("14497")
--			default_sensors_list.extend ("14565")
--			default_sensors_list.extend ("14624")
--			default_sensors_list.extend ("14758")
--			default_sensors_list.extend ("14759")
--			default_sensors_list.extend ("14760")
--			default_sensors_list.extend ("30523")

		end

feature -- Operations

	post1(a_msg: STRING) : STRING
			-- Post `a_msg' to remws using `LIBCURL_HTTP_CLIENT'
		local
			l_context: detachable HTTP_CLIENT_REQUEST_CONTEXT
			l_res: HTTP_CLIENT_RESPONSE
		do
			l_res := session.post ("http://" + host.value + ":" + port.value.out, l_context, a_msg)

			if attached l_res.body as r then
				Result := r
			else
				Result := ""
			end
		end

--	old_post(msg: STRING): STRING
--			--
--		local
--			l_result:   INTEGER
--		do
--			curl_buffer.wipe_out

--			curl.global_init

--			if curl_easy.is_dynamic_library_exists then
--				curl_handle := curl_easy.init
--				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,           "http://" + host.value + ":" + port.value.out)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)

--				--headers := curl.slist_append (headers.default_pointer, "")
--				--headers := curl.slist_append (headers, "content-type: text/xml;charset=utf-8")
--				--headers := curl.slist_append (headers, "SOAPAction: http://tempuri.org/IAutenticazione/Login")
--				--headers := curl.slist_append (headers, "Accept-Encoding: gzip, deflate")

--				--curl_easy.setopt_slist   (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpheader,    headers)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_post,          1)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, msg.count)
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_verbose,       0)
--				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_useragent,     "NMarzi ARPA Lombardia curl client")
--				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields,    msg)

--				--curl_easy.set_curl_function (curl_function)
--				curl_easy.set_write_function (curl_handle)
--				-- We pass our `curl_buffer''s object id to the callback function */
--				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata,     curl_buffer.object_id)

--				l_result := curl_easy.perform (curl_handle)

--				if l_result /= {CURL_CODES}.curle_ok then
--					io.put_string ("{NMARZI} cURL perfom returned: " + l_result.out)
--				end
--				--io.put_new_line

--				curl_easy.cleanup (curl_handle)
--			else
--				io.put_string ("{NMARZI} cURL library not found")
--				io.put_new_line
--			end

--			curl.global_cleanup

--			Result := curl_buffer.string
--		end

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

			r.replace_substring_all ("$sensor",      sensor.id.out)
			r.replace_substring_all ("$function",    sensor.function.out)
			r.replace_substring_all ("$operator",    sensor.operator.out)
			r.replace_substring_all ("$granularity", sensor.granularity.out)
			r.replace_substring_all ("$start",  l_start.formatted_out (default_date_time_format))
			r.replace_substring_all ("$finish", l_finish.formatted_out (default_date_time_format))

			response := post1 (r)

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

				sleep (100)

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

				sleep (100)

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

--	curl_easy: CURL_EASY_EXTERNALS
--			-- cURL easy externals
--		once
--			create Result
--		end

--	curl: CURL_EXTERNALS
--			-- cURL externals
--		once
--			create Result
--		end

--	curl_handle: POINTER
--			-- cURL handle

--	curl_buffer: CURL_STRING
--			-- response contents

	one_week:  DATE_TIME_DURATION
	one_day:   DATE_TIME_DURATION
	one_hour:  DATE_TIME_DURATION
	two_hours: DATE_TIME_DURATION

	session: LIBCURL_HTTP_CLIENT_SESSION

feature -- Parsing

	json_parser: JSON_PARSER


feature {NONE} -- sensors list

	sensors_list: ARRAYED_LIST[SENSOR_PARAMETERS]
			-- sensors list

	default_sensors_list: ARRAYED_LIST[SENSOR_PARAMETERS]
		-- default sensors list

	not_found_sensor_list: ARRAYED_LIST[STRING]
		-- sensors with no data

end
