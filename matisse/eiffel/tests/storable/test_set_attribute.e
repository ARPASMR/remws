note
	description: "Test cases for setting attribute values."
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


deferred class TEST_SET_ATTRIBUTE

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

feature -- Decimal (MT_NUMERIC)

	test_decimal1
		local
			obj: NUMERIC_CLASS
			new_value: DECIMAL
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)

			create new_value.make_from_string ("10.05")
			obj.set_att_numeric1 (new_value)

			assert_equal ("set_decimal-1", new_value,
										obj.mt_get_decimal_by_name ("att_numeric1"))
			appl.abort_transaction
		end

	test_decimal2
		local
			obj: NUMERIC_CLASS
			new_value: DECIMAL
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)

			create new_value.make_from_string ("0.05")
			obj.set_att_numeric1 (new_value)

			assert_equal ("set_decimal-2", new_value,
										obj.mt_get_decimal_by_name ("att_numeric1"))
			appl.abort_transaction
		end

	-- TBD
	test_decimal3
		local
			obj: NUMERIC_CLASS
			new_value: DECIMAL
			retried: BOOLEAN
		do
			if not retried then
				appl.start_transaction (0)
				obj ?= get_object_from_identifier ("i101", appl)

				-- att_numeric2: Numeric(10, 4)
				-- set a value which has more precision than 10.
				-- We should get a MATISSE developer exception.
				create new_value.make_from_string ("123456789.1234")
				obj.set_att_numeric2 (new_value)
				appl.abort_transaction
			else
				if appl.is_transaction_in_progress then
					appl.abort_transaction
				end
			end
		rescue
			assert_equal ("set_decimal-3.1", Developer_exception, exception)
			--assert_equal ("set_decimal-3.2", Matisse_, matisse_exception_code)
			retried := True
			retry
		end

	test_decimal4
		local
			obj: NUMERIC_CLASS
			new_value: DECIMAL
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)

			--create new_value.make_from_string ("0")
			create new_value.make_from_integer64 (0)
			obj.set_att_numeric1 (new_value)

			assert_equal ("set_decimal-4", new_value,
										obj.mt_get_decimal_by_name ("att_numeric1"))
			appl.abort_transaction
		end

	test_decimal10
		local
			obj: NUMERIC_CLASS
			new_value: DECIMAL
			new_list, res: LINKED_LIST[DECIMAL]
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)

			-- set new value
			create new_list.make
			create new_value.make_from_string ("1234.56")
			new_list.extend (new_value)
			create new_value.make_from_string ("0.56")
			new_list.extend (new_value)
			obj.set_att_numericlist (new_list)

			-- get new value and check
			res := obj.mt_get_decimal_list_by_name ("att_numericlist")
			assert_equal ("set_decimal-10.1", 2, res.count)

			if res.count = 2 then
				res.start
				assert_equal ("set_decimal-10.2", "1234.56", res.item.out)
				res.forth
				assert_equal ("set_decimal-10.3", "0.56", res.item.out)
			end

			appl.abort_transaction
		end

	test_decimal11
		local
			obj: NUMERIC_CLASS
		--	new_value: DECIMAL
			new_list: LINKED_LIST[DECIMAL]
		--	res: LINKED_LIST[DECIMAL]
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)

			-- set empty list
			create new_list.make
--			obj.set_att_numericlist (new_list)

			-- get new value and check
--			res := obj.mt_get_decimal_list_by_name ("att_numericlist")
--			assert_equal ("set_decimal-11.1", 0, res.count)

			appl.abort_transaction
		end

	test_decima20
		local
			obj: NUMERIC_CLASS
			new_value, a, b: DECIMAL
		do
			create a.make_from_string_precision_scale ("230.0", 19, 8)
			create b.make_from_string_precision_scale ("2.0", 2, 1)
			new_value := a - b

			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i102", appl)

			obj.set_att_numeric3 (new_value)

			assert_equal ("set_decimal-20", new_value,
										obj.mt_get_decimal_by_name ("att_numeric3"))
			--appl.abort_transaction
			appl.commit ()
		end

