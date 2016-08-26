indexing

	description:

		"Eiffel assertions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-09-06 16:51:05 +0200 (Sat, 06 Sep 2008) $"
	revision: "$Revision: 6497 $"

deferred class ET_ASSERTION

inherit

	ET_ASSERTION_ITEM

feature -- Initialization

	reset is
			-- Reset assertion as it was when it was last parsed.
		do
		end

feature -- Access

	expression: ET_EXPRESSION is
			-- Expression (may be Void)
		deferred
		end

	assertion: ET_ASSERTION is
			-- Assertion in list of assertions
		do
			Result := Current
		end

end
