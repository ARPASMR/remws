indexing

	description:

		"Eiffel precursor expressions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_PRECURSOR_EXPRESSION

inherit

	ET_PRECURSOR

	ET_EXPRESSION
		undefine
			reset
		end

create

	make

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_precursor_expression (Current)
		end

end
