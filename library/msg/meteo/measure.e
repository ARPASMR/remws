note
	description : "Summary description for {MEASURE}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:21 (dom 10 dic 2017, 19.44.21, CET) buck $"
	revision    : "$Revision 48 $"

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
