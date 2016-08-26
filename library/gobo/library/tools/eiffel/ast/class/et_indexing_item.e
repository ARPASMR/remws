indexing

	description:

		"Eiffel indexing clauses which appear in a semicolon-separated list of indexing clauses"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_INDEXING_ITEM

inherit

	ET_AST_NODE

feature -- Access

	indexing_clause: ET_INDEXING is
			-- Indexing clause in semicolon-separated list
		deferred
		ensure
			indexing_clause_not_void: Result /= Void
		end

end
