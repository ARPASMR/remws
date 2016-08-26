note
	description: "Summary description for {LOGGING_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
