note
	description: "Summary description for {MEASURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MEASURE

create
	make,
	make_with_parameters

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create date_time.make_empty
		end

	make_with_parameters (dt: STRING; v: DOUBLE)
			-- Initialization with parameters for `Current'
		do
			create date_time.make_empty
			date_time.copy (dt)
			value     := v
		end

feature --Access

	date_time:  STRING
			-- `Current' date and time
	value:      DOUBLE
			-- `Current' measure

feature -- Status setting

	set_date_time (dt: STRING)
			-- Sets `date_time'
		do
			date_time.copy(dt)
		end

	set_value (v: DOUBLE)
			-- Sets `value'
		do
			value := v
		end

end
