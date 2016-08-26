indexing

	description:

		"Eiffel procedure comparators by first seed"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2005, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_SEEDED_PROCEDURE_COMPARATOR

inherit

	KL_PART_COMPARATOR [ET_PROCEDURE]

create

	make

feature {NONE} -- Initialization

	make is
			-- Create a new procedure comparator by first seed.
		do
		end

feature -- Status report

	less_than (u, v: ET_PROCEDURE): BOOLEAN is
			-- Is `u' considered less than `v'?
		do
			Result := (u.first_seed < v.first_seed)
		end

end
