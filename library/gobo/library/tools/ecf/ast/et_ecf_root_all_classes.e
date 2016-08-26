indexing

	description:

		"ECF all classes roots"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-11-17 16:06:21 +0100 (Mon, 17 Nov 2008) $"
	revision: "$Revision: 6549 $"

class ET_ECF_ROOT_ALL_CLASSES

inherit

	ET_ECF_ROOT

create

	make

feature {NONE} -- Initialization

	make is
			-- Create a new all classes root.
		do
		end

feature -- Element change

	fill_root (a_system: ET_ECF_SYSTEM) is
			-- Fill `a_system' with root information.
		do
			a_system.unset_root_class
			a_system.set_root_creation (Void)
		end

end
