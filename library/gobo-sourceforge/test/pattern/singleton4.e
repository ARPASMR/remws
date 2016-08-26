indexing

	description:

		"Singleton4"

	library: "Gobo Eiffel Pattern Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

class SINGLETON4

inherit

	ANY -- required by SE 2.1b1

	SHARED_SINGLETON4

create

	make

feature {NONE} -- Initialization

	make is
			-- Create a singleton object.
		require
			singleton4_not_created: not singleton4_created
		do
			singleton4_cell.put (Current)
		end

invariant

	singleton4_created: singleton4_created
	singleton_pattern: Current = singleton4

end
