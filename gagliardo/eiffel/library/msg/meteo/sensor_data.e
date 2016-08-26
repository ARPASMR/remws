note
	description: "Summary description for {SENSOR_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENSOR_DATA

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
			create unit.make_empty
			create station.make
			create type.make
			create status.make
			create name.make_empty
		end

feature -- Access

	id:          INTEGER
			-- Sensor id
	name:        STRING
			-- Sensor name
	status:      SENSOR_STATUS
			-- Sensor status
	type:        SENSOR_TYPE
			-- Sensor type
	station:     STATION_IDNAME
			-- Station which have installed the sensor
	unit:        STRING
			-- Measure unit
	sample_rate: INTEGER
			-- Sample rate
	altitude:    INTEGER
			-- Sensor altitude
	gb_north:    REAL
			-- Sensor Gauss Boaga north coordinate
	gb_est:      REAL
			-- Sensor Gauss Boaga est coordinate
	latitude:    REAL
			-- Sensor latitude coordinate
	longitude:   REAL
			-- Sensor longitude coordinate
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

	set_status (a_status: SENSOR_STATUS)
			-- Sets `status'
		do
			status := a_status
		end

	set_type (a_type: SENSOR_TYPE)
			-- Sets `type'
		do
			type := a_type
		end

	set_station (a_station: STATION_IDNAME)
			-- Sets `status'
		do
			station := a_station
		end

	set_unit (a_unit: STRING)
			-- Sets `unit'
		do
			unit.copy (a_unit)
		end

	set_sample_rate (a_rate: INTEGER)
			-- Sets `sample_rate'
		do
			sample_rate := a_rate
		end

	set_altitude (an_altitude: INTEGER)
			-- Sets `altitude'
		do
			altitude := an_altitude
		end

	set_gb_north (a_gb_north: REAL)
			-- Sets `gb_north'
		do
			gb_north := a_gb_north
		end

	set_gb_est (a_gb_est: REAL)
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
			-- `SENSOR' as string
		do
			create Result.make_empty
			Result := "{id: " + id.out + ", name: " + name + "}"
		end

end
