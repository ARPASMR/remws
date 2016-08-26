indexing

	description:

		"Eiffel call instructions"

	library: "Gobo Eiffel Tools Library"
	copyright:  "Copyright (c) 1999-2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_CALL_INSTRUCTION

inherit

	ET_REGULAR_FEATURE_CALL

	ET_FEATURE_CALL_INSTRUCTION
		undefine
			reset
		end

create

	make

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_call_instruction (Current)
		end

end
