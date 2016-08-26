indexing

	description:

		"Eiffel lists of agent implicit open arguments"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-11-27 15:54:06 +0100 (Tue, 27 Nov 2007) $"
	revision: "$Revision: 6193 $"

class ET_AGENT_IMPLICIT_OPEN_ARGUMENT_LIST

inherit

	ET_AGENT_ARGUMENT_OPERANDS

	ET_TAIL_LIST [ET_AGENT_IMPLICIT_OPEN_ARGUMENT]
		rename
			item as actual_argument
		undefine
			is_empty, valid_index
		end

create

	make, make_with_capacity

feature {NONE} -- Implementation

	fixed_array: KL_SPECIAL_ROUTINES [ET_AGENT_IMPLICIT_OPEN_ARGUMENT] is
			-- Fixed array routines
		once
			create Result
		end

end
