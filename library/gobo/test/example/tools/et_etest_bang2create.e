indexing

	description:

		"Test 'bang2create' example"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class ET_ETEST_BANG2CREATE

inherit

	EXAMPLE_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING is "bang2create"
			-- Program name

	library_name: STRING is "tools"
			-- Library name of example

feature -- Test

	test_bang2create is
			-- Test 'bang2create' example.
		do
			compile_program
		end

end
