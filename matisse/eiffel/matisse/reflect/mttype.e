
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class 
	MTTYPE

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MTOBJECT
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance

-- BEGIN generation of create by Matisse SDL
create
	make_from_mtoid
	, make_from_mtclass
-- END of Matisse SDL generation of create
	, make_mttype

feature -- MATISSE Data Types

	Mt_Min_Type: INTEGER_32 = 0
	Mt_Oid: INTEGER_32 = 1
	Mt_Selection: INTEGER_32 = 2
	Mt_Any: INTEGER_32 = 3
	Mt_Null: INTEGER_32 = 4
	Mt_Audio: INTEGER_32 = 5
	Mt_Image: INTEGER_32 = 6
	Mt_Video: INTEGER_32 = 7
	Mt_Text: INTEGER_32 = 8
	Mt_Char: INTEGER_32 = 9

	Mt_Boolean: INTEGER_32 = 10
	Mt_Boolean_List: INTEGER_32 = 11

	Mt_String: INTEGER_32 = 14
	Mt_String_List: INTEGER_32 = 15

	Mt_Double: INTEGER_32 = 18
	Mt_Double_List: INTEGER_32 = 19

	Mt_Float: INTEGER_32 = 22
	Mt_Float_List: INTEGER_32 = 23

	Mt_Date: INTEGER_32 = 26
	Mt_Date_List: INTEGER_32 = 27

	Mt_Timestamp: INTEGER_32 = 30
	Mt_Timestamp_List: INTEGER_32 = 31

	Mt_Interval: INTEGER_32 = 34
	Mt_Interval_List: INTEGER_32 = 35

	Mt_Byte: INTEGER_32 =  38
	Mt_Bytes: INTEGER_32 = 39

	Mt_Short: INTEGER_32 = 42
	Mt_Short_List: INTEGER_32 = 43

	Mt_Integer: INTEGER_32 = 46
	Mt_Integer_List: INTEGER_32 = 47

	Mt_Long: INTEGER_32 = 50
	Mt_Long_List: INTEGER_32 = 51

	Mt_Numeric: INTEGER_32 = 54
	Mt_Numeric_List: INTEGER_32 = 55

	Mt_Table: INTEGER_32 = 62

	Mt_Max_Type: INTEGER_32 = 70

feature	-- String encoding
	Mt_Ascii: INTEGER_32 = 1
	Mt_Utf8:  INTEGER_32 = 5
	Mt_Utf16: INTEGER_32 = 9

feature -- Numeric

	Mt_Max_Decimal_Len :INTEGER_32 = 21
	Mt_Max_Precision: INTEGER_32 = 38
	Mt_Min_Precision: INTEGER_32 = 1
	Mt_Max_Scale: INTEGER_32     = 16
	Mt_Min_Scale: INTEGER_32     = 0

feature -- Initialization

	make_mttype (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("MtType"))
		end

-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 9.0.0
-- Date: Fri Dec  2 11:53:12 2011

