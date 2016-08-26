
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class 
	MTATTRIBUTE

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MTOBJECT
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance
	redefine
		deep_remove
	end

-- BEGIN generation of create by Matisse SDL
create
	make_from_mtoid
	, make_from_mtclass
-- END of Matisse SDL generation of create
	, make_from_mtname
	, make_mtattribute

feature -- Meta-Schema Attribute names

  MT_NAME_NAME : STRING =                          "MtName"
  MT_DEFAULT_VALUE_NAME: STRING =                  "MtDefaultValue"
  MT_NULLABLE_NAME: STRING =                       "MtNullable"
  MT_PRECISION_SCALE_NAME: STRING =                "MtPrecisionScale"
  MT_ENUMERATION_NAME : STRING =                   "MtEnumeration"
  MT_MAX_SIZE_NAME  : STRING =                     "MtMaxSize"
  MT_MAX_ELEMENTS_NAME : STRING =                  "MtMaxElements"
  MT_CARDINALITY_NAME : STRING =                   "MtCardinality"
  MT_PRESERVE_ORDER_NAME: STRING =                 "MtPreserveOrder"
  MT_BASIC_TYPE_NAME : STRING =                    "MtBasicType"
  MT_CHARACTER_ENCODING_NAME: STRING =             "MtCharacterEncoding"
  MT_CRITERIA_ORDER_NAME: STRING =                 "MtCriteriaOrder"
  MT_UNIQUE_KEY_NAME: STRING =                     "MtUniqueKey"
  MT_CASE_SENSITIVE_NAME: STRING =                 "MtCaseSensitive"
  MT_MAKE_ENTRY_FUNCTION_NAME: STRING =            "MtMakeEntryFunction"
  MT_SOURCE_NAME : STRING =                        "MtSource"
  MT_SIGNATURE_NAME: STRING =                      "MtSignature"
  MT_STATIC_NAME: STRING =                         "MtStatic"
  MT_AUTOMATIC_NAME: STRING =                      "MtAutomatic"
  MT_SHARABLE_NAME: STRING =                       "MtSharable"

feature {NONE} -- Initialization

	make_from_mtname (a_db: MT_DATABASE; attribute_name: STRING; a_cls: MTCLASS)
		-- Build an Attribute Descriptor from the database object
		require
			db_not_void: a_db /= Void
			attribute_not_void: attribute_name /= Void
			attribute_not_empty: not attribute_name.is_empty
			cl_not_void: a_cls /= Void
		local
			c_attribute_name: ANY
		do
			mtdb := a_db
			c_attribute_name := attribute_name.to_c
			oid := mtdb.context.get_class_attribute ( $c_attribute_name, a_cls.oid)
		end

	make_mtattribute (a_db: MT_DATABASE; attribute_name: STRING; att_type: INTEGER_32)
		-- Create an attribute object into the database.
		require
			db_not_void: a_db /= Void
			attribute_not_void: attribute_name /= Void
			attribute_not_empty: not attribute_name.is_empty
			valid_type: {MTTYPE}.Mt_Min_Type < att_type and att_type < {MTTYPE}.Mt_Max_Type

		local
			v_type: MTTYPE
		do
			make_from_mtclass (a_db.get_mtclass ({MTCLASS}.MT_ATTRIBUTE_NAME))
			Current.set_mtname(attribute_name)
			create v_type.make_from_mtclass (a_db.get_mtclass ({MTCLASS}.MT_TYPE_NAME))
			v_type.set_mtbasictype (att_type)
			Current.set_mtattributetype (v_type)
		end

	mtfullname, get_mtfullname (): STRING
		-- Gets the full name including namespace of the schema object.
		do
			Result := mtdb.context.get_schema_object_full_name (oid)
		end

feature -- Property Access

	get_mttype() : INTEGER_32
		local
			typ: MTTYPE
		do
			typ := CuRrent.mtattributetype
			if typ /= Void then
				Result := typ.mtbasictype
			else
				Result := {MTTYPE}.Mt_Null
			end
		end


feature -- remove

	deep_remove ()
		-- Overrides MtObject.deepRemove() to remove EntrypointDictionaries and type 
		-- object.
		local
			typ: MTTYPE
			epdict: MTENTRYPOINTDICTIONARY
		do
			-- Remove entry-point
			epdict := Current.get_mtentrypoint ()
			if epdict /= Void then
				epdict.deep_remove ()
			end
			-- Remove type
			typ := Current.get_mtattributetype ()
			if typ /= Void then
				typ.deep_remove ()
			end

			Current.remove ()
		end


-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 9.0.0
-- Date: Fri Dec  2 11:53:12 2011

feature -- Entry Point Dictionary Access

	mtnamedictionary_name: STRING = "MtNameDictionary"

