note
	description: "Summary description for {MSG_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MSG_CONSTANTS

feature -- Constants

	--| ---------------------------------------------------------------------------
	--| Token tag
	--| ---------------------------------------------------------------------------
	token_tag:                                   STRING = "$tokenid"
			-- Token tag

	--| ---------------------------------------------------------------------------
	--| Is it worth to ask for the current token and so to define a message for
	--| this?
	--| ---------------------------------------------------------------------------
	--| query_token_request_id:                      INTEGER = 0
	--| query_token_request_parnum:                  INTEGER = 0
	--| query_token_response_id:                     INTEGER = once Result := query_token_request_id + response_id_offset end
	--| query_token_response_parnum                  INTEGER = 1

	--| ---------------------------------------------------------------------------
	--| Response id offset
	--| ---------------------------------------------------------------------------
	response_id_offset:                          INTEGER = 1000
			-- Given a message request having `id' = 23
			-- the associated response should have `id' = `id' + `response_id_offset'

	--| ---------------------------------------------------------------------------
	--| Internal error parameters number
	--| ---------------------------------------------------------------------------
	internal_error_parnum:                       INTEGER = 2


	--| ---------------------------------------------------------------------------
	--| LOGIN request and response constants
	--| ---------------------------------------------------------------------------
	login_request_id:                            INTEGER = 1
			-- Message id for `LOGIN_REQUEST'
	login_request_parnum:                        INTEGER = 2
			-- Message parameters number for `LOGIN_REQUEST'
	login_response_id:                           INTEGER do Result := login_request_id + response_id_offset end
			-- Message id for `LOGIN_RESPONSE'
	login_response_success_parnum:               INTEGER = 4
			-- Message parameters number for a successful `LOGIN_RESPONSE'
	login_response_error_parnum:                 INTEGER = 2
			-- Message parameters number for `LOGIN_RESPONSE' containing errors

	--| ---------------------------------------------------------------------------
	--| LOGOUT request and response constants
	--| ---------------------------------------------------------------------------
	logout_request_id:                           INTEGER = 2
			-- Message id for `LOGOUT_REQUEST'
	logout_request_parnum:                       INTEGER = 1
			-- Message parameters number for `LOGOUT_REQUEST'
	logout_response_id:                          INTEGER do Result := response_id_offset + logout_request_id end
			-- Message id for `LOGOUT_RESPONSE'
	logout_response_success_parnum:              INTEGER = 2
			-- Message parameters number for a successful `LOGOUT_RESPONSE'
	logout_response_error_parnum:                INTEGER do Result := logout_response_success_parnum end
			-- Message parameters number for `LOGOUT_RESPONSE' containing errors

	--| ---------------------------------------------------------------------------
	--| STATION STATUS LIST request and response constants
	--| ---------------------------------------------------------------------------
	station_status_list_request_id:              INTEGER = 3
			--Message id for  `STATION_STATUS_LIST_REQUEST'
	station_status_list_request_parnum_no_token: INTEGER = 0
			-- Message parameters number when no token is used
	station_status_list_request_parnum_token:    INTEGER = 1
			-- Message parameters number when token is used
	station_status_list_response_id:             INTEGER do Result := response_id_offset + station_status_list_request_id end
			-- Message id for `STATION_STATUS_LIST_RESPONSE'
	station_status_list_response_parnum:         INTEGER = 1
			-- Message parameters number for `STATION_STATUS_LIST_RESPONSE'
			-- List after the parameter can be void or containing n elements

	--| ---------------------------------------------------------------------------
	--| STATION TYPES LIST request and response constants
	--| ---------------------------------------------------------------------------
	station_types_list_request_id:               INTEGER = 4
			-- Message id for `STATION_TYPES_LIST_REQUEST'
	station_types_list_request_parnum_no_token:  INTEGER = 0
			-- Message parameters number when no token is used
	station_types_list_request_parnum_token:     INTEGER = 1
			-- Message parameters number when token is used
	station_types_list_response_id:              INTEGER do Result := response_id_offset + station_types_list_request_id end
			-- Message id for `STATION_TYPES_LIST_RESPONSE'
	station_types_list_response_parnum:          INTEGER = 1
			-- Message parameters number for `STATION_TYPES_LIST_RESPONSE'
			-- List after the parameter can be void or containing n elements

	--| ---------------------------------------------------------------------------
	--| PROVINCE LIST request and response constants
	--| ---------------------------------------------------------------------------
	province_list_request_id:                    INTEGER = 5
			-- Message id for `PROVINCE_LIST_REQUEST'
	province_list_request_parnum_no_token:       INTEGER = 0
			-- Message parameters number when non token is used
	province_list_request_parnum_token:          INTEGER = 1
			-- Message parameters number when token is used
	province_list_response_id:                   INTEGER do Result := response_id_offset + province_list_request_id end
			-- Message id for `PROVINCE_LIST_RESPONSE'
	province_list_response_parnum:               INTEGER = 1
			-- Message parameters number for `PROVINCE_LIST_RESPONSE'
			-- List after the parameter can be void or containing n elements

	--| ---------------------------------------------------------------------------
	--| MUNICIPALITY LIST request and response constants
	--| ---------------------------------------------------------------------------
	municipality_list_request_id:                INTEGER = 6
			-- Message id for `MUNICIPALITY_LIST_REQUEST'
	municipality_list_request_parnum_no_token:   INTEGER = 1
			-- Message parameters number when no token is used
	municipality_list_request_parnum_token:      INTEGER = 2
			-- Message parameters number when token is used
	municipality_list_response_id:               INTEGER do Result := response_id_offset + municipality_list_request_id end
			-- Message id for `MUNICIPALITY_LIST_RESPONSE'
	municipality_list_response_parnum:           INTEGER = 1
			-- Message parameters number for `MUNICIPALITY_LIST_RESPONSE'
			-- List after the parameter can be void or containing n elements

	--| ---------------------------------------------------------------------------
	--| STATION LIST request and response constants
	--| ---------------------------------------------------------------------------
	station_list_request_id:                     INTEGER = 7
			-- Message id for `STATION_LIST_REQUEST'
	station_list_request_parnum_no_token:        INTEGER = 6
			-- Message parameters number when no token is used
	station_list_request_parnum_token:           INTEGER = 7
			-- Message parameters number when token is used
	station_list_response_id:                    INTEGER do Result := response_id_offset + station_list_request_id end
			-- Message id for `STATION_LIST_RESPONSE'
	station_list_response_parnum:                INTEGER = 2
			-- Message parameters number for `STATION_LIST_RESPONSE'
			-- Lists after the parameter can be void or containing n elements

	--| ---------------------------------------------------------------------------
	--| SENSOR TYPE LIST request and response constants
	--| ---------------------------------------------------------------------------
	sensor_type_list_request_id:                 INTEGER = 8
			-- Message id for `SENSOR_TYPE_LIST_REQUEST'
	sensor_type_list_request_parnum_no_token:    INTEGER = 1
			-- Message parameters number when no token is used
	sensor_type_list_request_parnum_token:       INTEGER = 2
			-- Message parameters number when token is used
	sensor_type_list_response_id:                INTEGER do Result := response_id_offset + sensor_type_list_request_id end
			-- Message id for `SENSOR_TYPE_LIST_RESPONSE'
	sensor_type_list_response_parnum:            INTEGER = 1
			-- Message parameters number for `SENSOR_TYPE_LIST_RESPONSE'
			-- Lists after the parameter can be void or containing elements

	--| ---------------------------------------------------------------------------
	--| SENSOR LIST request and response constants
	--| ---------------------------------------------------------------------------
	sensor_list_request_id:                      INTEGER = 9
			-- Message id for `SENSOR_LIST_REQUEST'
	sensor_list_request_parnum_no_token:         INTEGER = 6
			-- Message parameters number when no token is used
	sensor_list_request_parnum_token:            INTEGER = 5
			-- Message parameters number when token is used
	sensor_list_response_id:                     INTEGER do Result := response_id_offset + sensor_list_request_id end
			-- Message id for `SENSOR_LIST_RESPONSE'
	sensor_list_response_parnum:                 INTEGER = 1
			-- Message parameters number for `SENSOR_LIST_RESPONSE'
			-- Lists after the parameter can be voif or containing elements

	--| ---------------------------------------------------------------------------
	--| REALTIME DATA request and response constants
	--| ---------------------------------------------------------------------------
	realtime_data_request_id:                    INTEGER = 10
			-- Message id for `REALTIME_DATA_REQUEST'
	realtime_data_request_parnum_no_token:       INTEGER = 1
			-- Message parameters number when no token is used
	realtime_data_request_parnum_token:          INTEGER = 2
			-- Message parameters number when token is used
	realtime_data_response_id:                   INTEGER do Result := response_id_offset + realtime_data_request_id end
			-- Message id for `REALTIME_DATA_RESPONSE'
	realtime_data_response_parnum:               INTEGER = 1
			-- Message parameters number for `REALTIME_DATA_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| QUERY TOKEN request and response constants
	--| ---------------------------------------------------------------------------
	query_token_request_id:                      INTEGER = 11
			-- Message id for `QUERY_TOKEN_REQUEST'
	query_token_response_id:                     INTEGER do Result := response_id_offset + query_token_request_id end
			-- Message id for `QUERY_TOKEN_RESPONSE'

end
