note
	description : "Summary description for {SENSOR_STANDARD_RESPONSE_DATA}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:21 (dom 10 dic 2017, 19.44.21, CET) buck $"
	revision    : "$Revision 48 $"

class
	SENSOR_STANDARD_RESPONSE_DATA

inherit
	ANY
	redefine
		out
	end

create
	make,
	make_from_id

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create sensor_name.make_empty
			create measure_unit.make_empty
			create function_name.make_empty
			create operator_name.make_empty
			create granularity_description.make_empty
			create data.make (0)
		end

	make_from_id (an_id: INTEGER)
			-- Initialization for `Current'.
		do
			create sensor_name.make_empty
			create measure_unit.make_empty
			create function_name.make_empty
			create operator_name.make_empty
			create granularity_description.make_empty
			create data.make (0)

			sensor_id := an_id
		end

feature -- Access

	sensor_id: INTEGER
			-- Sensor id
	sensor_name: STRING
			-- Sensor name
	measure_unit: STRING
			-- Measure unit
	function_id: INTEGER
			-- Function id
	function_name: STRING
			-- Function name
	operator_id: INTEGER
			-- Operator id
	operator_name: STRING
			-- Operator name
	granularity_id: INTEGER
			-- Time granularity id
	granularity_description: STRING
			-- Time granularity description
	data: ARRAYED_LIST[STANDARD_DATA_RECORD]
			-- Data records

feature -- Status setting

	set_sensor_id (an_id: INTEGER)
			-- Sets `sensor_id'
		do
			sensor_id := an_id
		end

	set_sensor_name (a_name: STRING)
			-- Sets `sensor_name'
		do
			sensor_name.copy (a_name)
		end

	set_measure_unit (a_unit: STRING)
			-- Sets `measure_unit'
		do
			measure_unit.copy (a_unit)
		end

	set_function_id (an_id: INTEGER)
			-- Sets `function_id'
		do
			function_id := an_id
		end

	set_function_name (a_name: STRING)
			-- Sets `function_name'
		do
			function_name.copy (a_name)
		end

	set_operator_id (an_id:INTEGER)
			-- Sets `operator_id'
		do
			operator_id := an_id
		end

	set_operator_name (a_name: STRING)
			-- Sets `operator_name'
		do
			operator_name.copy (a_name)
		end

	set_granularity_id (an_id: INTEGER)
			-- Sets `granularity_id'
		do
			granularity_id := an_id
		end

	set_granularity_description (a_description: STRING)
			-- Sets `granularity_description'
		do
			granularity_description.copy (a_description)
		end

feature -- Status reporting

	out: STRING
			-- String representation
		do
			Result := sensor_id.out + " " + sensor_name
		end

end
