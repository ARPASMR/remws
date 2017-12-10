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

	default_gc_monitoring_message_number: INTEGER = 10000
			-- Default GC monitoring message number

	default_gc_memory_threshold: INTEGER = 40000000
			-- Default GC memory threshold

	default_runtime_max_memory: INTEGER = 160000000
			-- Default maximum amount of memory the run-time can allocate.

	default_gc_coalesce_period: INTEGER = 2
			-- Default GC coalesce period

	default_gc_collection_period: INTEGER = 2
			-- Default GC collection period

end
