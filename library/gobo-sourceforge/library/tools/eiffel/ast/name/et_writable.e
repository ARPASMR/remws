indexing

	description:

		"Eiffel writable entities"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-01-03 23:24:38 +0100 (Thu, 03 Jan 2008) $"
	revision: "$Revision: 6246 $"

deferred class ET_WRITABLE

inherit

	ET_EXPRESSION

feature -- Status report

	is_result: BOOLEAN is
			-- Is current expression the 'Result' entity?
		do
			-- Result := False
		end

end
