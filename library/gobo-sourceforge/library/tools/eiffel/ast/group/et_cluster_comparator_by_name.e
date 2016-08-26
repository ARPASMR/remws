indexing

	description:

		"Cluster comparators by name"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-03 23:47:03 +0200 (Thu, 03 Apr 2008) $"
	revision: "$Revision: 6332 $"

class ET_CLUSTER_COMPARATOR_BY_NAME

inherit

	KL_COMPARATOR [ET_CLUSTER]

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all end

create

	make

feature {NONE} -- Initialization

	make is
			-- Create a new comparator.
		do
		end

feature -- Status report

	less_than (u, v: ET_CLUSTER): BOOLEAN is
			-- Is `u' considered less than `v'?
		do
			Result := (STRING_.three_way_case_insensitive_comparison (u.name, v.name) = -1)
		end

end
