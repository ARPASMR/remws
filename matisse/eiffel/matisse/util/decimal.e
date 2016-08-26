note
	description: "MATISSE-Eiffel Binding: define the Decimal number class"
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

	Contributor(s): Kazuhiro Nakao
                   Didier Cabannes
                   Neal Lester
                   Luca Paganotti
	]"


class
	DECIMAL

inherit
	NUMERIC
		redefine
			is_equal, out, copy
		end

	COMPARABLE
		redefine
			out, three_way_comparison, is_equal, copy
		end

	HASHABLE
		redefine
			is_hashable, out, is_equal, copy
		end

create
	make,
	make_from_string,
	make_from_string_precision_scale,
	make_from_integer64,
	make_from_double

create
	from_int_array,
	from_int_buf_array

feature -- Numeric

	Mt_Max_Decimal_Len :INTEGER_32 = 21
	Mt_Max_Precision: INTEGER_32 = 38
	Mt_Min_Precision: INTEGER_32 = 1
	Mt_Max_Scale: INTEGER_32     = 16
	Mt_Min_Scale: INTEGER_32     = 0

feature  -- initialize

	make
		do
			item1 := zero_item1
			item2 := zero_item2
			item3 := zero_item3
			item4 := zero_item4
			item5 := zero_item5
			item6 := zero_item6
		end

	make_from_string (str: STRING)
		require
			not_void: str /= Void
			valid_length: 0 < str.count and str.count <= {DECIMAL}.Mt_Max_Precision + 2
		local
			res_array: ARRAY[INTEGER_32]
			any_a, any_s: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			any_s := str.to_c
			c_mt_numeric_array_from_string ($any_a, $any_s)
			from_int_array (res_array)
		end

	make_from_string_precision_scale (str: STRING; prec, a_scale: INTEGER_32)
		require
			not_void: str /= Void
			valid_length: 0 < str.count and str.count <= {DECIMAL}.Mt_Max_Precision + 2
			valid_precision: {DECIMAL}.Mt_Min_Precision <= prec and prec <= {DECIMAL}.Mt_Max_Precision
			valid_scale: {DECIMAL}.Mt_Min_Scale <= a_scale and a_scale <= {DECIMAL}.Mt_Max_Scale
		local
			res_array: ARRAY[INTEGER_32]
			any_a, any_s: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			any_s := str.to_c
			c_mt_numeric_array_from_string_precision_scale ($any_a, $any_s, prec, a_scale)
			from_int_array (res_array)
		end

	make_from_integer64 (value: INTEGER_64)
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_long_to_numeric_expd (value, $any_a)
			from_int_array (res_array)
		end

	make_from_double (value: DOUBLE)
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_double_to_numeric_expd (value, $any_a)
			from_int_array (res_array)
		end

feature -- Access

	zero: like Current
		do
			create Result.make
		end

	one: like Current
		local
			res_array: ARRAY[INTEGER_32]
			one_64: INTEGER_64
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_long_to_numeric_expd (one_64.one, $any_a)
			create Result.from_int_array (res_array)
		end

	scale: INTEGER_32
			-- Scale of value.  e.g. 123.45 has a scale of 2
		do
			Result := c_mt_get_numeric_scale_expd (item1, item2, item3, item4, item5, item6)
		end

	precision: INTEGER_32
			-- precision of value.  e.g. 123.45 has a precision of 5
		do
			Result := c_mt_get_numeric_precision_expd (item1, item2, item3, item4, item5, item6)
		end

	hash_code: INTEGER_32
		do
			Result := truncated_to_integer64.hash_code
		end

	sign: INTEGER_32
			-- Sign value (0, -1 or 1)
		do
			Result := c_mt_numeric_compare_expd (item1, item2, item3, item4, item5, item6,
																					 decimal_zero.item1,
																					 decimal_zero.item2,
																					 decimal_zero.item3,
																					 decimal_zero.item4,
																					 decimal_zero.item5,
																					 decimal_zero.item6
																					 )
		ensure
			three_way: Result = three_way_comparison (zero)
		end

feature -- Comparison

	infix "<" (other: like Current): BOOLEAN
			-- Is `other' greater than current double?
		do
--			Result := c_mt_numeric_compare_expd (item1, item2, item3, item4, item5, item6,
--							 other.item1, other.item2, other.item3,
--							 other.item4, other.item5, other.item6) < 0
			Result := to_double < other.to_double
		end

	is_equal (other: like Current): BOOLEAN
			-- Is 'other' equal to Current object?
		do
			Result := c_mt_numeric_compare_expd (item1, item2, item3, item4, item5, item6,
								 other.item1, other.item2, other.item3,
								 other.item4, other.item5, other.item6) = 0
		end


	-- TBD
	three_way_comparison (other: like Current): INTEGER_32
			-- If current object equal to `other', 0
			-- if smaller, -1; if greater, 1
		do
			Result := c_mt_numeric_compare_expd (item1, item2, item3, item4, item5, item6,
								 other.item1, other.item2, other.item3,
								 other.item4, other.item5, other.item6)
		end

