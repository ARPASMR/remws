indexing

	description:

		"Eiffel feature names which appear in a comma-separated list of feature names"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002-2005, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_FEATURE_NAME_ITEM

inherit

	ET_EXTENDED_FEATURE_NAME

feature -- Access

	alias_name: ET_ALIAS_NAME is
			-- Alias name, if any
		do
		end

end
