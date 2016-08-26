note
	description: "Test cases for SQL interface."
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


deferred class TEST_SQL

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

feature -- Test simple case

	test_sql_simple1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			i: INTEGER
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			rset := sql_stmt.execute_query
			        ("SELECT identifier, att_integer FROM Attrs_Class ORDER BY identifier")
			from
				rset.start
			until
				rset.exhausted
			loop
				inspect i
				when 0 then
					assert_equal ("test_sql_simple1-1", -100, rset.get_integer (2))
				when 1 then
					assert_equal ("test_sql_simple1-2", 0, rset.get_integer (2))
				when 2 then
					assert_equal ("test_sql_simple1-3", 0, rset.get_integer (2))
				end
				i := i + 1
				rset.forth
			end
			rset.close
			sql_stmt.close

			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end


feature -- Get values

	test_get_double1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_double, att_double_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable double attribute, the first column
			assert_equal ("test_get_double-1", -100.001, rset.get_double(1));

			-- check type
			assert_equal ("test_get_double-2", {MT_TYPE}.Mt_Double, rset.get_type(1));

			-- nullable integer attriute, the second column
			-- this actually NULL
			assert_equal ("test_get_double-3", 0.0, rset.get_double(2));

			-- check type
			assert_equal ("test_get_double-4", {MT_TYPE}.Mt_Null, rset.get_type(2));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_float1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			a_real: REAL
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_float, att_float_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable float attribute, the first column
			a_real := -100.001
			assert_equal ("test_get_float1-1", a_real, rset.get_float(1))

			-- check type
			assert_equal ("test_get_float1-2", {MT_TYPE}.Mt_Float, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this actually NULL
			a_real := 0.0
			assert_equal ("test_get_float1-3", a_real, rset.get_float(2))

			-- check type
			assert_equal ("test_get_float1-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_date1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			date: DATE
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_date, att_date_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable date attribute, the first column
			create date.make (2002, 1, 15)
			assert_equal ("test_get_date1-1", date, rset.get_date(1))

			-- check type
			assert_equal ("test_get_date1-2", {MT_TYPE}.Mt_Date, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this actually NULL
			assert_equal ("test_get_date1-3", Void, rset.get_date(2))

			-- check type
			assert_equal ("test_get_date1-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_timestamp1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			ts: DATE_TIME
			tmp: DOUBLE
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_ts, att_ts_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable date attribute, the first column
			create ts.make_fine (2002, 1, 15, 10, 27, 30.0)
			assert_equal ("test_get_timestamp1-1.1", 2002, rset.get_timestamp(1).year)
			assert_equal ("test_get_timestamp1-1.2", 1, rset.get_timestamp(1).month)
			assert_equal ("test_get_timestamp1-1.3", 15, rset.get_timestamp(1).day)
			assert_equal ("test_get_timestamp1-1.4", 10, rset.get_timestamp(1).hour)
			assert_equal ("test_get_timestamp1-1.5", 27, rset.get_timestamp(1).minute)
			assert_equal ("test_get_timestamp1-1.6", 30, rset.get_timestamp(1).second)
			tmp := (rset.get_timestamp(1).fine_second - 30.0).abs
			assert_equal ("test_get_timestamp1-1.7", True, tmp < 0.000000001)

			-- check type
			assert_equal ("test_get_timestamp1-2", {MT_TYPE}.Mt_Timestamp, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this actually NULL
			assert_equal ("test_get_timestamp1-3", Void, rset.get_timestamp(2));

			-- check type
			assert_equal ("test_get_timestamp1-4", {MT_TYPE}.Mt_Null, rset.get_type(2));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_interval1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			ti: DATE_TIME_DURATION
			tmp: DOUBLE
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_ti, att_ti_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable time interval attribute, the first column
			ti := rset.get_interval(1)
			assert_equal ("test_get_interval1-1.3", -15, rset.get_interval(1).day)
			assert_equal ("test_get_interval1-1.4", -10, rset.get_interval(1).hour)
			assert_equal ("test_get_interval1-1.5", -27, rset.get_interval(1).minute)
			assert_equal ("test_get_interval1-1.6", -30, rset.get_interval(1).second)
			tmp := (rset.get_interval(1).fine_second - (-30.123)).abs
			assert_equal ("test_get_interval1-1.7", True, tmp < 0.0000001)

			-- check type
			assert_equal ("test_get_interval1-2", {MT_TYPE}.Mt_Interval, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this actually NULL
			assert_equal ("test_get_interval1-3", Void, rset.get_interval(2));

			-- check type
			assert_equal ("test_get_interval1-4", {MT_TYPE}.Mt_Null, rset.get_type(2));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_byte
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_byte, att_byte_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable byte attribute, the first column
			assert_equal ("test_get_byte-1", (100).to_integer_8, rset.get_byte(1))

			-- check type
			assert_equal ("test_get_byte-2", {MT_TYPE}.Mt_Byte, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this actually NULL
			assert_equal ("test_get_byte-3", (0).to_integer_8, rset.get_byte(2))

			-- check type
			assert_equal ("test_get_byte-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_bytes
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			tmp: ARRAY[INTEGER_8]
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_bytes, att_bytes_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			create tmp.make (1, 7)
			tmp.put((255).to_integer_8, 1)
			tmp.put((254).to_integer_8, 2)
			tmp.put((0).to_integer_8, 3)
			tmp.put((1).to_integer_8, 4)
			tmp.put((10).to_integer_8, 5)
			tmp.put((160).to_integer_8, 6)
			tmp.put((0).to_integer_8, 7)
			-- non-nullable bytes attribute, the first column
			assert_equal ("test_get_bytes-1", tmp, rset.get_bytes(1))

			-- check type
-- temoprarily diabled
--			assert_equal ("test_get_bytes-2", {MT_TYPE}.Mt_Bytes, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this is actually NULL
			assert_equal ("test_get_bytes-3", Void, rset.get_bytes(2))

			-- check type
-- temoprarily diabled
--			assert_equal ("test_get_bytes-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end


	test_get_text
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_text, att_text_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable text attribute, the first column
--			assert_equal ("test_get_text-1", 2000, rset.get_text(1).count)

			-- check type
			-- TBD
			--assert_equal ("test_get_text-2", {MT_TYPE}.Mt_Text, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this is actually NULL
			assert_equal ("test_get_text-3", Void, rset.get_text(2))

			-- check type
			assert_equal ("test_get_text-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_char
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			tmp: CHARACTER
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_char, att_char_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable char attribute, the first column
			assert_equal ("test_get_char-1", 'a', rset.get_character(1))

			-- check type
			assert_equal ("test_get_char-2", {MT_TYPE}.Mt_Char, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this is actually NULL
			assert_equal ("test_get_char-3", tmp, rset.get_character(2))

			-- check type
			assert_equal ("test_get_char-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_short
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_short, att_short_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable short attribute, the first column
			assert_equal ("test_get_short-1", (30000).to_integer_16, rset.get_short(1))

			-- check type
			assert_equal ("test_get_short-2", {MT_TYPE}.Mt_Short, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this is actually NULL
			assert_equal ("test_get_short-3", (0).to_integer_16, rset.get_short(2))

			-- check type
			assert_equal ("test_get_short-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_integer
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_integer, att_integer_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable integer attribute, the first column
			assert_equal ("test_get_integer-1", -100, rset.get_integer(1))

			-- check type
			assert_equal ("test_get_integer-2", {MT_TYPE}.Mt_Integer, rset.get_type(1))

			-- nullable integer attriute, the second column
			-- this is actually NULL
			assert_equal ("test_get_integer-3", 0, rset.get_integer(2))

			-- check type
			assert_equal ("test_get_integer-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_long1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			tmp: INTEGER_64
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_long, att_long_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable long attribute, the first column
			tmp := (123456789).to_integer_64
			tmp := tmp * 100
			assert_equal ("test_get_long-1", tmp, rset.get_long(1))

			-- check type
			assert_equal ("test_get_long-2", {MT_TYPE}.Mt_Long, rset.get_type(1))

			-- nullable long attriute, the second column
			-- this is actually NULL
			assert_equal ("test_get_long-3", (0).to_integer_64, rset.get_long(2))

			-- check type
			assert_equal ("test_get_long-4", {MT_TYPE}.Mt_Null, rset.get_type(2))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_decimal
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			a_decimal: DECIMAL
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_numeric, att_numeric_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable decimal attribute, the first column
			create a_decimal.make_from_string ("-100.01");
			assert_equal ("test_get_decimal-1", a_decimal, rset.get_decimal(1));

			-- check type
			assert_equal ("test_get_decimal-2", {MT_TYPE}.Mt_Numeric, rset.get_type(1));

			-- nullable integer attriute, the second column
			-- this is actually NULL
			assert_equal ("test_get_decimal-3", Void, rset.get_decimal(2));

			-- check type
			assert_equal ("test_get_decimal-4", {MT_TYPE}.Mt_Null, rset.get_type(2));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_boolean
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_boolean, att_boolean_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable integer attribute, the first column
			assert_equal ("test_get_boolean-1", True, rset.get_boolean(1));

			-- check type
			assert_equal ("test_get_boolean-2", {MT_TYPE}.Mt_Boolean, rset.get_type(1));

			-- nullable integer attriute, the second column
			-- this is actually NULL, so returns the default value, False
			assert_equal ("test_get_boolean-3", False, rset.get_boolean(2));

			-- check type
			assert_equal ("test_get_boolean-4", {MT_TYPE}.Mt_Null, rset.get_type(2));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_string
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_string, att_string_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable integer attribute, the first column
			assert_equal ("test_get_string-1", "MATISSE eif", rset.get_string(1));

			-- check type
			assert_equal ("test_get_string-2", {MT_TYPE}.Mt_String, rset.get_type(1));

			-- nullable integer attriute, the second column
			-- this is actually NULL, so returns the default value, False
			assert_equal ("test_get_string-3", Void, rset.get_string(2));

			-- check type
			assert_equal ("test_get_string-4", {MT_TYPE}.Mt_Null, rset.get_type(2));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_string2
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_string, att_string_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i302'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable integer attribute, the first column
			-- Empty string
			assert_equal ("test_get_string2-1", "", rset.get_string(1));

			-- check type
			assert_equal ("test_get_string2-2", {MT_TYPE}.Mt_String, rset.get_type(1));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_oid1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT OID FROM Attrs_Class WHERE identifier = 'i302'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- check type
			assert_equal ("test_get_oid1-2", {MT_TYPE}.Mt_String, rset.get_type(1));

			-- non-nullable integer attribute, the first column
			-- Empty string
			assert_equal ("test_get_oid1-1", True, rset.get_oid(1) /= Void );

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_object1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT REF(c) FROM Attrs_Class c WHERE %
			         %identifier = 'i301' OR identifier = 'i302' ORDER BY identifier"
			rset := sql_stmt.execute_query (query)

			rset.start
			assert_equal ("test_get_object1-1", {MT_TYPE}.Mt_Oid, rset.get_type (1));
			obj ?= rset.get_object (1)
			assert_equal ("test_get_object1-2", "i301", obj.identifier);

			rset.forth
			assert_equal ("test_get_object1-3", {MT_TYPE}.Mt_Oid, rset.get_type (1));
			obj ?= rset.get_object (1)
			assert_equal ("test_get_object1-4", "i302", obj.identifier);

			rset.forth
			assert_equal ("test_get_object1-5", True, rset.exhausted);

			rset.close
			assert_equal ("test_get_object1-6", False, rset.is_open);

			sql_stmt.close
			assert_equal ("test_get_object1-5", False, sql_stmt.is_open);
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_any1
			-- get an integer value from MATISSE attribute that is defined
			-- as MT_ANY
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_any as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- any attribute, the first column
--			assert_equal ("test_get_any1-1", 12345, rset.get_integer(1));

			-- check type
--			assert_equal ("test_get_any1-2", {MT_TYPE}.Mt_Integer, rset.get_type(1));

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_get_value1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			a_decimal: DECIMAL
			ts: DATE_TIME
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_boolean, att_string, att_numeric, att_ts as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			rset.start

			-- non-nullable integer attribute, the first column
			assert_equal ("test_get_value1-1", True, rset.get_value(1));
			assert_equal ("test_get_value1-2", "MATISSE eif", rset.get_value(2));

			create a_decimal.make_from_string ("-100.01");
			assert_equal ("test_get_value1-3", a_decimal, rset.get_value(3));

			ts ?= rset.get_value (4)
			assert_equal ("test_get_value1-4.1", 2002, ts.year)
			assert_equal ("test_get_value1-4.2", 1, ts.month)
			assert_equal ("test_get_value1-4.3", 15, ts.day)

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

feature	-- Test empty result set

	test_no_obj_selected1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			obj_count: INTEGER
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT OID FROM Attrs_Class WHERE identifier = 'no_such_id_there!!!'"
			rset := sql_stmt.execute_query (query)

			from
				rset.start
			until
				rset.exhausted
			loop
				obj_count := obj_count + 1
				rset.forth
			end

			assert_equal ("test_no_obj_selected1-1", 0, obj_count)

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end


feature -- Test aggregation

	test_aggregate1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT COUNT(*) FROM Attrs_Class WHERE %
			         %identifier = 'i301' OR identifier = 'i302'"
			rset := sql_stmt.execute_query (query)
			rset.start
			assert_equal ("test_aggregate1-1", (2).to_integer_64, rset.get_long(1))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_aggregate2
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			a_decimal: DECIMAL
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT SUM(att_numeric) FROM Attrs_Class WHERE %
			%identifier = 'i301' OR identifier = 'i302'"
			rset := sql_stmt.execute_query (query)
			rset.start

			create a_decimal.make_from_string ("-100.01")
			assert_equal ("test_aggregate1-1", a_decimal, rset.get_decimal(1))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

feature -- Test execute_update

	test_execute_update1
		local
			sql_stmt: MT_STATEMENT
			query: STRING
			ucount: INTEGER
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "UPDATE Attrs_Class SET identifier = 'foobar' WHERE %
			%identifier = 'i301' OR identifier = 'i302'"
			ucount := sql_stmt.execute_update (query)

			assert_equal ("test_execute_update1-1", 2, ucount)
			assert_equal ("test_execute_update1-2", 2, sql_stmt.update_count);

			sql_stmt.close
			appl.abort_transaction
		rescue
			sql_stmt.close
		end

feature -- Test execute	and get result

	test_execute1
		local
			sql_stmt: MT_STATEMENT
			query: STRING
			bool: BOOLEAN
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "UPDATE Attrs_Class SET identifier = 'foobar' WHERE %
			%identifier = 'i301' OR identifier = 'i302'"
			bool := sql_stmt.execute (query)
			assert_equal ("test_execute1-1", False, bool)
			assert_equal ("test_execute1-2", 2, sql_stmt.update_count);
			assert_equal ("test_execute1-3", Void, sql_stmt.result_set);

			sql_stmt.close
			appl.abort_transaction
		rescue
			sql_stmt.close
		end

	test_execute2
		-- Execute SELECT stmt, and call update_count
		local
			sql_stmt: MT_STATEMENT
			query: STRING
			bool: BOOLEAN
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT * FROM Attrs_Class"
			bool := sql_stmt.execute (query)
			assert_equal ("test_execute2-1", True, bool)
			assert_equal ("test_execute2-2", -1, sql_stmt.update_count);

			sql_stmt.close
			appl.abort_transaction
		rescue
			sql_stmt.close
		end

	test_execute3
		-- Execute SELECT stmt, and get update count
		local
			sql_stmt: MT_STATEMENT
			query: STRING
			bool: BOOLEAN
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT * FROM Attrs_Class"
			bool := sql_stmt.execute (query)
			assert_equal ("test_execute3-1", True, bool)
			assert_equal ("test_execute3-2", -1, sql_stmt.update_count);

			sql_stmt.close
			appl.abort_transaction
		rescue
			sql_stmt.close
		end

	test_execute4
		-- Execute SELECT stmt, and get result set
		local
			sql_stmt: MT_STATEMENT
			query: STRING
			bool: BOOLEAN
			rset, rset2: MT_RESULT_SET
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT identifier FROM Attrs_Class WHERE identifier = 'i301'"
			bool := sql_stmt.execute (query)
			assert_equal ("test_execute4-1", True, bool)
			rset := sql_stmt.result_set
			assert_equal ("test_execute4-2", True, rset /= Void);

			rset2 := sql_stmt.result_set
			assert_equal ("test_execute4-4", True, rset = rset2);

			rset.start
			assert_equal ("test_execute4-5", "i301", rset.get_string(1));

			-- you can't get result set again because the result set is
			-- already open.
			assert_equal ("test_execute4-6", True, sql_stmt.result_set = Void);

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			sql_stmt.close
		end

feature -- Test stmt info

	test_stmt_info1
		local
			sql_stmt: MT_STATEMENT
			query: STRING
			bool: BOOLEAN
		do
			-- change the data access mode temporarily
			appl.set_data_access_mode ({MT_STORABLE_DATABASE}.Mt_Data_Definition)

			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "CREATE CLASS fooooooo (asdfsdfsd INTEGER)"
			bool := sql_stmt.execute (query)

			assert_equal ("test_stmt_info1-1", False, bool)
			assert_equal ("test_stmt_info1-2", {MT_STATEMENT}.MtSql_Create, sql_stmt.statement_type)
--			assert_equal ("test_stmt_info1-3", "fooooooo", sql_stmt.statement_info(MtSql_Stmt_Class))
			sql_stmt.close
			appl.abort_transaction


			-- reset the data access mode
			appl.set_data_access_mode ({MT_STORABLE_DATABASE}.Mt_Data_Modification)
		rescue
			sql_stmt.close
			appl.set_data_access_mode ({MT_STORABLE_DATABASE}.Mt_Data_Modification)
		end


feature -- Test implicit closing of result_set

	test_close_result_set1
		local
			sql_stmt: MT_STATEMENT
			rset, rset2: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_string, att_string_null as alias_name FROM Attrs_Class"
			rset := sql_stmt.execute_query (query)

			-- SQL stream is open on the result set
			rset.start

			-- get something
			assert_equal ("test_close_result_set1-1", True, rset.get_string(1) /= Void);

			-- Let's execute another statement without closing the result set.
			query := "SELECT att_integer, att_integer_null as alias_name FROM %
			%Attrs_Class WHERE identifier = 'i301'"
			rset2 := sql_stmt.execute_query (query)

			-- The first result set should have been closed
			assert_equal ("test_close_result_set1-2", False, rset.is_open)

			rset2.start
			-- non-nullable integer attribute, the first column
			assert_equal ("test_close_result_set1-3", -100, rset2.get_integer(1))

			rset2.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_close_result_set2
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			ucount: INTEGER
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_string, att_string_null as alias_name FROM Attrs_Class"
			rset := sql_stmt.execute_query (query)

			-- SQL stream is open on the result set
			rset.start

			-- get something
			assert_equal ("test_close_result_set2-1", True, rset.get_string(1) /= Void);

			-- Let's execute another UPDATE statement without closing the result set.
			query := "UPDATE Attrs_Class SET identifier = 'foobar' WHERE %
			%identifier = 'i301' OR identifier = 'i302'"
			ucount := sql_stmt.execute_update (query)

			-- The first result set should have been closed
			assert_equal ("test_close_result_set2-2", False, rset.is_open)

			-- non-nullable integer attribute, the first column
			assert_equal ("test_close_result_set2-3", 2, ucount)

			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end



feature -- Test status-setting

	test_set_current1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT identifier FROM Attrs_Class ORDER BY identifier"
			rset := sql_stmt.execute_query (query)
			rset.start
			rset.set_current (2)
			assert_equal ("test_set_current1-1", "i302", rset.get_string (1))

			rset.close
			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end


feature -- Test status-report

	test_exhausted1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			row_count: INTEGER
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT OID FROM Attrs_Class WHERE identifier = 'i301' %
               %OR identifier = 'i302'"
		  rset := sql_stmt.execute_query (query)
			from
				rset.start
			until
				rset.exhausted
			loop
				row_count := row_count + 1
				rset.forth
			end
			rset.close
			sql_stmt.close

			assert_equal ("test_exhausted1-1", 2, row_count)
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end


feature -- Find column meta data

	test_find_column_index1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			rset := sql_stmt.execute_query
			("SELECT oid, att_integer, att_integer_null as alias_name FROM Attrs_Class")

			assert_equal ("test_find_column_index1-1", 1, rset.find_column("OID"))
			assert_equal ("test_find_column_index1-2", 2, rset.find_column("att_integer"))
			assert_equal ("test_find_column_index1-3", 3, rset.find_column("alias_name"))
			assert_equal ("test_find_column_index1-4", 0, rset.find_column("att_integer_null"))
			assert_equal ("test_find_column_index1-5", 0, rset.find_column("hoge-hoge"))

			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
	  end

	test_column_count1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			rset := sql_stmt.execute_query
			("SELECT oid, att_integer, att_integer_null as alias_name FROM Attrs_Class")
			assert_equal ("test_column_count1-1", 3, rset.column_count)

			rset := sql_stmt.execute_query
			("SELECT count(*) FROM Attrs_Class")
			assert_equal ("test_column_count1-2", 1, rset.column_count)

			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

	test_column_name1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
		do
			appl.start_transaction (0)
			sql_stmt := appl.create_statement
			query := "SELECT att_boolean, att_boolean_null as alias_name FROM %
               %Attrs_Class WHERE identifier = 'i301'"
			rset := sql_stmt.execute_query (query)

			assert_equal ("test_column_name1-1", "att_boolean",
										rset.get_column_name (1))
			assert_equal ("test_column_name1-2", "alias_name",
										rset.column_name (2))

			sql_stmt.close
			appl.abort_transaction
		rescue
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
		end

feature -- Test sessions
	-- MATISSE OOS starts a version access if it received a request
	-- of SQL execution without tran or version.
	-- The Eiffel binding avoids it since, the binding needs to
	-- manage the session status

	test_sql_session1
		local
		--	obj: NUMERIC_CLASS
		--	sql_stmt: MT_STATEMENT
		--	rset: MT_RESULT_SET
		--	query: STRING
		--	retried: BOOLEAN
		do
--			if not retried then
--				sql_stmt := appl.create_statement
--				query := "SELECT REF(c) FROM Super c WHERE identifier = 'i101'"
--				  -- try to execute SQL without tran or version

--				rset := sql_stmt.execute_query (query)
--			end
		rescue
--			assert_equal ("test_sql_session1-1", true, sql_stmt.is_open)
--			sql_stmt.close
--			retried := True;
--			retry
		end


feature -- Test error cases

	test_syntax_error1
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			query: STRING
			retried: BOOLEAN
		do
			if not retried then
				appl.start_transaction (0)
				sql_stmt := appl.create_statement
				query := "SELECT att_boolean, att_boolean_null as alias_name FROM %
				%Attrs_Class FROM"
				rset := sql_stmt.execute_query (query)

				sql_stmt.close
				appl.abort_transaction
			end
		rescue
			assert_equal ("test_syntax_error1-1", Matisse_Syntax_Error,
										matisse_exception_code);
			retried := True;
			sql_stmt.close
			retry
		end


feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE

	zzzzz_: ATTRS_CLASS
	aaaaa_: MT_LINKED_LIST[ATTRS_CLASS]
	ddddd_: MT_ARRAY[ATTRS_CLASS]
end
