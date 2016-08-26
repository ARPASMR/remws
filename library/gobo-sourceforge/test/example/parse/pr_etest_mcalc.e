indexing

	description:

		"Test 'mcalc' example"

	library: "Gobo Eiffel Parse Library"
	copyright: "Copyright (c) 2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class PR_ETEST_MCALC

inherit

	EXAMPLE_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING is "mcalc"
			-- Program name

	library_name: STRING is "parse"
			-- Library name of example

feature -- Test

	test_mcalc is
			-- Test 'mcalc' example.
		do
			compile_program
		end

end
