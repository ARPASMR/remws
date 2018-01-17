note
	description : "Summary description for {STATION}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:21 (dom 10 dic 2017, 19.44.21, CET) buck $"
	revision    : "$Revision 48 $"

class
	STATION

inherit
	ANY

	redefine
		out
	end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create name.make_empty
			create status.make
			create types.make (0)
			create municipality.make
			create address.make_empty
		end

feature -- Access

	id:                INTEGER
			-- Station identifier

	name:              STRING
			-- Station name

	status:            STATION_STATUS
			-- Station status

	types:             ARRAYED_LIST[STATION_TYPE]
			-- Station type

	municipality:      MUNICIPALITY
			-- Station municipality

	address:           STRING
			-- Station address

	altitude:          INTEGER
			-- Station altitude

	gb_north:          INTEGER
			-- Station Gauss Boaga north coordinate

	gb_est:            INTEGER
			-- Station Gauss Boaga et coordinate

	latitude:          REAL
			-- Station latitude coordinate

	longitude:         REAL
			-- Station longitude coordinate

	latitude_degrees:  INTEGER
			-- Station latitude degrees
		do
			Result := latitude.floor
		end

	latitude_minutes:  INTEGER
			-- Station latitude minutes
		do
			Result := ((latitude - latitude.floor) * 60.0).floor
		end

	latitude_seconds:  REAL
			-- Station latitude seconds
		do
			Result := (((latitude - latitude.floor) * 60.0) - latitude_minutes) * 60.0
		end

	longitude_degrees: INTEGER
			-- Station longitude degrees
		do
			Result := longitude.floor
		end

	longitude_minutes: INTEGER
			-- Station longitude minutes
		do
			Result := ((longitude - longitude.floor) * 60.0).floor
		end

	longitude_seconds: REAL
			-- Station longitude seconds
		do
			Result := (((longitude - longitude.floor) * 60.0) - longitude_minutes) * 60.0
		end

feature -- Status setting

	set_id (an_id: INTEGER)
			-- Sets `id'
		do
			id := an_id
		end

	set_name (a_name: STRING)
			-- Sets `name'
		do
			name.copy (a_name)
		end

	set_status (a_status: STATION_STATUS)
			-- Sets `status'
		do
			status := a_status
		end

	set_types (a_type_array: ARRAY[STATION_TYPE])
			-- Sets `types'
		do

		end

	set_municipality (a_municipality: MUNICIPALITY)
			-- Sets `municipality'
		do
			municipality := a_municipality
		end

	set_address (an_address: STRING)
			-- Sets `address'
		do
			address.copy (an_address)
		end

	set_altitude (an_altitude: INTEGER)
			-- Sets `altitude'
		do
			altitude := an_altitude
		end

	set_gb_north (a_gb_north: INTEGER)
			-- Sets `gb_north'
		do
			gb_north := a_gb_north
		end

	set_gb_est (a_gb_est: INTEGER)
			-- Sets `gb_est'
		do
			gb_est := a_gb_est
		end

	set_latitude (a_latitude: REAL)
			-- Sets `latitude'
		do
			latitude := a_latitude
		end

	set_longitude (a_longitude: REAL)
			-- Sets `longitude'
		do
			longitude := a_longitude
		end

feature -- Reporting

	out: STRING
			-- `STATION_TYPE' as string
		do
			create Result.make_empty
			Result := "{id: " + id.out + ", name: " + name + "}"
		end

end
