note
	description: "Test cases for getting attribute values."
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


deferred class TEST_GET_ATTRIBUTE

inherit
	TS_TEST_CASE
		redefine
			set_up, tear_down
		end

	COMMON_FEATURES

	MT_EXCEPTIONS

feature -- Setting

	set_up
		do
			-- create appl.set_login(target_host, target_database)
			-- appl.set_base
			create appl.make(target_host, target_database)
			appl.open
		rescue
			if is_developer_exception then
				print (matisse_exception_code)
				retry
			end
		end

	tear_down
		do
			if appl.is_transaction_in_progress then
				appl.abort_transaction
			elseif appl.is_version_access_in_progress then
				appl.end_version_access
			end
			appl.close
		end

feature -- Decimal (MT_NUMERIC)

	test_decimal1
		local
			obj: NUMERIC_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)
			assert_equal ("get_decimal-1.1", "123456.78", obj.att_numeric1.out)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_decimal-1.2", "123456.78", obj.att_numeric1.out)
		end

	test_decimal2
		local
			obj: NUMERIC_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)
			assert_equal ("get_decimal-2", "123456.7890", obj.att_numeric2.out)
			appl.abort_transaction
		end

	test_decimal3
		local
			obj: NUMERIC_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)
			assert_equal ("get_decimal-3", "-123456.78000000", obj.att_numeric3.out)
			appl.abort_transaction
		end

	test_decimal4
		local
			obj: NUMERIC_CLASS
			res: LINKED_LIST[DECIMAL]
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)
			res := obj.att_numericlist;

			assert_equal ("get_decimal-4.1", 2, res.count)

			if res.count = 2 then
				res.start
				assert_equal ("get_decimal-4.2", "123456.78", res.item.out)
				res.forth
				assert_equal ("get_decimal-4.3", "-123456.78", res.item.out)
			end

			appl.abort_transaction
		end

	test_decimal5
		local
			obj: NUMERIC_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i102", appl)
			assert_equal ("get_decimal-5.1", Void, obj.att_numeric1)
			appl.abort_transaction

			assert_equal ("get_decimal-5.2", Void, obj.att_numeric1)

			appl.start_transaction (0)
			assert_equal ("get_decimal-5.3", Void, obj.att_numeric1)
			appl.abort_transaction
		end

	test_decimal_list1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_decimal_list-1.1", 3, obj.att_numeric_list.count)
			assert_equal ("get_decimal_list-1.2", "-100.01", obj.att_numeric_list.first.out)
			assert_equal ("get_decimal_list-1.3", "300.00", obj.att_numeric_list.last.out)
			appl.abort_transaction

			assert_equal ("get_decimal_list-1.11", 3, obj.att_numeric_list.count)
			assert_equal ("get_decimal_list-1.12", "-100.01", obj.att_numeric_list.first.out)
			assert_equal ("get_decimal_list-1.13", "300.00", obj.att_numeric_list.last.out)

			appl.start_transaction (0)
			assert_equal ("get_decimal_list-1.21", 3, obj.att_numeric_list.count)
			assert_equal ("get_decimal_list-1.22", "-100.01", obj.att_numeric_list.first.out)
			assert_equal ("get_decimal_list-1.23", "300.00", obj.att_numeric_list.last.out)
			appl.abort_transaction
		end

feature -- BYTE (MT_BYTE)

	test_byte1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_byte-1.1", (100).as_natural_8, obj.att_byte)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_byte-1.2", (100).as_natural_8, obj.att_byte)
		end

	test_byte2
			-- The value is 0, which is the default integer value
			-- in Eiffel.
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_byte-2.1", (0).as_natural_8, obj.att_byte)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_byte-2.2", (0).as_natural_8, obj.att_byte)

			appl.start_transaction (0)
			assert_equal ("get_byte-2.3", (0).as_natural_8, obj.att_byte)
			appl.abort_transaction
		end

feature -- MT_BYTES

	test_bytes1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_bytes-1.1", 7, obj.att_bytes.count)
			assert_equal ("get_bytes-1.2", (255).as_natural_8, obj.att_bytes.item(1))
			assert_equal ("get_bytes-1.3", (254).as_natural_8, obj.att_bytes.item(2))
			assert_equal ("get_bytes-1.4", (0).as_natural_8, obj.att_bytes.item(7))
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_bytes-1.11", 7, obj.att_bytes.count)
		end

	test_bytes2
			-- The value is an empty array
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_bytes-2.1", 0, obj.att_bytes.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_bytes-2.2", 0, obj.att_bytes.count)

			appl.start_transaction (0)
			assert_equal ("get_bytes-2.3", 0, obj.att_bytes.count)
			appl.abort_transaction
		end


