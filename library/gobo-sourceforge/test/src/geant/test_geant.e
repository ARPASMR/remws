indexing

	description:

		"Test 'geant'"

	library: "Gobo Eiffel Ant"
	copyright: "Copyright (c) 2001-2002, Sven Ehrke and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class TEST_GEANT

inherit

	TOOL_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING is "geant"
			-- Program name

feature -- Test

	test_geant is
			-- Test 'geant'.
		do
			compile_program
		end

end
