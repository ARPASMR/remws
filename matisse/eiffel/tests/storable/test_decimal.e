indexing
	license: "[
	The contents of this file are subject to the Matisse Interfaces 
	Public License Version 1.0 (the 'License'); you may not use this 
	file except in compliance with the License. You may obtain a copy of
	the License at http://www.matisse.com/pdf/developers/MIPL.html

	Software distributed under the License is distributed on an 'AS IS'
	basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See 
	the License for the specific language governing rights and
	limitations under the License.

	The Original Code was created by Matisse Software Inc. 
	and its successors.

	The Initial Developer of the Original Code is Matisse Software Inc. 
	Portions created by Matisse Software are Copyright (C) 
	Matisse Software Inc. All Rights Reserved.

	Contributor(s): 
	]"


deferred class TEST_DECIMAL
	
inherit
	TS_TEST_CASE	
	
feature -- Test initialization
	
	test_make1
		local
			a, res: DECIMAL
		do
			create res.make_from_string ("0")
			create a.make  -- initialized to 0.0

			assert_equal ("make-1", res, a)
		end
	
	test_make2
		local
			a: DECIMAL
		do
			create a.make  -- initialized to 0.0
			assert_equal ("make-2", "0", a.out)
		end
	
	test_make_from_string1
		local
			a: DECIMAL
		do
			create a.make_from_string("0.001")
			assert_equal ("make_from_string-1", "0.001", a.out)
		end
		
	test_make_from_string2
		local
			a: DECIMAL
		do
			create a.make_from_string("-123450.001")
			assert_equal ("make_from_string-2", "-123450.001", a.out)
		end
	
	test_make_from_string3
		local
			a: DECIMAL
		do
			create a.make_from_string ("9876543210123456789.1234567890123")
			assert_equal ("make_from_string-3", "9876543210123456789.1234567890123", a.out)
		end
	
	test_make_from_integer64_1
		local
			a: DECIMAL
		do
			create a.make_from_integer64(1234)
			assert_equal ("make_from_integer64-1", "1234", a.out)
		end
	
	test_make_from_integer64_2
		local
			a: DECIMAL
			b: INTEGER
		do
			b := -123456789
			create a.make_from_integer64(b)
			assert_equal ("make_from_integer64-2", "-123456789", a.out)
		end
	
	test_make_from_integer64_3
		local
			a: DECIMAL
			b, c, d: INTEGER_64
		do
			b := -123456789
			c := 100000;
			d := b * c
			create a.make_from_integer64(d)
--			assert_equal ("make_from_integer64-3", "-12345678901234567", a.out)
			assert_equal ("make_from_integer64-3", d.out, a.out)
		end
	
	test_make_from_double1
		local
			a: DECIMAL
		do
			create a.make_from_double(1234567.890123)
			assert_equal ("make_from_double-1", "1234567.890123", a.out)
		end

feature -- access
	
	test_zero1
		local
			a: DECIMAL
		do
			create a.make_from_string("1");
			assert_equal ("zero-1", "0", a.zero.out)
		end
	
	test_one1
		local
			a: DECIMAL
		do
			create a.make
			assert_equal ("one-1", "1", a.one.out)
		end

	test_scale1
		local
			a: DECIMAL
		do
			create a.make_from_string ("123.456789")
			assert_equal ("scale-1", 6, a.scale)
		end
	
	test_scale2
		local
			a: DECIMAL
		do
			create a.make_from_string ("123.")
			assert_equal ("scale-2", 0, a.scale)
		end
	
	test_precision1
		local
			a: DECIMAL
		do
			create a.make_from_string ("123.")
			assert_equal ("precision-1", 3, a.precision)
		end
	
	test_precision2
		local
			a: DECIMAL
		do
			create a.make_from_string ("0.001234")
			assert_equal ("precision-1", 7, a.precision)
		end
	
	test_hash_code1
		local
			a: DECIMAL
		do
			create a.make_from_string ("1234567.89")
			assert_equal ("hash_code-1", 1234567, a.hash_code)
		end
	
	test_sign1
		local
			a: DECIMAL
		do
			create a.make_from_string ("12345678901234.56789")
			assert_equal ("sign-1", 1, a.sign)
		end
	
	test_sign2
		local
			a: DECIMAL
		do
			create a.make_from_string ("-12345678901234.56789")
			assert_equal ("sign-2", -1, a.sign)
		end
	
	test_sign3
		local
			a: DECIMAL
		do
			create a.make_from_string ("000.000")
			assert_equal ("sign-3", 0, a.sign)
		end

