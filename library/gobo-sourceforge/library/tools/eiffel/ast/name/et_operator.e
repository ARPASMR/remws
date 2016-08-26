indexing

	description:

		"Eiffel operators"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002-2005, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class ET_OPERATOR

inherit

	ET_CALL_NAME

	ET_TOKEN_CODES
		export {NONE} all end

feature -- Access

	lower_name: STRING is
			-- Lower-name of feature call
			-- (May return the same object as `name' if already in lower case.)
		do
			Result := name
		end

end
