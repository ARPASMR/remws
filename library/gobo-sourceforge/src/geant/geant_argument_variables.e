indexing

	description:

		"Argument variables for GEANT"

	library: "Gobo Eiffel Ant"
	copyright:"Copyright (c) 2005, Sven Ehrke and others"
	license:"MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision:"$Revision: 5877 $"

class GEANT_ARGUMENT_VARIABLES

inherit

	GEANT_VARIABLES

create

	make

feature -- Status report

	has_numbered_keys: BOOLEAN is
			-- Do entries exist which indicate that Current contains only numbered entries?
		do
			Result := has ("1")
		ensure
			definition: Result implies has ("1")
		end

end
