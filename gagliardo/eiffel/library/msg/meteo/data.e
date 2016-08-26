note
	description: "Summary description for {DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATA

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
			create function_name.make_empty
			create operator.make_empty
			create interval_description.make_empty
		end

feature -- Access

	function_id:          INTEGER
			-- Function id	
	function_name:        STRING
			-- Function_name
	operator_id:          INTEGER
			-- Computation operator id
	operator:             STRING
			-- Computation operator name
	interval_id:          INTEGER
			-- Time interval id
	interval_description: STRING
			-- Time interval name

feature -- Status setting

	set_function_id (an_id: INTEGER)
			-- Sets `function_id'
		do
			function_id := an_id
		end

	set_function_name (a_name: STRING)
			-- sets `function_name'
		do
			function_name.copy (a_name)
		end

	set_operator_id (an_id: INTEGER)
			-- Sets `operator_id'
		do
			operator_id := an_id
		end

	set_operator (a_name: STRING)
			-- Sets `operator'
		do
			operator.copy (a_name)
		end

	set_interval_id (an_id: INTEGER)
			-- Sets `interval_id'
		do
			interval_id := an_id
		end

	set_interval_description (a_description: STRING)
			-- Sets `interval_description'
		do
			interval_description.copy (a_description)
		end

feature -- reporting

	out: STRING
			-- `DATA_SEGMENT' as string
		do
			Result := "{function id: " + function_id.out + " function name:        " + function_name        + "%N"
			Result.append (" operator id: " + operator_id.out + " operator:             " + operator             + "%N")
			Result.append (" interval id: " + interval_id.out + " interval_description: " + interval_description + "}%N")
		end

end
