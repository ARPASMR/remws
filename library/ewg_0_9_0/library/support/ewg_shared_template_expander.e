indexing

	description:

		"Provides global access to a EWG_TEMPLATE_EXPANDER"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2001, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:17:01 $"
	revision: "$Revision: 1.1 $"

class EWG_SHARED_TEMPLATE_EXPANDER

feature -- Access

	template_expander: EWG_TEMPLATE_EXPANDER is
			-- Shared template expander
		once
			create Result.make
		ensure
			template_expander_not_void: Result /= Void
		end

end
