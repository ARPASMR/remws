indexing

	description:

		"Eiffel lists of feature precursors at run-time"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_DYNAMIC_PRECURSOR_LIST

inherit

	ET_TAIL_LIST [ET_DYNAMIC_PRECURSOR]

create

	make, make_with_capacity

feature {NONE} -- Implementation

	fixed_array: KL_SPECIAL_ROUTINES [ET_DYNAMIC_PRECURSOR] is
			-- Fixed array routines
		once
			create Result
		end

end