feature -- Comparison
	
	test_more_than1
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("0.001")
			create b.make_from_string ("0.002")
			assert_equal ("more_than-1", True, a < b)
		end
	
	test_more_than2
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-0.001")
			create b.make_from_string ("-0.002")
			assert_equal ("more_than-2", False, a < b)
		end
	
	test_more_than3
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("10.001")
			create b.make_from_string ("10.001")
			assert_equal ("more_than-3", False, a < b)
		end
	
	test_more_than4
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-10.001")
			create b.make_from_string ("-10.001")
			assert_equal ("more_than-4", False, a < b)
		end
	
		test_more_than_equal1
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("0.001")
			create b.make_from_string ("0.002")
			assert_equal ("more_than_equal-1", True, a <= b)
		end
	
	test_more_than_equal2
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-0.001")
			create b.make_from_string ("-0.002")
			assert_equal ("more_than_equal-2", False, a <= b)
		end
	
	test_more_than_equal3
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("10.001")
			create b.make_from_string ("10.001")
			assert_equal ("more_than_equal-3", True, a <= b)
		end
	
	test_more_than_equal4
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-10.001")
			create b.make_from_string ("-10.001")
			assert_equal ("more_than_equal-4", True, a <= b)
		end
	
	test_less_than1
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("0.001")
			create b.make_from_string ("0.002")
			assert_equal ("less_than-1", False, a > b)
		end
	
	test_less_than2
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-0.001")
			create b.make_from_string ("-0.002")
			assert_equal ("less_than-2", True, a > b)
		end
	
	test_less_than3
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("10.001")
			create b.make_from_string ("10.001")
			assert_equal ("less_than-3", False, a > b)
		end
	
	test_less_than4
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-10.001")
			create b.make_from_string ("-10.001")
			assert_equal ("less_than-4", False, a > b)
		end
	
		test_less_than_equal1
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("0.001")
			create b.make_from_string ("0.002")
			assert_equal ("less_than_equal-1", False, a >= b)
		end
	
	test_less_than_equal2
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-0.001")
			create b.make_from_string ("-0.002")
			assert_equal ("less_than_equal-2", True, a >= b)
		end
	
	test_less_than_equal3
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("10.001")
			create b.make_from_string ("10.001")
			assert_equal ("less_than_equal-3", True, a >= b)
		end
	
	test_less_than_equal4
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-10.001")
			create b.make_from_string ("-10.001")
			assert_equal ("less_than_equal-4", True, a >= b)
		end
	
	test_is_equal1
		local
			a: DECIMAL
		do
			create a.make_from_string ("-10.00100")
			assert_equal ("is_equal1", True, a.is_equal(a))
		end
	
	test_is_equal2
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("010.00100")
			create b.make_from_string ("010.00100")
			assert_equal ("is_equal2", True, a.is_equal(b))
		end

	test_is_equal3
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("010.00100")
			create b.make_from_string ("-010.00100")
			assert_equal ("is_equal3", False, a.is_equal(b))
		end
	
	test_three_way_comparison1
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("010.00100")
			create b.make_from_string ("-010.00100")
			assert_equal ("three_way_comparison1", 1, a.three_way_comparison(b))
		end

