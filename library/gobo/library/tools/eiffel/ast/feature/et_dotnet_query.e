indexing

	description:

		"Queries (functions or attributes) implemented in .NET"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-04-23 23:23:03 +0200 (Mon, 23 Apr 2007) $"
	revision: "$Revision: 5948 $"

deferred class ET_DOTNET_QUERY

inherit

	ET_QUERY
		undefine
			is_frozen, is_dotnet,
			overloaded_extended_name
		end

	ET_DOTNET_FEATURE
		undefine
			reset, type
		end

end
