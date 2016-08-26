note
	description: "MATISSE-Eiffel Binding: define the Matisse constants"
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
	MT_TYPE

inherit
	INTERNAL
		rename
			c_is_instance_of as internal_c_instance_of,
			is_instance_of as internal_instance_of
		export
			{NONE} all
		end

feature -- MATISSE Data Types

	Mt_Min_Type: INTEGER = 0
	Mt_Oid: INTEGER = 1
	Mt_Selection: INTEGER = 2
	Mt_Any: INTEGER = 3
	Mt_Null, Mt_Nil: INTEGER = 4
	Mt_Audio: INTEGER = 5
	Mt_Image: INTEGER = 6
	Mt_Video: INTEGER = 7
	Mt_Text: INTEGER = 8
	Mt_Char: INTEGER = 9

	Mt_Boolean: INTEGER = 10
	Mt_Boolean_List: INTEGER = 11

	Mt_String: INTEGER = 14
	Mt_String_List: INTEGER = 15
	Mt_String_Array: INTEGER = 16

	Mt_Double: INTEGER = 18
	Mt_Double_List: INTEGER = 19
	Mt_Double_Array: INTEGER = 20

	Mt_Float: INTEGER = 22
	Mt_Float_List: INTEGER = 23
	Mt_Float_Array: INTEGER = 24

	Mt_Date: INTEGER = 26
	Mt_Date_List: INTEGER = 27

	Mt_Timestamp: INTEGER = 30
	Mt_Timestamp_List: INTEGER = 31

	Mt_Interval: INTEGER = 34
	Mt_Interval_List: INTEGER = 35

	Mt_Byte, Mt_U8: INTEGER =  38
	Mt_Bytes, Mt_U8_List: INTEGER = 39
	Mt_Byte_Array, Mt_U8_Array: INTEGER = 40

	Mt_Short, Mt_S16: INTEGER = 42
	Mt_Short_List, Mt_S16_List: INTEGER = 43
	Mt_Short_Array, Mt_S16_Array: INTEGER = 44

	Mt_Integer, Mt_S32: INTEGER = 46
	Mt_Integer_List, Mt_S32_List: INTEGER = 47
	Mt_Integer_Array, Mt_S32_Array: INTEGER = 48

	Mt_Long, Mt_S64: INTEGER = 50
	Mt_Long_List, Mt_Integer_64_List, Mt_S64_List: INTEGER = 51
	Mt_Long_Array, Mt_Integer_64_Array, Mt_S64_Array: INTEGER = 52

	Mt_Numeric: INTEGER = 54
	Mt_Numeric_List: INTEGER = 55

	Mt_Enum: INTEGER = 58
	Mt_Enum_List: INTEGER = 59

	Mt_Table: INTEGER = 62

	Mt_Max_Type: INTEGER = 70

feature	-- String encoding
	Mt_Ascii: INTEGER = 1
	Mt_Utf8:  INTEGER = 5
	Mt_Utf16: INTEGER = 9

feature -- Decimal

	Mt_Max_Decimal_Len :INTEGER = 21
	Mt_Max_Precision: INTEGER = 38
	Mt_Min_Precision: INTEGER = 1
	Mt_Max_Scale: INTEGER     = 16
	Mt_Min_Scale: INTEGER     = 0


feature -- Eiffel class types

	Eif_character_type: INTEGER  once Result := dynamic_type ('a') end
	Eif_integer_type: INTEGER  once Result := dynamic_type (1) end
	Eif_boolean_type: INTEGER  once Result := dynamic_type (True) end
	Eif_string_type: INTEGER  once Result := dynamic_type ("a") end
	Eif_real_type: INTEGER
		local
			a: REAL
		once
			a := 1.0
			Result := dynamic_type (a)
		end

	Eif_double_type: INTEGER
		local
			a: DOUBLE
		once
			a := 1.0
			Result := dynamic_type (a)
		end

	Eif_integer_array_type: INTEGER
		local
			a: ARRAY [INTEGER]
		once
			create a.make (0, 0)
			Result := dynamic_type (a)
		end

	Eif_real_array_type: INTEGER
		local
			a: ARRAY [REAL]
		once
			create a.make (0, 0)
			Result := dynamic_type (a)
		end

	Eif_double_array_type: INTEGER
		local
			a: ARRAY [DOUBLE]
		once
			create a.make (0, 0)
			Result := dynamic_type (a)
		end

	Eif_reference_array_type, Eif_string_array_type: INTEGER
		local
			a: ARRAY [STRING]
		once
			create a.make (0, 0)
			Result := dynamic_type (a)
		end

	Eif_byte_array_type: INTEGER
		local
			a: ARRAY [CHARACTER]
		once
			create a.make (0, 0)
			Result := dynamic_type (a)
		end

	Eif_integer_list_type: INTEGER
		local
			a: LINKED_LIST [INTEGER]
		once
			create a.make
			Result := dynamic_type (a)
		end

	Eif_real_list_type: INTEGER
		local
			a: LINKED_LIST [REAL]
		once
			create a.make
			Result := dynamic_type (a)
		end

	Eif_double_list_type: INTEGER
		local
			a: LINKED_LIST [DOUBLE]
		once
			create a.make
			Result := dynamic_type (a)
		end

	Eif_string_list_type: INTEGER
		local
			a: LINKED_LIST [STRING]
		once
			create a.make
			Result := dynamic_type (a)
		end

	Eif_ucstring_type: INTEGER
		local
			a: UC_STRING
		once
			create a.make (1)
			Result := dynamic_type (a)
		end

	Eif_byte_list_type: INTEGER
		local
			a: LINKED_LIST [CHARACTER]
		once
			create a.make
			Result := dynamic_type (a)
		end

	Eif_date_type: INTEGER
		local
			a: DATE
		once
			create a.make (1, 1, 1)
			Result := dynamic_type (a)
		end
	Eif_date_time_type: INTEGER
		local
			a: DATE_TIME
		once
			create a.make (1, 1, 1, 1, 1, 1)
			Result := dynamic_type (a)
		end

	Eif_date_time_duration_type: INTEGER
		local
			a: DATE_TIME_DURATION
		once
			create a.make (1, 1, 1, 1, 1, 1)
			Result := dynamic_type (a)
		end

  Eif_decimal_type: INTEGER
    local
      a: DECIMAL
    once
      create a.make
      Result := dynamic_type(a)
    end

  Eif_decimal_list_type: INTEGER
    local
      a: LINKED_LIST[DECIMAL]
    once
      create a.make
      Result := dynamic_type(a)
    end

  Eif_decimal_array_type: INTEGER
    local
      a: ARRAY[DECIMAL]
    once
      create a.make(1,1)
      Result := dynamic_type(a)
    end


end -- class MTTYPE
