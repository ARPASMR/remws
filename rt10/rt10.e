note
	description : "rt10 application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	RT10

inherit
	DEFAULTS
	ARGUMENTS
	RDB_HANDLE
	EXECUTION_ENVIRONMENT
	rename
		Command_line as env_command_line
	end

	DATABASE_SESSION_MANAGER_ACCESS

create
	make

feature {NONE} -- Initialization

	init
			-- General initialization
		do
			create db_host.make_empty
			create db_user.make_empty
			create db_password.make_empty
			create db.make_empty
			create collect_host.make_empty
			create results.make (0)
			create sensors.make (0)

			create now.make_now
			create one_month.make (0, 0, -30, 0, 0, 0)
			create one_week.make (0, 0, -7, 0, 0, 0)
			create one_day.make (0, 0, 0, -24, 0, 0)
			create one_hour.make (0, 0, 0, 1, 0, 0)
			create two_hours.make (0, 0, 0, 2, 0, 0)
			create one_minute.make (0, 0, 0, 0, 1, 0)
			create five_minutes.make (0, 0, 0, 0, 5, 0)
			create ten_minutes.make(0, 0, 0, 0, 10, 0)

			create start_date.make_now
			create end_date.make_now

			create realtime_data_res.make
			create response.make_empty
			create curl_buffer.make_empty

			-- Parsing
			create json_parser.make_with_string ("{}")

		end

	make
			-- Run application.
		local
			l_data:      ARRAYED_LIST[STRING]
			fd:          FORMAT_DOUBLE
			l_start:     DATE_TIME
			l_end:       DATE_TIME
			l_idx:       INTEGER
			l_sensor_id: INTEGER
		do
			create l_start.make_now

			create fd.make (6, 1)
			fd.right_justify

			init

			display_line ("Ten minutes realtime acquisition", true)
			display_line ("Home folder:        " + home_folder, true)
			display_line ("Preferences folder: " + preferences_folder, true)

			init_preferences

			set_hostname (db_host)
			set_application (db)
			login(db_user, db_password)
			set_base

			create modification.make
			create selection.make
			create session_control.make
			session_control.connect

			l_idx := index_of_word_option ("s")
			if l_idx > 0 then
				l_sensor_id := argument (l_idx + 1).to_integer

				-- Carica i sensori
				load_sensors (results)

				-- Cerca il singolo sensore
				from sensors.start
				until sensors.after
				loop
					if sensors.item.sensor_id = l_sensor_id then
						-- determinare l'ultimo dato acquisito per il sensore (es. 9104)
						get_last_dates (sensors.item)

						-- interrogare il remws per ottenere i dati dall'ultimo dato acquisito fino all'istante corrente
						l_data := ask_sensor (sensors.item)

						-- salvare i dati ottenuti nel dbMeteo
						save_sensor_data (sensors.item)

						-- Stampa a video i dati
						print_data (sensors.item)
					end

					sensors.forth
				end

			else

				-- Carica i sensori
				load_sensors (results)

				-- Cancellare i dati troppo vecchi
				delete_old_data

				-- per ciascun sensore
				from sensors.start
				until sensors.after
				loop
					-- determinare l'ultimo dato acquisito per il sensore (es. 9104)
					get_last_dates (sensors.item)

					-- interrogare il remws per ottenere i dati dall'ultimo dato acquisito fino all'istante corrente
					l_data := ask_sensor (sensors.item)

					-- salvare i dati ottenuti nel dbMeteo
					save_sensor_data (sensors.item)

					-- stampa i dati per il sensore
					print_data (sensors.item)

					sensors.forth
				end

			end

			sensors.wipe_out

			selection.clear_all
			selection.terminate
			selection.reset
			modification.clear_all
			modification.reset
			session_control.disconnect

			create l_end.make_now

			display_line ("Started at:  " + l_start.formatted_out (default_date_time_format), true)
			display_line ("Finished at: " + l_end.formatted_out (default_date_time_format), true)
		end

