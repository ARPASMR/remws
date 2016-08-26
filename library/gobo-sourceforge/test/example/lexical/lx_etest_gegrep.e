indexing

	description:

		"Test 'gegrep' example"

	library: "Gobo Eiffel Lexical Library"
	copyright: "Copyright (c) 2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class LX_ETEST_GEGREP

inherit

	EXAMPLE_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING is "gegrep"
			-- Program name

	library_name: STRING is "lexical"
			-- Library name of example

feature -- Test

	test_gegrep is
			-- Test 'gegrep' example.
		do
			compile_program
		end

end
