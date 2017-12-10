note
	description: "Summary description for {MSG_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MSG_CONSTANTS

	inherit
		INTERNAL_TAGS
		INTERNAL_MESSAGES

feature -- Constants

	--| ---------------------------------------------------------------------------
	--| Token tag
	--| ---------------------------------------------------------------------------
	token_tag:                                   STRING = "$tokenid"
			-- Token tag

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
	login_response_id:                           INTEGER do Result := login_request_id + response_id_offset end
			-- Message id for `LOGIN_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| LOGOUT request and response constants
	--| ---------------------------------------------------------------------------
	logout_request_id:                           INTEGER = 2
			-- Message id for `LOGOUT_REQUEST'
	logout_response_id:                          INTEGER do Result := response_id_offset + logout_request_id end
			-- Message id for `LOGOUT_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| STATION STATUS LIST request and response constants
	--| ---------------------------------------------------------------------------
	station_status_list_request_id:              INTEGER = 3
			--Message id for  `STATION_STATUS_LIST_REQUEST'
	station_status_list_response_id:             INTEGER do Result := response_id_offset + station_status_list_request_id end
			-- Message id for `STATION_STATUS_LIST_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| STATION TYPES LIST request and response constants
	--| ---------------------------------------------------------------------------
	station_types_list_request_id:               INTEGER = 4
			-- Message id for `STATION_TYPES_LIST_REQUEST'
	station_types_list_response_id:              INTEGER do Result := response_id_offset + station_types_list_request_id end
			-- Message id for `STATION_TYPES_LIST_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| PROVINCE LIST request and response constants
	--| ---------------------------------------------------------------------------
	province_list_request_id:                    INTEGER = 5
			-- Message id for `PROVINCE_LIST_REQUEST'
	province_list_response_id:                   INTEGER do Result := response_id_offset + province_list_request_id end
			-- Message id for `PROVINCE_LIST_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| MUNICIPALITY LIST request and response constants
	--| ---------------------------------------------------------------------------
	municipality_list_request_id:                INTEGER = 6
			-- Message id for `MUNICIPALITY_LIST_REQUEST'
	municipality_list_response_id:               INTEGER do Result := response_id_offset + municipality_list_request_id end
			-- Message id for `MUNICIPALITY_LIST_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| STATION LIST request and response constants
	--| ---------------------------------------------------------------------------
	station_list_request_id:                     INTEGER = 7
			-- Message id for `STATION_LIST_REQUEST'
	station_list_response_id:                    INTEGER do Result := response_id_offset + station_list_request_id end
			-- Message id for `STATION_LIST_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| SENSOR TYPE LIST request and response constants
	--| ---------------------------------------------------------------------------
	sensor_type_list_request_id:                 INTEGER = 8
			-- Message id for `SENSOR_TYPE_LIST_REQUEST'
	sensor_type_list_response_id:                INTEGER do Result := response_id_offset + sensor_type_list_request_id end
			-- Message id for `SENSOR_TYPE_LIST_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| SENSOR LIST request and response constants
	--| ---------------------------------------------------------------------------
	sensor_list_request_id:                      INTEGER = 9
			-- Message id for `SENSOR_LIST_REQUEST'
	sensor_list_response_id:                     INTEGER do Result := response_id_offset + sensor_list_request_id end
			-- Message id for `SENSOR_LIST_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| REALTIME DATA request and response constants
	--| ---------------------------------------------------------------------------
	realtime_data_request_id:                    INTEGER = 10
			-- Message id for `REALTIME_DATA_REQUEST'
	realtime_data_response_id:                   INTEGER do Result := response_id_offset + realtime_data_request_id end
			-- Message id for `REALTIME_DATA_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| QUERY_TOKEN request and response constants
	--| ---------------------------------------------------------------------------
	query_token_request_id:                      INTEGER = 11
			-- Message id for `QUERY_TOKEN_REQUEST'
	query_token_response_id:                     INTEGER do Result := query_token_request_id + response_id_offset end
			-- Message id for `QUERY_TOKEN_RESPONSE'

	--| ---------------------------------------------------------------------------
	--| STANDARD DATA request and response constants
	--| ---------------------------------------------------------------------------
	standard_data_request_id:                    INTEGER = 12
			-- Message id for `STANDARD_DATA_REQUEST'
	standard_data_response_id:                   INTEGER do Result := standard_data_request_id + response_id_offset end
			-- Message id for `STANDARD_DATA_RESPONSE'

end
