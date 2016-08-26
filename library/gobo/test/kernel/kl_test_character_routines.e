indexing

	description:

		"Test features of KL_CHARACTER_ROUTINES"

	library: "Gobo Eiffel Kernel Library"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2008-02-13 12:34:45 +0100 (Wed, 13 Feb 2008) $"
	revision: "$Revision: 6301 $"

class KL_TEST_CHARACTER_ROUTINES

inherit

	KL_TEST_CASE

	KL_IMPORTED_CHARACTER_ROUTINES
		export {NONE} all end

create

	make_default

feature -- Test

	test_is_digit is
			-- Test feature `is_digit'.
		do
			assert ("0 is a digit", CHARACTER_.is_digit ('0'))
			assert ("a is not a digit", not CHARACTER_.is_digit ('a'))
		end

	test_is_hex_digit is
			-- Test feature `is_hex_digit'.
		do
			assert ("0 is a hex digit", CHARACTER_.is_hex_digit ('0'))
			assert ("a is a hex digit", CHARACTER_.is_hex_digit ('a'))
			assert ("A is a hex digit", CHARACTER_.is_hex_digit ('A'))
			assert ("G is not a hex digit", not CHARACTER_.is_hex_digit ('G'))
		end

end
