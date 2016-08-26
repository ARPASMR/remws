indexing

	description:

		"Eiffel argument names"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_ARGUMENT_NAME

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
