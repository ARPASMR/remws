indexing

	description:

		"Eiffel manifest types"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2005, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class ET_MANIFEST_TYPE

inherit

	ET_CONSTANT
		undefine
			reset
		redefine
			is_type_constant
		end

	ET_BRACED_TYPE
		redefine
			process
		end

create

	make

feature -- Status report

	is_type_constant: BOOLEAN is True
			-- Is current constant a TYPE constant?

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_manifest_type (Current)
		end

end
