indexing

	description:

		"Test features of class IDENTIFIED"

	library: "FreeELKS Library"
	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class TEST_IDENTIFIED

inherit

	TS_TEST_CASE

create

	make_default

feature -- Test

	test_id_object is
			-- Test feature 'id_object'.
		local
			l_identified: IDENTIFIED
			i: INTEGER
		do
			create l_identified
			i := l_identified.object_id
			assert_same ("object1", l_identified, l_identified.id_object (i))
		end

end