feature -- Conversion
	
	test_ceiling1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("10.123456")
			create res.make_from_string ("10.1235")
			assert_equal ("ceiling1", res, a.ceiling(4));
		end
	
	test_ceiling2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("10.723456")
			create res.make_from_string ("11")
			assert_equal ("ceiling2", res, a.ceiling(0));
		end
	
	test_ceiling3
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-10.723456")
			create res.make_from_string ("-10.7")
			assert_equal ("ceiling3", res, a.ceiling(1));
		end
	
	test_half_up1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("10.723456")
			create res.make_from_string ("10.723")
			assert_equal ("half_up1", res, a.half_up(3));
		end
	
	test_half_up2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("10.723456")
			create res.make_from_string ("11")
			assert_equal ("half_up2", res, a.half_up(0));
		end
	
	test_half_up3
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-0.72345")
			create res.make_from_string ("-0.7235")
			assert_equal ("half_up3", res, a.half_up(4));
		end
	
	test_half_even1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("10.723456")
			create res.make_from_string ("10.723")
			assert_equal ("half_even1", res, a.half_even(3));
		end
	
	test_half_even2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("10.723456")
			create res.make_from_string ("11")
			assert_equal ("half_even2", res, a.half_even(0));
		end
	
	test_half_even3
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-0.72345")
			create res.make_from_string ("-0.7234")
			assert_equal ("half_even3", res, a.half_even(4));
		end
	
	test_down1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("555.72345")
			create res.make_from_string ("555.7234")
			assert_equal ("down1", res, a.down(4));
		end
	
	test_down2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("555.72345")
			create res.make_from_string ("555.0")
			assert_equal ("down2", res, a.down(0));
		end
	
	test_down3
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-555.72345")
			create res.make_from_string ("-555.7")
			assert_equal ("down3", res, a.down(1));
		end
	
	test_floor1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("555.72345")
			create res.make_from_string ("555.7234")
			assert_equal ("floor1", res, a.floor(4));
		end
	
	test_floor2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("555.72345")
			create res.make_from_string ("555.0")
			assert_equal ("floor2", res, a.floor(0));
		end
	
	test_floor3
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-555.72345")
			create res.make_from_string ("-555.8")
			assert_equal ("floor3", res, a.floor(1));
		end
	
	test_abs1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-555.72345")
			create res.make_from_string ("555.72345")
			assert_equal ("abs1", res, a.abs);
		end
	
	test_abs2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("55500")
			create res.make_from_string ("55500")
			assert_equal ("abs2", res, a.abs);
		end
	
	test_to_double1
		local
			a: DECIMAL
		do
			create a.make_from_string ("55500")
			assert_equal ("to_double1", 55500.0, a.to_double);
		end
	
	test_to_double2
		local
			a: DECIMAL
		do
			create a.make_from_string ("-55500.11123456")
			assert_equal ("to_double2", True, 
										a.to_double > -55500.11123457 and
										a.to_double < -55500.11123455
										);
		end
	
	test_truncated_to_integer64_1
		local
			a: DECIMAL
			b: INTEGER_64
		do
			create a.make_from_string ("-55500.11123456")
			b := -55500
			assert_equal ("truncated_to_integer64_1", b, a.truncated_to_integer64)
		end
	
	test_truncated_to_integer64_2
		local
			a: DECIMAL
			b: INTEGER_64
		do
			create a.make_from_string ("0.11123456")
			b := 0
			assert_equal ("truncated_to_integer64_2", b, a.truncated_to_integer64)
		end
	
