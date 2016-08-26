indexing

	description:

		"Eiffel actual arguments"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004-2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_ACTUAL_ARGUMENTS

inherit

	ET_ARGUMENT_OPERANDS
		redefine
			actual_argument
		end

	ET_EXPRESSIONS
		rename
			expression as actual_argument
		redefine
			actual_argument
		end

feature -- Access

	actual_argument (i: INTEGER): ET_EXPRESSION is
			-- Actual argument at index `i'
		deferred
		end

end
