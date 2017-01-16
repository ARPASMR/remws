note
	description: "Summary description for {SENSOR_REALTIME_REQUEST_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENSOR_REALTIME_REQUEST_DATA

inherit

	DEFAULTS

	redefine
		out
	end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create start.make_now
			create finish.make_now
		end

feature -- Access

	sensor_id: INTEGER
			-- Sensor id
	function_code: INTEGER
			-- Function code. Refer to `FUNCTION_CODES' class.
	applied_operator: INTEGER
			-- Applied operator id. Refer to `APPLIED_OPERATOR_CODES' class.
	time_granularity: INTEGER
			-- Time granularity code. Refer to `TIME_GRANULARITY_CODES' class.
	start: DATE_TIME
			-- Request time interval begin time.
	finish: DATE_TIME
			-- Request time interval finish time.

feature -- Status setting

	set_sensor_id (an_id: INTEGER)
			-- Sets `sensor_id'
		do
			sensor_id := an_id
		end

	set_function_code (a_code: INTEGER)
			-- Sets `function_code'
		do
			function_code := a_code
		end

	set_applied_operator (an_operator: INTEGER)
			-- Sets `applied_operator'
		do
			applied_operator := an_operator
		end

	set_time_granularty (a_granularity: INTEGER)
			-- Sets `time_granularity'
		do
			time_granularity := a_granularity
		end

	set_start (a_datetime: DATE_TIME)
			-- Sets `start'
		do
			start := a_datetime
		end

	set_finish (a_datetime: DATE_TIME)
			-- Sets `finish'
		do
			finish := a_datetime
		end

feature -- Reporting

	out: STRING
			-- `Current' string representation.
		do
			Result := "{sensor_id: " + sensor_id.out + " function_code: " + function_code.out + " applied_operator: " + applied_operator.out +
			          " time_granularity: " + time_granularity.out + " start: " + start.formatted_out (default_date_time_format) + " finish: " +
			          finish.formatted_out (default_date_time_format) + "}"
		end

end
