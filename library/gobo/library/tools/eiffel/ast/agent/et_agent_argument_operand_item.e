indexing

	description:

		"Eiffel agent actual arguments which appear in a comma-separated list"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-02-17 15:29:21 +0100 (Sat, 17 Feb 2007) $"
	revision: "$Revision: 5895 $"

deferred class ET_AGENT_ARGUMENT_OPERAND_ITEM

inherit

	ET_AST_NODE

feature -- Access

	agent_actual_argument: ET_AGENT_ARGUMENT_OPERAND is
			-- Agent actual argument in comma-separated list
		deferred
		ensure
			agent_actual_argument_not_void: Result /= Void
		end

end