feature -- Process

	print_data (sensor: RT10_SENSOR)
			-- displays sensor measures
		local
			fd: FORMAT_DOUBLE
		do
			create fd.make (6, 1)
			fd.right_justify

			from sensor.measures.start
			until sensor.measures.after
			loop
				if sensor.measures.count > 0 then
					from sensor.measures.item.start
					until sensor.measures.item.after
					loop
						display_line ("%T" + sensor.sensor_id.out + " " + sensor.measures.item.item.date_time + " " +
						               fd.formatted (sensor.measures.item.item.value) + " " +
						               sensor.operators.i_th (sensor.measures.index).out, true)

						sensor.measures.item.forth
					end
				else
					display_line ("%T" + sensor.sensor_id.out + " " + sensor.operators.i_th (sensor.measures.index).out + " has 0 items", true)
				end
				sensor.measures.forth
			end
		end

	make_last_dates_queries (sensor: RT10_SENSOR) : TUPLE[STRING, STRING, STRING]
			-- Construct query for last data
		local
			query: STRING
			i:     INTEGER
		do
			create Result.default_create

			from
				sensor.operators.start
				i:= Result.lower
			until sensor.operators.after
			loop
				create query.make_empty
				query := "select Data_e_ora from METEO.M_Osservazioni_TR where IDsensore = " + sensor.sensor_id.out
				query := query + " and NomeTipologia = '" + sensor.typology + "'"
				query := query + " and IDoperatore = " + sensor.operators.item.out + " order by Data_e_ora desc limit 1;"
				Result.put (query, i)
				sensor.operators.forth
				i := i + 1
			end
		end

	make_insert_into_data (s: INTEGER; o: INTEGER; t: STRING; m: MEASURE) : STRING
			-- Construct insert into query string
		local
			l_now: DATE_TIME
		do
			create Result.make_empty
			create l_now.make_now

			Result := "INSERT INTO `METEO`.`M_Osservazioni_TR` " +
                      "(`IDsensore`, " +
                      "`NomeTipologia`, " +
                      "`IDoperatore`, " +
                      "`Data_e_ora`, " +
                      "`Misura`, " +
                      "`Flag_manuale_DBunico`, " +
                      "`Flag_manuale`, " +
                      "`Flag_automatica`, " +
                      "`Autore`, " +
                      "`Data`, " +
                      "`IDutente`) " +
                      "VALUES (" + s.out + ", " +
                      "'" + t + "'" + ", " +
                      o.out + ", " +
                      "'" + m.date_time + "', " +
					  m.value.out + ", " +
                      "0, " +
                      "'M', " +
                      "'P', " +
                      "'RT10', '" +
                      l_now.formatted_out (default_date_time_format) + "', " +
                      "59);"
		end

	make_exists_measure_query (s: INTEGER; o: INTEGER; t: STRING; d: DATE_TIME) : STRING
			-- Constructs exists query for sensor `s' with operator `o' and typology `t'
		do
			Result := "select Data_e_ora from METEO.M_Osservazioni_TR where "+
			          "IDsensore = " + s.out + " and IDoperatore = " + o.out +
			          " and NomeTipologia = '" + t + "' and Data_e_ora = '" + d.formatted_out (default_date_time_format) + ".000';"
		end

	get_last_dates (sensor: RT10_SENSOR)
			-- Retrieve sensor's last date till current time
		local
			date:     DATE_TIME
			queries:  TUPLE[STRING, STRING, STRING]
			i:        INTEGER
			l_tuple:  DB_TUPLE
			r_any:    detachable ANY
		do

			-- Determino le ultime date per cui sono disponibili i dati per il sensore `sensor'
			queries := make_last_dates_queries (sensor)

			io.put_string ("Sensor " + sensor.sensor_id.out + " last dates {")
			if attached queries.at (1) as l_q1 then
				io.put_string (l_q1.out)
			end
			io.put_string (",")
			if attached queries.at (2) as l_q2 then
			    io.put_string (l_q2.out)
			end
			io.put_string (",")
			if attached queries.at (3) as l_q3 then
				io.put_string (l_q3.out)
			end
			io.put_string ("}")
			io.put_new_line

			from i := 1
			until i = queries.count + 1
			loop
				if attached queries.item (i) as l_q then
					selection.set_query (l_q.out)
					if selection.is_executable then
						selection.execute_query
					else
						io.put_string ("{get_last_dates} selection not executable " + l_q.out)
						io.put_new_line
						selection.clear_all
						selection.terminate
					end

					io.put_string ("{get_last_dates} Execute query: " + l_q.out)
					io.put_new_line

					if selection.is_ok then
						selection.set_container (results)
						selection.load_result

						-- Se non ho risultati dovrò richiedere gli ultimi 7 giorni
						if results.is_empty then
							sensor.last_dates.extend(now + one_week);
						else -- altrimenti dovrò richiedere i dati dall'ultimo inserito
							from results.start
							until results.after
							loop
								if attached selection.cursor as l_cursor then
									create l_tuple.copy(l_cursor)
									r_any := l_tuple.item (1)

									if r_any /= Void then
										if attached {DATE_TIME} r_any as l_date_time then
											sensor.last_dates.extend (l_date_time)
										end
									end
								end
								selection.forth
							end
						end
						results.wipe_out
						selection.clear_all
						selection.terminate
					end
				end
				i := i + 1
			end

			from sensor.last_dates.start
			     i := 1
			until sensor.last_dates.after
			loop
				io.put_string ("Must request data for sensor id " + sensor.sensor_id.out + " operator: " +
				                sensor.operators.i_th (i).out + " from " + (sensor.last_dates.item + ten_minutes).formatted_out (default_date_time_format))
				io.put_new_line
				sensor.last_dates.forth
				i := i + 1
			end

		end

	load_sensors(some_results: ARRAYED_LIST[DB_RESULT])
			-- Load `sensors'
		local
			l_tuple: DB_TUPLE
			l_sensor: RT10_SENSOR
			r_int: INTEGER_REF
			r_any: detachable ANY
		do
			if session_control.is_connected then
				io.put_string ("Connected to database: " + db + "%N")

				-- chiedere l'elenco dei sensori

				selection.set_query ("select IDsensore, Destinazione, AggregazioneTemporale, NOMEtipologia from METEO.vw_rt10 order by IDsensore desc;")
				selection.execute_query

				-- Processare il risultato della query
				if selection.is_ok then
					selection.set_container (some_results)
					selection.load_result

					display_line (some_results.count.out + " sensors found", true)

					from selection.start
					until selection.after
					loop
						if attached selection.cursor as l_cursor then
							create l_tuple.copy(l_cursor)
							create r_int
							create l_sensor.make
							r_any := l_tuple.item (1)
							if r_any /= Void then
								if attached {INTEGER_REF} r_any as l_r_int then
									r_int := l_r_int
									l_sensor.set_sensor_id (r_int.item)
								end
							end
							r_any := l_tuple.item (2)
							if r_any /= Void then
								if attached {READABLE_STRING_GENERAL} r_any as l_destination then
									l_sensor.set_destination (l_destination.to_string_32)
								end
							end
							r_any := l_tuple.item (3)
							if r_any /= Void then
								if attached {INTEGER_REF} r_any as l_r_int then
									r_int := l_r_int
									l_sensor.set_time_granularity (r_int.item)
								end
							end
							r_any := l_tuple.item (4)
							if r_any /= Void then
								if attached {READABLE_STRING_GENERAL} r_any as l_typology then
									l_sensor.set_typology (l_typology.to_string_32)
								end
							end
							sensors.extend (l_sensor)
						end
						selection.forth
					end

					selection.clear_all
					selection.terminate
					some_results.wipe_out
				end
			end
		end

	check_day_light_time_saving (dt: DATE_TIME) : DATE_TIME_DURATION
			-- Check for day light time savin on `dt'
		local
			l_date:        DATE
			l_month:       INTEGER
			l_day:         INTEGER
			l_dow:         INTEGER
			l_prev_sunday: INTEGER
			l_one_hour:    DATE_TIME_DURATION
			l_two_hours:   DATE_TIME_DURATION
		do
			create l_one_hour.make (0, 0, 0, 1, 0, 0)
			create l_two_hours.make (0, 0, 0, 2, 0, 0)

			l_day   := dt.day
			l_month := dt.month

			l_date  := dt.date;
			l_dow   := dt.date.day_of_the_week


			create Result.make (0, 0, 0, 1, 0, 0)

			if l_month < 3 or l_month > 10 then
				-- Non siamo in ora legale quindi l'offset rispetto a UTC è di un'ora
				Result := l_one_hour
			elseif l_month > 3 and l_month < 10 then
				-- Siamo in ora legale quindi l'offset rispetto a UTC è di due ore
				Result := l_two_hours
			else
				l_prev_sunday := dt.day - l_dow
				if l_month = 3 then
					if l_prev_sunday >= 25 then
						-- Siamo in ora legale quindi l'offset rispetto a UTC è di due ore
						Result := l_two_hours
					else
						-- Non siamo in ora legale quindi l'offset rispetto a UTC è di un'ora
						Result := l_one_hour
					end
				end
				if l_month = 10 then
					if l_prev_sunday < 25 then
						-- Siamo in ora legale quindi l'offset rispetto a UTC è di due ore
						Result := l_two_hours
					else
						-- Non siamo in ora legale quindi l'offset rispetto a UTC è di un'ora
						Result := l_one_hour
					end
				end
			end
		end

feature -- Display

	display_line (a_line: STRING; nl: BOOLEAN)
			-- Display `a_line' on screen with a new line if `nl' is True
		do
			io.put_string (a_line)
			if nl then
				io.put_new_line
			end
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
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,           "http://" + collect_host + ":" + collect_port.out)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_fresh_connect, 1)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_forbid_reuse,  1)

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
					io.put_string ("cURL perfom returned: " + l_result.out)
				end
				--io.put_new_line

				curl_easy.cleanup (curl_handle)
			else
				io.put_string ("cURL library not found")
				io.put_new_line
			end

			curl.global_cleanup

			Result := curl_buffer.string
		end

	ask_sensor(sensor: RT10_SENSOR): ARRAYED_LIST[STRING]
			-- Ask `sensor' data
		local

			fd:       FORMAT_DOUBLE
			r:        STRING
			j,k:      INTEGER
			l_line:   STRING
			l_tokens: LIST[STRING]

			l_measures: ARRAYED_LIST[MEASURE]
			l_measure:  MEASURE
		do
			-- Now try a realtime data request for one nmarzi sensor
			display_line ("Asks for realtime data, sensor: " + sensor.sensor_id.out, true)

			create Result.make (0)
			create r.make_empty

			from sensor.last_dates.start
			until sensor.last_dates.after
			loop
				start_date  := sensor.last_dates.item + ten_minutes
				end_date := now + check_day_light_time_saving (now) + one_hour

				create fd.make (6, 1)
				fd.right_justify

				display_line ("Ask data for sensor: " + sensor.sensor_id.out + " from: " + start_date.formatted_out (default_date_time_format) +
				               " to: " + end_date.formatted_out (default_date_time_format) +
				               " operator: " + sensor.operators.i_th (sensor.last_dates.index).out, true)

				r.copy (realtime_data_request_nmarzi_template)

				r.replace_substring_all ("$sensor",      sensor.sensor_id.out)

				if sensor.time_granularity = {TIME_GRANULARITY_CODES}.one_minute or
				   sensor.time_granularity = {TIME_GRANULARITY_CODES}.five_minutes then

				   	r.replace_substring_all ("$function", {FUNCTION_CODES}.computed_data.out)
					r.replace_substring_all ("$granularity", {TIME_GRANULARITY_CODES}.ten_minutes.out)
				   	if sensor.typology.is_equal ({SENSOR_TYPOLOGY_CODES}.rainfall) then
				   		r.replace_substring_all ("$operator", {APPLIED_OPERATOR_CODES}.cumulated.out)
				   	else
				   		r.replace_substring_all ("$operator", {APPLIED_OPERATOR_CODES}.average.out)
				   	end

				else
					r.replace_substring_all ("$granularity", sensor.time_granularity.out)
					r.replace_substring_all ("$function",    {FUNCTION_CODES}.acquired_data.out)
					r.replace_substring_all ("$operator",    sensor.operators.i_th (sensor.last_dates.index).out)
				end

				r.replace_substring_all ("$start",  start_date.formatted_out (default_date_time_format))
				r.replace_substring_all ("$finish", end_date.formatted_out (default_date_time_format))

				display_line (">>> " + r, true)

				response := post (r)

				display_line ("<<< " + response, true)

				if attached response as res and not response.is_empty then
					realtime_data_res.sensor_data_list.wipe_out
					realtime_data_res.from_json (res, json_parser)
					io.put_string ("Found " + realtime_data_res.sensor_data_list.count.out + " sensors list data")
					io.put_new_line
					if realtime_data_res.sensor_data_list.count = 0 then
						display_line ("No sensor data found for sensor " + sensor.sensor_id.out + " " + sensor.typology + " from " +
						               start_date.formatted_out (default_date_time_format) + " to " + end_date.formatted_out (default_date_time_format), true)
					end

					create l_measures.make (0)
					sensor.measures.extend (l_measures)

					from j := 1
					until j = realtime_data_res.sensor_data_list.count + 1
					loop
						display_line (realtime_data_res.sensor_data_list.i_th (j).out + " " + sensor.operators.i_th (sensor.last_dates.index).out, true)
						from k := 1
						until k = realtime_data_res.sensor_data_list.i_th (j).data.count + 1
						loop
							l_line := realtime_data_res.sensor_data_list.i_th (j).data.i_th (k).out

							Result.extend (l_line)
							k := k + 1

							l_tokens := l_line.split (';')

							create l_measure.make
							l_measure.set_date_time (l_tokens.i_th (1) + ".000")
							l_measure.set_value (fd.formatted (l_tokens.i_th (2).to_double).to_double)

							sensor.measures.i_th (sensor.last_dates.index).extend (l_measure)

						end
						j := j + 1
					end
				else
					display_line ("{ask_sensor} json string is empty", true)
				end
				sensor.last_dates.forth
			end
		end

	save_sensor_data (sensor: RT10_SENSOR)
			-- Save measures to database
		local
			l_query: STRING
			l_date: DATE_TIME
		do
			from sensor.measures.start
			until sensor.measures.after
			loop
				--l_date := start_date
				l_date := sensor.last_dates.at (sensor.measures.index) + ten_minutes

				from sensor.measures.item.start
				until sensor.measures.item.after
				loop

					if not is_measure_already_present (sensor.sensor_id, sensor.operators.i_th (sensor.measures.index), sensor.typology, l_date) then
						l_query := make_insert_into_data (sensor.sensor_id, sensor.operators.i_th (sensor.measures.index), sensor.typology, sensor.measures.item.item)
						modification.set_query (l_query)

						if modification.is_ok and modification.is_executable then
							modification.execute_query
							display_line ("Inserted measure for sensor id " + sensor.sensor_id.out + " operator " + sensor.operators.i_th (sensor.measures.index).out +
							               " measure " + sensor.measures.item.item.value.out + " date " + sensor.measures.item.item.date_time, true)
						else
							display_line ("{save_sensor} Query not ok or not executable", true)
						end

						session_control.commit
					end
					sensor.measures.item.forth
					l_date := l_date + ten_minutes
				end
				sensor.measures.forth
			end

		end

	delete_old_data
			-- Deletes data older than 30 days
		local
			l_query: STRING
			l_date:  DATE_TIME
		do
			create l_query.make_empty
			l_date := now + one_month
			l_query := "delete from METEO.M_Osservazioni_TR where Data_e_ora < '" + l_date.formatted_out (default_date_time_format) + "';"
			modification.modify (l_query)
			session_control.commit
		end

	is_measure_already_present (sensor_id: INTEGER; operator: INTEGER; typology: STRING; date: DATE_TIME) : BOOLEAN
			-- Is measure already present in db
		local
			l_query:      STRING
			some_results: ARRAYED_LIST[DB_RESULT]
		do
			Result := false
			create some_results.make (0)

			l_query := make_exists_measure_query (sensor_id, operator, typology, date)
			selection.set_query (l_query)
			if selection.is_executable then
				selection.execute_query
			else
				io.put_string ("{is_measure_already_present} Query not executable: " + l_query)
				io.put_new_line
				selection.clear_all
			end


			if selection.is_ok then
				if selection.is_connected then
					selection.set_container (some_results)
					selection.load_result
					if some_results.count > 0 then
						display_line ("Measure for sensor " + sensor_id.out + " operator " + operator.out + " date " + date.formatted_out (default_date_time_format) + " ALREADY EXISTS", true)
						Result := true
					end
				else
					display_line ("{is_measure_already_present} ERROR selection not connected", true)
					selection.reset
				end

			else
				display_line ("{is_measure_already_present} ERROR selection not OK", true)
				selection.reset
			end

			selection.clear_all
			selection.terminate
			some_results.wipe_out
		end

feature -- Preferences

	preferences: PREFERENCES
			-- Preferences
	preference_manager: PREFERENCE_MANAGER
			-- Preference manager
	preferences_storage: PREFERENCES_STORAGE_DEFAULT
			-- Preferences storage
	host_pref:          STRING_PREFERENCE
			-- Host preference
	database_pref:      STRING_PREFERENCE
			-- Database name preference
	dbusr_pref:         STRING_PREFERENCE
			-- Database user preference
	dbpwd_pref:         STRING_PREFERENCE
			-- Database password preference
	collect_host_pref:  STRING_PREFERENCE
			-- Host running collect preference
	collect_port_pref:  INTEGER_PREFERENCE
			-- Collect port preference
	factory:            BASIC_PREFERENCE_FACTORY
			-- Preferences factory

	init_preferences
			-- Loads preferences
		do
			create preferences_storage.make_with_location (preferences_folder + "/rt10conf.xml")
			create preferences.make_with_storage (preferences_storage)
			preference_manager := preferences.new_manager ("rt10")

			create factory
			host_pref         := factory.new_string_preference_value (preference_manager,  "rt10.host",         "localhost")
			database_pref     := factory.new_string_preference_value (preference_manager,  "rt10.database",     "METEO")
			dbusr_pref        := factory.new_string_preference_value (preference_manager,  "rt10.dbusr",        "root")
			dbpwd_pref        := factory.new_string_preference_value (preference_manager,  "rt10.dbpwd",        "METEO")
			collect_host_pref := factory.new_string_preference_value (preference_manager,  "rt10.collect_host", "localhost")
			collect_port_pref := factory.new_integer_preference_value (preference_manager, "rt10.collect_port", 9090)
			db_host           := host_pref.value
			db_user           := dbusr_pref.value
			db_password       := dbpwd_pref.value
			db                := database_pref.value
			collect_host      := collect_host_pref.value
			collect_port      := collect_port_pref.value

			display_line ("Host:         " + db_host, true)
			display_line ("Database:     " + db, true)
			display_line ("Db user:      " + db_user, true)
			display_line ("Db password:  " + "*****", true)
			display_line ("Collect host: " + collect_host, true)
			display_line ("Collect port: " + collect_port.out, true)

			--preferences.save_preferences
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

feature -- Implementation

	db_host:      STRING
			-- Database host
	db_user:      STRING
			-- Database user
	db_password:  STRING
			-- Database password
	db:           STRING
			-- Database name
	collect_host: STRING
			-- Collect host (IP or name)
	collect_port: INTEGER

	session_control: DB_CONTROL
			-- Session manager
	selection:       DB_SELECTION
			-- Database selection object
	modification:    DB_CHANGE
			-- Database modification tool
	results:         ARRAYED_LIST[DB_RESULT]
			-- Database query results
	sensors:         ARRAYED_LIST[RT10_SENSOR]
			-- Sensors list


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

	now:          DATE_TIME
	one_month:    DATE_TIME_DURATION
	one_week:     DATE_TIME_DURATION
	one_day:      DATE_TIME_DURATION
	one_hour:     DATE_TIME_DURATION
	two_hours:    DATE_TIME_DURATION
	one_minute:   DATE_TIME_DURATION
	five_minutes: DATE_TIME_DURATION
	ten_minutes:  DATE_TIME_DURATION

	json_parser:  JSON_PARSER

	start_date:   DATE_TIME
	end_date:     DATE_TIME

	home_folder: STRING_32
			-- Current user home folder
		once
			if( attached item("HOME") as l_home ) then
				create Result.make_from_string (l_home)
			else
				create Result.make_empty
			end
		end

	preferences_folder: STRING_32
			-- Preferences folder
		once
			if( home_folder.is_empty ) then
				create Result.make_from_string("./.rt10")
			else
				create Result.make_from_string(home_folder + "/.rt10")
			end

		end

end
