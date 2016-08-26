indexing

	description:

		"Eiffel assertions in list of assertions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_ASSERTION_ITEM

inherit

	ET_AST_NODE

feature -- Access

	assertion: ET_ASSERTION is
			-- Assertion in list of assertions
		deferred
		ensure
			assertion_not_void: Result /= Void
		end

end
