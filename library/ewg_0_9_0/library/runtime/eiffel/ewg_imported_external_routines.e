indexing

	description:

		"Imported external routines that are not portable"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:17:01 $"
	revision: "$Revision: 1.1 $"

class EWG_IMPORTED_EXTERNAL_ROUTINES

feature {ANY} -- Access

	external_garbage_collector: EWG_EXTERNAL_GARBAGE_COLLECTOR_ROUTINES is
			-- External garbage collector routines
		once
			create Result
		ensure
			result_not_void: Result /= Void
		end

	external_garbage_collector_: like external_garbage_collector is
		obsolete "Use `external_garbage_collector' instead"
		do
			Result := external_garbage_collector
		ensure
			result_not_void: Result /= Void
		end

	external_memory: EWG_EXTERNAL_MEMORY_ROUTINES is
			-- External memory routines; Needs to be expanded because
			-- sometimes routines from there need to be called from
			-- withing `dispose'.
		once
			create Result
		ensure
			result_not_void: Result /= Void
		end

	external_memory_: like external_memory is
		obsolete "Use `external_memory' instead"
		do
			Result := external_memory
		ensure
			result_not_void: Result /= Void
		end

	external_string: EWG_EXTERNAL_STRING_ROUTINES is
			-- External string routines
		once
			create Result
		ensure
			result_not_void: Result /= Void
		end

	external_string_: like external_string is
		obsolete "Use `external_string' instead"
		do
			Result := external_string
		ensure
			result_not_void: Result /= Void
		end

end
