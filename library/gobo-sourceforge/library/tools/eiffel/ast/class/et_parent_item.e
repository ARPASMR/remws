indexing

	description:

		"Eiffel class parents in semicolon-separated list of class parents"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_PARENT_ITEM

inherit

	ET_AST_NODE

feature -- Access

	parent: ET_PARENT is
			-- Class parent in semicolon-separated list
		deferred
		ensure
			parent_not_void: Result /= Void
		end

end
