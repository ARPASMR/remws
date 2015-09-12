note
	description: "Summary description for {DEFAULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULTS

feature -- Implementation

	default_port:             INTEGER = 9090
			-- Default listening port

	default_date_time_format: STRING  = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"
			-- Default date time format string

end
