indexing

	description:

		"Test features of class MEMORY"

	library: "FreeELKS Library"
	copyright: "Copyright (c) 2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class TEST_MEMORY

inherit

	TS_TEST_CASE

	MEMORY

create

	make_default

feature -- Test

	test_is_in_final_collect is
			-- Test feature 'is_in_final_collect'.
		do
			assert ("is_in_final_collect1", not is_in_final_collect)
		end

end
