indexing

	description:

		"Shared access to EWG_ANY_FEATURE_NAMES"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:45 $"
	revision: "$Revision: 1.3 $"

class EWG_SHARED_ANY_FEATURE_NAMES

feature -- Singleton access

	any_feature_names: EWG_ANY_FEATURE_NAMES is
			-- Singleton access to EWG_ANY_FEATURE_NAMES
		once
			create Result.make
		ensure
			names_not_void: Result /= Void
		end

end
