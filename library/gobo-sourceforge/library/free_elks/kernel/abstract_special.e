indexing
	description: "Ancestor of SPECIAL to perform queries on SPECIAL without knowing its actual generic type."
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 2005, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2007-02-18 12:15:30 +0100 (Sun, 18 Feb 2007) $"
	revision: "$Revision: 5897 $"

deferred class
	ABSTRACT_SPECIAL

feature -- Measurement

	count: INTEGER is
			-- Count of special area		
		deferred
		ensure
			count_non_negative: Result >= 0
		end

end