feature -- Property Access

	get_mtname_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtName from the database
		do
			Result := mtdb.get_mtattribute("MtName", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtname, get_mtname (): STRING
		-- get the value of MtName from the database
		do
			Result := get_string (get_mtname_attribute ())
		end

	is_mtname_default_value (): BOOLEAN
		-- Check if MtName attribute value is set to its default value
		do
			Result := is_default_value (get_mtname_attribute ())
		end

	get_mtdefaultvalue_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtDefaultValue from the database
		do
			Result := mtdb.get_mtattribute("MtDefaultValue", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtdefaultvalue, get_mtdefaultvalue (): ANY
		-- get the value of MtDefaultValue from the database
		do
			Result := get_value (get_mtdefaultvalue_attribute ())
		end

	is_mtdefaultvalue_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_mtdefaultvalue_attribute ())
		end

	is_mtdefaultvalue_default_value (): BOOLEAN
		-- Check if MtDefaultValue attribute value is set to its default value
		do
			Result := is_default_value (get_mtdefaultvalue_attribute ())
		end

	get_mtnullable_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtNullable from the database
		do
			Result := mtdb.get_mtattribute("MtNullable", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtnullable, get_mtnullable (): BOOLEAN
		-- get the value of MtNullable from the database
		do
			Result := get_boolean (get_mtnullable_attribute ())
		end

	is_mtnullable_default_value (): BOOLEAN
		-- Check if MtNullable attribute value is set to its default value
		do
			Result := is_default_value (get_mtnullable_attribute ())
		end

	get_mtsharable_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtSharable from the database
		do
			Result := mtdb.get_mtattribute("MtSharable", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtsharable, get_mtsharable (): BOOLEAN
		-- get the value of MtSharable from the database
		do
			Result := get_boolean (get_mtsharable_attribute ())
		end

	is_mtsharable_default_value (): BOOLEAN
		-- Check if MtSharable attribute value is set to its default value
		do
			Result := is_default_value (get_mtsharable_attribute ())
		end

	get_mtattributetype_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtAttributeType from the database
		do
			Result := mtdb.get_mtrelationship ("MtAttributeType", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtattributetype, get_mtattributetype (): MTTYPE
		-- get the MtAttributeType relationship successor from the database
		do
			Result ?= get_successor (get_mtattributetype_relationship ())
		end

	get_mtnamespaceattributeof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceAttributeOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceAttributeOf", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtnamespaceattributeof, get_mtnamespaceattributeof (): MTNAMESPACE
		-- get the MtNamespaceAttributeOf relationship successor from the database
		do
			Result ?= get_successor (get_mtnamespaceattributeof_relationship ())
		end

	get_mtattributeof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtAttributeOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtAttributeOf", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtattributeof, get_mtattributeof (): ARRAY[MTCLASS]
		-- get the MtAttributeOf relationship successors from the database
		local
			v_res: ARRAY[MTCLASS]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtattributeof_relationship (), v_res)
			Result := v_res
		end

	mtattributeof_size, get_mtattributeof_size (): INTEGER_32
		-- get the MtAttributeOf relationship size from the database
		do
			Result := get_successor_size (get_mtattributeof_relationship ())
		end

	mtattributeof_iterator (): MT_OBJECT_ITERATOR[MTCLASS]
		-- Opens an iterator on the MtAttributeOf relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtattributeof_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtcriterionof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtCriterionOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtCriterionOf", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtcriterionof, get_mtcriterionof (): ARRAY[MTINDEX]
		-- get the MtCriterionOf relationship successors from the database
		local
			v_res: ARRAY[MTINDEX]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtcriterionof_relationship (), v_res)
			Result := v_res
		end

	mtcriterionof_size, get_mtcriterionof_size (): INTEGER_32
		-- get the MtCriterionOf relationship size from the database
		do
			Result := get_successor_size (get_mtcriterionof_relationship ())
		end

	mtcriterionof_iterator (): MT_OBJECT_ITERATOR[MTINDEX]
		-- Opens an iterator on the MtCriterionOf relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtcriterionof_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtentrypoint_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtEntryPoint from the database
		do
			Result := mtdb.get_mtrelationship ("MtEntryPoint", mtdb.get_mtclass("MTATTRIBUTE"))
		end

	mtentrypoint, get_mtentrypoint (): MTENTRYPOINTDICTIONARY
		-- get the MtEntryPoint relationship successor from the database
		do
			Result ?= get_successor (get_mtentrypoint_relationship ())
		end


feature -- Update Attributes

	set_mtname (a_val: STRING)
		-- update MtName attribute value in the database
		do
			set_string (get_mtname_attribute (), a_val)
		end

	remove_mtname ()
		-- remove MtName attribute value in the database
		do
			remove_value (get_mtname_attribute ())
		end

	set_mtdefaultvalue (a_val: ANY)
		-- update MtDefaultValue attribute value in the database
		do
			set_value (get_mtdefaultvalue_attribute (), a_val)
		end

	remove_mtdefaultvalue ()
		-- remove MtDefaultValue attribute value in the database
		do
			remove_value (get_mtdefaultvalue_attribute ())
		end

	set_mtnullable (a_val: BOOLEAN)
		-- update MtNullable attribute value in the database
		do
			set_boolean (get_mtnullable_attribute (), a_val)
		end

	remove_mtnullable ()
		-- remove MtNullable attribute value in the database
		do
			remove_value (get_mtnullable_attribute ())
		end

	set_mtsharable (a_val: BOOLEAN)
		-- update MtSharable attribute value in the database
		do
			set_boolean (get_mtsharable_attribute (), a_val)
		end

	remove_mtsharable ()
		-- remove MtSharable attribute value in the database
		do
			remove_value (get_mtsharable_attribute ())
		end

	set_mtattributetype (succ: MTTYPE)
		-- Update MtAttributeType relationship successor
		do
			set_successor (get_mtattributetype_relationship (), succ)
		end

	clear_mtattributetype ()
		-- Remove MtAttributeType relationship successor
		do
			clear_successors (get_mtattributetype_relationship ())
		end

	set_mtnamespaceattributeof (succ: MTNAMESPACE)
		-- Update MtNamespaceAttributeOf relationship successor
		do
			set_successor (get_mtnamespaceattributeof_relationship (), succ)
		end

	clear_mtnamespaceattributeof ()
		-- Remove MtNamespaceAttributeOf relationship successor
		do
			clear_successors (get_mtnamespaceattributeof_relationship ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTATTRIBUTE

