note
	description: "MATISSE-Eiffel Binding: define Matisse MtAttribute meta-class"
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
	MT_ATTRIBUTE

inherit
	MT_DATETIME
		undefine
			is_equal, copy
		end
	MT_PROPERTY
		rename
			id as aid
		redefine
			predefined_eif_field
		end

	MT_EXCEPTIONS
		export
			{NONE}	all;
		undefine
			is_equal, copy
		end

create
	make, make_from_names, make_from_id

feature -- Meta-Schema Attribute names

  MT_NAME_NAME : STRING =                          "MtName"
  MT_DEFAULT_VALUE_NAME: STRING =                  "MtDefaultValue"
  MT_NULLABLE_NAME: STRING =                       "MtNullable"
  MT_PRECISION_SCALE_NAME: STRING =                "MtPrecisionScale"
  MT_ENUMERATION_NAME : STRING =                   "MtEnumeration"
  MT_MAX_SIZE_NAME  : STRING =                     "MtMaxSize"
  MT_MAX_ELEMENTS_NAME : STRING =                  "MtMaxElements"
  MT_DEFERRED_NAME  : STRING =                     "MtDeferred"
  MT_CONSTRAINTS_NAME: STRING =                    "MtConstraints"
  MT_CARDINALITY_NAME : STRING =                   "MtCardinality"
  MT_PRESERVE_ORDER_NAME: STRING =                 "MtPreserveOrder"
  MT_BASIC_TYPE_NAME : STRING =                    "MtBasicType"
  MT_CHARACTER_ENCODING_NAME: STRING =             "MtCharacterEncoding"
  MT_CRITERIA_ORDER_NAME: STRING =                 "MtCriteriaOrder"
  MT_UNIQUE_KEY_NAME: STRING =                     "MtUniqueKey"
  MT_CASE_SENSITIVE_NAME: STRING =                 "MtCaseSensitive"
  MT_MAKE_ENTRY_FUNCTION_NAME: STRING =            "MtMakeEntryFunction"
  MT_DOCUMENTATIO_NAMEN: STRING =                  "MtDocumentation"
  MT_SOURCE_NAME : STRING =                        "MtSource"
  MT_SIGNATURE_NAME: STRING =                      "MtSignature"
  MT_STATIC_NAME: STRING =                         "MtStatic"
  MT_ACTIVATION_NAME: STRING =                     "MtActivation"
  MT_SCOPE_NAME: STRING =                          "MtScope"
  MT_AUTOMATIC_NAME: STRING =                      "MtAutomatic"
  MT_SHARABLE_NAME: STRING =                       "MtSharable"

