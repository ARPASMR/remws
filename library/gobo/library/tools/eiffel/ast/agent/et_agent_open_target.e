indexing

	description:

		"Eiffel agent open targets for the form '{TYPE}'"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-02-17 15:29:21 +0100 (Sat, 17 Feb 2007) $"
	revision: "$Revision: 5895 $"

class ET_AGENT_OPEN_TARGET

inherit

	ET_AGENT_TARGET
		undefine
			reset
		redefine
			is_open_operand
		end

	ET_BRACED_TYPE
		redefine
			process
		end

create

	make

feature -- Status report

	is_open_operand: BOOLEAN is True
			-- Is current operand open?

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_agent_open_target (Current)
		end

end
