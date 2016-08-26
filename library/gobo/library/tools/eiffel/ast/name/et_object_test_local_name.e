indexing

	description:

		"Eiffel object-test local names"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-29 19:45:23 +0200 (Tue, 29 Apr 2008) $"
	revision: "$Revision: 6387 $"

deferred class ET_OBJECT_TEST_LOCAL_NAME

inherit

	ET_EXPRESSION

feature -- Access

	identifier: ET_IDENTIFIER is
			-- Identifier
		deferred
		ensure
			identifier_not_void: Result /= Void
		end

end
