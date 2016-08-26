indexing

	description:

		"Eiffel retry instructions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_RETRY_INSTRUCTION

inherit

	ET_INSTRUCTION
		undefine
			first_position, last_position
		end
	
	ET_KEYWORD
		rename
			make_retry as make
		redefine
			process
		end

create

	make

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_retry_instruction (Current)
		end

invariant

	is_retry: is_retry

end
