indexing

	description:

		"Lace Eiffel systems"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2001-2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-22 17:56:35 +0200 (Tue, 22 Apr 2008) $"
	revision: "$Revision: 6372 $"

class ET_LACE_SYSTEM

inherit

	ET_SYSTEM
		redefine
			clusters
		end

create

	make

feature -- Access

	clusters: ET_LACE_CLUSTERS
			-- Clusters

end
