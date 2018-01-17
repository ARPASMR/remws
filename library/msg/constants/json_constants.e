note
	description : "Summary description for {JSON_CONSTANTS}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

class
	JSON_CONSTANTS

feature -- JSON constants

	json_username_tag:                           STRING = "username"
			-- JSON username tag
	json_password_tag:                           STRING = "password"
			-- JSON password tag
	json_header_tag:                             STRING = "header"
			-- JSON header tag
	json_data_tag:                               STRING = "data"
			-- JSON data tag
	json_outcome_tag:							 STRING = "outcome"
			-- JSON outcome tag
	json_message_tag:							 STRING = "message"
			-- JSON message tag
	json_tokenid_tag:							 STRING = "tokenid"
			-- JSON tokenid tag
	json_expiry_tag:                             STRING = "expiry"
			-- JSON expiry tag
	json_province_tag:                           STRING = "province"
			-- JSON province tag
	json_provinces_list_tag:                     STRING = "provinces_list"
			-- JSON provinces list tag
	json_municipalities_list_tag:                STRING = "municipalities_list"
			-- JSON municipalities list tag
	json_istat_code_tag:                         STRING = "istat_code"
			-- JSON istat code tag
	json_id_tag:                                 STRING = "id"
			-- JSON message id tag
	json_name_tag:                               STRING = "name"
			-- JSON realtime data message name tag
	json_sensor_data_list_tag:                   STRING = "sensor_data_list"
			-- JSON realtime data message sensor list data tag
	json_sensor_id_tag:                          STRING = "sensor_id"
			-- JSON sensor id tag
	json_function_id_tag:                        STRING = "function_id"
			-- JSON function id tag
	json_operator_id_tag:                        STRING = "operator_id"
			-- JSON operator id tag
	json_granularity_tag:                        STRING = "granularity"
			-- JSON granularity tag
	json_granularity_id_tag:                     STRING = "granularity_id"
			-- JSON granularity id tag
	json_granularity_name_tag:                   STRING = "granularity_name"
			-- JSON granularity name tag
	json_start_tag:                              STRING = "start"
			-- JSON start tag
	json_finish_tag:                             STRING = "finish"
			-- JSON finish tag
	json_sensor_name_tag:                        STRING = "sensor_name"
			-- JSON sensor name tag
	json_sensor_tag:                             STRING = "sensor"
			-- JSON sensor tag
	json_sensor_measure_unit_tag:                STRING = "sensor_measure_unit"
			-- JSON sensor measure unit tag
	json_function_name_tag:                      STRING = "function_name"
			-- JSON function name tag
	json_operator_name_tag:                      STRING = "operator_name"
			-- JSON operator name tag
	json_data_row_tag:                           STRING = "datarow"
			-- JSON realtime data message data row tag
	json_status_list_tag:                        STRING = "status_list"
			-- JSON station status list message status list tag
	json_types_list_tag:                         STRING = "types_list"
			-- JSON station types list tag
	json_stations_list_tag:                      STRING = "stations_list"
			-- JSON stations list tag
	json_station_name_tag:                       STRING = "station_name"
			-- JSON station name tag
	json_municipality_tag:                       STRING = "municipality"
			-- JSON municipality tag
	json_type_tag:                               STRING = "type"
			-- JSON type tag
	json_types_tag:                              STRING = "types"
			-- JSON types tag
	json_status_tag:                             STRING = "status"
			-- JSON status tag
	json_station_tag:                            STRING = "station"
			-- JSON station tag
	json_address_tag:                            STRING = "address"
			-- JSON address tag
	json_altitude_tag:                           STRING = "altitude"
			-- JSON altitude tag
	json_gb_north_tag:                           STRING = "gb_north"
			-- JSON Gauss Boaga north tag
	json_gb_est_tag:                             STRING = "gb_est"
			-- JSON Gauss Boaga east tag
	json_latitude_tag:                           STRING = "latitude"
			-- JSON latitude tag
	json_latitude_degrees_tag:                   STRING = "latitude_degrees"
			-- JSON latitude degrees tag
	json_latitude_minutes_tag:                   STRING = "latitude_minutes"
			-- JSON latitude minutes tag
	json_latitude_seconds_tag:                   STRING = "latitude_seconds"
			-- JSON latitude seconds tag
	json_longitude_tag:                          STRING = "longitude"
			-- JSON longitude tag
	json_longitude_degrees_tag:                  STRING = "longitude_degrees"
			-- JSON longitude degrees tag
	json_longitude_minutes_tag:                  STRING = "longitude_minutes"
			-- JSON longitude minutes tag
	json_longitude_seconds_tag:                  STRING = "longitude_seconds"
			-- JSON longitude seconds tag
	json_sensors_list_tag:						 STRING = "sensors_list"
			-- JSON sensors list tag
	json_sensor_types_list_tag:			     	 STRING = "sensor_types_list"
			-- JSON sensor types list tag
	json_d_tag:                                  STRING = "D"
			-- JSON date time tag for standard data records
	json_v_tag:                                  STRING = "V"
			-- JSON value tag for standard data records
	json_s_tag:                                  STRING = "S"
			-- JSON status tag for standard data records

	------------------------------------------------------------------------------------
	--| JSON character constants
	------------------------------------------------------------------------------------
	space:                                       STRING = " "
			-- Space
	double_space:                                STRING = "  "
			-- Double space
	tab:                                         STRING = "%T"
			-- Tab
	left_brace:                                  STRING = "{"
			-- Opening brace
	right_brace:                                 STRING = "}"
			-- Closing brace
	double_quotes:                               STRING = "%""
			-- Double quotes
	colon:                                       STRING = ":"
			-- Colon
	comma:                                       STRING = ","
			-- Comma
	left_bracket:                                STRING = "["
			-- Opening bracket
	right_bracket:                               STRING = "]"
			-- Closing bracket



end
