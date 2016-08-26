indexing

	description:

		"Eiffel boolean constants"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_BOOLEAN_CONSTANT

inherit

	ET_CONSTANT
		undefine
			first_position, last_position
		redefine
			is_boolean_constant
		end

	ET_INDEXING_TERM
		undefine
			first_position, last_position
		end

	ET_KEYWORD
		undefine
			process, is_current
		end

feature -- Status report

	is_boolean_constant: BOOLEAN is True
			-- Is current constant a BOOLEAN constant?

end
