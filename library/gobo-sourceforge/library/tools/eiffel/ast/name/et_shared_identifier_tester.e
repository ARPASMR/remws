indexing

	description:

		"Shared identifier equality testers"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-23 11:55:46 +0100 (Sat, 23 Feb 2008) $"
	revision: "$Revision: 6312 $"

class ET_SHARED_IDENTIFIER_TESTER

feature -- Access

	identifier_tester: ET_IDENTIFIER_TESTER is
			-- Identifier equality tester
		once
			create Result
		ensure
			identifier_tester_not_void: Result /= Void
		end

end
