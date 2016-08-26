indexing

	description:

		"Shared Xace option names"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_SHARED_XACE_OPTION_NAMES

feature -- Access

	options: ET_XACE_OPTION_NAMES is
			-- Option names
		once
			create Result
		ensure
			options_not_void: Result /= Void
		end

end