feature -- Property Access

	get_mtbasictype_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtBasicType from the database
		do
			Result := mtdb.get_mtattribute("MtBasicType", mtdb.get_mtclass("MTTYPE"))
		end

	mtbasictype, get_mtbasictype (): INTEGER_32
		-- get the value of MtBasicType from the database
		do
			Result := get_integer (get_mtbasictype_attribute ())
		end

	is_mtbasictype_default_value (): BOOLEAN
		-- Check if MtBasicType attribute value is set to its default value
		do
			Result := is_default_value (get_mtbasictype_attribute ())
		end

	get_mtcharacterencoding_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtCharacterEncoding from the database
		do
			Result := mtdb.get_mtattribute("MtCharacterEncoding", mtdb.get_mtclass("MTTYPE"))
		end

	mtcharacterencoding, get_mtcharacterencoding (): INTEGER_32
		-- get the value of MtCharacterEncoding from the database
		do
			Result := get_integer (get_mtcharacterencoding_attribute ())
		end

	is_mtcharacterencoding_default_value (): BOOLEAN
		-- Check if MtCharacterEncoding attribute value is set to its default value
		do
			Result := is_default_value (get_mtcharacterencoding_attribute ())
		end

	get_mtprecisionscale_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtPrecisionScale from the database
		do
			Result := mtdb.get_mtattribute("MtPrecisionScale", mtdb.get_mtclass("MTTYPE"))
		end

	mtprecisionscale, get_mtprecisionscale (): ARRAY [INTEGER_32]
		-- get the value of MtPrecisionScale from the database
		do
			Result := get_integers (get_mtprecisionscale_attribute ())
		end

	is_mtprecisionscale_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_mtprecisionscale_attribute ())
		end

	is_mtprecisionscale_default_value (): BOOLEAN
		-- Check if MtPrecisionScale attribute value is set to its default value
		do
			Result := is_default_value (get_mtprecisionscale_attribute ())
		end

	get_mtenumeration_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtEnumeration from the database
		do
			Result := mtdb.get_mtattribute("MtEnumeration", mtdb.get_mtclass("MTTYPE"))
		end

	mtenumeration, get_mtenumeration (): ANY
		-- get the value of MtEnumeration from the database
		do
			Result := get_value (get_mtenumeration_attribute ())
		end

	is_mtenumeration_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_mtenumeration_attribute ())
		end

	is_mtenumeration_default_value (): BOOLEAN
		-- Check if MtEnumeration attribute value is set to its default value
		do
			Result := is_default_value (get_mtenumeration_attribute ())
		end

	get_mtmaxsize_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtMaxSize from the database
		do
			Result := mtdb.get_mtattribute("MtMaxSize", mtdb.get_mtclass("MTTYPE"))
		end

	mtmaxsize, get_mtmaxsize (): INTEGER_32
		-- get the value of MtMaxSize from the database
		do
			Result := get_integer (get_mtmaxsize_attribute ())
		end

	is_mtmaxsize_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_mtmaxsize_attribute ())
		end

	is_mtmaxsize_default_value (): BOOLEAN
		-- Check if MtMaxSize attribute value is set to its default value
		do
			Result := is_default_value (get_mtmaxsize_attribute ())
		end

	get_mtmaxelements_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtMaxElements from the database
		do
			Result := mtdb.get_mtattribute("MtMaxElements", mtdb.get_mtclass("MTTYPE"))
		end

	mtmaxelements, get_mtmaxelements (): ARRAY [INTEGER_32]
		-- get the value of MtMaxElements from the database
		do
			Result := get_integers (get_mtmaxelements_attribute ())
		end

	is_mtmaxelements_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_mtmaxelements_attribute ())
		end

	is_mtmaxelements_default_value (): BOOLEAN
		-- Check if MtMaxElements attribute value is set to its default value
		do
			Result := is_default_value (get_mtmaxelements_attribute ())
		end

	get_mtattributetypeof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtAttributeTypeOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtAttributeTypeOf", mtdb.get_mtclass("MTTYPE"))
		end

	mtattributetypeof, get_mtattributetypeof (): ARRAY[MTATTRIBUTE]
		-- get the MtAttributeTypeOf relationship successors from the database
		local
			v_res: ARRAY[MTATTRIBUTE]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtattributetypeof_relationship (), v_res)
			Result := v_res
		end

	mtattributetypeof_size, get_mtattributetypeof_size (): INTEGER_32
		-- get the MtAttributeTypeOf relationship size from the database
		do
			Result := get_successor_size (get_mtattributetypeof_relationship ())
		end

	mtattributetypeof_iterator (): MT_OBJECT_ITERATOR[MTATTRIBUTE]
		-- Opens an iterator on the MtAttributeTypeOf relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtattributetypeof_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end


feature -- Update Attributes

	set_mtbasictype (a_val: INTEGER_32)
		-- update MtBasicType attribute value in the database
		do
			set_integer (get_mtbasictype_attribute (), a_val)
		end

	remove_mtbasictype ()
		-- remove MtBasicType attribute value in the database
		do
			remove_value (get_mtbasictype_attribute ())
		end

	set_mtcharacterencoding (a_val: INTEGER_32)
		-- update MtCharacterEncoding attribute value in the database
		do
			set_integer (get_mtcharacterencoding_attribute (), a_val)
		end

	remove_mtcharacterencoding ()
		-- remove MtCharacterEncoding attribute value in the database
		do
			remove_value (get_mtcharacterencoding_attribute ())
		end

	set_mtprecisionscale (a_val: ARRAY [INTEGER_32])
		-- update MtPrecisionScale attribute value in the database
		do
			set_integers (get_mtprecisionscale_attribute (), a_val)
		end

	remove_mtprecisionscale ()
		-- remove MtPrecisionScale attribute value in the database
		do
			remove_value (get_mtprecisionscale_attribute ())
		end

	set_mtenumeration (a_val: ANY)
		-- update MtEnumeration attribute value in the database
		do
			set_value (get_mtenumeration_attribute (), a_val)
		end

	remove_mtenumeration ()
		-- remove MtEnumeration attribute value in the database
		do
			remove_value (get_mtenumeration_attribute ())
		end

	set_mtmaxsize (a_val: INTEGER_32)
		-- update MtMaxSize attribute value in the database
		do
			set_integer (get_mtmaxsize_attribute (), a_val)
		end

	remove_mtmaxsize ()
		-- remove MtMaxSize attribute value in the database
		do
			remove_value (get_mtmaxsize_attribute ())
		end

	set_mtmaxelements (a_val: ARRAY [INTEGER_32])
		-- update MtMaxElements attribute value in the database
		do
			set_integers (get_mtmaxelements_attribute (), a_val)
		end

	remove_mtmaxelements ()
		-- remove MtMaxElements attribute value in the database
		do
			remove_value (get_mtmaxelements_attribute ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTTYPE

