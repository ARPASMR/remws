indexing

	description:

		"Eiffel inline agents with a do-procedure as associated feature"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-02-17 15:29:21 +0100 (Sat, 17 Feb 2007) $"
	revision: "$Revision: 5895 $"

class ET_DO_PROCEDURE_INLINE_AGENT

inherit

	ET_INTERNAL_PROCEDURE_INLINE_AGENT

create

	make

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_do_procedure_inline_agent (Current)
		end

end
