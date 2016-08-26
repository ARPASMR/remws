indexing

	description:

		"Eiffel lists of procedures"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2005, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_PROCEDURE_LIST

inherit

	ET_FEATURE_LIST
		redefine
			item, fixed_array
		end

create

	make, make_with_capacity

feature -- Access

	item (i: INTEGER): ET_PROCEDURE is
			-- Procedure at index `i' in list
		do
			Result := storage.item (count - i)
		end

feature {NONE} -- Implementation

	fixed_array: KL_SPECIAL_ROUTINES [ET_PROCEDURE] is
			-- Fixed array routines
		once
			create Result
		end

end
