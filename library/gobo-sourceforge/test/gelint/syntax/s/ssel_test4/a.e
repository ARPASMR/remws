indexing

	description:

		"Empty lines not allowed in multi-line manifest strings"

	library:    "Gobo Eiffel Tools Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 1999, Eric Bezault and others"
	license:    "MIT License"
	date:       "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision:   "$Revision: 5877 $"

class A

create

	make

feature

	make is
		do
			print ("first line %
				%%
				% third line")
		end

end -- class A
