note
	description : "[
						curl_test_client application root class
						user     = a_usr
    					password = a_pwd
    					host     = remws.arpa.local
					]"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CURL_TEST_CLIENT

inherit
	ARGUMENTS
	DEFAULTS
	EXCEPTIONS
	EXECUTION_ENVIRONMENT
	rename
		command_line as env_command_line
	end

create
	make

feature {NONE} -- Initialization


	make
			--
		local
			r:STRING
			i,j,k:INTEGER
			rt_res: REALTIME_DATA_RESPONSE
		do
			io.put_string ("cURL test client")
			io.put_new_line

			initialize

			create r.make_empty
			create rt_res.make

			--rt_res.from_xml (xml1)

			--die(0)




			-- Now try a realtime data request
--			io.put_string ("{CURL_TEST_CLIENT} Asks for realtime data")
--			io.put_new_line

--			r.copy (realtime_data_request)
--			io.put_string ("{CURL_TEST_CLIENT} >>> " + realtime_data_request)
--			io.put_new_line

--			response := post (r)

--			io.put_string ("{CURL_TEST_CLIENT} <<< " + response)
--			io.put_new_line


--			if attached response as res then
--				realtime_data_res.sensor_data_list.wipe_out
--				realtime_data_res.from_json (res)
--				io.put_string ("{CURL_TEST_CLIENT} Found " + realtime_data_res.sensor_data_list.count.out + " sensors list data")
--				io.put_new_line
--				from j := 1
--				until j = realtime_data_res.sensor_data_list.count + 1
--				loop
--					io.put_string (realtime_data_res.sensor_data_list.i_th (j).out)
--					io.put_new_line
--					from k := 1
--					until k = realtime_data_res.sensor_data_list.i_th (j).data.count + 1
--					loop
--						io.put_string (realtime_data_res.sensor_data_list.i_th (j).data.i_th (k).out)
--						io.put_new_line
--						k := k + 1
--					end
--					j := j + 1
--				end
--			end
--			die(0)







			from i := 0
			until i > 1000
			loop
				-- Now try a station status list request
				io.put_string ("{CURL_TEST_CLIENT} Asks for station status list")
				io.put_new_line

				r.copy (station_status_list_request)

				response := post (r)

				if attached response as res then
					station_status_list_res.status_list.wipe_out
					station_status_list_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + station_status_list_res.status_list.count.out + " station status")
					io.put_new_line
					from j := 1
					until j = station_status_list_res.status_list.count + 1
					loop
						io.put_string (station_status_list_res.status_list.i_th (j).out)
						io.put_new_line
						j := j + 1
					end
				end


				-- Now try a station types list request
				io.put_string ("{CURL_TEST_CLIENT} Ask for station types list")
				io.put_new_line

				r.copy (station_types_list_request)

				response := post (r)
				if attached response as res then
					station_types_list_res.types_list.wipe_out
					station_types_list_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + station_types_list_res.types_list.count.out + " station types")
					io.put_new_line
					from j := 1
					until j = station_types_list_res.types_list.count + 1
					loop
						io.put_string (station_types_list_res.types_list.i_th (j).out)
						io.put_new_line
						j := j + 1
					end
				end

				-- Now try a province list request
				io.put_string ("{CURL_TEST_CLIENT} Ask for provinces list")
				io.put_new_line

				r.copy (province_list_request)

				response := post (r)
				if attached response as res then
					province_list_res.provinces_list.wipe_out
					province_list_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + province_list_res.provinces_list.count.out + " provinces")
					io.put_new_line
					from j := 1
					until j = province_list_res.provinces_list.count + 1
					loop
						io.put_string (province_list_res.provinces_list.i_th (j).out)
						io.put_new_line
						j := j + 1
					end
				end

				-- Now try a municipality list request
				io.put_string ("{CURL_TEST_CLIENT} Ask for municipalities list")
				io.put_new_line

				r.copy (municipalities_list_request)

				io.put_string("{CURL_TEST_CLIENT} json request:%N" + municipalities_list_request)
				io.put_new_line

				response := post (r)

				io.put_string("{CURL_TEST_CLIENT} json response:%N" + response)
				io.put_new_line

				if attached response as res then
					municipality_list_res.municipalities_list.wipe_out
					municipality_list_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + municipality_list_res.municipalities_list.count.out + " municipalities")
					io.put_new_line
					from j := 1
					until j = municipality_list_res.municipalities_list.count + 1
					loop
						io.put_string (municipality_list_res.municipalities_list.i_th (j).out)
						io.put_new_line
						j := j + 1
					end
				end

				-- Now try a sensor type list request
				io.put_string ("{CURL_TEST_CLIENT} Ask for sensor types list")
				io.put_new_line

				r.copy (sensor_type_list_request)

				response := post (r)
				if attached response as res then
					sensor_type_list_res.sensor_types_list.wipe_out
					sensor_type_list_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + sensor_type_list_res.sensor_types_list.count.out + " sensor types")
					io.put_new_line
					from j := 1
					until j = sensor_type_list_res.sensor_types_list.count + 1
					loop
						io.put_string (sensor_type_list_res.sensor_types_list.i_th (j).out)
						io.put_new_line
						j := j + 1
					end
				end

				-- Now try a station list request
				io.put_string ("{CURL_TEST_CLIENT} Ask for stations list")
				io.put_new_line

				r.copy (station_list_request)

				io.put_string("{CURL_TEST_CLIENT} json request:%N" + station_list_request)
				io.put_new_line

				response := post (r)

				io.put_string("{CURL_TEST_CLIENT} json response:%N" + response)
				io.put_new_line


				if attached response as res then
					station_list_res.stations_list.wipe_out
					station_list_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + station_list_res.stations_list.count.out + " stations")
					io.put_new_line
					from j := 1
					until j = station_list_res.stations_list.count + 1
					loop
						io.put_string (station_list_res.stations_list.i_th (j).out)
						io.put_new_line
						j := j + 1
					end
				end


				-- Now try a realtime data request
				io.put_string ("{CURL_TEST_CLIENT} Asks for realtime data")
				io.put_new_line

				r.copy (realtime_data_request)
				io.put_string ("{CURL_TEST_CLIENT} >>> " + realtime_data_request)
				io.put_new_line

				response := post (r)

				io.put_string ("{CURL_TEST_CLIENT} <<< " + response)
				io.put_new_line


				if attached response as res then
					realtime_data_res.sensor_data_list.wipe_out
					realtime_data_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + realtime_data_res.sensor_data_list.count.out + " sensors list data")
					io.put_new_line
					from j := 1
					until j = realtime_data_res.sensor_data_list.count + 1
					loop
						io.put_string (realtime_data_res.sensor_data_list.i_th (j).out)
						io.put_new_line
						from k := 1
						until k = realtime_data_res.sensor_data_list.i_th (j).data.count + 1
						loop
							io.put_string (realtime_data_res.sensor_data_list.i_th (j).data.i_th (k).out)
							io.put_new_line
							k := k + 1
						end
						j := j + 1
					end
				end

				-- Now try a realtime data request for one data
				io.put_string ("{CURL_TEST_CLIENT} Asks for realtime data")
				io.put_new_line

				r.copy (realtime_data_request_idro)
				io.put_string ("{CURL_TEST_CLIENT} >>> " + realtime_data_request_idro)
				io.put_new_line

				response := post (r)

				io.put_string ("{CURL_TEST_CLIENT} <<< " + response)
				io.put_new_line


				if attached response as res then
					realtime_data_res.sensor_data_list.wipe_out
					realtime_data_res.from_json (res)
					io.put_string ("{CURL_TEST_CLIENT} Found " + realtime_data_res.sensor_data_list.count.out + " sensors list data")
					io.put_new_line
					from j := 1
					until j = realtime_data_res.sensor_data_list.count + 1
					loop
						io.put_string (realtime_data_res.sensor_data_list.i_th (j).out)
						io.put_new_line
						from k := 1
						until k = realtime_data_res.sensor_data_list.i_th (j).data.count + 1
						loop
							io.put_string (realtime_data_res.sensor_data_list.i_th (j).data.i_th (k).out)
							io.put_new_line
							k := k + 1
						end
						j := j + 1
					end
				end














				io.put_string ("----------------------------------------------------------------------%N")
				io.put_string ("| iteration:" + i.out + "%N")
				io.put_string ("----------------------------------------------------------------------%N")

				i := i + 1

			end

			io.put_string ("Dieing happily!!!")
			io.put_new_line
			die(0)
















			die(0)


			from i := 0
			until i = 2
			loop









				i := i + 1

				io.put_string ("--------------------------------------------------------------------------------")
				io.put_new_line
			end

		end

	initialize
			-- object creation
		local
			l_path: STRING
		do
			create headers
			create curl_buffer.make_empty
			create curl_function.make

			create login_res.make
			create logout_res.make
			create station_status_list_res.make
			create station_types_list_res.make
			create province_list_res.make
			create municipality_list_res.make
			create station_list_res.make
			create sensor_type_list_res.make
			create realtime_data_res.make

			create response.make_empty

			create token_id.make_empty
			create expiry.make_now
			create station.make

			create username.make_empty
			create password.make_empty

			if not cfg_file_path.is_empty then
				l_path := cfg_file_path
			else
				l_path := "/etc/curl_test_client/credentials.conf"
			end

			create cfg_file.make_with_name (l_path)

			read_cfg
		end

	cfg_file_path: STRING
			-- format cfg file name full path
		do
			create Result.make_empty
			if attached home_directory_path as l_home then
				Result := l_home.out + "/.curl_test_client/" + cfg_file_name
			end
		end

	read_cfg
			-- Trivial config file --> switch to preferences library
		do
			cfg_file.open_read

			cfg_file.read_line
			username := cfg_file.last_string
			cfg_file.read_line
			password := cfg_file.last_string

			cfg_file.close
		end

