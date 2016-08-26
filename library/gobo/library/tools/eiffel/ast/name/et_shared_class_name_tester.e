indexing

	description:

		"Shared class name equality testers"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_SHARED_CLASS_NAME_TESTER

feature -- Access

	class_name_tester: ET_CLASS_NAME_TESTER is
			-- Class name equality tester
		once
			create Result
		ensure
			class_name_tester_not_void: Result /= Void
		end

end