feature -- INTEGER (MT_INTEGER)

	test_integer1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_integer-1.1", -100, obj.att_integer)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_integer-1.2", -100, obj.att_integer)
		end

	test_integer2
			-- The value is 0, which is the default integer value
			-- in Eiffel.
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_integer-2.1", 0, obj.att_integer)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_integer-2.2", 0, obj.att_integer)

			appl.start_transaction (0)
			assert_equal ("get_integer-2.3", 0, obj.att_integer)
			appl.abort_transaction
		end

	test_integer_list1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_int_list-1.1", 3, obj.att_int_list.count)
			assert_equal ("get_int_list-1.2", 100, obj.att_int_list.first)
			assert_equal ("get_int_list-1.3", 200, obj.att_int_list.last)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_int_list-1.10", 3, obj.att_int_list.count)
			assert_equal ("get_int_list-1.11", 200, obj.att_int_list.last)

			appl.start_transaction (0)
			assert_equal ("get_int_list-1.20", 100, obj.att_int_list.first)
			appl.abort_transaction
		end

	test_integer_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_int_list-2.1", 0, obj.att_int_list.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_int_list-2.10", 0, obj.att_int_list.count)

			appl.start_transaction (0)
			assert_equal ("get_int_list-2.20", 0, obj.att_int_list.count)
			appl.abort_transaction
		end

	test_long1
		local
			obj: ATTRS_CLASS
			expected_value: INTEGER_64
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			expected_value := 12345678900
			assert_equal ("get_long-1.1", expected_value, obj.att_long)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_long-1.2", expected_value, obj.att_long)
		end

	test_long2
			-- The value is 0, which is the default long value
			-- in Eiffel.
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_long-2.1", (0).to_integer_64, obj.att_long)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_long-2.2", (0).to_integer_64, obj.att_long)

			appl.start_transaction (0)
			assert_equal ("get_long-2.3", (0).to_integer_64, obj.att_long)
			appl.abort_transaction
		end

	test_long_list1
		local
			obj: ATTRS_CLASS
			first, last: INTEGER_64
		do
			appl.start_transaction (0)
			first := 12345678955
			last := 456
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_long_list-1.1", 3, obj.att_long_list.count)
			assert_equal ("get_long_list-1.2", first, obj.att_long_list.first)
			assert_equal ("get_long_list-1.3", last, obj.att_long_list.last)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_long_list-1.10", 3, obj.att_long_list.count)
			assert_equal ("get_long_list-1.11", first, obj.att_long_list.first)

			appl.start_transaction (0)
			assert_equal ("get_long_list-1.20", last, obj.att_long_list.last)
			appl.abort_transaction
		end

	test_long_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_long_list-2.1", 0, obj.att_long_list.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_long_list-2.10", 0, obj.att_long_list.count)

			appl.start_transaction (0)
			assert_equal ("get_long_list-2.20", 0, obj.att_long_list.count)
			appl.abort_transaction
		end

feature -- MT_SHORT

	test_short1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_short-1.1", (30000).as_integer_16, obj.att_short)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_short-1.2", (30000).as_integer_16, obj.att_short)
		end

	test_short2
			-- The value is 0, which is the default integer value
			-- in Eiffel.
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_short-2.1", (0).as_integer_16, obj.att_short)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_short-2.2", (0).as_integer_16, obj.att_short)

			appl.start_transaction (0)
			assert_equal ("get_short-2.3", (0).as_integer_16, obj.att_short)
			appl.abort_transaction
		end

	test_short_list1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_short_list-1.1", 3, obj.att_short_list.count)
			assert_equal ("get_short_list-1.2", (30000).to_integer_16, obj.att_short_list.first)
			assert_equal ("get_short_list-1.3", (10000).to_integer_16, obj.att_short_list.last)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_short_list-1.10", 3, obj.att_short_list.count)
			assert_equal ("get_short_list-1.11", (10000).to_integer_16, obj.att_short_list.last)

			appl.start_transaction (0)
			assert_equal ("get_short_list-1.20", (30000).to_integer_16, obj.att_short_list.first)
			appl.abort_transaction
		end

	test_short_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_short_list-2.1", 0, obj.att_short_list.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_short_list-2.10", 0, obj.att_short_list.count)

			appl.start_transaction (0)
			assert_equal ("get_short_list-2.20", 0, obj.att_short_list.count)
			appl.abort_transaction
		end

