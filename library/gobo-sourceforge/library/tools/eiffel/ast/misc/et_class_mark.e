indexing

	description:

		"Eiffel type marks (e.g. 'expanded', 'reference', 'separate', 'deferred', '!' or '?')"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-10 14:53:01 +0200 (Thu, 10 Apr 2008) $"
	revision: "$Revision: 6346 $"

deferred class ET_CLASS_MARK

inherit

	ET_TYPE_MARK

feature -- Status report

	is_deferred: BOOLEAN is
			-- Is current type mark 'deferred'?
		do
			-- Result := False
		end

end
