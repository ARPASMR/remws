note
	description : "Summary description for {LOGGING_I}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:14 (dom 10 dic 2017, 19.44.14, CET) buck $"
	revision    : "$Revision 48 $"

deferred class
	LOGGING_I

feature -- Logging

	is_logging_enabled: BOOLEAN
			-- Is logging enabled
		deferred
		end

	log (a_string: STRING; priority: INTEGER)
			-- Logs `a_string'
		deferred
		end

feature {NONE} -- Implementation

	logger: detachable LOG_LOGGING_FACILITY

end