feature -- MT_FLOAT

	test_real1 is
		local
			obj: ATTRS_CLASS
			a_real: REAL
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			a_real := -100.001
			assert_equal ("get_real-1.1", a_real, obj.att_float)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_real-1.2", a_real, obj.att_float)

			appl.start_transaction (0)
			assert_equal ("get_real-1.3", a_real, obj.att_float)
			appl.abort_transaction
		end

	test_real2
		local
			obj: ATTRS_CLASS
			a_real: REAL
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			a_real := 0.0
			assert_equal ("get_real-2.1", a_real, obj.att_float)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_real-2.2", a_real, obj.att_float)

			appl.start_transaction (0)
			assert_equal ("get_real-2.3", a_real, obj.att_float)
			appl.abort_transaction
		end

	test_real_list1
		local
			obj: ATTRS_CLASS
			real1, real2: REAL
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_real_list-1.1", 3, obj.att_float_list.count)
			real1 := -100.001
			assert_equal ("get_real_list-1.2", real1, obj.att_float_list.first)
			real2 := -300.003
			assert_equal ("get_real_list-1.3", real2, obj.att_float_list.last)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_real_list-1.11", 3, obj.att_float_list.count)
			assert_equal ("get_real_list-1.12", real1, obj.att_float_list.first)
			assert_equal ("get_real_list-1.13", real2, obj.att_float_list.last)

			appl.start_transaction (0)
			assert_equal ("get_real_list-1.11", 3, obj.att_float_list.count)
			assert_equal ("get_real_list-1.12", real1, obj.att_float_list.first)
			assert_equal ("get_real_list-1.13", real2, obj.att_float_list.last)
			appl.abort_transaction
		end

	test_real_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_real_list-2.1", 0, obj.att_float_list.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_real_list-2.11", 0, obj.att_float_list.count)

			appl.start_transaction (0)
			assert_equal ("get_real_list-2.11", 0, obj.att_float_list.count)
			appl.abort_transaction
		end

	test_real_array1
		local
			obj: ATTRS_CLASS
			real1, real2: REAL
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_real_array-1.1", 3, obj.att_float_array.count)
			real1 := -100.001
			assert_equal ("get_real_array-1.2", real1, obj.att_float_array.item(1))
			real2 := -300.003
			assert_equal ("get_real_array-1.3", real2, obj.att_float_array.item(3))
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_real_array-1.11", 3, obj.att_float_array.count)
			assert_equal ("get_real_array-1.12", real1, obj.att_float_array.item(1))
			assert_equal ("get_real_array-1.13", real2, obj.att_float_array.item(3))

			appl.start_transaction (0)
			assert_equal ("get_real_array-1.11", 3, obj.att_float_array.count)
			assert_equal ("get_real_array-1.12", real1, obj.att_float_array.item(1))
			assert_equal ("get_real_array-1.13", real2, obj.att_float_array.item(3))
			appl.abort_transaction
		end

	test_real_array2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_real_array-2.1", 0, obj.att_float_array.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_real_array-2.11", 0, obj.att_float_array.count)

			appl.start_transaction (0)
			assert_equal ("get_real_array-2.11", 0, obj.att_float_array.count)
			appl.abort_transaction
		end


feature -- MT_DOUBLE

	test_double1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_double-1.1", -100.001, obj.att_double)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_double-1.2", -100.001, obj.att_double)

			appl.start_transaction (0)
			assert_equal ("get_double-1.3", -100.001, obj.att_double)
			appl.abort_transaction
		end

	test_double2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_double-2.1", 0.0, obj.att_double)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_double-2.2", 0.0, obj.att_double)

			appl.start_transaction (0)
			assert_equal ("get_double-2.3", 0.0, obj.att_double)
			appl.abort_transaction
		end

	test_double_list1
		local
			obj: ATTRS_CLASS
			double1, double2: DOUBLE
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_double_list-1.1", 3, obj.att_double_list.count)
			double1 := -100.001
			assert_equal ("get_double_list-1.2", double1, obj.att_double_list.first)
			double2 := -300.003
			assert_equal ("get_double_list-1.3", double2, obj.att_double_list.last)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_double_list-1.11", 3, obj.att_double_list.count)
			assert_equal ("get_double_list-1.12", double1, obj.att_double_list.first)
			assert_equal ("get_double_list-1.13", double2, obj.att_double_list.last)

			appl.start_transaction (0)
			assert_equal ("get_double_list-1.11", 3, obj.att_double_list.count)
			assert_equal ("get_double_list-1.12", double1, obj.att_double_list.first)
			assert_equal ("get_double_list-1.13", double2, obj.att_double_list.last)
			appl.abort_transaction
		end

	test_double_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_double_list-2.1", 0, obj.att_double_list.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_double_list-2.11", 0, obj.att_double_list.count)

			appl.start_transaction (0)
			assert_equal ("get_double_list-2.11", 0, obj.att_double_list.count)
			appl.abort_transaction
		end

	test_double_array1
		local
			obj: ATTRS_CLASS
			double1, double2: DOUBLE
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_double_array-1.1", 3, obj.att_double_array.count)
			double1 := -100.001
			assert_equal ("get_double_array-1.2", double1, obj.att_double_array.item(1))
			double2 := -300.003
			assert_equal ("get_double_array-1.3", double2, obj.att_double_array.item(3))
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_double_array-1.11", 3, obj.att_double_array.count)
			assert_equal ("get_double_array-1.12", double1, obj.att_double_array.item(1))
			assert_equal ("get_double_array-1.13", double2, obj.att_double_array.item(3))

			appl.start_transaction (0)
			assert_equal ("get_double_array-1.11", 3, obj.att_double_array.count)
			assert_equal ("get_double_array-1.12", double1, obj.att_double_array.item(1))
			assert_equal ("get_double_array-1.13", double2, obj.att_double_array.item(3))
			appl.abort_transaction
		end

	test_double_array2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_double_array-2.1", 0, obj.att_double_array.count)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_double_array-2.11", 0, obj.att_double_array.count)

			appl.start_transaction (0)
			assert_equal ("get_double_array-2.11", 0, obj.att_double_array.count)
			appl.abort_transaction
		end

