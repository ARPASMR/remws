indexing

	description:

		"Eiffel adapted class libraries"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-22 17:56:35 +0200 (Tue, 22 Apr 2008) $"
	revision: "$Revision: 6372 $"

class ET_ADAPTED_LIBRARY

inherit

	ET_ADAPTED_UNIVERSE
		rename
			universe as library
		redefine
			library
		end

create

	make

feature -- Access

	library: ET_LIBRARY
			-- Eiffel library being adapted

end
