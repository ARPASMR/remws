indexing

	description:

		"Eiffel language clauses in external routines"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_EXTERNAL_LANGUAGE

inherit

	ET_AST_NODE

feature -- Access

	manifest_string: ET_MANIFEST_STRING is
			-- External language name
		deferred
		ensure
			manifest_string_not_void: Result /= Void
		end

end