feature -- MT_CHAR

	test_char1
		local
			obj: ATTRS_CLASS
			char: CHARACTER
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_char-1.1", char, obj.att_char_null)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_char-1.11", char, obj.att_char_null)

			appl.start_transaction (0)
			assert_equal ("get_char-1.31", char, obj.att_char_null)
			appl.abort_transaction
		end

	test_char2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_char-2.1", 'Z', obj.att_char)
			appl.abort_transaction

			-- Can we still access the attribute after transaction
			assert_equal ("get_char-2.11", 'Z', obj.att_char)

			appl.start_transaction (0)
			assert_equal ("get_char-2.31", 'Z', obj.att_char)
			appl.abort_transaction
		end

feature -- MT_STRING

	test_string1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_string-1.1", "MATISSE eif", obj.att_string)
			appl.abort_transaction

			assert_equal ("get_string-1.11", "MATISSE eif", obj.att_string)

			appl.start_transaction (0)
			assert_equal ("get_string-1.21", "MATISSE eif", obj.att_string)
			appl.abort_transaction
		end

	test_string2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_string-2.1", Void, obj.att_string_null)
			appl.abort_transaction

			assert_equal ("get_string-2.11", Void, obj.att_string_null)

			appl.start_transaction (0)
			assert_equal ("get_string-2.21", Void, obj.att_string_null)
			appl.abort_transaction
		end

	test_string3
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_string-3.1", "", obj.att_string)
			appl.abort_transaction

			assert_equal ("get_string-3.11", "", obj.att_string)

			appl.start_transaction (0)
			assert_equal ("get_string-3.21", "", obj.att_string)
			appl.abort_transaction
		end

	test_string_list1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_string_list-1.1", 3, obj.att_string_list.count)
			assert_equal ("get_string_list-1.1", "MATISSE eif#1", obj.att_string_list.first)
			assert_equal ("get_string_list-1.1", "MATISSE eif#3", obj.att_string_list.last)
			appl.abort_transaction

			assert_equal ("get_string_list-1.1", 3, obj.att_string_list.count)
			assert_equal ("get_string_list-1.1", "MATISSE eif#1", obj.att_string_list.first)
			assert_equal ("get_string_list-1.1", "MATISSE eif#3", obj.att_string_list.last)

			appl.start_transaction (0)
			assert_equal ("get_string_list-1.1", 3, obj.att_string_list.count)
			assert_equal ("get_string_list-1.1", "MATISSE eif#1", obj.att_string_list.first)
			assert_equal ("get_string_list-1.1", "MATISSE eif#3", obj.att_string_list.last)
			appl.abort_transaction
		end

	test_string_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_string_list-2.1", Void, obj.att_string_list_null)
			appl.abort_transaction

			assert_equal ("get_string_list-2.1", Void, obj.att_string_list_null)

			appl.start_transaction (0)
			assert_equal ("get_string_list-2.1", Void, obj.att_string_list_null)
			appl.abort_transaction
		end

	test_string_list3
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i303", appl)
			assert_equal ("get_string_list-3.1", 3, obj.att_string_list.count)
			assert_equal ("get_string_list-3.2", "", obj.att_string_list.first)
			assert_equal ("get_string_list-3.3", "", obj.att_string_list.last)
			appl.abort_transaction

			assert_equal ("get_string_list-3.11", 3, obj.att_string_list.count)
			assert_equal ("get_string_list-3.12", "", obj.att_string_list.first)
			assert_equal ("get_string_list-3.13", "", obj.att_string_list.last)

			appl.start_transaction (0)
			assert_equal ("get_string_list-3.21", 3, obj.att_string_list.count)
			assert_equal ("get_string_list-3.22", "", obj.att_string_list.first)
			assert_equal ("get_string_list-3.23", "", obj.att_string_list.last)
			appl.abort_transaction
		end