feature -- status report	
	
	test_divisible1
		local
			a: DECIMAL
		do
			create a.make_from_string ("0.11123456")
			assert_equal ("divisible1", True, a.divisible(a))
		end
	
	test_divisible2
		local
			a: DECIMAL
		do
			create a.make_from_string ("0.11123456")
			assert_equal ("divisible2", False, a.divisible(a.decimal_zero))
		end
	
	test_is_hashable1
		local
			a: DECIMAL
		do
			create a.make_from_string ("0.11123456")
			assert_equal ("is_hashable1", True, a.is_hashable)
		end
	
	test_is_hashable2
		local
			a: DECIMAL
		do
			create a.make_from_string ("0.11123456")
			assert_equal ("is_hashable2", False, a.decimal_zero.is_hashable)
		end
	
	test_prefix_minus1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("0.1")
			create res.make_from_string ("-.1")
			assert_equal ("prefix_minus1", res, -a)
		end
	
	test_prefix_minus2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-10")
			create res.make_from_string ("10")
			assert_equal ("prefix_minus2", res, -a)
		end
	
	test_prefix_plus1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("0.1")
			create res.make_from_string ("0.1")
			assert_equal ("prefix_plus1", res, +a)
		end
	
	test_prefix_plus2
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-10")
			create res.make_from_string ("-10")
			assert_equal ("prefix_plus2", res, +a)
		end
	
	test_infix_plus1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-10")
			create res.make_from_string ("-10")
			assert_equal ("infix_plus1", res, a + a.zero)
		end
	
	test_infix_plus2
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string ("1.12345")
			create b.make_from_string ("5.54321")
			create res.make_from_string ("6.66666")
			assert_equal ("infix_plus2", res, a + b)
		end
	
	test_infix_minus1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-10")
			create res.make_from_string ("-10")
			assert_equal ("infix_minus1", res, a - a.zero)
		end
	
	test_infix_minus2
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string ("1.12345")
			create b.make_from_string ("5.54321")
			create res.make_from_string ("-4.41976")
			assert_equal ("infix_minus2", res, a - b)
		end
	
	test_infix_minus3
		-- big precision and scale
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string_precision_scale ("-100.50000000", 19, 8)
			create b.make_from_string_precision_scale ("100.0000670200001000", 38, 16)
			create res.make_from_string ("-200.5000670200001000")
			assert_equal ("infix_minus3", res, a - b)
		end
	
	test_infix_multi1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-10")
			create res.make_from_string ("-10")
			assert_equal ("infix_multi1", res, a * a.one)
		end
	
	test_infix_multi2
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string ("1.12345")
			create b.make_from_string ("-5.54321")
			create res.make_from_string ("-6.2275192745")
			assert_equal ("infix_multi2", res, a * b)
		end
	
	test_infix_multi3
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string ("111111.123456789")
			create b.make_from_string ("-55555.54321012345")
			create res.make_from_string ("-6172838820.3290025255434306")
			assert_equal ("infix_multi3", res, a * b)
		end
	
	test_infix_divide1
		local
			a, res: DECIMAL
		do
			create a.make_from_string ("-10")
			create res.make_from_string ("-10")
			assert_equal ("infix_divide1", res, a / a.one)
		end
	
	test_infix_divide2
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string ("1.12345")
			create b.make_from_string ("5.54321")
			create res.make_from_string ("0.2026713763324860")
			assert_equal ("infix_divide2", res, a / b)
		end
	
	test_infix_divide3
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string_precision_scale ("11233444321.123452343294", 38, 16)
			create b.make_from_string_precision_scale ("54444.5444234234344321", 22, 16)
			create res.make_from_string ("206328.19027300")
			assert_equal ("infix_divide3", res, a / b)
		end
	
	
feature -- addition
	
	test_add1
			-- Test add
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string ("12.3")
			create b.make_from_string ("-123.34")
			create res.make_from_string ("-111.04")
			assert_equal ("add-1", res, a + b)
		end
	
	test_add2
			-- Test add
		local
			a, b, res: DECIMAL
		do
			create a.make_from_string ("0.300000")
			create b.make_from_string ("-.34")
			create res.make_from_string ("-0.040000")
			assert_equal ("add-2", res, a + b)
		end
	
feature -- min, max
	
	test_min1
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("0.300000")
			create b.make_from_string ("-.34")
			assert_equal ("min1", b, a.min(b))
		end
	
	test_min2
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("0.300000")
			create b.make_from_string ("-.34")
			assert_equal ("min2", b, b.min(a))
		end
	
	test_max1
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("-1230.300000")
			create b.make_from_string ("-.34")
			assert_equal ("max1", b, a.max(b))
		end
	
	test_max2
		local
			a, b: DECIMAL
		do
			create a.make_from_string ("0.300000")
			create b.make_from_string ("-.34")
			assert_equal ("max2", a, b.max(a))
		end
	
feature -- To avoid compile-crash
	
	zzzzz_: ATTRS_CLASS
	aaaaa_: MT_LINKED_LIST[ATTRS_CLASS]
	ddddd_: MT_ARRAY[ATTRS_CLASS]
	
end