feature {NONE} -- Initialization

	make (attribute_name: STRING; a_db: MT_DATABASE)
			-- Get attribute from database.
			-- If `attribute_name' not unique, an error is raised.
		require
			attribute_not_void: attribute_name /= Void
			attribute_not_empty: not attribute_name.is_empty
		local
			c_attribute_name: ANY
		do
			persister ?= a_db.persister
			mtdb := a_db
			c_attribute_name := attribute_name.to_c
			oid := mtdb.context.get_attribute ( $c_attribute_name)
			-- 'Current_db.mt_connection' is a temporary implementation.
			-- we should do make(attr_name: STRING; db: MT_PERSISTER) ...
		end

	make_from_names (attribute_name, cl_name: STRING; a_db: MT_DATABASE)
			-- Get attribute from database.
		require
			attribute_not_void: attribute_name /= Void
			attribute_not_empty: not attribute_name.is_empty
			cl_not_void: cl_name /= Void
			cl_not_empty: not cl_name.is_empty
		local
			c_attribute_name: ANY
			c_cl_name: ANY
		do
			persister ?= a_db.persister
			mtdb := a_db
			c_attribute_name := attribute_name.to_c
			c_cl_name := cl_name.to_c
			oid := mtdb.context.get_attribute_from_names ( $c_attribute_name, $c_cl_name)
		end

feature {NONE} -- Initialization

	make_from_id (a_db: MT_DATABASE; attribute_id: INTEGER)
			-- Create attribute with its id.
		do
			persister ?= a_db.persister
			mtdb := a_db
			oid := attribute_id
		end

	mttype_ref: MT_TYPE  once create Result end

feature -- Access

	dimension (one_object: MT_OBJECT; rank: INTEGER): INTEGER
			-- Dimension of current attribute.
			-- When the value of the attribute is an array, returns the size of the
			-- array for the dimension rank.
			-- If the attribute value is a list, rank must be equal to 0 and dimension
			-- gives the number of elements in the list.
		require
			rank_positive_or_null: rank >= 0
		do
			Result := mtdb.context.get_dimension ( one_object.oid, oid, rank)
		end

	get_value (an_obj: MT_OBJECT): ANY
		do
			if mt_type = 0 then
				-- Attribute type could be any, i.e. type is unspecified
				Result := get_value_of_mt_type (an_obj, mtdb.context.get_value_type( an_obj.oid, oid))
			else
				Result := get_value_of_mt_type (an_obj, mt_type)
			end
		end

	get_value_of_mt_type (an_obj: MT_OBJECT; a_type: INTEGER): ANY
		do
			inspect a_type
			when {MT_TYPE}.Mt_Boolean then
				Result := get_boolean (an_obj)
			when {MT_TYPE}.Mt_Boolean_LIst then
				Result := get_boolean_list (an_obj)
			when {MT_TYPE}.Mt_Timestamp then
				Result := get_timestamp (an_obj)
			when {MT_TYPE}.Mt_Timestamp_List then
				Result := get_timestamp_list (an_obj)
			when {MT_TYPE}.Mt_Date then
				Result := get_date (an_obj)
			when {MT_TYPE}.Mt_Date_List then
				Result := get_date_list (an_obj)
			when {MT_TYPE}.Mt_Interval then
				Result := get_time_interval (an_obj)
			when {MT_TYPE}.Mt_Interval_List then
				Result := get_time_interval_list (an_obj)
			when {MT_TYPE}.Mt_Byte then
				Result := get_byte (an_obj)
			when {MT_TYPE}.Mt_Bytes  then
				Result := get_byte_list (an_obj)
			when {MT_TYPE}.Mt_s16  then
				Result := get_short (an_obj)
			when {MT_TYPE}.Mt_s16_list then
				Result := get_short_list (an_obj)
			when {MT_TYPE}.Mt_s32  then
				Result := get_integer (an_obj)
			when {MT_TYPE}.Mt_Char  then
				Result := get_character (an_obj)
			when {MT_TYPE}.Mt_Double  then
				Result := get_double (an_obj)
			when {MT_TYPE}.Mt_Nil  then
				Result := Void
			when {MT_TYPE}.Mt_S32_List  then
				Result := get_integer_list (an_obj)
			when {MT_TYPE}.Mt_Double_List  then
				Result := get_double_list (an_obj)
			when {MT_TYPE}.Mt_String_List  then
				Result := get_string_list (an_obj)
			when {MT_TYPE}.Mt_String  then
				Result := get_string (an_obj)
			when {MT_TYPE}.Mt_U8_Array  then
				Result := get_byte_array (an_obj)
			when {MT_TYPE}.Mt_S16_Array  then
				Result := get_short_array (an_obj)
			when {MT_TYPE}.Mt_S32_Array  then
				Result := get_integer_array (an_obj)
			when {MT_TYPE}.Mt_Double_Array  then
				Result := get_double_array (an_obj)
			when {MT_TYPE}.Mt_String_Array  then
				Result := get_string_array (an_obj)
			when {MT_TYPE}.Mt_Float_Array  then
				Result := get_real_array (an_obj)
			when {MT_TYPE}.Mt_Float  then
				Result := get_real (an_obj)
			when {MT_TYPE}.Mt_Float_List  then
				Result := get_real_list (an_obj)
			else
			end
		end

feature -- Status Report

	check_attribute (one_object: MT_OBJECT): BOOLEAN
			-- Check if attribute is correct in 'one_object'.
		do
			mtdb.context.check_attribute ( oid, one_object.oid)
		end -- check

	type: INTEGER
			-- Attribute type in Matisse (see MT_CONSTANTS).
		do
			Result := mtdb.context.get_attribute_type ( oid)
		end -- type

	dynamic_att_type (an_obj: MT_OBJECT): INTEGER
			-- This is useful when the current attribute has multiple available types.
			-- Result is one of the MT_PERSISTER attribute types.
		do
			Result := mtdb.context.get_value_type ( an_obj.oid, oid)
		end

feature -- Element Change

	set_value_not_default (an_object: MT_STORABLE)
			-- If the field value is not default value, store the value to the database.
		local
			a_value: ANY
		do
			if an_object.want_to_set_value (Current) then
				an_object.set_value_of_attribute (Current)
			else
				a_value := field (eif_field_index, an_object)
				if a_value /= Void then
					inspect mt_type
					when {MT_TYPE}.Mt_Boolean then
						set_boolean (an_object)
					when {MT_TYPE}.Mt_Timestamp then
						set_timestamp (an_object)
					when {MT_TYPE}.Mt_Date then
						set_date (an_object)
					when {MT_TYPE}.Mt_Interval then
						set_time_interval (an_object)
					when {MT_TYPE}.Mt_u8 then
						set_byte (an_object)
          when {MT_TYPE}.Mt_U8_List  then
						set_byte_list (an_object)
          when {MT_TYPE}.Mt_s16  then
						set_short (an_object)
					when {MT_TYPE}.Mt_S16_List then
						set_short_list (an_object)
					when {MT_TYPE}.Mt_s32  then
						set_integer (an_object)
					when {MT_TYPE}.Mt_S64  then
						-- set_integer64 (an_object) -- TBD
					when {MT_TYPE}.Mt_Numeric  then
						set_decimal (an_object)
					when {MT_TYPE}.Mt_Char  then
						set_character (an_object)
					when {MT_TYPE}.Mt_Double  then
						set_double (an_object)
					when {MT_TYPE}.Mt_Nil  then
					when {MT_TYPE}.Mt_S32_List  then
						set_integer_list (an_object)
					when {MT_TYPE}.Mt_Double_List  then
						set_double_list (an_object)
					when {MT_TYPE}.Mt_String_List  then
						set_string_list (an_object, {MT_TYPE}.Mt_String_List)

          when {MT_TYPE}.Mt_String  then
						set_string (an_object, {MT_TYPE}.Mt_String)
          when {MT_TYPE}.Mt_Text  then
						set_string (an_object, {MT_TYPE}.Mt_Text)

          when {MT_TYPE}.Mt_U8_Array  then
						set_byte_array (an_object, {MT_TYPE}.Mt_U8_Array)
          when {MT_TYPE}.Mt_Audio  then
						set_byte_array (an_object, {MT_TYPE}.Mt_Audio)
          when {MT_TYPE}.Mt_Image  then
            set_byte_array (an_object, {MT_TYPE}.Mt_Image)
          when {MT_TYPE}.Mt_Video  then
						set_byte_array (an_object, {MT_TYPE}.Mt_Video)

					when {MT_TYPE}.Mt_S16_Array  then
						set_short_array (an_object)
					when {MT_TYPE}.Mt_S32_Array  then
						set_integer_array (an_object)
					when {MT_TYPE}.Mt_Double_Array  then
						set_double_array (an_object)
					when {MT_TYPE}.Mt_String_Array  then
						set_string_array (an_object, {MT_TYPE}.Mt_String_Array)
					when {MT_TYPE}.Mt_Float_Array  then
						set_real_array (an_object)
					when {MT_TYPE}.Mt_Float  then
						set_real (an_object)
					when {MT_TYPE}.Mt_Float_List  then
						set_real_list (an_object)
					end -- inspect
				end -- if a_value /= Void
			end
		end

	set_dynamic_value (an_object: MT_STORABLE; value: ANY)
		local
			an_int: INTEGER_REF
      a_decimal: DECIMAL
			a_real: REAL_REF
			a_double: DOUBLE_REF
			a_boolean: BOOLEAN_REF
			a_string: STRING
			a_ucstring: UC_STRING
			int_array: ARRAY [INTEGER]
			decimal_array: ARRAY [DECIMAL]
			real_array: ARRAY [REAL]
			double_array: ARRAY [DOUBLE]
			string_array: ARRAY [STRING]
			int_list: LINKED_LIST [INTEGER]
			decimal_list: LINKED_LIST [DECIMAL]
			real_list: LINKED_LIST [REAL]
			double_list: LINKED_LIST [DOUBLE]
			string_list: LINKED_LIST [STRING]
			a_date: DATE
			a_date_time: DATE_TIME
			a_duration: DATE_TIME_DURATION
			value_type: INTEGER
		do
			if an_object.want_to_set_value (Current) then
				an_object.set_value_of_attribute (Current)
			else
				value_type := dynamic_type (value)
				if value_type = mttype_ref.Eif_integer_type then
					an_int ?= value
					set_integer_value (an_object, an_int.item)
				elseif value_type = mttype_ref.Eif_decimal_type then
          a_decimal ?= value
          set_decimal_value (an_object, a_decimal)
				elseif value_type = mttype_ref.Eif_real_type then
					a_real ?= value
					set_real_value (an_object, a_real.item)
				elseif value_type = mttype_ref.Eif_double_type then
					a_double ?= value
					set_double_value (an_object, a_double.item)
				elseif value_type = mttype_ref.Eif_string_type then
					a_string ?= value
					set_string_value (an_object, {MT_TYPE}.Mt_String, a_string)
				elseif value_type = mttype_ref.Eif_ucstring_type then
					a_ucstring ?= value
					set_string_utf8_value (an_object, {MT_TYPE}.Mt_String, a_ucstring)
				elseif value_type = mttype_ref.Eif_boolean_type then
					a_boolean ?= value
					set_boolean_value (an_object, a_boolean.item)
				elseif value_type = mttype_ref.Eif_integer_array_type then
					int_array ?= value
					inspect dynamic_att_type (an_object)
					when {MT_TYPE}.Mt_S16_Array then
						set_short_array_value (an_object, int_array)
					when {MT_TYPE}.Mt_S32_Array then
						set_integer_array_value (an_object, int_array)
					else
						set_integer_array_value (an_object, int_array)
					end
				elseif value_type = mttype_ref.Eif_decimal_array_type then
					decimal_array ?= value
					set_decimal_array_value (an_object, decimal_array)
				elseif value_type = mttype_ref.Eif_real_array_type then
					real_array ?= value
					set_real_array_value (an_object, real_array)
				elseif value_type = mttype_ref.Eif_double_array_type then
					double_array ?= value
					set_double_array_value (an_object, double_array)
				elseif value_type = mttype_ref.Eif_string_array_type then
					string_array ?= value
					set_string_array_value (an_object, {MT_TYPE}.Mt_String_Array, string_array)
				elseif value_type = mttype_ref.Eif_integer_list_type then
					int_list ?= value
					set_integer_list_value (an_object, int_list)
				elseif value_type = mttype_ref.Eif_decimal_list_type then
					decimal_list ?= value
					set_decimal_list_value (an_object, decimal_list)
				elseif value_type = mttype_ref.Eif_real_list_type then
					real_list ?= value
					set_real_list_value (an_object, real_list)
				elseif value_type = mttype_ref.Eif_double_list_type then
					double_list ?= value
					set_double_list_value (an_object, double_list)
				elseif value_type = mttype_ref.Eif_string_list_type then
					string_list ?= value
					set_string_list_value (an_object, {MT_TYPE}.Mt_String_List, string_list)
				elseif value_type = mttype_ref.Eif_date_type then
					a_date ?= value
					set_date_value (an_object, a_date)
				elseif value_type = mttype_ref.Eif_date_time_type then -- {MT_TYPE}.Mt_Timestamp
					a_date_time ?= value
					set_timestamp_value (an_object, a_date_time)
				elseif value_type = mttype_ref.Eif_date_time_duration_type then -- {MT_TYPE}.Mt_Interval
					a_duration ?= value
					set_time_interval_value (an_object, a_duration)
				else
					trigger_dev_exception (100000012, "")
				end

			end
		end

	set_value (an_object: MT_STORABLE)
		do
			if an_object.want_to_set_value (Current) then
				an_object.set_value_of_attribute (Current)
			else
				inspect mt_type
				when {MT_TYPE}.Mt_Boolean then
					set_boolean (an_object)
				when {MT_TYPE}.Mt_Timestamp then
					set_timestamp (an_object)
				when {MT_TYPE}.Mt_Date then
					set_date (an_object)
				when {MT_TYPE}.Mt_Interval then
					set_time_interval (an_object)
				when {MT_TYPE}.Mt_U8 then
					set_byte (an_object)
				when {MT_TYPE}.Mt_U8_list  then
					set_byte_list (an_object)
				when {MT_TYPE}.Mt_s16  then
					set_short (an_object)
				when {MT_TYPE}.Mt_S16_List then
					set_short_list (an_object)
				when {MT_TYPE}.Mt_s32  then
					set_integer (an_object)
				when {MT_TYPE}.Mt_Numeric  then
					set_decimal (an_object)
				when {MT_TYPE}.Mt_Char  then
					set_character (an_object)
				when {MT_TYPE}.Mt_Double  then
					set_double (an_object)
				when {MT_TYPE}.Mt_Nil  then
				when {MT_TYPE}.Mt_S32_List  then
					set_integer_list (an_object)
				when {MT_TYPE}.Mt_Numeric_List  then
					set_decimal_list (an_object)
				when {MT_TYPE}.Mt_Double_List  then
					set_double_list (an_object)
				when {MT_TYPE}.Mt_String_List  then
					set_string_list (an_object, {MT_TYPE}.Mt_String_List)
				when {MT_TYPE}.Mt_String  then
					set_string (an_object, {MT_TYPE}.Mt_String)
				when {MT_TYPE}.Mt_Text  then
					set_string (an_object, {MT_TYPE}.Mt_Text)

        when {MT_TYPE}.Mt_U8_array  then
					set_byte_array (an_object, {MT_TYPE}.Mt_U8_array)
        when {MT_TYPE}.Mt_Audio  then
          set_byte_array (an_object, {MT_TYPE}.Mt_Audio)
        when {MT_TYPE}.Mt_Image  then
          set_byte_array (an_object, {MT_TYPE}.Mt_Image)
        when {MT_TYPE}.Mt_Video  then
          set_byte_array (an_object, {MT_TYPE}.Mt_Video)

				when {MT_TYPE}.Mt_S16_Array  then
					set_short_array (an_object)
				when {MT_TYPE}.Mt_S32_Array  then
					set_integer_array (an_object)
				when {MT_TYPE}.Mt_Double_Array  then
					set_double_array (an_object)
				when {MT_TYPE}.Mt_String_Array  then
					set_string_array (an_object, {MT_TYPE}.Mt_String_Array)
				when {MT_TYPE}.Mt_Float_Array  then
					set_real_array (an_object)
				when {MT_TYPE}.Mt_Float  then
					set_real (an_object)
				when {MT_TYPE}.Mt_Float_List  then
					set_real_list (an_object)
				else
				end -- inspect
			end
		end

	set_character (an_object: MT_STORABLE)
		local
			new_value: CHARACTER
		do
			new_value := character_field (eif_field_index, an_object)
			mtdb.context.set_value_char ( an_object.oid, oid, {MT_TYPE}.Mt_Char, new_value, 0)
			persister.notify_attribute_update (an_object, Current)
		end

	set_boolean (an_object: MT_STORABLE)
		local
			new_value: BOOLEAN
		do
			new_value := boolean_field (eif_field_index, an_object)
			mtdb.context.set_value_boolean ( an_object.oid, oid, new_value)
			persister.notify_attribute_update (an_object, Current)
		end

	set_boolean_value (an_object: MT_STORABLE; new_value: BOOLEAN)
		do
			mtdb.context.set_value_boolean ( an_object.oid, oid, new_value)
			persister.notify_attribute_update (an_object, Current)
		end

	set_boolean_list (an_object: MT_STORABLE)
		local
			a_boolean_list: LINKED_LIST [BOOLEAN]
		do
			a_boolean_list ?= field (eif_field_index, an_object)
			set_boolean_list_value (an_object, a_boolean_list)
		end

	set_boolean_list_value (an_object: MT_STORABLE; value: LINKED_LIST [BOOLEAN])
		local
			booleans: ARRAY [BOOLEAN]
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S32_List, $p, 0)
				else
					create booleans.make (1, value.count)
					from
						value.start
						i := 1
					until
						value.off
					loop
						booleans.put (value.item, i)
						value.forth
						i := i + 1
					end
					mtdb.context.set_value_boolean_array ( an_object.oid, oid, booleans.count, $booleans)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end


	set_date (an_object: MT_STORABLE)
		local
			new_date: DATE
		do
			new_date ?= field (eif_field_index, an_object)
			set_date_value (an_object, new_date)
			persister.notify_attribute_update (an_object, Current)
		end

	set_date_list (an_object: MT_STORABLE)
		local
			a_date_list: LINKED_LIST [DATE]
		do
			a_date_list ?= field (eif_field_index, an_object)
			set_date_list_value (an_object, a_date_list)
		end

	set_date_list_value (an_object: MT_STORABLE; value: LINKED_LIST [DATE])
		local
			years, months, days: ARRAY [INTEGER]
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S32_List, $p, 0)
				else
					create years.make (1, value.count)
					create months.make (1, value.count)
					create days.make (1, value.count)
					from
						value.start
						i := 1
					until
						value.off
					loop
						years.put (value.item.year, i)
						months.put (value.item.month, i)
						days.put (value.item.day, i)
						value.forth
						i := i + 1
					end
					mtdb.context.set_value_date_array ( an_object.oid, oid, years.count, $years, $months, $days)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_date_value (an_object: MT_STORABLE; new_date: DATE)
		local
			p: ANY
		do
			if new_date = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				mtdb.context.set_value_date ( an_object.oid, oid, new_date.year, new_date.month, new_date.day)
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_timestamp (an_object: MT_STORABLE)
		local
			new_time: DATE_TIME
		do
			new_time ?= field (eif_field_index, an_object)
			set_timestamp_value (an_object, new_time)
		end

	set_timestamp_value (an_object: MT_STORABLE; new_time: DATE_TIME)
		local
			-- microsecond: INTEGER
			p: ANY
		do
			if new_time = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				mtdb.context.set_value_timestamp ( an_object.oid, oid,
						new_time.year, new_time.month, new_time.day,
						new_time.hour, new_time.minute, new_time.second,
						date_microseconds (new_time))
			end
			persister.notify_attribute_update (an_object, Current)
		end

	date_microseconds (a_date_time: DATE_TIME): INTEGER is
		     require
			valid_a_date_time: a_date_time /= Void
		do
		  Result := (a_date_time.fractional_second * 1000000).floor
		end


	set_timestamp_list (an_object: MT_STORABLE)
		local
			a_timestamp_list: LINKED_LIST [DATE_TIME]
		do
			a_timestamp_list ?= field (eif_field_index, an_object)
			set_timestamp_list_value (an_object, a_timestamp_list)
		end

	set_timestamp_list_value (an_object: MT_STORABLE; value: LINKED_LIST [DATE_TIME])
		local
			years, months, days, hours, minutes, seconds, microseconds: ARRAY [INTEGER]
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S32_List, $p, 0)
				else
					create years.make (1, value.count)
					create months.make (1, value.count)
					create days.make (1, value.count)
					create hours.make (1, value.count)
					create minutes.make (1, value.count)
					create seconds.make (1, value.count)
					create microseconds.make (1, value.count)

					from
						value.start
						i := 1
					until
						value.off
					loop
						years.put (value.item.year, i)
						months.put (value.item.month, i)
						days.put (value.item.day, i)
						days.put (value.item.hour, i)
						days.put (value.item.minute, i)
						days.put (value.item.second, i)
						days.put (date_microseconds (value.item), i)

						value.forth
						i := i + 1
					end
					mtdb.context.set_value_timestamp_array ( an_object.oid, oid, years.count, $years, $months, $days, $hours, $minutes, $seconds, $microseconds)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end


	set_time_interval (an_object: MT_STORABLE)
		local
			new_interval: DATE_TIME_DURATION
		do
			new_interval ?= field (eif_field_index, an_object)
			set_time_interval_value (an_object, new_interval)
		end

	set_time_interval_value (an_object: MT_STORABLE; new_interval: DATE_TIME_DURATION)
		local
			-- days: INTEGER
			-- fine_seconds: INTEGER_64
			p: ANY
		do
			if new_interval = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				mtdb.context.set_value_time_interval ( an_object.oid, oid, date_time_fine_seconds (new_interval))
			end
			persister.notify_attribute_update (an_object, Current)
		end

	date_time_fine_seconds (a_date_time_duration: DATE_TIME_DURATION): INTEGER_64
		require
			valid_a_date_time_duration: a_date_time_duration /= Void
		do
			Result := ((a_date_time_duration.date.day * 86400) + (a_date_time_duration.time.fine_seconds_count)).truncated_to_integer_64
		end

	set_time_interval_list (an_object: MT_STORABLE)
		local
			a_time_interval_list: LINKED_LIST [DATE_TIME_DURATION]
		do
			a_time_interval_list ?= field (eif_field_index, an_object)
			set_time_interval_list_value (an_object, a_time_interval_list)
		end

	set_time_interval_list_value (an_object: MT_STORABLE; value: LINKED_LIST [DATE_TIME_DURATION])
		local
			intervals: ARRAY [INTEGER_64]
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S32_List, $p, 0)
				else
					create intervals.make (1, value.count)
					from
						value.start
						i := 1
					until
						value.off
					loop
						intervals.put (date_time_fine_seconds (value.item), i)
						value.forth
						i := i + 1
					end
					p := intervals.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_Long_Array, $p, 1, intervals.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end


	set_byte (an_object: MT_STORABLE)
		local
			new_value: INTEGER
		do
			new_value := integer_field (eif_field_index, an_object)
			mtdb.context.set_value_u8 ( an_object.oid, oid, new_value)
			persister.notify_attribute_update (an_object, Current)
		end

	set_byte_array (an_object: MT_STORABLE; a_mt_type: INTEGER)
		local
			an_array: ARRAY [NATURAL_8]
			p: ANY
		do
			an_array ?= field (eif_field_index, an_object)
			if an_array = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if an_array.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, a_mt_type, $p, 0)
				else
					p := an_array.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, a_mt_type, $p, 1, an_array.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_byte_list (an_object: MT_STORABLE)
		local
			a_byte_array: ARRAY [NATURAL_8]
			a_byte_list: LINKED_LIST [NATURAL_8]
			i: INTEGER
			p: ANY
		do
			a_byte_list ?= field (eif_field_index, an_object)
			if a_byte_list = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if a_byte_list.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_U8_List, $p, 0)
				else
					create a_byte_array.make (1, a_byte_list.count)
					from
						a_byte_list.start
						i := 1
					until
						a_byte_list.off
					loop
						a_byte_array.put (a_byte_list.item, i)
						a_byte_list.forth
						i := i + 1
					end
					p := a_byte_array.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_U8_List, $p, 1, a_byte_list.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_byte_list_elements (an_object: MT_STORABLE; buffer: ARRAY [NATURAL_8];
			buffer_size: INTEGER; offset: INTEGER; discard_after: BOOLEAN)
		local
			to_c: ANY
			p: ANY
		do
			if buffer = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if buffer.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_U8_List, $p, 0)
				else
					to_c := buffer.to_c
					mtdb.context.set_value_byte_list_elements ( an_object.oid, oid, {MT_TYPE}.Mt_U8_List,
						$to_c, buffer_size, offset, discard_after)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

  -- MT_S16, MT_SHORT --	
	set_short (an_object: MT_STORABLE)
		local
			new_value: INTEGER
		do
			new_value := integer_field (eif_field_index, an_object)
			mtdb.context.set_value_s16 ( an_object.oid, oid, new_value)
			persister.notify_attribute_update (an_object, Current)
		end

	set_short_array (an_object: MT_STORABLE)
		local
			an_array: ARRAY [INTEGER]
		do
			an_array ?= field (eif_field_index, an_object)
			set_short_array_value (an_object, an_array)
		end

	set_short_array_value (an_object: MT_STORABLE; an_array: ARRAY [INTEGER])
		local
			p: ANY
		do
			if an_array = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if an_array.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S16_Array, $p, 0)
				else
					mtdb.context.set_value_short_array ( an_object.oid, oid, {MT_TYPE}.Mt_S16_Array, $an_array, 1)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_short_list (an_object: MT_STORABLE)
		local
			a_short_array: ARRAY [INTEGER]
			a_short_list: LINKED_LIST [INTEGER]
			i: INTEGER
			p: ANY
		do
			a_short_list ?= field (eif_field_index, an_object)
			if a_short_list = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if a_short_list.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S16_List, $p, 0)
				else
					create a_short_array.make (1, a_short_list.count)
					from
						a_short_list.start
						i := 1
					until
						a_short_list.off
					loop
						a_short_array.put (a_short_list.item, i)
						a_short_list.forth
						i := i + 1
					end
					mtdb.context.set_value_short_array ( an_object.oid, oid, {MT_TYPE}.Mt_S16_List, $a_short_array, 1)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

  -- MT_S32, MT_INTEGER --
	set_integer (an_object: MT_STORABLE)
		local
			new_value: INTEGER
		do
			new_value := integer_field (eif_field_index, an_object)
			mtdb.context.set_value_integer ( an_object.oid, oid, {MT_TYPE}.Mt_s32, new_value, 0)
			persister.notify_attribute_update (an_object, Current)
		end

	set_integer_value (an_object: MT_STORABLE; value: INTEGER)
		do
			mtdb.context.set_value_integer ( an_object.oid, oid, {MT_TYPE}.Mt_s32, value, 0)
			persister.notify_attribute_update (an_object, Current)
		end

	set_integer_array (an_object: MT_STORABLE)
		local
			an_array: ARRAY [INTEGER]
		do
			an_array ?= field (eif_field_index, an_object)
			set_integer_array_value (an_object, an_array)
		end

	set_integer_array_value (an_object: MT_STORABLE; value: ARRAY [INTEGER])
		local
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S32_Array, $p, 0)
				else
					p := value.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_S32_Array, $p, 1, value.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_integer_list (an_object: MT_STORABLE)
		local
			an_integer_list: LINKED_LIST [INTEGER]
		do
			an_integer_list ?= field (eif_field_index, an_object)
			set_integer_list_value (an_object, an_integer_list)
		end

	set_integer_list_value (an_object: MT_STORABLE; value: LINKED_LIST [INTEGER])
		local
			an_integer_array: ARRAY [INTEGER]
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_S32_List, $p, 0)
				else
					create an_integer_array.make (1, value.count)
					from
						value.start
						i := 1
					until
						value.off
					loop
						an_integer_array.put (value.item, i)
						value.forth
						i := i + 1
					end
					p := an_integer_array.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_S32_List, $p, 1, value.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

  -- MT_LONG --
    set_integer_64 (an_object: MT_STORABLE)
		local
			new_value: INTEGER_64
		do
			new_value := integer_64_field (eif_field_index, an_object)
			mtdb.context.set_value_integer_64 ( an_object.oid, oid, {MT_TYPE}.Mt_Long, new_value, 0)
			persister.notify_attribute_update (an_object, Current)
		end

	set_integer_64_value (an_object: MT_STORABLE; value: INTEGER_64)
		do
			mtdb.context.set_value_integer_64 ( an_object.oid, oid, {MT_TYPE}.Mt_Long, value, 0)
			persister.notify_attribute_update (an_object, Current)
		end

	set_integer_64_array (an_object: MT_STORABLE)
		local
			an_array: ARRAY [INTEGER_64]
		do
			an_array ?= field (eif_field_index, an_object)
			set_integer_64_array_value (an_object, an_array)
		end

	set_integer_64_array_value (an_object: MT_STORABLE; value: ARRAY [INTEGER_64])
		local
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Long_Array, $p, 0)
				else
					p := value.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_Long_Array, $p, 1, value.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_integer_64_list (an_object: MT_STORABLE)
		local
			an_integer_64_list: LINKED_LIST [INTEGER_64]
		do
			an_integer_64_list ?= field (eif_field_index, an_object)
			set_integer_64_list_value (an_object, an_integer_64_list)
		end

	set_integer_64_list_value (an_object: MT_STORABLE; value: LINKED_LIST [INTEGER_64])
		local
			an_integer_64_array: ARRAY [INTEGER_64]
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Long_List, $p, 0)
				else
					create an_integer_64_array.make (1, value.count)
					from
						value.start
						i := 1
					until
						value.off
					loop
						an_integer_64_array.put (value.item, i)
						value.forth
						i := i + 1
					end
					p := an_integer_64_array.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_Long_List, $p, 1, value.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

  -- MT_NUMERIC --
	set_decimal (an_object: MT_STORABLE)
		local
			new_value: DECIMAL
		do
			new_value ?= field (eif_field_index, an_object)
			set_decimal_value (an_object, new_value)
		end

	set_decimal_value (an_object: MT_STORABLE; value: DECIMAL)
	    local
	    	p: ANY
		do
      		if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
      		else
  				mtdb.context.mt_set_value_numeric ( an_object.oid, oid,
										value.item1, value.item2, value.item3, value.item4, value.item5, value.item6)
    	  	end
      		persister.notify_attribute_update (an_object, Current)
		end


	set_decimal_array (an_object: MT_STORABLE)
		local
			an_array: ARRAY [DECIMAL]
		do
			an_array ?= field (eif_field_index, an_object)
			set_decimal_array_value (an_object, an_array)
		end

	set_decimal_array_value (an_object: MT_STORABLE; value: ARRAY [DECIMAL])
		local
			a_decimal_array: ARRAY [INTEGER] -- array of item1 through item6
			p_array: ANY
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Numeric_List, $p, 0)
				else

					create a_decimal_array.make (1, value.count * 6)
					from
						--value.start
						i := 1
					until
						i > value.count --value.off
					loop
						a_decimal_array.put (value.item(i).item1, i * 6 - 5)
						a_decimal_array.put (value.item(i).item2, i * 6 - 4)
						a_decimal_array.put (value.item(i).item3, i * 6 - 3)
						a_decimal_array.put (value.item(i).item4, i * 6 - 2)
						a_decimal_array.put (value.item(i).item5, i * 6 - 1)
						a_decimal_array.put (value.item(i).item6, i * 6)
						--value.forth
						i := i + 1
					end
					p_array := a_decimal_array.to_c
					-- TBD
					mtdb.context.mt_set_value_numeric_list ( an_object.oid, oid, $p_array, value.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_decimal_list (an_object: MT_STORABLE)
		local
			a_decimal_list: LINKED_LIST [DECIMAL]
		do
			a_decimal_list ?= field (eif_field_index, an_object)
			set_decimal_list_value (an_object, a_decimal_list)
		end

	set_decimal_list_value (an_object: MT_STORABLE; value: LINKED_LIST [DECIMAL])
		local
			a_decimal_array: ARRAY [INTEGER] -- array of items
			p_array: ANY
			i: INTEGER
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Numeric_List, $p, 0)
				else
					create a_decimal_array.make (1, value.count * 6)
					from
						value.start
						i := 1
					until
						value.off
					loop
						a_decimal_array.put (value.item.item1, i)
						a_decimal_array.put (value.item.item2, i + 1)
						a_decimal_array.put (value.item.item3, i + 2)
						a_decimal_array.put (value.item.item4, i + 3)
						a_decimal_array.put (value.item.item5, i + 4)
						a_decimal_array.put (value.item.item6, i + 5)
						value.forth
						i := i + 6
					end
					p_array := a_decimal_array.to_c
					mtdb.context.mt_set_value_numeric_list ( an_object.oid, oid, $p_array, value.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

  -- MT_STRING --	
	set_string (an_object: MT_STORABLE; a_mt_type: INTEGER)
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String or a_mt_type = {MT_TYPE}.Mt_text
		local
			new_value: STRING
			new_uc_str: UC_STRING
		do
			new_uc_str ?= field (eif_field_index, an_object)
			if new_uc_str /= Void then
				set_string_utf8_value (an_object, a_mt_type, new_uc_str)
			else
				new_value ?= field (eif_field_index, an_object)
				set_string_value (an_object, a_mt_type, new_value)
			end
		end

	set_string_value (an_object: MT_STORABLE; a_mt_type: INTEGER; value: STRING)
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String or a_mt_type = {MT_TYPE}.Mt_Text
		local
			c_string: ANY
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_string ( an_object.oid, oid, a_mt_type, $p, {MT_TYPE}.Mt_Ascii)
			else
				c_string := value.to_c
				mtdb.context.set_value_string ( an_object.oid, oid, a_mt_type, $c_string, {MT_TYPE}.Mt_Ascii)
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_string_array (an_object: MT_STORABLE; a_mt_type: INTEGER)
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String_Array
		local
			a_string_array: ARRAY [STRING]
		do
			a_string_array ?= field (eif_field_index, an_object)
			set_string_array_value (an_object, a_mt_type, a_string_array)
		end

	set_string_array_value (an_object: MT_STORABLE; a_mt_type: INTEGER; a_string_array: ARRAY [STRING])
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String_Array
		local
			c_string: ANY
			an_array_pointer: ARRAY [POINTER]
			i: INTEGER
			p: ANY
		do
			if a_string_array = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if a_string_array.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, a_mt_type, $p, 0)
				else
					create an_array_pointer.make (1, a_string_array.count)
					from
						i := a_string_array.lower
					until
						i > a_string_array.upper
					loop
						if a_string_array.item (i) = Void then
							an_array_pointer.put ($p, i)
						else
							c_string := a_string_array.item (i).to_c
							an_array_pointer.put ($c_string, i)
						end
						i:= i + 1
					end
					p := an_array_pointer.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, a_mt_type, $p, 1, a_string_array.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_string_list (an_object: MT_STORABLE; a_mt_type: INTEGER)
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String_List
		local
			a_string_list: LINKED_LIST [STRING]
		do
			a_string_list ?= field (eif_field_index, an_object)
			set_string_list_value (an_object, a_mt_type, a_string_list)
		end

	set_string_list_value (an_object: MT_STORABLE; a_mt_type: INTEGER; a_string_list: LINKED_LIST [STRING])
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String_List
		local
			c_string: ANY
			an_array_pointer: ARRAY [POINTER]
			i: INTEGER
			p: ANY
		do
			if a_string_list = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if a_string_list.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, a_mt_type, $p, 0)
				else
					create an_array_pointer.make (1, a_string_list.count)
					from
						a_string_list.start
						i := 1
					until
						a_string_list.off
					loop
						if a_string_list.item = Void then
							an_array_pointer.put ($p, i)
						else
							c_string := a_string_list.item.to_c
							an_array_pointer.put ($c_string, i)
						end
						a_string_list.forth
						i := i + 1
					end
					p := an_array_pointer.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, a_mt_type, $p, 1, a_string_list.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	-- MT_STRING (UTF8) --	
	set_string_utf8 (an_object: MT_STORABLE; a_mt_type: INTEGER)
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String
		local
			new_value: UC_STRING
		do
			new_value ?= field (eif_field_index, an_object)
			set_string_utf8_value (an_object, a_mt_type, new_value)
		end

	set_string_utf8_value (an_object: MT_STORABLE; a_mt_type: INTEGER; value: UC_STRING)
		require
			mt_type: a_mt_type = {MT_TYPE}.Mt_String or a_mt_type = {MT_TYPE}.Mt_Text
		local
			c_string: ANY
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_string ( an_object.oid, oid, a_mt_type, $p, {MT_TYPE}.Mt_Utf8)
			else
				c_string := value.to_utf8.to_c
				mtdb.context.set_value_string ( an_object.oid, oid, a_mt_type, $c_string, {MT_TYPE}.Mt_Utf8)
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_double (an_object: MT_STORABLE)
		local
			a_double: DOUBLE
		do
			a_double := double_field (eif_field_index, an_object)
			mtdb.context.set_value_double ( an_object.oid, oid, {MT_TYPE}.Mt_Double, a_double, 0)
			persister.notify_attribute_update (an_object, Current)
		end

	set_double_value (an_object: MT_STORABLE; value: DOUBLE)
		do
			mtdb.context.set_value_double ( an_object.oid, oid, {MT_TYPE}.Mt_Double, value, 0)
			persister.notify_attribute_update (an_object, Current)
		end

	set_double_array (an_object: MT_STORABLE)
		local
			a_double_array: ARRAY [DOUBLE]
		do
			a_double_array ?= field (eif_field_index, an_object)
			set_double_array_value (an_object, a_double_array)
		end

	set_double_array_value (an_object: MT_STORABLE; a_double_array: ARRAY [DOUBLE])
		local
			p: ANY
		do
			if a_double_array = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if a_double_array.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Double_Array, $p, 0)
				else
					p := a_double_array.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_Double_Array, $p, 1, a_double_array.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_double_list (an_object: MT_STORABLE)
		local
			a_double_list: LINKED_LIST [DOUBLE]
		do
			a_double_list ?= field (eif_field_index, an_object)
			set_double_list_value (an_object, a_double_list)
		end

	set_double_list_value (an_object: MT_STORABLE; a_double_list: LINKED_LIST [DOUBLE])
		local
			a_double_array: ARRAY [DOUBLE]
			i: INTEGER
			p: ANY
		do
			if a_double_list = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if a_double_list.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Double_List, $p, 0)
				else
					create a_double_array.make (1, a_double_list.count)
					from
						a_double_list.start
						i := 1
					until
						a_double_list.off
					loop
						a_double_array.put (a_double_list.item, i)
						a_double_list.forth
						i := i + 1
					end
					p := a_double_array.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_Double_List, $p, 1, a_double_list.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

	set_real (an_object: MT_STORABLE)
		local
			a_real: REAL
		do
			a_real := real_field (eif_field_index, an_object)
			mtdb.context.set_value_real ( an_object.oid, oid, {MT_TYPE}.Mt_Float, a_real)
			persister.notify_attribute_update (an_object, Current)
		end

	set_real_value (an_object: MT_STORABLE; value: REAL)
		do
			mtdb.context.set_value_real ( an_object.oid, oid, {MT_TYPE}.Mt_Float, value)
			persister.notify_attribute_update (an_object, Current)
		end

	set_real_array (an_object: MT_STORABLE)
		local
			a_real_array: ARRAY [REAL]
		do
			a_real_array ?= field (eif_field_index, an_object)
			set_real_array_value (an_object, a_real_array)
		end

	set_real_array_value (an_object: MT_STORABLE; value: ARRAY [REAL])
		local
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Float_Array, $p, 0)
				else
					p := value.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_Float_Array, $p, 1, value.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end


	set_real_list (an_object: MT_STORABLE)
		local
			a_real_list: LINKED_LIST [REAL]
		do
			a_real_list ?= field (eif_field_index, an_object)
			set_real_list_value (an_object, a_real_list)
		end

	set_real_list_value (an_object: MT_STORABLE; a_real_list: LINKED_LIST [REAL])
		local
			a_real_array: ARRAY [REAL]
			i: INTEGER
			p: ANY
		do
			if a_real_list = Void then
				mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Nil, $p, 0)
			else
				if a_real_list.count = 0 then
					mtdb.context.set_value_void ( an_object.oid, oid, {MT_TYPE}.Mt_Float_List, $p, 0)
				else
					create a_real_array.make (1, a_real_list.count)
					from
						a_real_list.start
						i := 1
					until
						a_real_list.off
					loop
						a_real_array.put (a_real_list.item, i)
						a_real_list.forth
						i := i + 1
					end
					p := a_real_array.to_c
					mtdb.context.set_value_array_numeric ( an_object.oid, oid, {MT_TYPE}.Mt_Float_List, $p, 1, a_real_list.count)
				end
			end
			persister.notify_attribute_update (an_object, Current)
		end

feature
	remove_value (an_obj: MT_STORABLE)
		do
			mtdb.context.remove_value ( an_obj.oid, oid)
			persister.notify_attribute_update (an_obj, Current)
		end

feature {MT_CLASS, MT_PERSISTER}-- Schema

	eif_field_type: INTEGER
		-- Field type of eiffel object field corresponding to Current

	mt_type: INTEGER
		-- MATISSE attribute type

	set_field_type (i: INTEGER)
		do
			eif_field_type := i
		end

	set_mt_type (i: INTEGER)
		do
			mt_type := i
		end

	predefined_eif_field (a_field_name: STRING): BOOLEAN
			-- Is a_field_name an attribute defined in this class?
		do
			Result := a_field_name.is_equal ("oid") or
					a_field_name.is_equal ("db") or
					a_field_name.is_equal ("attributes_loaded") or
					a_field_name.is_equal ("relationships_loaded") or
					a_field_name.is_equal ("eif_field_index") or
					a_field_name.is_equal ("eif_field_type")
		end

	setup_field (field_index: INTEGER; sample_obj: MT_STORABLE; a_db: MT_DATABASE)
			-- Initialize current as an attribute  for a speicif class,
			-- which is the class of sample_obj.
		local
			excp: MT_EXCEPTIONS
			message: STRING
		do
			persister ?= a_db.persister
			eif_field_index := field_index
			eif_field_type := (field_type (field_index, sample_obj))

			mt_type := mtdb.context.get_attribute_type ( oid)
			if not conform_to_field_type (mt_type) then
				create excp
				message := "Eiffel field '"
				message.append (eiffel_name)
				message.append ("' of class '")
				message.append (sample_obj.generator)
				message.append ("' does not conform to MATISSE attribute type.")
				excp.trigger (excp.Developer_exception, 100002, message)
			end
		end

feature {NONE} -- Implementation

	conform_to_field_type (a_mt_type: INTEGER): BOOLEAN
			-- Does a_mt_type conform to field type of object field
			-- specified by current?
		do
			inspect a_mt_type
			when {MT_TYPE}.Mt_Nil then Result := False
			when {MT_TYPE}.Mt_Any then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Boolean then Result := eif_field_type = Boolean_type
			when {MT_TYPE}.Mt_Boolean_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Timestamp then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Timestamp_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Date then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Date_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Interval then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Interval_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_U8 then Result := eif_field_type = natural_8_type
			when {MT_TYPE}.Mt_U8_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Text then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Audio then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Image then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Video then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_s16 then Result := eif_field_type = Integer_16_type
			when {MT_TYPE}.Mt_S16_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_s32 then Result := eif_field_type = Integer_type
			when {MT_TYPE}.Mt_Long then Result := eif_field_type = Integer_64_type
			when {MT_TYPE}.Mt_Numeric then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Numeric_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Double then Result := eif_field_type = Double_type
			when {MT_TYPE}.Mt_Float then Result := eif_field_type = Real_type
			when {MT_TYPE}.Mt_Char then Result := eif_field_type = Character_type
			when {MT_TYPE}.Mt_String then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_S32_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Double_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Float_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_String_List then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_long_list then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_S32_Array then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_U8_Array then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_S16_Array then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Double_Array then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_Float_Array then Result := eif_field_type = Reference_type
			when {MT_TYPE}.Mt_String_Array then Result := eif_field_type = Reference_type
			else Result := False
			end
		end

feature -- Value by type

	-- MT_U8 --
	get_byte (an_object: MT_OBJECT): NATURAL_8
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Byte then
				Result := mtdb.context.get_byte_value ( an_object.oid, oid);
			end
		end

	get_byte_array, get_byte_list (an_object: MT_OBJECT): ARRAY [NATURAL_8]
		local
			array_size, a_mttype: INTEGER
			to_c: ANY
		do
      a_mttype := mtdb.context.get_value_type ( an_object.oid, oid)
			if {MT_TYPE}.Mt_Byte_Array = a_mttype or {MT_TYPE}.Mt_Bytes = a_mttype or {MT_TYPE}.Mt_Audio = a_mttype or {MT_TYPE}.Mt_Image = a_mttype or {MT_TYPE}.Mt_Video = a_mttype then
				array_size := dimension (an_object, 0)
				create Result.make (1, array_size)
				to_c := Result.to_c
				mtdb.context.get_byte_array ( an_object.oid, oid, array_size, $to_c);
			end
		end

	get_byte_list_elements (an_object: MT_OBJECT; buffer: ARRAY [NATURAL_8];
			count, offset: INTEGER): INTEGER
		local
			to_c: ANY
		do
			to_c := buffer.to_c
			Result := mtdb.context.get_byte_list_elements ( an_object.oid, oid, $to_c, count, offset)
		end

	-- MT_LONF, MT_S64 --
	get_integer_64 (an_object: MT_OBJECT): INTEGER_64
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_long then
				Result := mtdb.context.get_integer_64_value ( an_object.oid, oid);
			end
		end

	get_integer_64_list (an_object: MT_OBJECT): LINKED_LIST [INTEGER_64]
		local
			list_count, count: INTEGER
			buffer: ARRAY[INTEGER_64]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Integer_64_List then
				list_count := dimension (an_object, 0)
				create buffer.make (1, list_count)
				create Result.make
				to_c := buffer.to_c
				mtdb.context.get_integer_64_array ( an_object.oid, oid, list_count, $to_c)
				from
					count := 1
				until
					count = list_count + 1
				loop
					Result.extend (buffer.item (count))
					count := count + 1
				end
			end
		end

	get_integer_64_array (an_object: MT_OBJECT): ARRAY [INTEGER_64]
		local
			array_size: INTEGER
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Integer_64_Array then
				array_size:= dimension (an_object, 0)
				create Result.make (1, array_size)
				to_c := Result.to_c
				mtdb.context.get_integer_64_array ( an_object.oid, oid, array_size, $to_c)
			end
		end

	-- MT_S32 --
	get_integer (an_object: MT_OBJECT): INTEGER
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Integer then
				Result := mtdb.context.get_integer_value ( an_object.oid, oid);
			end
		end

	get_integer_list (an_object: MT_OBJECT): LINKED_LIST [INTEGER]
		local
			list_count, count: INTEGER
			buffer: ARRAY[INTEGER]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Integer_List then
				list_count := dimension (an_object, 0)
				create buffer.make (1, list_count)
				create Result.make
				to_c := buffer.to_c
				mtdb.context.get_integer_array ( an_object.oid, oid, list_count, $to_c)
				from
					count := 1
				until
					count = list_count + 1
				loop
					Result.extend (buffer.item (count))
					count := count + 1
				end
			end
		end

	get_integer_array (an_object: MT_OBJECT): ARRAY [INTEGER]
		local
			array_size: INTEGER
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Integer_Array then
				array_size:= dimension (an_object, 0)
				create Result.make (1, array_size)
				to_c := Result.to_c
				mtdb.context.get_integer_array ( an_object.oid, oid, array_size, $to_c)
			end
		end

	-- MT_S16 --
	get_short (an_object: MT_OBJECT): INTEGER_16
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Short then
				Result := mtdb.context.get_short_value ( an_object.oid, oid);
			end
		end

	get_short_list (an_object: MT_OBJECT): LINKED_LIST [INTEGER_16]
		local
			list_count, count: INTEGER
			buf: ARRAY[INTEGER_16]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Short_List then
				list_count := dimension (an_object, 0)
				create Result.make
				create buf.make (1, list_count)
				to_c := buf.to_c
				mtdb.context.get_short_array ( an_object.oid, oid, list_count, $to_c)
				from
					count := 1
				until
					count = list_count + 1
				loop
					Result.extend (buf.item (count))
					count := count + 1
				end
			end
		end

	get_short_array (an_object: MT_OBJECT): ARRAY [INTEGER_16]
		local
			array_size: INTEGER
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Short_Array then
				array_size := dimension (an_object, 0)
				create Result.make (1, array_size)
				to_c := Result.to_c
				mtdb.context.get_short_array ( an_object.oid, oid, array_size, $to_c)
			end
		end

	get_integer_type_value (an_object: MT_OBJECT): INTEGER
		-- MATISSE type is MT_S64, MT_S32, MT_U32, MT_S16 or MT_U16.
		do
			inspect mt_type
			when {MT_TYPE}.Mt_U8 then
				Result := get_byte (an_object)
			when {MT_TYPE}.Mt_s16 then
				Result := get_short (an_object)
			when {MT_TYPE}.Mt_s32 then
				Result := get_integer (an_object)
			--when {MT_TYPE}.Mt_S64 then
			--	Result := get_integer_64 (an_object)
			else
			end
		end

	-- MT_NUMERIC --
	get_decimal (an_object: MT_OBJECT): DECIMAL
		local
			res_array: ARRAY[INTEGER]
			any_a: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Numeric then
				create res_array.make(1, 6)
				any_a := res_array.to_c
				mtdb.context.get_numeric_value ( an_object.oid, oid, $any_a)
				create Result.from_int_array (res_array)
			end
		end

	get_decimal_list (an_object: MT_OBJECT): LINKED_LIST [DECIMAL]
		local
			num_elem, count: INTEGER
			buffer: ARRAY[INTEGER]
			each_dec: DECIMAL
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Numeric_List then
				num_elem := dimension (an_object, 0)
				create buffer.make (1, num_elem * 6)
				to_c := buffer.to_c
				mtdb.context.get_numeric_array ( an_object.oid, oid, num_elem, $to_c)

				create Result.make
				from
					count := 1
				until
					count = num_elem + 1
				loop
					create each_dec.from_int_buf_array (buffer, (count - 1) * 6 + 1)
					Result.extend (each_dec)
					count := count + 1
				end
			end
		end

	-- MT_REAL --	
	get_real (an_object: MT_OBJECT): REAL
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Float then
				Result := mtdb.context.get_real_value ( an_object.oid, oid);
			end
		end

	get_real_list (an_object: MT_OBJECT): LINKED_LIST [REAL]
		local
			num_elem, count: INTEGER
			buffer: ARRAY[REAL]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Float_List then
				num_elem := dimension (an_object, 0)
				create buffer.make (1, num_elem)
				to_c := buffer.to_c
				mtdb.context.get_real_array ( an_object.oid, oid, num_elem, $to_c)

				create Result.make
				from
					count := 1
				until
					count = num_elem + 1
				loop
					Result.extend (buffer.item (count))
					count := count + 1
				end
			end
		end

	get_real_array (an_object: MT_OBJECT): ARRAY [REAL]
		local
			array_size: INTEGER
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Float_Array then
				array_size := dimension (an_object, 0)
				create Result.make (1, array_size)
				to_c := Result.to_c
				mtdb.context.get_real_array ( an_object.oid, oid, array_size, $to_c)
			end
		end

	-- MT_DOUBLE --
	get_double (an_object: MT_OBJECT): DOUBLE
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Double then
				Result := mtdb.context.get_double_value ( an_object.oid, oid);
			end
		end

	get_double_list (an_object: MT_OBJECT): LINKED_LIST [DOUBLE]
		local
			num_elem, count: INTEGER
			buffer: ARRAY[DOUBLE]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Double_List then
				num_elem := dimension (an_object, 0)
				create buffer.make (1, num_elem)
				to_c := buffer.to_c
				mtdb.context.get_double_array ( an_object.oid, oid, num_elem, $to_c)

				create Result.make
				from
					count := 1
				until
					count = num_elem + 1
				loop
					Result.extend (buffer.item (count))
					count := count + 1
				end
			end
		end

	get_double_array (an_object: MT_OBJECT): ARRAY [DOUBLE]
		local
			num_elem: INTEGER
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Double_Array then
				num_elem := dimension (an_object, 0)
				create Result.make (1, num_elem)
				to_c := Result.to_c
				mtdb.context.get_double_array ( an_object.oid, oid, num_elem, $to_c)
			end
		end

	-- MT_CHAR --
	get_character (an_object: MT_OBJECT): CHARACTER
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Char then
				Result := mtdb.context.get_char_value ( an_object.oid, oid);
			end
		end

	-- MT_STRING --
	get_string (an_object: MT_OBJECT): STRING
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_String then
				Result := mtdb.context.get_string_value ( an_object.oid, oid)
			end
		end

	get_string_list (an_object: MT_OBJECT): LINKED_LIST [STRING]
		local
			list_size, count: INTEGER
			buffer: ARRAY[STRING]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_String_List then
				list_size := dimension (an_object, 0)
				create buffer.make (1, list_size)
				to_c := buffer.to_c
				mtdb.context.get_string_array ( an_object.oid, oid, list_size, to_c)

				create Result.make
				from
					count := 1
				until
					count = list_size + 1
				loop
					Result.extend (buffer.item(count))
					count := count + 1
				end
			end
		end

	get_string_array (an_object: MT_OBJECT): ARRAY [STRING]
		-- Note: support one-dimensional array only
		local
			array_size: INTEGER
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_String_Array then
				array_size := dimension (an_object, 0)
				create Result.make (1, array_size)
				to_c := Result.to_c
				mtdb.context.get_string_array ( an_object.oid, oid, array_size, to_c)
			end
		end

	-- MT_STRING (UTF8)--
	get_string_utf8 (an_object: MT_OBJECT): UC_STRING
		local
			a_string: STRING
		do
			a_string := mtdb.context.get_string_value ( an_object.oid, oid)
			if a_string /= Void then
				create Result.make_from_utf8 (a_string)
			end
		end

	-- MT_BOOLEAN --
	get_boolean (an_object: MT_OBJECT): BOOLEAN
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Boolean then
				Result := mtdb.context.get_boolean_value ( an_object.oid, oid)
			end
		end

	get_boolean_list (an_object: MT_OBJECT): LINKED_LIST [BOOLEAN]
		local
			num_elem, count: INTEGER
			buffer: ARRAY[BOOLEAN]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Boolean_List then
				num_elem := dimension (an_object, 0)
				create buffer.make (1, num_elem)
				to_c := buffer.to_c
				mtdb.context.get_boolean_array ( an_object.oid, oid, num_elem, $to_c)

				create Result.make
				from
					count := 1
				until
					count = num_elem + 1
				loop
					Result.extend (buffer.item (count))
					count := count + 1
				end
			end
		end

	-- MT_DATE --
	get_date (an_object: MT_OBJECT): DATE
		-- Type of result is still subject to change
		local
			yr, mh, dy: INTEGER
			hr, me, sd, msd: INTEGER -- not used for Date
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Date then
				mtdb.context.get_timestamp_value ( an_object.oid, oid, $yr, $mh, $dy, $hr, $me, $sd, $msd)
				create Result.make (yr, mh, dy)
			end
		end

	get_date_list (an_object: MT_OBJECT): LINKED_LIST [DATE]
		local
			num_elem, count: INTEGER
			buffer: ARRAY[INTEGER]
			to_c: ANY
			each: DATE
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Date_List then
				num_elem := dimension (an_object, 0)
				create buffer.make (1, num_elem * 3)
				to_c := buffer.to_c
				mtdb.context.get_date_array ( an_object.oid, oid, num_elem, $to_c)

				create Result.make
				from
					count := 0
				until
					count = num_elem
				loop
					create each.make (buffer.item(count * 3 + 1), -- year
									  buffer.item(count * 3 + 2), -- month
									  buffer.item(count * 3 + 3)) -- day
					Result.extend (each)
					count := count + 1
				end
			end
		end

	-- MT_TIMESTAMP --
	get_timestamp (an_object: MT_OBJECT): DATE_TIME
		-- Type of result is still subject to change
		local
			yr, mh, dy, hr, me, sd, msd: INTEGER
			fine_sec: DOUBLE
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Timestamp then
				mtdb.context.get_timestamp_value ( an_object.oid, oid, $yr, $mh, $dy, $hr, $me, $sd, $msd)
				fine_sec := sd + (msd / 1000000)
				create Result.make_fine (yr, mh, dy, hr, me, fine_sec)
			end
		end

	get_timestamp_list (an_object: MT_OBJECT): LINKED_LIST [DATE_TIME]
		local
			num_elem, count: INTEGER
			buffer: ARRAY[INTEGER]
			to_c: ANY
			each: DATE_TIME
			fine_sec: DOUBLE
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Timestamp_List then
				num_elem := dimension (an_object, 0)
				create buffer.make (1, num_elem * 7)
				to_c := buffer.to_c
				mtdb.context.get_timestamp_array ( an_object.oid, oid, num_elem, $to_c)

				create Result.make
				from
					count := 0
				until
					count = num_elem
				loop
					fine_sec := buffer.item (count * 7 + 6) -- second
						+ (buffer.item (count * 7 + 7) / 1000000) -- microsecond
					create each.make_fine (buffer.item(count * 7 + 1), -- year
											 buffer.item(count * 7 + 2), -- month
											 buffer.item(count * 7 + 3), -- day
											 buffer.item(count * 7 + 4), -- hour
											 buffer.item(count * 7 + 5), -- minute
											 fine_sec)
					Result.extend (each)
					count := count + 1
				end
			end
		end

	-- MT_INTERVAL --
	get_time_interval (an_object: MT_OBJECT): DATE_TIME_DURATION
		-- Type of result is still subject to change
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Interval then
				Result := date_time_duration_from_milliseconds (mtdb.context.get_interval_value ( an_object.oid, oid))
			end
		end

	get_time_interval_list (an_object: MT_OBJECT): LINKED_LIST [DATE_TIME_DURATION]
		local
			num_elem, i: INTEGER
			-- milliseconds: INTEGER_64
			-- new_duration: DATE_TIME_DURATION
			buffer: ARRAY [INTEGER_64]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( an_object.oid, oid) = {MT_TYPE}.Mt_Interval_List then
				num_elem := dimension (an_object, 0)
				create buffer.make (1, num_elem)
				create Result.make
				to_c := buffer.to_c
				--mtdb.context.get_integer_64_array ( an_object.oid, oid, num_elem, $to_c)
				mtdb.context.get_interval_array ( an_object.oid, oid, num_elem, $to_c)
				from
					i := 1
				until
					i > num_elem
				loop
					Result.extend (date_time_duration_from_milliseconds (buffer [i]))
					i := i + 1
				end
			end
		end



feature {MT_PERSISTER} -- Object life cycle

	revert_to_unloaded (an_obj: MT_STORABLE)
		local
			a_type: INTEGER
		do
			if mt_type = 0 then
				a_type := mtdb.context.get_value_type ( an_obj.oid, oid)
			else
				a_type := mt_type
			end

			inspect a_type
			when {MT_TYPE}.Mt_Boolean then set_boolean_field (eif_field_index, an_obj, False)
			when {MT_TYPE}.Mt_U8 then set_integer_field (eif_field_index, an_obj, 0)
			when {MT_TYPE}.Mt_S16  then set_integer_16_field (eif_field_index, an_obj, 0)
			when {MT_TYPE}.Mt_S32  then set_integer_field (eif_field_index, an_obj, 0)
			when {MT_TYPE}.Mt_Long  then set_integer_64_field (eif_field_index, an_obj, (0).to_integer_64)
			when {MT_TYPE}.Mt_Char  then set_character_field (eif_field_index, an_obj, '%U')
			when {MT_TYPE}.Mt_Double  then set_double_field (eif_field_index, an_obj, Double_default_value)
			when {MT_TYPE}.Mt_Float  then set_real_field (eif_field_index, an_obj, Real_default_value)
			else
				set_reference_field (eif_field_index, an_obj, Void)
			end
		end

end -- class MTATTRIBUTE