feature -- MT_STRING UTF-8

	test_string_utf8_1
		local
			obj: ATTRS_CLASS
			str: UC_STRING
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			str := obj.att_string_utf8
			obj.set_att_string_utf8 (str)
			appl.commit ()

			appl.start_transaction (0)
			str := obj.att_string_utf8
			assert_equal ("set_string_utf8-1.1", 4, str.count)
			assert_equal ("set_string_utf8-1.2", "a", str.item(1).out)
			assert_equal ("set_string_utf8-1.3", "b", str.item(2).out)
			appl.abort_transaction
		end

	test_string_utf8_2
		-- Remove the value (make it unspecified)
		local
			obj: ATTRS_CLASS
			str: UC_STRING
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			--obj.set_att_string_utf8_null (Void)
			obj.mt_remove_value_by_name ("att_string_utf8_null")
			appl.commit ()

			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			str := obj.att_string_utf8_null
			assert_equal ("set_string_utf8-2", Void, str)
			appl.abort_transaction
		end

	test_string_utf8_2_1
		-- Remove the value (make it unspecified)
		local
			obj: ATTRS_CLASS
			str: UC_STRING
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			obj.set_att_string_utf8_null (Void)
			--obj.mt_remove_value_by_name ("att_string_utf8_null")
			appl.commit ()

			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			str := obj.att_string_utf8_null
			assert_equal ("set_string_utf8-2-1", Void, str)
			appl.abort_transaction
		end

	test_string_utf8_3
		-- set empty string
		local
			obj: ATTRS_CLASS
			str: UC_STRING
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			create str.make_from_string ("")
			obj.set_att_string_utf8 (str)
			appl.commit ()

			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i302", appl)
			str := obj.att_string_utf8
			assert_equal ("set_string_utf8-3", 0, str.count)
			appl.abort_transaction
		end

	test_string_utf8_4
		-- Set a Japanese string 'nakao' in UTF8
		local
		--	obj: ATTRS_CLASS
		--	str: UC_STRING
		do
--			appl.start_transaction (0)
--			obj ?= get_object_from_identifier ("i303", appl)
--			create str.make (2)
--			str.append_code (20013) -- naka in Japanese
--			str.append_code (23614) -- o in Japanese
--			obj.set_att_string_utf8 (str)
--			appl.commit ()

--			appl.start_transaction (0)
--			obj ?= get_object_from_identifier ("i303", appl)
--			str := obj.att_string_utf8
--			assert_equal ("set_string_utf8-4.1", 2, str.count)
--			assert_equal ("set_string_utf8-4.2", 20013, str.item(1).code)
--			assert_equal ("set_string_utf8-4.3", 23614, str.item(2).code)
--			appl.abort_transaction
		end

	test_string_utf8_5
		-- Set a Japanese string 'nakao' and some ASCII chars in UTF8
		local
		--	obj: ATTRS_CLASS
		--	str: UC_STRING
		--	char: UC_CHARACTER
		do
--			appl.start_transaction (0)
--			obj ?= get_object_from_identifier ("i303", appl)
--			create str.make (4)
--			str.append_code (20013)  -- 'naka' in Japanese
--			str.append_code (23614)  -- 'o' in Japanese
--			str.append_code (97)  -- a
--			str.append_code (98)  -- b
--			obj.set_att_string_utf8 (str)
--			appl.commit ()

--			appl.start_transaction (0)
--			obj ?= get_object_from_identifier ("i303", appl)
--			str := obj.att_string_utf8
--			assert_equal ("set_string_utf8-5.1", 4, str.count)
--			assert_equal ("set_string_utf8-5.2", 20013, str.item(1).code)
--			assert_equal ("set_string_utf8-5.3", 23614, str.item(2).code)
--			assert_equal ("set_string_utf8-5.4", 97, str.item(3).code)
--			assert_equal ("set_string_utf8-5.5", 98, str.item(4).code)
--			appl.abort_transaction
		end

	test_string_utf8_6
			-- a_unicode.make_from_string, set it
		local
		--	obj: ATTRS_CLASS
		--	str: STRING
		--	ucstr, res_ucstr: UC_STRING
		do
