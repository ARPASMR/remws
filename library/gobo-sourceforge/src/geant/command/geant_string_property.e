indexing

    description:

        "STRING properties for Geant tasks and commands"

    library: "Gobo Eiffel Ant"
    copyright: "Copyright (c) 2008, Sven Ehrke and others"
    license: "MIT License"
    date: "$Date: 2008-05-08 20:58:05 +0200 (Thu, 08 May 2008) $"
    revision: "$Revision: 6395 $"

class GEANT_STRING_PROPERTY

inherit

	GEANT_PROPERTY [STRING]

create

	make

feature -- Access

	value: STRING is
			-- String value
		do
			Result := string_value
		end

end
