indexing

	description:

		"Test features of class XM_EXPAT_PARSER"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class XM_TEST_EXPAT_PARSER

inherit

	TS_TEST_CASE

create

	make_default

feature -- Test

	test_parse_empty_string is
			-- Test feature `parse_from_string' with an empty input string.
		local
			a_parser: XM_EXPAT_PARSER
		do
			create a_parser.make
			a_parser.parse_from_string ("")
			assert ("not_correct", not a_parser.is_correct)
		end

end