--			appl.start_transaction (0)
--			obj ?= get_object_from_identifier ("i302", appl)
--			str := "This a test UC string"
--			create ucstr.make_from_string (str)
--			obj.set_att_string_utf8 (ucstr)
--			res_ucstr := obj.mt_get_string_utf8_by_name ("att_string_utf8")
--			assert_equal ("test_string_utf8_6-1", str.count, res_ucstr.count)
--			assert_equal ("test_string_utf8_6-2", str, res_ucstr.out)
--			appl.abort_transaction
		end

	test_string_utf8_7
			-- create a transient object with UTF8, then make it persistent
		local
		--	obj: ATTRS_CLASS
		--	str: STRING
		--	ucstr, res_ucstr: UC_STRING
		do
--			str := "This a test UC string"
--			create ucstr.make_from_string (str)
--			create obj
--			obj.set_att_string_utf8 (ucstr)
--
--			appl.start_transaction (0)
--			appl.persist (obj)
--
--			res_ucstr := obj.mt_get_string_utf8_by_name ("att_string_utf8")
--			assert_equal ("test_string_utf8_6-1", str.count, res_ucstr.count)
--			assert_equal ("test_string_utf8_6-2", str, res_ucstr.out)
--			appl.abort_transaction
		end

feature -- Test Image, Audio

  test_image_1
      -- set an ordinary Image
    local
      obj: ATTRS_CLASS
      image, image2: ARRAY[NATURAL_8]
    do
      create image.make(1, 10000)
      image.put(100, 1)
      image.put(101, 10000)
      create obj
      obj.set_att_image (image)

      appl.start_transaction (0)
      appl.persist (obj)

      image2 := obj.mt_get_byte_array_by_name ("att_image")
      assert_equal ("test_image_1-1", 10000, image2.count);
      assert_equal ("test_image_1-2", (100).as_natural_8, image2.item(1));
      assert_equal ("test_image_1-3", (101).as_natural_8, image2.item(10000));

      appl.abort_transaction
    end

  test_image_2
      -- set an empty Image
    local
      obj: ATTRS_CLASS
      image, image2: ARRAY[NATURAL_8]
    do
      create image.make(1, 0)
      create obj
      obj.set_att_image (image)

      appl.start_transaction (0)
      appl.persist (obj)

      image2 := obj.mt_get_byte_array_by_name ("att_image")
      assert_equal ("test_image_2-1", 0, image2.count);

      appl.abort_transaction
    end

  test_audio_1
      -- set an ordinary Audio
    local
      obj: ATTRS_CLASS
      audio, audio2: ARRAY[NATURAL_8]
    do
      create audio.make(1, 10000)
      audio.put(100, 1)
      audio.put(101, 10000)
      create obj
      obj.set_att_audio (audio)

      appl.start_transaction (0)
      appl.persist (obj)

      audio2 := obj.mt_get_byte_array_by_name ("att_audio")
      assert_equal ("test_audio_1-1", 10000, audio2.count);
      assert_equal ("test_audio_1-2", (100).as_natural_8, audio2.item(1));
      assert_equal ("test_audio_1-3", (101).as_natural_8, audio2.item(10000));

      appl.abort_transaction
    end

  test_audio_2
      -- set an empty Audio
    local
      obj: ATTRS_CLASS
      audio, audio2: ARRAY[NATURAL_8]
    do
      create audio.make(1, 0)
      create obj
      obj.set_att_audio (audio)

      appl.start_transaction (0)
      appl.persist (obj)

      audio2 := obj.mt_get_byte_array_by_name ("att_audio")
      assert_equal ("test_audio_2-1", 0, audio2.count);

      appl.abort_transaction
    end

feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE

	zzzzz_: ATTRS_CLASS
	aaaaa_: MT_LINKED_LIST[ATTRS_CLASS]
	ddddd_: MT_ARRAY[ATTRS_CLASS]
end
