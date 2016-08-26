indexing

	description:

		"Test semantics of recursive once functions"

	remark: "[
		ECMA 367-2, section 8.23.22 p.124: "Semantics: Once Routine Execution Semantics",
		says that the recursive calls to once-functions should return the value of
		'Result' as it was when the recursive calls occurred.
	]"

	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-16 12:20:22 +0200 (Wed, 16 Apr 2008) $"
	revision: "$Revision: 6349 $"

class TEST_ONCE_RECURSIVE

inherit

	TS_TEST_CASE

create

	make_default

feature -- Test

	test_once_recursive is
			-- Test recursive once functions.
			-- ECMA 367-2, section 8.23.22 p.124: "Semantics: Once Routine Execution Semantics",
			-- says that the recursive calls to once-functions should return the value of
			-- 'Result' as it was when the recursive calls occurred.
		do
			assert_integers_equal ("one", 1, f)
		end

feature -- Once function

	f: INTEGER is
			-- Recursive once function
		once
			Result := 1
			Result := f
		end

end
