indexing

	description:

		"Eiffel inspect choices which appear in a comma-separated list of choices"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_CHOICE_ITEM

inherit

	ET_AST_NODE

feature -- Access

	choice: ET_CHOICE is
			-- Choice in comma-separated list
		deferred
		ensure
			choice_not_void: Result /= Void
		end

end
