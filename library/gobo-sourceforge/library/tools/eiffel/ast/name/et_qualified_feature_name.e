indexing

	description:

		"Eiffel feature names in qualified calls"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_QUALIFIED_FEATURE_NAME

inherit

	ET_AST_NODE

feature -- Access

	feature_name: ET_FEATURE_NAME is
			-- Feature name
		deferred
		ensure
			feature_name_not_void: Result /= Void
		end

end