feature -- MT_STRING (UTF8)

	test_string_utf8_1
		local
			obj: ATTRS_CLASS
			str: UC_STRING
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			str := obj.att_string_utf8
			assert_equal ("get_string_utf8-1.1", 4, str.count)
			assert_equal ("get_string_utf8-1.2", "a", str.item(1).out)
			assert_equal ("get_string_utf8-1.3", "b", str.item(2).out)
			appl.abort_transaction
		end

	test_string_utf8_2
			-- no value assigned (Unspecified)
		local
			obj: ATTRS_CLASS
			str: UC_STRING
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			str := obj.att_string_utf8_null
			assert_equal ("get_string_utf8-2", Void, str)
			appl.abort_transaction
		end

	test_string_utf8_3 is
			-- not null, but empty unicode string
		local
			obj: ATTRS_CLASS
			str: UC_STRING
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			str := obj.att_string_utf8
			assert_equal ("get_string_utf8-3", 0, str.count)
			appl.abort_transaction
		end

feature -- MT_BOOLEAN

	test_boolean1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_boolean-1.1", true, obj.att_boolean)
			appl.abort_transaction

			assert_equal ("get_boolean-1.11", true, obj.att_boolean)

			appl.start_transaction (0)
			assert_equal ("get_boolean-1.21", true, obj.att_boolean)
			appl.abort_transaction
		end

	test_boolean2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_boolean-2.1", false, obj.att_boolean_null)
			appl.abort_transaction

			assert_equal ("get_boolean-2.11", false, obj.att_boolean_null)

			appl.start_transaction (0)
			assert_equal ("get_boolean-2.21", false, obj.att_boolean_null)
			appl.abort_transaction
		end

	test_boolean_list1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_boolean-list-1.1", 5, obj.att_boolean_list.count)
			assert_equal ("get_boolean-list-1.2", true, obj.att_boolean_list.first)
			assert_equal ("get_boolean_list-1.3", false, obj.att_boolean_list.last)
			appl.abort_transaction

			assert_equal ("get_boolean-list-1.11", 5, obj.att_boolean_list.count)
			assert_equal ("get_boolean-list-1.12", true, obj.att_boolean_list.first)
			assert_equal ("get_boolean_list-1.13", false, obj.att_boolean_list.last)

			appl.start_transaction (0)
			assert_equal ("get_boolean-list-1.21", 5, obj.att_boolean_list.count)
			assert_equal ("get_boolean-list-1.22", true, obj.att_boolean_list.first)
			assert_equal ("get_boolean_list-1.23", false, obj.att_boolean_list.last)
			appl.abort_transaction
		end

	test_boolean_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_boolean-list-2.1", 0, obj.att_boolean_list.count)
			appl.abort_transaction

			assert_equal ("get_boolean-list-2.11", 0, obj.att_boolean_list.count)

			appl.start_transaction (0)
			assert_equal ("get_boolean-list-2.21", 0, obj.att_boolean_list.count)
			appl.abort_transaction
		end


	test_boolean_list3
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_boolean_list-3.1", Void, obj.att_boolean_list_null)
			appl.abort_transaction

			assert_equal ("get_boolean_list-3.2", Void, obj.att_boolean_list_null)

			appl.start_transaction (0)
			assert_equal ("get_boolean_list-3.3", Void, obj.att_boolean_list_null)
			appl.abort_transaction
		end

feature -- MT_DATE

	test_date1
		local
			obj: ATTRS_CLASS
			d: DATE
		do
			!!d.make(2002, 1, 15);
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_date-1.1", d, obj.att_date)
			appl.abort_transaction

			assert_equal ("get_date-1.11", d, obj.att_date)

			appl.start_transaction (0)
			assert_equal ("get_date-1.21", d, obj.att_date)
			appl.abort_transaction
		end

	test_date2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_date-2.1", Void, obj.att_date_null)
			appl.abort_transaction

			assert_equal ("get_date-2.11", Void, obj.att_date_null)

			appl.start_transaction (0)
			assert_equal ("get_date-2.21", Void, obj.att_date_null)
			appl.abort_transaction
		end


	test_date_list1
		local
			obj: ATTRS_CLASS
			d1, d2: DATE
		do
			!!d1.make(2002, 1, 15);
			!!d2.make(2002, 5, 16);
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_date_list-1.1", 3, obj.att_date_list.count)
			assert_equal ("get_date_list-1.2", d1, obj.att_date_list.first)
			assert_equal ("get_date_list-1.3", d2, obj.att_date_list.last)
			appl.abort_transaction

			assert_equal ("get_date_list-1.11", 3, obj.att_date_list.count)
			assert_equal ("get_date_list-1.12", d1, obj.att_date_list.first)
			assert_equal ("get_date_list-1.13", d2, obj.att_date_list.last)

			appl.start_transaction (0)
			assert_equal ("get_date_list-1.21", 3, obj.att_date_list.count)
			assert_equal ("get_date_list-1.22", d1, obj.att_date_list.first)
			assert_equal ("get_date_list-1.23", d2, obj.att_date_list.last)
			appl.abort_transaction
		end

