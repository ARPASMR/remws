note
	description: "MATISSE-Eiffel Binding: define the storable class which is the base class for persistence."
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
	MT_STORABLE

inherit
	MT_OBJECT
	--	rename
	--		make as make_from_oid
		undefine
			copy
		end

	IDENTIFIED
		undefine
			is_equal
		end
	MT_EXCEPTIONS
		undefine
			copy, is_equal
		end

create
	make_from_oid

feature -- Accessing attributes

	frozen make_from_oid (db_oid: INTEGER)
		-- Object from Database.
		do
			oid := db_oid
		end

	mt_load_all_values
			-- Load values of all attributes of the class.
		local
			c: MT_CLASS
		do
			if not attributes_loaded and then persister /= Void then
				c := persister.mt_class_from_object (Current)
				c.load_attr_values_of_object (Current)
				loading_attrs_done
			end
		end

	mt_get_value_by_name, mtget_value (attr_name: STRING): ANY
			-- Return the value of the attribute specified by 'attr_name'.
		do
			if is_persistent then
				Result := persister.get_attr_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_value_by_position, mt_get_value (index: INTEGER): ANY
			-- Return the value of the attribute field-positioned at 'index'.
		do
			if is_persistent then
				Result := persister.get_attr_value_of_object_by_position (Current, index)
			end
		end

	-- MT_BOOLEAN --	
	mt_get_boolean_by_name, mtget_boolean (attr_name: STRING): BOOLEAN
		do
			if is_persistent then
				Result := persister.get_boolean_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_boolean_by_position, mt_get_boolean (index: INTEGER): BOOLEAN
		do
			if is_persistent then
				Result := persister.get_boolean_of_object_by_position (Current, index)
			end
		end

	mt_get_boolean_list_by_name, mtget_boolean_list (attr_name: STRING): LINKED_LIST [BOOLEAN]
		do
			if is_persistent then
				Result := persister.get_boolean_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_boolean_list_by_position, mt_get_boolean_list (index: INTEGER): LINKED_LIST [BOOLEAN]
		do
			if is_persistent then
				Result := persister.get_boolean_list_of_object_by_position (Current, index)
			end
		end

	-- MT_DATE --
	mt_get_date_by_name, mtget_date (attr_name: STRING): DATE
		do
			if is_persistent then
				Result := persister.get_date_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_date_by_position, mt_get_date (index: INTEGER): DATE
		do
			if is_persistent then
				Result := persister.get_date_of_object_by_position (Current, index)
			end
		end

	mt_get_date_list_by_name, mtget_date_list (attr_name: STRING): LINKED_LIST [DATE]
		do
			if is_persistent then
				Result := persister.get_date_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_date_list_by_position, mt_get_date_list (index: INTEGER): LINKED_LIST [DATE]
		do
			if is_persistent then
				Result := persister.get_date_list_of_object_by_position (Current, index)
			end
		end

	-- MT_TIMESTAMP --
	mt_get_timestamp_by_name, mtget_timestamp (attr_name: STRING): DATE_TIME
		do
			if is_persistent then
				Result := persister.get_timestamp_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_timestamp_by_position, mt_get_timestamp (index: INTEGER): DATE_TIME
		do
			if is_persistent then
				Result := persister.get_timestamp_of_object_by_position (Current, index)
			end
		end

	mt_get_timestamp_list_by_name, mtget_timestamp_list (attr_name: STRING): LINKED_LIST [DATE_TIME]
		do
			if is_persistent then
				Result := persister.get_timestamp_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_timestamp_list_by_position, mt_get_timestamp_list (index: INTEGER): LINKED_LIST [DATE_TIME]
		do
			if is_persistent then
				Result := persister.get_timestamp_list_of_object_by_position (Current, index)
			end
		end

	-- MT_INTERVAL --
	mt_get_time_interval_by_name, mtget_time_interval (attr_name: STRING): DATE_TIME_DURATION
		do
			if is_persistent then
				Result := persister.get_time_interval_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_time_interval_by_position, mt_get_time_interval (index: INTEGER): DATE_TIME_DURATION
		do
			if is_persistent then
				Result := persister.get_time_interval_of_object_by_position (Current, index)
			end
		end

	mt_get_time_interval_list_by_name, mtget_time_interval_list (attr_name: STRING): LINKED_LIST [DATE_TIME_DURATION]
		do
			if is_persistent then
				Result := persister.get_time_interval_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_time_interval_list_by_position, mt_get_time_interval_list (index: INTEGER): LINKED_LIST [DATE_TIME_DURATION]
		do
			if is_persistent then
				Result := persister.get_time_interval_list_of_object_by_position (Current, index)
			end
		end

	-- MT_S64, MT_LONG --  -- TBD
	mt_get_integer_64_by_name, mtget_integer_64 (attr_name: STRING): INTEGER_64
		do
			if is_persistent then
				Result := persister.get_integer_64_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_integer_64_by_position (index: INTEGER): INTEGER_64
		do
			if is_persistent then
				Result := persister.get_integer_64_value_of_object_by_position (Current, index)
			end
		end

	mt_get_integer_64_array_by_name, mtget_integer_64_array (attr_name: STRING): ARRAY [INTEGER_64]
		do
			if is_persistent then
				Result := persister.get_integer_64_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_integer_64_array_by_position, mt_get_integer_64_array (index: INTEGER): ARRAY [INTEGER_64]
		do
			if is_persistent then
				Result := persister.get_integer_64_array_of_object_by_position (Current, index)
			end
		end

	mt_get_integer_64_list_by_name, mtget_integer_64_list (attr_name: STRING): LINKED_LIST [INTEGER_64]
		do
			if is_persistent then
				Result := persister.get_integer_64_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_integer_64_list_by_position, mt_get_integer_64_list (index: INTEGER): LINKED_LIST [INTEGER_64]
		do
			if is_persistent then
				Result := persister.get_integer_64_list_of_object_by_position (Current, index)
			end
		end

	-- MT_S32 --
	mt_get_integer_by_name, mtget_integer (attr_name: STRING): INTEGER
		do
			if is_persistent then
				Result := persister.get_integer_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_integer_by_position, mt_get_integer (index: INTEGER): INTEGER
		do
			if is_persistent then
				Result := persister.get_integer_value_of_object_by_position (Current, index)
			end
		end

	mt_get_integer_array_by_name, mtget_integer_array (attr_name: STRING): ARRAY [INTEGER]
		do
			if is_persistent then
				Result := persister.get_integer_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_integer_array_by_position, mt_get_integer_array (index: INTEGER): ARRAY [INTEGER]
		do
			if is_persistent then
				Result := persister.get_integer_array_of_object_by_position (Current, index)
			end
		end

	mt_get_integer_list_by_name, mtget_integer_list (attr_name: STRING): LINKED_LIST [INTEGER]
		do
			if is_persistent then
				Result := persister.get_integer_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_integer_list_by_position, mt_get_integer_list (index: INTEGER): LINKED_LIST [INTEGER]
		do
			if is_persistent then
				Result := persister.get_integer_list_of_object_by_position (Current, index)
			end
		end

	-- MT_S16 --
	mt_get_short_by_name, mtget_short (attr_name: STRING): INTEGER
		do
			if is_persistent then
				Result := persister.get_short_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_short_by_position, mt_get_short (index: INTEGER): INTEGER_16
		do
			if is_persistent then
				Result := persister.get_short_of_object_by_position (Current, index)
			end
		end

	mt_get_short_array_by_name, mtget_short_array (attr_name: STRING): ARRAY [INTEGER_16]
		do
			if is_persistent then
				Result := persister.get_short_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_short_array_by_position, mt_get_short_array (index: INTEGER): ARRAY [INTEGER_16]
		do
			if is_persistent then
				Result := persister.get_short_array_of_object_by_position (Current, index)
			end
		end

	mt_get_short_list_by_name, mtget_short_list (attr_name: STRING): LINKED_LIST [INTEGER_16]
		do
			if is_persistent then
				Result := persister.get_short_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_short_list_by_position, mt_get_short_list (index: INTEGER): LINKED_LIST [INTEGER_16]
		do
			if is_persistent then
				Result := persister.get_short_list_of_object_by_position (Current, index)
			end
		end

	-- MT_U8 --
	mt_get_byte_by_name, mtget_byte (attr_name: STRING): INTEGER
		do
			if is_persistent then
				Result := persister.get_byte_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_byte_by_position, mt_get_byte (index: INTEGER): NATURAL_8
		do
			if is_persistent then
				Result := persister.get_byte_of_object_by_position (Current, index)
			end
		end

	mt_get_byte_array_by_name, mtget_byte_array (attr_name: STRING): ARRAY [NATURAL_8]
		do
			if is_persistent then
				Result := persister.get_byte_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_byte_array_by_position, mt_get_byte_array, mt_get_image_by_position, mt_get_audio_by_position, mt_get_video_by_position (index: INTEGER): ARRAY [NATURAL_8]
		do
			if is_persistent then
				Result := persister.get_byte_array_of_object_by_position (Current, index)
			end
		end

	mt_get_text_by_position (index: INTEGER): STRING is
		local
			as_array: ARRAY [NATURAL_8]
		do
			if is_persistent then
				as_array := persister.get_byte_array_of_object_by_position (Current, index)
				Result := ""
				as_array.do_all (agent (a_result: STRING; a_value: NATURAL_8) do a_Result.extend (a_value.to_character_8) end (Result, ?))
			end
		end

	mt_get_text_utf8_by_position (index: INTEGER): UC_STRING is
		do
			if is_persistent then
				create Result.make_from_utf8 (mt_get_text_by_position (index))
			end
		end

	mt_get_text_utf16_by_position (index: INTEGER): UC_STRING is
		do
			if is_persistent then
				create Result.make_from_utf16 (mt_get_text_by_position (index))
			end
		end



	mt_get_byte_list_by_name, mtget_byte_list (attr_name: STRING): ARRAY [NATURAL_8]
		do
			if is_persistent then
				Result := persister.get_byte_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_byte_list_by_position, mt_get_byte_list (index: INTEGER): ARRAY [NATURAL_8]
		do
			if is_persistent then
				Result := persister.get_byte_list_of_object_by_position (Current, index)
			end
		end

	mt_get_byte_list_elements_by_position, mt_get_byte_list_elements (index: INTEGER;
			buffer: ARRAY [NATURAL_8]; count, offset: INTEGER): INTEGER
			-- This routine eventually uses the MATISSE API MtGetListElts () which
			-- retrieves a subset of the list value of the attribute.
			-- This routine copies the 'count' number of list elements beginning from
			-- the 'offset' into the 'buffer'. The first element of the stored list has the
			-- offset 0. You may use as an offset Mt_Begin_Offset or Mt_Current_Offset
			-- which are defined in the class MT_CONSTANTS.
			-- This routine returns the number of elements copied into the 'buffer'.
		do
			if is_persistent then
				Result := persister.get_byte_list_elements_of_object_by_position (Current,
							index, buffer, count, offset)
			end
		end

	-- MT_NUMERIC --
	mt_get_decimal_by_name, mtget_decimal (attr_name: STRING): DECIMAL
		do
			if is_persistent then
				Result := persister.get_decimal_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_decimal_by_position, mt_get_decimal (index: INTEGER): DECIMAL
		do
			if is_persistent then
				Result := persister.get_decimal_of_object_by_position (Current, index)
			end
		end

	mt_get_decimal_list_by_name, mtget_decimal_list (attr_name: STRING): LINKED_LIST [DECIMAL]
		do
			if is_persistent then
				Result := persister.get_decimal_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_decimal_list_by_position, mt_get_decimal_list (index: INTEGER): LINKED_LIST [DECIMAL]
		do
			if is_persistent then
				Result := persister.get_decimal_list_of_object_by_position (Current, index)
			end
		end

	-- MT_FLOAT --
	mt_get_real_by_name, mtget_real (attr_name: STRING): REAL
		do
			if is_persistent then
				Result := persister.get_real_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_real_by_position, mt_get_real (index: INTEGER): REAL
		do
			if is_persistent then
				Result := persister.get_real_value_of_object_by_position (Current, index)
			end
		end

	mt_get_real_array_by_name, mtget_real_array (attr_name: STRING): ARRAY [REAL]
		do
			if is_persistent then
				Result := persister.get_real_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_real_array_by_position, mt_get_real_array (index: INTEGER): ARRAY [REAL]
		do
			if is_persistent then
				Result := persister.get_real_array_of_object_by_position (Current, index)
			end
		end

	mt_get_real_list_by_name, mtget_real_list (attr_name: STRING): LINKED_LIST [REAL]
		do
			if is_persistent then
				Result := persister.get_real_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_real_list_by_position, mt_get_real_list (index: INTEGER): LINKED_LIST [REAL]
		do
			if is_persistent then
				Result := persister.get_real_list_of_object_by_position (Current, index)
			end
		end

	mt_get_double_by_name, mtget_double (attr_name: STRING): DOUBLE
		do
			if is_persistent then
				Result := persister.get_double_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_double_by_position, mt_get_double (index: INTEGER): DOUBLE
		do
			if is_persistent then
				Result := persister.get_double_value_of_object_by_position (Current, index)
			end
		end

	mt_get_double_array_by_name, mtget_double_array (attr_name: STRING): ARRAY [DOUBLE]
		do
			if is_persistent then
				Result := persister.get_double_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_double_array_by_position, mt_get_double_array (index: INTEGER): ARRAY [DOUBLE]
		do
			if is_persistent then
				Result := persister.get_double_array_of_object_by_position (Current, index)
			end
		end

	mt_get_double_list_by_name, mtget_double_list (attr_name: STRING): LINKED_LIST [DOUBLE]
		do
			if is_persistent then
				Result := persister.get_double_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_double_list_by_position, mt_get_double_list (index: INTEGER): LINKED_LIST [DOUBLE]
		do
			if is_persistent then
				Result := persister.get_double_list_of_object_by_position (Current, index)
			end
		end

	mt_get_character_by_name, mtget_character (attr_name: STRING): CHARACTER
		do
			if is_persistent then
				Result := persister.get_char_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_character_by_position, mt_get_character (index: INTEGER): CHARACTER
		do
			if is_persistent then
				Result := persister.get_char_value_of_object_by_position (Current, index)
			end
		end

	-- MT_STRING --
	mt_get_string_by_name, mtget_string (attr_name: STRING): STRING
		do
			if is_persistent then
				Result := persister.get_string_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_by_position, mt_get_string (index: INTEGER): STRING
		do
			if is_persistent then
				Result := persister.get_string_value_of_object_by_position (Current, index)
			end
		end

	mt_get_string_array_by_name, mtget_string_array (attr_name: STRING): ARRAY [STRING]
		do
			if is_persistent then
				Result := persister.get_string_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_array_by_position, mt_get_string_array (index: INTEGER): ARRAY [STRING]
		do
			if is_persistent then
				Result := persister.get_string_array_of_object_by_position (Current, index)
			end
		end

	mt_get_string_list_by_name, mtget_string_list (attr_name: STRING): LINKED_LIST [STRING]
		do
			if is_persistent then
				Result := persister.get_string_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_list_by_position, mt_get_string_list (index: INTEGER): LINKED_LIST [STRING]
		do
			if is_persistent then
				Result := persister.get_string_list_of_object_by_position (Current, index)
			end
		end

	-- MT_STRING (UTF8) --
	mt_get_string_utf8_by_name, mtget_string_utf8 (attr_name: STRING): UC_STRING
		do
			if is_persistent then
				Result := persister.get_string_utf8_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_utf8_by_position, mt_get_string_utf8 (index: INTEGER): UC_STRING
		do
			if is_persistent then
				Result := persister.get_string_utf8_value_of_object_by_position (Current, index)
			end
		end

	mt_get_string_utf8_array_by_name, mtget_string_utf8_array (attr_name: STRING): ARRAY [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf8_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_utf8_array_by_position, mt_get_string_utf8_array (index: INTEGER): ARRAY [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf8_array_of_object_by_position (Current, index)
			end
		end

	mt_get_string_utf8_list_by_name, mtget_string_utf8_list (attr_name: STRING): LINKED_LIST [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf8_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_utf8_list_by_position, mt_get_string_utf8_list (index: INTEGER): LINKED_LIST [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf8_list_of_object_by_position (Current, index)
			end
		end

	-- MT_STRING (UTF16) --
	mt_get_string_utf16_by_name, mtget_string_utf16 (attr_name: STRING): UC_STRING
		do
			if is_persistent then
				--Result := persister.get_string_utf16_value_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_utf16_by_position, mt_get_string_utf16 (index: INTEGER): UC_STRING
		do
			if is_persistent then
				--Result := persister.get_string_utf16_value_of_object_by_position (Current, index)
			end
		end

	mt_get_string_utf16_array_by_name, mtget_string_utf16_array (attr_name: STRING): ARRAY [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf16_array_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_utf16_array_by_position, mt_get_string_utf16_array (index: INTEGER): ARRAY [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf16_array_of_object_by_position (Current, index)
			end
		end

	mt_get_string_utf16_list_by_name, mtget_string_utf16_list (attr_name: STRING): LINKED_LIST [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf16_list_of_object_by_name (Current, attr_name)
			end
		end

	mt_get_string_utf16_list_by_position, mt_get_string_utf16_list (index: INTEGER): LINKED_LIST [UC_STRING]
		do
			if is_persistent then
				--Result := persister.get_string_utf16_list_of_object_by_position (Current, index)
			end
		end

	mt_remove_value_by_name, mtremove_value (attr_name: STRING)
		do
			if is_persistent then
				persister.remove_value_by_name (Current, attr_name)
			end
		end

	mt_remove_value_by_position, mt_remove_value (index: INTEGER)
		local
		do
			if is_persistent then
				persister.remove_value_by_position (Current, index)
			end
		end

	property_undefined (index: INTEGER; a_field_name: STRING)
			-- The index-th field, whose field name is a_field_name, isn't defined
			-- as corresponding attribute/relationship in the current database.
			-- You can redefine this procedure in your own class.
		do
		end

feature {NONE} -- Update attribute

	mt_set_value (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_attribute_value (Current, field_index)
			end
		end

	mt_set_character (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_char_by_position (Current, field_index)
			end
		end

	mt_set_boolean (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_boolean_by_position (Current, field_index)
			end
		end

	mt_set_boolean_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_boolean_list_by_position (Current, field_index)
			end
		end

	mt_set_date (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_date_by_position (Current, field_index)
			end
		end

	mt_set_date_list (field_index: INTEGER)
		do
			if is_persistent then
				persister.set_date_list_by_position (Current, field_index)
			end
		end

	mt_set_timestamp (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_timestamp_by_position (Current, field_index)
			end
		end

	mt_set_timestamp_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_timestamp_list_by_position (Current, field_index)
			end
		end

	mt_set_time_interval (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_time_interval_by_position (Current, field_index)
			end
		end

	mt_set_time_interval_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_time_interval_list_by_position (Current, field_index)
			end
		end

	mt_set_byte (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_byte_by_position (Current, field_index)
			end
		end

	mt_set_byte_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_byte_array_by_position (Current, field_index, {MT_TYPE}.Mt_Bytes)
			end
		end

 	mt_set_text (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_text_by_position (Current, field_index)
			end
		end

 	mt_set_image (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_byte_array_by_position (Current, field_index, {MT_TYPE}.Mt_Image)
			end
		end

 	mt_set_audio (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_byte_array_by_position (Current, field_index, {MT_TYPE}.Mt_Audio)
			end
		end

 	mt_set_video (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_byte_array_by_position (Current, field_index, {MT_TYPE}.Mt_Video)
			end
		end

	mt_set_byte_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_byte_list_by_position (Current, field_index)
			end
		end

	mt_set_byte_list_elements (field_index: INTEGER; buffer: ARRAY [NATURAL_8];
			buffer_size: INTEGER; offset: INTEGER; discard_after: BOOLEAN)
			-- 'field_index'-th value is updated. Store the new value
			-- This routine eventually uses the MATISSE API MtSetListElts () which
			-- store the buffer content as a subset of the existing list value of the attribute.
			-- This routine copies the 'buffer_size' number of elements of 'buffer'
			-- into the list value at the offset 'offset'. The first element of the stored list has the
			-- offset 0. You may use as an offset Mt_Begin_Offset, Mt_Current_Offset or
			-- Mt_End_Offset which are defined in the class MT_CONSTANTS.
		do
			if is_persistent then
				persister.set_byte_list_elements_by_position (Current, field_index, buffer,
						buffer_size, offset, discard_after)
			end
		end

  -- MT_S16, MT_SHORT --		
	mt_set_short (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_short_by_position (Current, field_index)
			end
		end

	mt_set_short_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_short_array_by_position (Current, field_index)
			end
		end

	mt_set_short_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_short_list_by_position (Current, field_index)
			end
		end

  -- MT_S32, MT_INTEGER --	
	mt_set_integer (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_integer_by_position (Current, field_index)
			end
		end

	mt_set_integer_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_integer_array_by_position (Current, field_index)
			end
		end

	mt_set_integer_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_integer_list_by_position (Current, field_index)
			end
		end

  -- MT_S64, MT_LONG --	 -- TBD
	mt_set_integer64 (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_integer_64_by_position (Current, field_index)
			end
		end

	mt_set_integer_64_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_integer_64_array_by_position (Current, field_index)
			end
		end

	mt_set_integer_64_list, mt_set_integer64_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_integer_64_list_by_position (Current, field_index)
			end
		end


  -- MT_NUMERIC
	mt_set_decimal (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_decimal_by_position (Current, field_index)
			end
		end

	mt_set_decimal_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_decimal_list_by_position (Current, field_index)
			end
		end

  -- MT_STRING	
	mt_set_string (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_string_by_position (Current, field_index)
			end
		end

	mt_set_string_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_string_array_by_position (Current, field_index)
			end
		end

	mt_set_string_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_string_list_by_position (Current, field_index)
			end
		end

	-- MT_STRING (UTF8) --
	mt_set_string_utf8 (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_string_utf8_by_position (Current, field_index)
			end
		end

	mt_set_string_utf8_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				--persister.set_string_utf8_array_by_position (Current, field_index)
			end
		end

	mt_set_string_utf8_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				--persister.set_string_utf8_list_by_position (Current, field_index)
			end
		end

	-- MT_STRING (UTF16) --
	mt_set_string_utf16 (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				--persister.set_string_utf16_by_position (Current, field_index)
			end
		end

	mt_set_string_utf16_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				--persister.set_string_utf16_array_by_position (Current, field_index)
			end
		end

	mt_set_string_utf16_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				--persister.set_string_utf16_list_by_position (Current, field_index)
			end
		end

	mt_set_double (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_double_by_position (Current, field_index)
			end
		end

	mt_set_double_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_double_array_by_position (Current, field_index)
			end
		end

	mt_set_double_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_double_list_by_position (Current, field_index)
			end
		end

	mt_set_real (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_real_by_position (Current, field_index)
			end
		end

	mt_set_real_array (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_real_array_by_position (Current, field_index)
			end
		end

	mt_set_real_list (field_index: INTEGER)
			-- 'field_index'-th value is updated. Store the new value.
		do
			if is_persistent then
				persister.set_real_list_by_position (Current, field_index)
			end
		end

feature -- Accessing relationships

	mt_load_all_successors
			-- Load successors of all relationships of the class.
		local
			c: MT_CLASS
		do
			if not relationships_loaded and then persister /= Void then
				c := persister.mt_class_from_object (Current)
				c.load_rs_successors_of_object (Current)
				loading_relationships_done
			end
		end

	mt_get_successors_by_name (rs_name: STRING): MT_RS_CONTAINABLE
			-- Return an array of successor objects of Current through
			-- the relationship specified by 'rs_name'.
		do
			if is_persistent then
				Result := persister.get_rs_successors_by_name (Current, rs_name)
				Result.load_successors
			end
		end

	mt_get_successors_by_position (index: INTEGER): MT_RS_CONTAINABLE
			-- Return an array of successor objects of Current through
			-- the relationship specified by 'rs_name'.
		do
			if is_persistent then
				Result := persister.get_rs_successors_by_position (Current, index)
				Result.load_successors
			end
		end

	mt_get_successor_by_name (rs_name: STRING): MT_STORABLE
			-- Return the first successor object of Current through
			-- the relationship specified by 'rs_name'.
			-- This is usually used to get a successor of 'sigle-relationship'.
		do
			if is_persistent then
				Result := persister.get_rs_successor_by_name (Current, rs_name)
			end
		end

	mt_get_successor_by_position (index: INTEGER): MT_STORABLE
			-- Same as 'mt_get_successor_by_name' except that relationship
			-- is specified by field position.
		do
			if is_persistent then
				Result := persister.get_rs_successor_by_position (Current, index)
			end
		end

  mt_get_predecessor_by_name (rs_name: STRING): MT_STORABLE
			-- Return the predecessor object of Current through
			-- the relationship specified by 'rs_name'.
			-- This can be used to get an object through a read-only relationship.
      -- Example: Suppose you have PERSON and CAR classes, and two relationships
      -- "cars" as direct relationship in PERSON and "ownedBy" as read-only.
      -- Then, you write:
      --   a_person ?= a_car.mt_get_predecessor_by_name("cars")
		do
			if is_persistent then
				Result := persister.get_rs_predecessor_by_name (Current, rs_name)
			end
		end

  mt_get_predecessors_by_name (rs_name: STRING): ARRAY [MT_STORABLE]
			-- Return the predecessor objects of Current through
			-- the relationship specified by 'rs_name'.
			-- This can be used to get objects through a read-only relationship
		do
			if is_persistent then
				Result := persister.get_rs_predecessors_by_name (Current, rs_name)
			end
		end

	mt_load_all_properties
			-- Load both values of attributes and successors of relationships.
		local
			c: MT_CLASS
		do
			if not attributes_loaded and then persister /= Void then
				c := persister.mt_class_from_object (Current)
				c.load_attr_values_of_object (Current)
				loading_attrs_done
			end

			if not relationships_loaded and then persister /= Void then
				if c = Void then
					c := persister.mt_class_from_object (Current)
				end
				c.load_rs_successors_of_object (Current)
				loading_relationships_done
			end
		end

	added_successors (one_relationship: MT_RELATIONSHIP): ARRAY [MT_STORABLE]
			-- Get all added successors through a relationship
			-- since beginning a current transaction.
		do
			Result := retrieved_array (mtdb.context.get_added_successors ( oid,one_relationship.rid))
		end

	removed_successors (one_relationship: MT_RELATIONSHIP): ARRAY [MT_STORABLE]
			-- Get all removed successors since beginning of transaction.
		do
			Result := retrieved_array (mtdb.context.get_removed_successors ( oid,one_relationship.rid))
		end

	successors (one_relationship: MT_RELATIONSHIP): ARRAY [MT_STORABLE]
			-- Successors of current Matisse Object.
		do
			Result := retrieved_array (mtdb.context.get_successors ( oid,one_relationship.rid))
		end

	predecessors (one_relationship: MT_RELATIONSHIP): ARRAY [MT_STORABLE]
			-- Predecessors of current Matisse Object.
		do
			Result := retrieved_array (mtdb.context.get_predecessors ( oid,one_relationship.rid))
		end

	current_predecessors_by_oid (one_rshp_oid: INTEGER): ARRAY [MT_STORABLE] is
			-- Predecessors of current Matisse Object that are already being retrieved from database.
		do
			Result := retrieved_array_if_found (mtdb.context.get_predecessors ( oid, one_rshp_oid))
		end

feature -- Deletion

	frozen mt_remove ()
			-- Delete the current object from the database.
		do
			if is_persistent then
				persister.delete_object (Current)
			end
		end

	deep_remove ()
		-- Delete the current object from the database.
		-- must be redefined in subclasses to delete composed object if necessary
		do
			mt_remove ()
		end


feature {NONE} -- Update relationship

	mt_set_successor (field_index: INTEGER)
			-- 'field_index'-th successor is updated. Store the new successor
		do
			if is_persistent then
				persister.set_single_successor (Current, field_index)
			end
		end

	successor_appened (field_index: INTEGER; new_successor: MT_STORABLE)
		do
			if is_persistent then
				persister.append_successor (Current, field_index, new_successor)
			end
		end

feature {MT_RELATIONSHIP, MT_LINEAR_COLLECTION, MT_PERSISTER} -- Update successors

	mt_reload_successors (rid: INTEGER) is
			--  force reloading successors of the relationship (rid)
		local
			--myclass: MT_CLASS
			--rshp: MT_RELATIONSHIP
		do
			if is_persistent then
				persister.reload_successors (Current, rid)
			end
		end



feature {NONE} -- Implementation

	version_number: INTEGER

	field_position_of (a_field_name: STRING): INTEGER
		local
			i, count: INTEGER
		do
			count := field_count (Current)
			from
				i := 1
			until
				i > count or Result > 0
			loop
				if field_name (i, Current).is_equal (a_field_name) then
					Result := i
				end
				i := i + 1
			end
		end

	retrieved_array (oids: ARRAY[INTEGER]): ARRAY [MT_STORABLE]
		local
			i: INTEGER
		do
			create Result.make (1, oids.count)
			from
				i := oids.lower
			until
				i > oids.upper
			loop
				Result.force (persister.eif_object_from_oid (oids.item (i)), i)
 				i := i + 1
			end
		end


	retrieved_array_if_found (oids: ARRAY[INTEGER]): ARRAY [MT_STORABLE] is
		local
			i, j: INTEGER
			obj: MT_STORABLE
		do
			!! Result.make (1, oids.count)
			j := 1
			from
				i := oids.lower
			until
				i > oids.upper
			loop
				obj := persister.eif_object_from_oid_if_found (oids.item (i))
				if obj /= Void then
					Result.force (obj, j)
					j := j + 1
				end
 				i := i + 1
			end
			if j > 1 then
				Result.conservative_resize (1, j - 1)
			end

		end

feature  -- Attributes

feature -- Status report

	attributes_loaded: BOOLEAN
	relationships_loaded: BOOLEAN

	check_object, is_ok: BOOLEAN
			-- Check instance.
		do
			mtdb.context.check_object ( oid)
		end

	is_predefined, is_predefined_msp: BOOLEAN
			-- Does object belongs to meta-schema?
		local
			-- necessary dummy variables to include these classes in the system for sure
			unused_but_needed_a: MT_METHOD
			unused_but_needed_b: MT_INDEX
		do
			Result := mtdb.context.is_predefined_object ( oid)
		end

	is_instance_of (one_class: MT_CLASS): BOOLEAN
		-- Is current object an instance of 'one_class'.
	do
		Result := mtdb.context.is_instance_of ( oid,one_class.oid)
	end

feature -- Output

	print_to_file (file: FILE)
			-- Outputs object to file.
		require
			file_not_void: file /= Void
			file_exists: file.exists
			file_is_open_write: file.is_open_read
			file_is_plain_text: file.is_plain_text
		do
			mtdb.context.print_to_file ( oid, file.file_pointer)
		end

feature  -- Database

		-- Connection to a Matisse Database
	mtdb: MT_DATABASE


feature {MT_PERSISTER, MT_LINEAR_COLLECTION, MT_HASH_TABLE, MT_HASH_TABLE_RELATIONSHIP, MT_RS_CONTAINABLE, MT_STREAM} -- Attributes

	-- Persistence Manager
	persister: MT_PERSISTER

	is_obsolete: BOOLEAN
		do
			if is_persistent then
				Result := version_number /= persister.version_number
			else
				Result := False
			end
		end

feature -- Schema

	oids_of_property_names (names: ARRAY [STRING]): ARRAY [INTEGER]
			-- The oids associated with properities/relationships with names
		require
			valid_names: names /= Void and then not names.is_empty
			-- All names must be valid field names in this class
		local
			names_as_list: ARRAYED_LIST [STRING]
			index, an_oid: INTEGER
		do
			create names_as_list.make_from_array (names)
			create Result.make (1, names.count)
			from
				names_as_list.start
				index := 1
			until
				names_as_list.after
			loop
				check
					-- Verify names_as_list.item is a valid property name
					oid_of_property_name (names_as_list.item) > 0
				end
				an_oid := oid_of_property_name (names_as_list.item)

				Result.put (an_oid, index)
				names_as_list.forth
				index := index + 1
			end


		end

	oid_of_property_name (a_name: STRING) : INTEGER
		-- Returns the OID of a Matisse property (attribute or relationship).
		-- For an invalid name, returns 0
		require
			valid_name: a_name /= Void
		local
			the_class: MT_CLASS
		do
			the_class := persister.mt_class_from_object (Current)
			Result := the_class.oid_of_property (a_name)
		end


feature {MT_PERSISTER, MT_HASH_TABLE_RELATIONSHIP} -- Access from MATISSE

	set_persister (a_persister: MT_PERSISTER)
		do
			persister := a_persister
		end

	set_oid (an_oid: INTEGER)
		do
			oid := an_oid
		end

	set_version (v: INTEGER)
		do
			version_number := v
		end

	become_persistent (a_db: MT_DATABASE; v: INTEGER)
		do
			version_number := v
			persister ?= a_db.persister
			if post_retrieved then
				persister.add_post_retireved (oid)
			end
		end

feature {MT_PERSISTER, MT_RELATIONSHIP, MT_LINEAR_COLLECTION} -- Access from MATISSE

	become_obsolete
		do
			version_number := -1
		end

feature {MT_CLASS, MT_PERSISTER} -- Access

	loading_attrs_done
		do
			attributes_loaded := True
		end

 	loading_relationships_done
		do
			relationships_loaded := True
		end

	attributes_unloaded
		do
			attributes_loaded := False
		end

	relationships_unloaded
		do
			relationships_loaded := False
		end

	predefined_eif_field (a_field_name: STRING): BOOLEAN
			-- Is a_field_name an attribute defined in this class MT_STORABLE?
		do
			Result := a_field_name.is_equal ("oid") or
					a_field_name.is_equal ("persister") or
					a_field_name.is_equal ("attributes_loaded") or
					a_field_name.is_equal ("relationships_loaded")
		end

feature -- Modification Mark

	mark_attrs_modified
			-- One of the attributes of current object is modified.
			-- Set a mark of all-attributes-modification.
			-- When transaction is committed, the value is saved in a database.
		do
			if is_persistent then
				write_lock
				persister.mark_attrs_modified (oid)
			end
		end

	mark_rls_modified
			-- One of the relationships of current object is modified.
			-- Set a mark of all-relationships-modification.
			-- When transaction is committed, the successor objects are saved.
			-- in a database.
		do
			if is_persistent then
				write_lock
				mt_load_all_successors
				persister.mark_rls_modified (oid)
			end
		end

feature {MT_ATTRIBUTE} -- Storing value

want_to_set_value (an_attribute: MT_ATTRIBUTE): BOOLEAN
		once
			Result := False
		end

	set_value_of_attribute (an_attribute: MT_ATTRIBUTE)
			-- Default behavior.
			-- (Do nothing)
		do
		end

feature -- Access

	mt_class, mt_generator: MT_CLASS
			-- Class that has generated current object
		do
			if is_persistent then
				Result := persister.mt_class_from_object (Current)
			end
		end

	size: INTEGER
			-- Size of Matisse Object in bytes.
		do
			Result := mtdb.context.object_size ( oid)
		end

feature -- Persistence

	is_persistent: BOOLEAN
		-- Is the current object a persistent one?
		do
			Result := persister /= Void and then persister.is_tran_or_version_open
		end

	check_persistence (an_object: MT_STORABLE)
			-- Is an_object a persistent object in the current_db?
			-- If yes, do nothing.
			-- If no, create new MATISSE object (using MtCreateObject),
			-- add an_object into cache of current_db, add oid of
			-- an_object into attr_modified_set and rl_modified_set.
		do
			if is_persistent then
				if an_object /= Void and then not persister.has (an_object) then
					persister.persist_transient_object (an_object)
				end
			end
		end

	remove_from_cache
			-- Discard the current object from the object table of current database
		do
			if persister /= Void then
				persister.safe_wean (Current)
			end
		end

	mt_make (a_class: MT_CLASS)
			-- Initialize the current object as a persistent object.
			-- Assign an empty container to each multiple-relationship.
			-- This procedrue is called also when a transient object is
			-- promoted into a persistent one.
		require
			class_initiliazed: a_class.properties_initialized
		local
			relationships: ARRAY [MT_RELATIONSHIP]
			a_rs: MT_MULTI_RELATIONSHIP
			i: INTEGER
			a_rs_containable: MT_RS_CONTAINABLE
		do
			mtdb := a_class.mtdb
			relationships := a_class.relationships
			from
				i := relationships.lower
			until
				i > relationships.upper
			loop
				a_rs ?= relationships.item (i)
				if a_rs /= Void and then field (a_rs.eif_field_index, Current) = Void then
					set_reference_field (a_rs.eif_field_index, Current,
							a_rs.empty_container_for (Current, field_static_type_of_type (a_rs.eif_field_index, dynamic_type (Current))))
				elseif a_rs /= Void then
					-- Added by SM, 04/15/99
					-- Without that, a list which is created in `Current'
					-- is not considered as persistent.
					a_rs_containable ?= field (a_rs.eif_field_index, Current)
					a_rs_containable.set_relationship (a_rs)
 					a_rs_containable.set_predecessor (Current)
				end
				i := i + 1
			end
		end

	post_retrieved: BOOLEAN
			-- Descendant classes can redefine this procedure so that additional
			-- initialization can be done on some field, especially on "transient" fields.
			-- If this is redefined in descendent classes, they need to
			-- return True.
		do
			Result := False
		end

feature -- Facilities

	remove_all_from_database (a_list: LINKED_LIST [MT_STORABLE]) is
			-- Remove all items in a_list from database (and a_list)
		require
			valid_a_list: a_list /= Void
		do
			from
				a_list.start
			until
				a_list.after
			loop
				if a_list.item.is_persistent then
					a_list.item.mt_remove
				else
					a_list.remove
				end

				a_list.start
			end
		end


feature -- Locking

	lock (a_lock: INTEGER)
			-- Lock current object in Matisse.
		require
			a_lock_is_read_or_is_write: a_lock = {MT_DATABASE}.Mt_Read or else a_lock = {MT_DATABASE}.Mt_Write
		do
			mtdb.context.lock_object ( oid, a_lock)
		end

	write_lock
			-- Set write lock on current object in MATISSE.
		do
			mtdb.context.write_lock_object ( oid)
		end

	lock_composite (a_lock: INTEGER)
		require
			a_lock_is_read_or_is_write: a_lock = {MT_DATABASE}.Mt_Read or else a_lock = {MT_DATABASE}.Mt_Write
		do
			if is_persistent then
				persister.lock_composite (Current, a_lock)
			end
		end

feature -- C level memory management

	load
			-- Load current object in client cache so that
			-- there is no more server access readings on this object.
		do
			mtdb.context.load_object ( oid)
		end

	free, unload, mt_dispose
			-- Remove object from local cache.
		do
			mtdb.context.free_object ( oid)
		end

feature {NONE} -- Constants of default initialization values

	Integer_default_value: INTEGER = 0
	Integer64_default_value: INTEGER_64 = 0
	Real_default_value: REAL = 0.0
	Double_default_value: DOUBLE = 0.0
	Character_default_value: CHARACTER = '%U'
	Boolean_default_value: BOOLEAN = False

invariant
	persistence: is_persistent implies persister /= Void

end -- class MT_STORABLE

