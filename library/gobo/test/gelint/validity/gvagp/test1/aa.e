indexing

	description:

		"Test root"

	library:    "Gobo Eiffel Tools Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 2001, Eric Bezault and others"
	license:    "MIT License"
	date:       "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision:   "$Revision: 5877 $"

class AA

create

	make

feature

	make is
		local
			b: BB
		do
			create b
		end

end -- class AA
