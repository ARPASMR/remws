indexing

	description:

		"Test features of class IDENTIFIED_ROUTINES"

	library: "FreeELKS Library"
	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class TEST_IDENTIFIED_ROUTINES

inherit

	TS_TEST_CASE

create

	make_default

feature -- Test

	test_eif_id_object is
			-- Test feature 'eif_id_object'.
		local
			ir: IDENTIFIED_ROUTINES
			i: INTEGER
			s: STRING
		do
			create ir
			s := "gobo"
			i := ir.eif_object_id (s)
			assert_same ("object1", s, ir.eif_id_object (i))
		end

end