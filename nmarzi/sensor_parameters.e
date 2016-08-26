note
	description: "Summary description for {SENSOR_PARAMETERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENSOR_PARAMETERS
	inherit
		ANY

create
	make,
	make_with_parameters

feature -- Initialization

	make
			--
		do
		end

	make_with_parameters(i, f, o, g: INTEGER)
			-- make with parameters
		do
			id          := i
			function    := f
			operator    := o
			granularity := g
		end

feature -- Access

	id: INTEGER
			-- sensor id

	function: INTEGER
			-- sensor function

	operator: INTEGER
			-- sensor operator

	granularity: INTEGER
			-- sensor granularity

feature -- Status setting

	set_id(i: INTEGER)
			--
		do
			id := i
		end

	set_function(f: INTEGER)
			--
		do
			function := f
		end

	set_operator(o: INTEGER)
			--
		do
			operator := o
		end

	set_granularity(g:INTEGER)
			--
		do
			granularity := g
		end

end
