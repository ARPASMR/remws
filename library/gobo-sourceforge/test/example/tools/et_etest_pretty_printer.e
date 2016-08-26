indexing

	description:

		"Test 'pretty printer' example"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-11-17 17:14:47 +0100 (Mon, 17 Nov 2008) $"
	revision: "$Revision: 6551 $"

class ET_ETEST_PRETTY_PRINTER

inherit

	EXAMPLE_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING is "pretty_printer"
			-- Program name

	library_name: STRING is "tools"
			-- Library name of example

feature -- Test

	test_pretty_printer is
			-- Test 'pretty_printer' example.
		do
			compile_program
		end

end
