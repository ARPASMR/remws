indexing

	description:

		"Variable resolvers"

	library: "Gobo Eiffel Ant"
	copyright: "Copyright (c) 2004, Sven Ehrke and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class GEANT_VARIABLE_RESOLVER

inherit

	KL_VALUES [STRING, STRING]

feature -- Status report

	has (k: STRING): BOOLEAN is
			-- Is there an item associated with `k'?
		require
			k_not_void: k /= Void 
			k_not_empty: not k.is_empty
		deferred
		end

end