feature -- Conversion

	ceiling (decimal_places: INTEGER_32): like Current
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_rounding_expd (item1, item2, item3, item4, item5, item6,
																	$any_a, decimal_places, round_ceiling)
			create Result.from_int_array (res_array)
		end

	half_up, rounded (decimal_places: INTEGER_32): like Current
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled(0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_rounding_expd (item1, item2, item3, item4, item5, item6,
																	$any_a, decimal_places, round_half_up)
			create Result.from_int_array (res_array)
		end

	half_even (decimal_places: INTEGER_32): like Current
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_rounding_expd (item1, item2, item3, item4, item5, item6,
																	$any_a, decimal_places, round_half_even)
			create Result.from_int_array (res_array)
		end

	down (decimal_places: INTEGER_32): like Current
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_rounding_expd (item1, item2, item3, item4, item5, item6,
																	$any_a, decimal_places, round_down)
			create Result.from_int_array (res_array)
		end

	floor (decimal_places: INTEGER_32): like Current
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_rounding_expd (item1, item2, item3, item4, item5, item6,
																	$any_a, decimal_places, round_floor)
			create Result.from_int_array (res_array)
		end

	abs: like Current
			-- Absolute value of decimal
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled (0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_absolute_expd (item1, item2, item3, item4, item5, item6,
					$any_a)
			create Result.from_int_array (res_array)
		end

	to_double: DOUBLE
			-- Double value
		do
			Result := c_mt_numeric_to_double_expd (item1, item2, item3, item4, item5, item6)
		end

	truncated_to_integer64: INTEGER_64
		do
			Result := c_mt_numeric_to_long_expd (item1, item2, item3, item4, item5, item6)
		end


feature -- status report	

	divisible (other: like Current): BOOLEAN
			-- Is divisible by `other'?
		do
			Result := not (other.is_equal(decimal_zero))
		end

	exponentiable (other: NUMERIC): BOOLEAN
			-- Is exponentiable by `other'?
		do
			Result := false
		end

	is_hashable: BOOLEAN
			-- May current object be hashed?
			-- (True if it is not its type's default.)
		do
			Result := not Current.is_equal(decimal_zero)
		end

feature -- Basic operations

	prefix "-": like Current
			-- Negative value of decimal
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled(0, 1, num_items)
			any_a := res_array.to_c
      c_mt_numeric_long_multiply_expd (item1, item2, item3, item4, item5, item6,
																			 -1, $any_a)
			create Result.from_int_array (res_array)
		end

	infix "-" (other: like Current): like Current
			-- Subtract with `other'
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled(0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_op_expd (item1, item2, item3, item4, item5, item6,
														other.item1, other.item2, other.item3,
														other.item4, other.item5, other.item6,
														$any_a, op_subtraction)
			create Result.from_int_array (res_array)
		end

	infix "+" (other: like Current): like Current
			-- Add with `other'
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled(0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_op_expd (item1, item2, item3, item4, item5, item6,
														other.item1, other.item2, other.item3,
														other.item4, other.item5, other.item6,
														$any_a, op_addition)
			create Result.from_int_array (res_array)
		end

	infix "*" (other: like Current): like Current
			-- Multiply by `other'
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled(0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_op_expd (item1, item2, item3, item4, item5, item6,
														other.item1, other.item2, other.item3,
														other.item4, other.item5, other.item6,
														$any_a, op_multiplication)
			create Result.from_int_array (res_array)
		end

	infix "/" (other: like Current): like Current
			-- Divide by `other'
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			create res_array.make_filled(0, 1, num_items)
			any_a := res_array.to_c
			c_mt_numeric_op_expd (item1, item2, item3, item4, item5, item6,
														other.item1, other.item2, other.item3,
														other.item4, other.item5, other.item6,
														$any_a, op_division)
			create Result.from_int_array (res_array)
		end

	prefix "+": like Current
			-- Unary plus
		do
			create Result.make
			Result.set_high_low (item1, item2, item3, item4, item5, item6);
		end

	infix "^" (other: NUMERIC):NUMERIC
			-- Current objects to the power 'other'
		do
			-- TBD
		end

feature -- Constant

  decimal_zero: DECIMAL
    once
			create Result.make
    end

feature -- Duplication	

	copy (other: like Current)
		do
			item1 := other.item1
			item2 := other.item2
			item3 := other.item3
			item4 := other.item4
			item5 := other.item5
			item6 := other.item6
		end

feature -- Output

	out: STRING
		do
			Result := c_mt_numeric_print (item1, item2, item3, item4, item5, item6)
		end

feature -- externals

	c_mt_numeric_array_from_string (any_a, any_s: POINTER)
		external
			"C"
		end

	c_mt_numeric_array_from_string_precision_scale (any_a, any_s: POINTER; prec, a_scale: INTEGER_32)
		external
			"C"
		end

	c_mt_numeric_print (i1, i2, i3, i4, i5, i6: INTEGER_32): STRING
		external
			"C"
		end

	c_mt_numeric_compare_expd (i1_1, i1_2, i1_3, i1_4, i1_5, i1_6, i2_1, i2_2, i2_3, i2_4, i2_5, i2_6: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_long_to_numeric_expd (val: INTEGER_64; array_ptr: POINTER)
		external
			"C"
		end

	c_mt_double_to_numeric_expd (val: DOUBLE; array_ptr: POINTER)
		external
			"C"
		end

	c_mt_get_numeric_scale_expd (i1, i2, i3, i4, i5, i6 : INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_get_numeric_precision_expd (i1, i2, i3, i4, i5, i6: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_numeric_long_multiply_expd (i1, i2, i3, i4, i5, i6, an_int: INTEGER_32;
																	array_ptr: POINTER)
		external
			"C"
		end

	c_mt_numeric_op_expd (i1_1, i1_2, i1_3, i1_4, i1_5, i1_6, i2_1, i2_2, i2_3, i2_4, i2_5, i2_6: INTEGER_32;
												p_array: POINTER; op: INTEGER_32)
		external
			"C"
		end

	c_mt_numeric_rounding_expd (i1, i2, i3, i4, i5, i6: INTEGER_32;
															p_array: POINTER;
															decimal_places,
															rounding_algorithm: INTEGER_32)
		external
			"C"
		end

	c_mt_numeric_absolute_expd (i1, i2, i3, i4, i5, i6:INTEGER_32;
															p_array: POINTER)
		external
			"C"
		end

	c_mt_numeric_to_double_expd (i1, i2, i3, i4, i5, i6: INTEGER_32): DOUBLE
		external
			"C"
		end

	c_mt_numeric_to_long_expd (i1, i2, i3, i4, i5, i6: INTEGER_32): INTEGER_64
		external
			"C"
		end

feature {DECIMAL, MT_ATTRIBUTE, MT_OBJECT, MT_RESULT_SET, MT_CALLABLE_STATEMENT}

	item1: INTEGER_32
	item2: INTEGER_32
	item3: INTEGER_32
	item4: INTEGER_32
	item5: INTEGER_32
	item6: INTEGER_32

	from_int_array (an_array: ARRAY[INTEGER_32])
		do
			item1 := an_array.item(1)
			item2 := an_array.item(2)
			item3 := an_array.item(3)
			item4 := an_array.item(4)
			item5 := an_array.item(5)
			item6 := an_array.item(6)
		end

	from_int_buf_array (an_array: ARRAY[INTEGER_32]; start: INTEGER_32)
		do
			item1 := an_array.item(start)
			item2 := an_array.item(start + 1)
			item3 := an_array.item(start + 2)
			item4 := an_array.item(start + 3)
			item5 := an_array.item(start + 4)
			item6 := an_array.item(start + 5)
		end

	set_high_low (i1, i2, i3, i4, i5, i6: INTEGER_32)
		do
			item1 := i1
			item2 := i2
			item3 := i3
			item4 := i4
			item5 := i5
			item6 := i6
		end

feature {NONE} -- Constants

	op_addition:       INTEGER_32 = 1;
	op_subtraction:    INTEGER_32 = 2;
	op_multiplication: INTEGER_32 = 3;
	op_division:       INTEGER_32 = 4;

	round_ceiling:   INTEGER_32 = 1;
	round_half_up:   INTEGER_32 = 2;
	round_half_even: INTEGER_32 = 3;
	round_down:      INTEGER_32 = 4;
	round_floor:     INTEGER_32 = 5;

feature {NONE} -- Implementation

	zero_item1: INTEGER_32
		local
			d: DECIMAL
		once
			create d.make_from_string("0")
			Result := d.item1
		end

	zero_item2: INTEGER_32
		local
			d: DECIMAL
		once
			create d.make_from_string("0")
			Result := d.item2
		end
	zero_item3: INTEGER_32
		local
			d: DECIMAL
		once
			create d.make_from_string("0")
			Result := d.item3
		end

	zero_item4: INTEGER_32
		local
			d: DECIMAL
		once
			create d.make_from_string("0")
			Result := d.item4
		end

	zero_item5: INTEGER_32
		local
			d: DECIMAL
		once
			create d.make_from_string("0")
			Result := d.item5
		end
	zero_item6: INTEGER_32
		local
			d: DECIMAL
		once
			create d.make_from_string("0")
			Result := d.item6
		end

	num_items: INTEGER_32 = 6

end -- class DECIMAL
