indexing

	description:

		"Shared equality testers for Eiffel features with their target base type"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-30 16:12:36 +0200 (Wed, 30 Apr 2008) $"
	revision: "$Revision: 6389 $"

class ET_SHARED_TARGETED_FEATURE_TESTER

feature -- Access

	targeted_feature_tester: ET_TARGETED_FEATURE_TESTER is
			-- Targeted feature equality tester
		once
			create Result
		ensure
			targeted_feature_tester_not_void: Result /= Void
		end

end
