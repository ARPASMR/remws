indexing

	description:

		"Eiffel agent actual arguments"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-02-17 15:29:21 +0100 (Sat, 17 Feb 2007) $"
	revision: "$Revision: 5895 $"

deferred class ET_AGENT_ARGUMENT_OPERANDS

inherit

	ET_ARGUMENT_OPERANDS
		redefine
			actual_argument
		end

feature -- Access

	actual_argument (i: INTEGER): ET_AGENT_ARGUMENT_OPERAND is
			-- Actual argument at index `i'
		deferred
		end

end
