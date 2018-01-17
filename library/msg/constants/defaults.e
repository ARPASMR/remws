note
	description : "Summary description for {DEFAULTS}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

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