feature -- Basic operations

	post(msg: STRING): STRING
			--
		local
			l_result:   INTEGER
		do
			curl_buffer.wipe_out

			curl.global_init

			if curl_easy.is_dynamic_library_exists then
				curl_handle := curl_easy.init
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,           "http://localhost:9090")
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
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_useragent,     "Eiffel curl testclient")
				curl_easy.setopt_string  (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields,    msg)

				--curl_easy.set_curl_function (curl_function)
				curl_easy.set_write_function (curl_handle)
				-- We pass our `curl_buffer''s object id to the callback function */
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata,     curl_buffer.object_id)

				l_result := curl_easy.perform (curl_handle)

				if l_result /= {CURL_CODES}.curle_ok then
					io.put_string ("{CURL_TEST_CLIENT} cURL perfom returned: " + l_result.out)
				end
				--io.put_new_line

				curl_easy.cleanup (curl_handle)
			else
				io.put_string ("{CURL_TEST_CLIENT} cURL library not found")
				io.put_new_line
			end

			curl.global_cleanup

			Result := curl_buffer.string
		end

feature {NONE} -- Implementation

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

	headers:     POINTER
			-- headers slist

	curl_function: CURL_DEFAULT_FUNCTION
			-- default cURL calbacks

	curl_buffer: CURL_STRING
			-- response contents

	one_second: INTEGER = 1000000000

	cfg_file_name: STRING = "credentials.conf"

feature -- Configuration

	username: STRING
	password: STRING
	cfg_file: PLAIN_TEXT_FILE

feature -- msg data

	login_res:               LOGIN_RESPONSE
	logout_res:              LOGOUT_RESPONSE
	station_status_list_res: STATION_STATUS_LIST_RESPONSE
	station_types_list_res:  STATION_TYPES_LIST_RESPONSE
	province_list_res:       PROVINCE_LIST_RESPONSE
	municipality_list_res:   MUNICIPALITY_LIST_RESPONSE
	station_list_res:        STATION_LIST_RESPONSE
	sensor_type_list_res:    SENSOR_TYPE_LIST_RESPONSE
	realtime_data_res:       REALTIME_DATA_RESPONSE

	response:                STRING

	token_id:                STRING
	expiry:                  DATE_TIME
	station:                 STATION

	query_token_request: STRING = "[
		{
	      "header": {
	        "id":                0,
	        "parameters_number": 0
	      },
	      "data": {}
	    }
	]"

	login_request: STRING = "[
		{
	      "header": {
	        "id": 1
	      },
	      "data": {
	        "username": "$usr",
	        "password": "$pwd"
	      }
	    }
	]"

	login_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
			<s:Body>
				<LoginResponse xmlns="http://tempuri.org/">
					<LoginResult>
						<LoginResponse xmlns="">
							<LoginResult>
								<Token>
									<Id>EC83F50C-0B47-4973-B2FD-A8B319F687E7</Id>
									<Scadenza>2015-08-18 16:08:38</Scadenza>
								</Token>
								<Esito>0</Esito>
								<Messaggio>Login affettuata con successo</Messaggio>
							</LoginResult>
						</LoginResponse>
					</LoginResult>
				</LoginResponse>
			</s:Body>
		</s:Envelope>
	]"

	logout_request: STRING = "[
		{
	      "header": {
	        "id": 2
	      },
	      "data": {}
	    }
	]"

	logout_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
			<s:Body>
				<LogoutResponse xmlns="http://tempuri.org/">
					<LogoutResult>
						<LogoutResponse xmlns="">
							<LogoutResult>
								<Esito>0</Esito>
								<Messaggio>Sessione chiusa con successo</Messaggio>
							</LogoutResult>
						</LogoutResponse>
					</LogoutResult>
				</LogoutResponse>
			</s:Body>
		</s:Envelope>
	]"

	station_status_list_request: STRING = "[
		{
	      "header": {
	        "id": 3
	      },
	      "data": {}
	    }
	]"

	station_types_list_request: STRING = "[
		{
	      "header": {
	        "id": 4
	      },
	      "data": {}
	    }
	]"

	province_list_request: STRING = "[
		{
		  "header": {
		    "id": 5
		  },
		  "data": {}
		}
	]"

	municipalities_list_request: STRING = "[
		{
		  "header": {
		    "id": 6
		  },
		  "data": {
		    "provinces_list": [ {"province": "MI"},
		                        {"province": "BG"}]
		  }
		}
	]"

	station_list_request: STRING = "[
		{
		  "header": {
		    "id": 7
		  },
		  "data": {
            "municipalities_list": [{"municipality": 362}],
            "provinces_list":      [],
            "types_list":          [],
            "status_list":         [],
            "stations_list":       [],
            "station_name":        ""
		  } 
		}
	]"

	sensor_type_list_request: STRING = "[
		{
		  "header": {
		    "id": 8
		  },
		  "data": {
		    "stations_list": []
		  }	
		}
	]"

	sensor_list_request: STRING = "[
		{
          "header": {
            "id": 9
          },
         "data": {
                   "municipalities_list": [],
                   "stations_list":       [],
                   "sensor_types_list"    [],
                   "sensors_list":        [],
                   "sensor_name":         ""
                 }
        }
    ]"

	realtime_data_request: STRING = "[
		{
          "header": {
          "id": 10
        },
        "data": {
          "sensors_list": [ {
                              "sensor_id": 4058,
                              "function_id": 1,
                              "operator_id": 1,
                              "granularity": 1,
                              "start": "2015-11-21 06:30:00",
                              "finish": "2015-11-21 14:30:00"
                            } ]
                }    
		}
	]"

	realtime_data_request_idro: STRING = "[
		{
          "header": {
          "id": 10
        },
        "data": {
          "sensors_list": [ {
                              "sensor_id": 14304,
                              "function_id": 1,
                              "operator_id": 1,
                              "granularity": 1,
                              "start": "2016-01-14 06:30:00",
                              "finish": "2016-01-14 06:30:00"
                            } ]
                }
		}
	]"

	realtime_data_request_multi: STRING = "[
		{
          "header": {
          "id": 10
        },
        "data": {
          "sensors_list": [ {
                              "sensor_id": 14304,
                              "function_id": 1,
                              "operator_id": 1,
                              "granularity": 1,
                              "start": "2016-01-14 06:30:00",
                              "finish": "2016-01-14 06:30:00"
                            },
                            {
                              "sensor_id": 4058,
                              "function_id": 1,
                              "operator_id": 1,
                              "granularity": 1,
                              "start": "2015-11-21 06:30:00",
                              "finish": "2015-11-21 14:30:00"
                            } ]
                }
		}
	]"




feature -- cdata

     xml: STRING = "[
		<Esito>0</Esito>
		<Sensore
		  IdSensore=%"4058%"
		  NomeSensore=%"Milano - Parco Nord  Temperatura%"
		  UnitaMisura=%"°C%"
		  IdFunzione=%"1%"
		  Funzione=%"Dato Rilevato%"
		  IdOperatore=%"1%"
		  Operatore=%"Media%"
		  IdPeriodo=%"1%"
		  Periodo=%"10 minuti%">
          <Dati>
            <![CDATA[
              2015-11-21 09:30:00;10.10000000;0
		 	  2015-11-21 09:40:00;10.30000000;0
		 	  2015-11-21 09:50:00;10.50000000;0
              2015-11-21 10:00:00;10.70000000;0
              2015-11-21 10:10:00;10.80000000;0
              2015-11-21 10:20:00;10.90000000;0
              2015-11-21 10:30:00;11.00000000;0
              2015-11-21 10:40:00;11.00000000;0
              2015-11-21 10:50:00;11.10000000;0
              2015-11-21 11:00:00;11.00000000;0
              2015-11-21 11:10:00;11.10000000;0
              2015-11-21 11:20:00;11.10000000;0
              2015-11-21 11:30:00;11.10000000;0
            ]]>
          </Dati>
        </Sensore>
]"




	xml1: STRING = "<Esito>0</Esito><Sensore IdSensore=%"4058%" NomeSensore=%"Milano - Parco Nord  Temperatura%" UnitaMisura=%"°C%" IdFunzione=%"1%" Funzione=%"Dato Rilevato%" IdOperatore=%"1%" Operatore=%"Media%" IdPeriodo=%"1%" Periodo=%"10 minuti%"><Dati><![CDATA[2015-11-21 09:30:00;10.10000000;0%N2015-11-21 09:40:00;10.30000000;0%N2015-11-21 09:50:00;10.50000000;0%N2015-11-21 10:00:00;10.70000000;0%N2015-11-21 10:10:00;10.80000000;0%N2015-11-21 10:20:00;10.90000000;0]]></Dati></Sensore>"





end

--				curlpp::options::Url url(wsdl_uri_);
--				curlpp::options::FreshConnect fresh_connect(true);
--				curlpp::options::ForbidReuse  forbid_reuse(true);

--				headers.push_back("content-type: text/xml;charset=utf-8");
--				std::string soap_action  = "SOAPAction: ";
--				soap_action             += ws_uri_;
--				soap_action             += ws_interface_;
--				soap_action             += "/";
--				soap_action             += ws_endpoint_;

--				//headers.push_back("SOAPAction: http://tempuri.org/IAutenticazione/Login");
--				headers.push_back(soap_action.c_str());
--				headers.push_back("Accept-Encoding: gzip, deflate");
--				//sprintf(buf, "Content-Length: %d", size);
--				//headers.push_back(buf);

--				curlpp::options::HttpHeader h(headers);
--				curlpp::options::Post p(true);

--				curlpp::options::PostFields f(remws_xml_req);
--				curlpp::options::PostFieldSize s(remws_xml_req.size());
--				curlpp::options::Verbose v(false);
--				curlpp::options::UserAgent u("remws gateway via libcurlpp");

--				curlpp::options::WriteStream ws(&ss)


-- Login response

--<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--	<s:Body>
--		<LoginResponse xmlns="http://tempuri.org/">
--			<LoginResult>
--				<LoginResponse xmlns="">
--					<LoginResult>
--						<Token>
--							<Id>EC83F50C-0B47-4973-B2FD-A8B319F687E7</Id>
--							<Scadenza>2015-08-18 16:08:38</Scadenza>
--						</Token>
--						<Esito>0</Esito>
--						<Messaggio>Login affettuata con successo</Messaggio>
--					</LoginResult>
--				</LoginResponse>
--			</LoginResult>
--		</LoginResponse>
--	</s:Body>
--</s:Envelope>

-- Logout response

--<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
--	<s:Body>
--		<LogoutResponse xmlns="http://tempuri.org/">
--			<LogoutResult>
--				<LogoutResponse xmlns="">
--					<LogoutResult>
--						<Esito>0</Esito>
--						<Messaggio>Sessione chiusa con successo</Messaggio>
--					</LogoutResult>
--				</LogoutResponse>
--			</LogoutResult>
--		</LogoutResponse>
--	</s:Body>
--</s:Envelope>


--				io.put_string ("{CURL_TEST_CLIENT} - Trying to login --> attempt: " + (i + 1).out)
--				io.put_new_line

--				login_request.replace_substring_all ("$usr", username)
--				login_request.replace_substring_all ("$pwd", password)
--				response := post (login_request)
--				if attached response as resp then
--					io.put_string ("{CURL_TEST_CLIENT} <<< " + resp)
--					io.put_new_line
--					login_res.from_json (resp)
--				end

--				token_id := login_res.token.id
--				expiry   := login_res.token.expiry

--				io.put_string ("{CURL_TEST_CLIENT} Acquired token: " + token_id)
--				io.put_new_line
--				io.put_string ("{CURL_TEST_CLIENT} Expiry date: " + expiry.formatted_out (default_date_time_format))
--				io.put_new_line


				-- Now logout
--				io.put_string ("{CURL_TEST_CLIENT} - Trying to logout")
--				io.put_new_line

--				if attached token_id as tid and then not tid.is_empty then
--					r.copy (logout_request)
--					r.replace_substring_all ("$tokenid", token_id)

--					io.put_string ("{CURL_TEST_CLIENT} >>> " + r)
--					io.put_new_line

--					response := post(r)
--					if attached response as res then
--						io.put_string ("{CURL_TEST_CLIENT} <<< " + response)
--						io.put_new_line
--						logout_res.from_json (res)
--					end
--				else
--					io.put_string ("{CURL_TEST_CLIENT} Not logged in")
--					io.put_new_line
--					io.put_string ("{CURL_TEST_CLIENT} Login attempt: " + (i + 1).out + " failed")
--					io.put_new_line
--				end
