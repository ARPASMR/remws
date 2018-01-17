note
	description : "Summary description for {STANDARD_DATA_RECORD}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:21 (dom 10 dic 2017, 19.44.21, CET) buck $"
	revision    : "$Revision 48 $"

class
	STANDARD_DATA_RECORD

inherit
	DEFAULTS
	redefine
		out
	end
	ANY
	redefine
		out
	end

create
	make,
	make_from_parameters

feature -- Access

	d: DATE_TIME
		-- Data `DATE_TIME'
	v: REAL
		-- Data value
	s: INTEGER
		-- Data status

feature -- Status setting

	set_dt (a_dt: STRING)
			-- Sets `d' from string
		do
			if d.date_time_valid (a_dt, default_date_time_format) then
				d := create {DATE_TIME}.make_from_string (a_dt, default_date_time_format)
			end
		end

	set_value (a_value: REAL)
			-- Sets `v' to `a_value'
		do
			v := a_value
		end

	set_status (a_status: INTEGER)
			-- Sets `s' to `a_status'
		do
			s := a_status
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create d.make_now
		end

	make_from_parameters (a_date_time: DATE_TIME; a_value: REAL; a_status: INTEGER)
			-- Initialization of `Current' with parameters
		require
			attached_date_time: attached a_date_time
		do
			create d.make_by_date_time (a_date_time.date, a_date_time.time)
			v := a_value
			s := a_status
		end

feature -- Representation

	out: STRING
			-- `Current` `STRING' representation
		do
			Result := "[" + d.formatted_out (default_date_time_format) + " " + v.out + " " + s.out + "]"
		end

end
