indexing

	description:

		"Eiffel types which appear in a comma-separated list of types"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_TYPE_ITEM

inherit

	ET_AST_NODE

feature -- Access

	type: ET_TYPE is
			-- Type in comma-separated list
		deferred
		ensure
			type_not_void: Result /= Void
		end

end
