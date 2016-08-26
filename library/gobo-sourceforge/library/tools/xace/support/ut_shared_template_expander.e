indexing

	description:

		"Provides global access to a TEMPLATE_EXPANDER"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2001, Andreas Leitner and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class UT_SHARED_TEMPLATE_EXPANDER

feature -- Access

	template_expander: UT_TEMPLATE_EXPANDER is
			-- Shared template expander
		once
			create Result.make
		ensure
			template_expander_not_void: Result /= Void
		end

end
