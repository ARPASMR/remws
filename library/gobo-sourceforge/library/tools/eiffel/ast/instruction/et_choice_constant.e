indexing

	description:

		"Eiffel choice constants in when parts of inspect instructions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002-2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_CHOICE_CONSTANT

inherit

	ET_CHOICE

	ET_EXPRESSION
		undefine
			reset
		end

feature -- Access

	lower: ET_CHOICE_CONSTANT is
			-- Lower bound
		do
			Result := Current
		end

	upper: ET_CHOICE_CONSTANT is
			-- Upper bound
		do
			Result := Current
		end

end