-- Commented because data not ready...
--
	test_date_list2
		local
			obj: ATTRS_CLASS
			d1, d2: DATE
		do
			!!d1.make(2002, 1, 15);
			!!d2.make(2002, 5, 16);
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_date_list-1.1", 1, obj.att_date_list.count)
			appl.abort_transaction

			assert_equal ("get_date_list-1.11", 1, obj.att_date_list.count)

			appl.start_transaction (0)
			assert_equal ("get_date_list-1.21", 1, obj.att_date_list.count)
			appl.abort_transaction
		end



feature -- MT_TIMESTAMP

	test_timestamp1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("test_get_timestamp1-1.1", 2002, obj.att_ts.year)
			assert_equal ("test_get_timestamp1-1.2", 1, obj.att_ts.month)
			assert_equal ("test_get_timestamp1-1.3", 15, obj.att_ts.day)
			assert_equal ("test_get_timestamp1-1.4", 10, obj.att_ts.hour)
			assert_equal ("test_get_timestamp1-1.5", 27, obj.att_ts.minute)
			assert_equal ("test_get_timestamp1-1.6", 30, obj.att_ts.second)
			appl.abort_transaction

			assert_equal ("test_get_timestamp1-1.11", 2002, obj.att_ts.year)
			assert_equal ("test_get_timestamp1-1.12", 1, obj.att_ts.month)
			assert_equal ("test_get_timestamp1-1.13", 15, obj.att_ts.day)
			assert_equal ("test_get_timestamp1-1.14", 10, obj.att_ts.hour)
			assert_equal ("test_get_timestamp1-1.15", 27, obj.att_ts.minute)
			assert_equal ("test_get_timestamp1-1.16", 30, obj.att_ts.second)

			appl.start_transaction (0)
			assert_equal ("test_get_timestamp1-1.21", 2002, obj.att_ts.year)
			assert_equal ("test_get_timestamp1-1.22", 1, obj.att_ts.month)
			assert_equal ("test_get_timestamp1-1.23", 15, obj.att_ts.day)
			assert_equal ("test_get_timestamp1-1.24", 10, obj.att_ts.hour)
			assert_equal ("test_get_timestamp1-1.25", 27, obj.att_ts.minute)
			assert_equal ("test_get_timestamp1-1.26", 30, obj.att_ts.second)
			appl.abort_transaction
		end

	test_timestamp2
		-- Void (MATISSE attribute att_ts is unspecified (MT_NULL)
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("test_get_timestamp2-1", Void, obj.att_ts_null)
			appl.abort_transaction

			assert_equal ("test_get_timestamp2-2", Void, obj.att_ts_null)

			appl.start_transaction (0)
			assert_equal ("test_get_timestamp2-3", Void, obj.att_ts_null)
			appl.abort_transaction
		end

	test_ts_list1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_ts_list-1.1", 3, obj.att_ts_list.count)
			assert_equal ("get_ts_list-1.2", 2002, obj.att_ts_list.first.year)
			assert_equal ("get_ts_list-1.3", 1, obj.att_ts_list.first.month)
			assert_equal ("get_ts_list-1.4", 15, obj.att_ts_list.first.day)
			assert_equal ("get_ts_list-1.5", 10, obj.att_ts_list.first.hour)
			assert_equal ("get_ts_list-1.6", 27, obj.att_ts_list.first.minute)
			assert_equal ("get_ts_list-1.7", 30, obj.att_ts_list.first.second)
			assert_equal ("get_ts_list-1.8", 30.0, obj.att_ts_list.first.fine_second)
			assert_equal ("get_ts_list-1.9", 2002, obj.att_ts_list.last.year)
			assert_equal ("get_ts_list-1.10", 5, obj.att_ts_list.last.month)
			assert_equal ("get_ts_list-1.11", 16, obj.att_ts_list.last.day)
			assert_equal ("get_ts_list-1.12", 11, obj.att_ts_list.last.hour)
			assert_equal ("get_ts_list-1.13", 22, obj.att_ts_list.last.minute)
			assert_equal ("get_ts_list-1.14", 33, obj.att_ts_list.last.second)
			assert_equal ("get_ts_list-1.15", 33.001, obj.att_ts_list.last.fine_second)
			appl.abort_transaction

			assert_equal ("get_ts_list-1.11", 3, obj.att_ts_list.count)
			assert_equal ("get_ts_list-1.12", 2002, obj.att_ts_list.first.year)
			assert_equal ("get_ts_list-1.13", 1, obj.att_ts_list.first.month)
			assert_equal ("get_ts_list-1.14", 15, obj.att_ts_list.first.day)
			assert_equal ("get_ts_list-1.15", 10, obj.att_ts_list.first.hour)
			assert_equal ("get_ts_list-1.16", 27, obj.att_ts_list.first.minute)
			assert_equal ("get_ts_list-1.17", 30, obj.att_ts_list.first.second)
			assert_equal ("get_ts_list-1.18", 30.0, obj.att_ts_list.first.fine_second)
			assert_equal ("get_ts_list-1.19", 2002, obj.att_ts_list.last.year)
			assert_equal ("get_ts_list-1.110", 5, obj.att_ts_list.last.month)
			assert_equal ("get_ts_list-1.111", 16, obj.att_ts_list.last.day)
			assert_equal ("get_ts_list-1.112", 11, obj.att_ts_list.last.hour)
			assert_equal ("get_ts_list-1.113", 22, obj.att_ts_list.last.minute)
			assert_equal ("get_ts_list-1.114", 33, obj.att_ts_list.last.second)
			assert_equal ("get_ts_list-1.115", 33.001, obj.att_ts_list.last.fine_second)

			appl.start_transaction (0)
			assert_equal ("get_ts_list-1.21", 3, obj.att_ts_list.count)
			assert_equal ("get_ts_list-1.32", 2002, obj.att_ts_list.first.year)
			assert_equal ("get_ts_list-1.33", 1, obj.att_ts_list.first.month)
			assert_equal ("get_ts_list-1.34", 15, obj.att_ts_list.first.day)
			assert_equal ("get_ts_list-1.35", 10, obj.att_ts_list.first.hour)
			assert_equal ("get_ts_list-1.36", 27, obj.att_ts_list.first.minute)
			assert_equal ("get_ts_list-1.37", 30, obj.att_ts_list.first.second)
			assert_equal ("get_ts_list-1.38", 30.0, obj.att_ts_list.first.fine_second)
			assert_equal ("get_ts_list-1.39", 2002, obj.att_ts_list.last.year)
			assert_equal ("get_ts_list-1.310", 5, obj.att_ts_list.last.month)
			assert_equal ("get_ts_list-1.311", 16, obj.att_ts_list.last.day)
			assert_equal ("get_ts_list-1.312", 11, obj.att_ts_list.last.hour)
			assert_equal ("get_ts_list-1.313", 22, obj.att_ts_list.last.minute)
			assert_equal ("get_ts_list-1.314", 33, obj.att_ts_list.last.second)
			assert_equal ("get_ts_list-1.315", 33.001, obj.att_ts_list.last.fine_second)
			appl.abort_transaction
		end

	test_ts_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_ts_list-2.1", Void, obj.att_ts_list_null)
			appl.abort_transaction

			assert_equal ("get_ts_list-2.11", Void, obj.att_ts_list_null)

			appl.start_transaction (0)
			assert_equal ("get_ts_list-2.21", Void, obj.att_ts_list_null)
			appl.abort_transaction
		end

feature -- MT_INTERVAL

	test_ti1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_ti-1.1", -15, obj.att_ti.day)
			assert_equal ("get_ti-1.2", -10, obj.att_ti.hour)
			assert_equal ("get_ti-1.3", -27, obj.att_ti.minute)
			assert_equal ("get_ti-1.4", -30, obj.att_ti.second)
			assert_equal ("get_ti-1.5", true, (obj.att_ti.fine_second - (-30.123)).abs < 0.000001)
			appl.abort_transaction

			assert_equal ("get_ti-1.11", -15, obj.att_ti.day)
			assert_equal ("get_ti-1.12", -10, obj.att_ti.hour)
			assert_equal ("get_ti-1.13", -27, obj.att_ti.minute)
			assert_equal ("get_ti-1.14", -30, obj.att_ti.second)
			assert_equal ("get_ti-1.15", true, (obj.att_ti.fine_second - (-30.123)).abs < 0.000001)

			appl.start_transaction (0)
			assert_equal ("get_ti-1.21", -15, obj.att_ti.day)
			assert_equal ("get_ti-1.22", -10, obj.att_ti.hour)
			assert_equal ("get_ti-1.23", -27, obj.att_ti.minute)
			assert_equal ("get_ti-1.24", -30, obj.att_ti.second)
			assert_equal ("get_ti-1.25", true, (obj.att_ti.fine_second - (-30.123)).abs < 0.000001)
			appl.abort_transaction
		end

	test_ti2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_ti-2.1", 16, obj.att_ti.day)
			assert_equal ("get_ti-2.2", 10, obj.att_ti.hour)
			assert_equal ("get_ti-2.3", 27, obj.att_ti.minute)
			assert_equal ("get_ti-2.4", 30, obj.att_ti.second)
			assert_equal ("get_ti-2.5", true, (obj.att_ti.fine_second - (30.123)).abs < 0.000001)
			appl.abort_transaction

			assert_equal ("get_ti-2.11", 16, obj.att_ti.day)
			assert_equal ("get_ti-2.12", 10, obj.att_ti.hour)
			assert_equal ("get_ti-2.13", 27, obj.att_ti.minute)
			assert_equal ("get_ti-2.14", 30, obj.att_ti.second)
			assert_equal ("get_ti-2.15", true, (obj.att_ti.fine_second - (30.123)).abs < 0.000001)

			appl.start_transaction (0)
			assert_equal ("get_ti-2.21", 16, obj.att_ti.day)
			assert_equal ("get_ti-2.22", 10, obj.att_ti.hour)
			assert_equal ("get_ti-2.23", 27, obj.att_ti.minute)
			assert_equal ("get_ti-2.24", 30, obj.att_ti.second)
			assert_equal ("get_ti-2.25", true, (obj.att_ti.fine_second - (30.123)).abs < 0.000001)
			appl.abort_transaction
		end

	test_ti_list1
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("get_ti_list-1.0", 3, obj.att_ti_list.count)
			assert_equal ("get_ti_list-1.1", 15, obj.att_ti_list.first.day)
			assert_equal ("get_ti_list-1.2", 10, obj.att_ti_list.first.hour)
			assert_equal ("get_ti_list-1.3", 27, obj.att_ti_list.first.minute)
			assert_equal ("get_ti_list-1.4", 30, obj.att_ti_list.first.second)
			assert_equal ("get_ti_list-1.5", true,
											(obj.att_ti_list.first.fine_second - (30.123)).abs < 0.000001)
			assert_equal ("get_ti_list-1.6", -16, obj.att_ti_list.last.day)
			assert_equal ("get_ti_list-1.7", -10, obj.att_ti_list.last.hour)
			assert_equal ("get_ti_list-1.8", -27, obj.att_ti_list.last.minute)
			assert_equal ("get_ti_list-1.9", -31, obj.att_ti_list.last.second)
			assert_equal ("get_ti_list-1.9a", true,
										(obj.att_ti_list.last.fine_second - (-31.123)).abs < 0.000001)
			appl.abort_transaction

			assert_equal ("get_ti_list-1.10", 3, obj.att_ti_list.count)
			assert_equal ("get_ti_list-1.11", 15, obj.att_ti_list.first.day)
			assert_equal ("get_ti_list-1.12", 10, obj.att_ti_list.first.hour)
			assert_equal ("get_ti_list-1.13", 27, obj.att_ti_list.first.minute)
			assert_equal ("get_ti_list-1.14", 30, obj.att_ti_list.first.second)
			assert_equal ("get_ti_list-1.15", true,
										(obj.att_ti_list.first.fine_second - (30.123)).abs < 0.000001)
			assert_equal ("get_ti_list-1.16", -16, obj.att_ti_list.last.day)
			assert_equal ("get_ti_list-1.17", -10, obj.att_ti_list.last.hour)
			assert_equal ("get_ti_list-1.18", -27, obj.att_ti_list.last.minute)
			assert_equal ("get_ti_list-1.19", -31, obj.att_ti_list.last.second)
			assert_equal ("get_ti_list-1.19a", true,
										(obj.att_ti_list.last.fine_second - (-31.123)).abs < 0.000001)

			appl.start_transaction (0)
			assert_equal ("get_ti_list-1.20", 3, obj.att_ti_list.count)
			assert_equal ("get_ti_list-1.21", 15, obj.att_ti_list.first.day)
			assert_equal ("get_ti_list-1.22", 10, obj.att_ti_list.first.hour)
			assert_equal ("get_ti_list-1.23", 27, obj.att_ti_list.first.minute)
			assert_equal ("get_ti_list-1.24", 30, obj.att_ti_list.first.second)
			assert_equal ("get_ti_list-1.25", true,
										(obj.att_ti_list.first.fine_second - (30.123)).abs < 0.000001)
			assert_equal ("get_ti_list-1.26", -16, obj.att_ti_list.last.day)
			assert_equal ("get_ti_list-1.27", -10, obj.att_ti_list.last.hour)
			assert_equal ("get_ti_list-1.28", -27, obj.att_ti_list.last.minute)
			assert_equal ("get_ti_list-1.29", -31, obj.att_ti_list.last.second)
			assert_equal ("get_ti_list-1.29a", true,
										(obj.att_ti_list.last.fine_second - (-31.123)).abs < 0.000001)
			appl.abort_transaction
		end

	-- commented because data is not ready due to mt_xml bug
	test_ti_list2
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			assert_equal ("get_ti_list-2.0", 1, obj.att_ti_list.count)
			appl.abort_transaction

			assert_equal ("get_ti_list-2.10", 1, obj.att_ti_list.count)

			appl.start_transaction (0)
			assert_equal ("get_ti_list-2.20", 1, obj.att_ti_list.count)
			appl.abort_transaction
		end

feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE
	dummy: MT_LINKED_LIST[MT_STORABLE]
end
