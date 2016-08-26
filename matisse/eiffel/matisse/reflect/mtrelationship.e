
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class
	MTRELATIONSHIP

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
	, make_mtrelationship
feature -- Meta-Schema Relationship names

  MT_SUPERCLASSES_NAME: STRING =                   "MtSuperclasses"
  MT_SUBCLASSES_NAME: STRING =                     "MtSubclasses"
  MT_ATTRIBUTES_NAME: STRING =                     "MtAttributes"
  MT_ATTRIBUTE_OF_NAME : STRING =                  "MtAttributeOf"
  MT_RELATIONSHIPS_NAME: STRING =                  "MtRelationships"
  MT_RELATIONSHIP_OF_NAME: STRING =                "MtRelationshipOf"
  MT_ATTRIBUTE_TYPE_NAME: STRING =                 "MtAttributeType"
  MT_ATTRIBUTE_TYPE_OF_NAME: STRING =              "MtAttributeTypeOf"
  MT_INVERSE_RELATIONSHIP_NAME: STRING =           "MtInverseRelationship"
  MT_SUCCESSORS_NAME: STRING =                     "MtSuccessors"
  MT_SUCCESSOR_OF_NAME: STRING =                   "MtSuccessorOf"
  MT_CLASSES_NAME: STRING =                        "MtClasses"
  MT_INDEXES_NAME: STRING =                        "MtIndexes"
  MT_CRITERIA_NAME : STRING =                      "MtCriteria"
  MT_CRITERION_OF_NAME: STRING =                   "MtCriterionOf"
  MT_ENTRY_POINT_NAME : STRING =                   "MtEntryPoint"
  MT_ENTRY_POINT_OF_NAME: STRING =                 "MtEntryPointOf"
  MT_METHODS_NAME : STRING =                       "MtMethods"
  MT_METHOD_OF_NAME: STRING =                      "MtMethodOf"
  MT_NAMESPACES_NAME: STRING =                     "MtNamespaces"
  MT_NAMESPACE_OF_NAME: STRING =                   "MtNamespaceOf"
  MT_NAMESPACE_CLASSES_NAME: STRING =              "MtNamespaceClasses"
  MT_NAMESPACE_CLASS_OF_NAME: STRING =             "MtNamespaceClassOf"
  MT_NAMESPACE_INDEXES_NAME: STRING =              "MtNamespaceIndexes"
  MT_NAMESPACE_INDEX_OF_NAME: STRING =             "MtNamespaceIndexOf"
  MT_NAMESPACE_DICTIONARIES_NAME: STRING =         "MtNamespaceDictionaries"
  MT_NAMESPACE_DICTIONARY_OF_NAME: STRING =        "MtNamespaceDictionaryOf"
  MT_NAMESPACE_ATTRIBUTES_NAME: STRING =           "MtNamespaceAttributes"
  MT_NAMESPACE_ATTRIBUTE_OF_NAME: STRING =         "MtNamespaceAttributeOf"
  MT_NAMESPACE_RELATIONSHIPS_NAME: STRING =        "MtNamespaceRelationships"
  MT_NAMESPACE_RELATIONSHIP_OF_NAME: STRING =      "MtNamespaceRelationshipOf"

feature {NONE} -- Initialization

	make_from_mtname (a_db: MT_DATABASE; relationship_name: STRING; a_cls: MTCLASS)
		-- Build an Attribute Descriptor from the database object
		require
			rel_not_void: relationship_name /= Void
			rel_not_empty: not relationship_name.is_empty
			cl_not_void: a_cls /= Void
			db_not_void: a_db /= Void
		local
			relationship_name_to_c: ANY
		do
			mtdb := a_db
			relationship_name_to_c := relationship_name.to_c
			oid := mtdb.context.get_class_relationship ( $relationship_name_to_c, a_cls.oid)
		end

	make_mtrelationship (a_db: MT_DATABASE; relationship_name: STRING; succ_cls: MTCLASS; min_card, max_card: INTEGER_32)
		-- Create a new relationship into the database
		require
			rel_not_void: relationship_name /= Void
			rel_not_empty: not relationship_name.is_empty
			db_not_void: a_db /= Void
			succ_cls_not_void: succ_cls /= Void
		local
			vcard: ARRAY [INTEGER_32]
		do
			make_from_mtclass (a_db.get_mtclass ({MTCLASS}.MT_RELATIONSHIP_NAME))
			Current.set_mtname(relationship_name)
			Current.append_mtsuccessors (succ_cls)
			create vcard.make_filled (0, 1,2)
			vcard.force(min_card, 1)
			vcard.force(max_card, 2)
			Current.set_mtcardinality (vcard)
		end


	mtfullname, get_mtfullname (): STRING
		-- Gets the full name including namespace of the schema object.
		do
			Result := mtdb.context.get_schema_object_full_name (oid)
		end

feature -- remove

	deep_remove ()
		-- Overrides MtObject.deepRemove() to remove this and it's inverse relationship.
		do
			Current.remove_both ()
		end

	remove_both ()
		-- Removes this relationship and its inverse relationship.
		local
			inv: MTRELATIONSHIP
		do
			-- Remove inverse unless its itself
			inv := Current.get_mtinverserelationship ()
			if not Current.is_equal(inv) then
				inv.remove ()
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
			Result := mtdb.get_mtattribute("MtName", mtdb.get_mtclass("MTRELATIONSHIP"))
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

	get_mtcardinality_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtCardinality from the database
		do
			Result := mtdb.get_mtattribute("MtCardinality", mtdb.get_mtclass("MTRELATIONSHIP"))
		end

	mtcardinality, get_mtcardinality (): ARRAY [INTEGER_32]
		-- get the value of MtCardinality from the database
		do
			Result := get_integers (get_mtcardinality_attribute ())
		end

	is_mtcardinality_default_value (): BOOLEAN
		-- Check if MtCardinality attribute value is set to its default value
		do
			Result := is_default_value (get_mtcardinality_attribute ())
		end

	get_mtpreserveorder_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtPreserveOrder from the database
		do
			Result := mtdb.get_mtattribute("MtPreserveOrder", mtdb.get_mtclass("MTRELATIONSHIP"))
		end

	mtpreserveorder, get_mtpreserveorder (): BOOLEAN
		-- get the value of MtPreserveOrder from the database
		do
			Result := get_boolean (get_mtpreserveorder_attribute ())
		end

	is_mtpreserveorder_default_value (): BOOLEAN
		-- Check if MtPreserveOrder attribute value is set to its default value
		do
			Result := is_default_value (get_mtpreserveorder_attribute ())
		end

	get_mtsharable_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtSharable from the database
		do
			Result := mtdb.get_mtattribute("MtSharable", mtdb.get_mtclass("MTRELATIONSHIP"))
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

	get_mtautomatic_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtAutomatic from the database
		do
			Result := mtdb.get_mtattribute("MtAutomatic", mtdb.get_mtclass("MTRELATIONSHIP"))
		end

	mtautomatic, get_mtautomatic (): BOOLEAN
		-- get the value of MtAutomatic from the database
		do
			Result := get_boolean (get_mtautomatic_attribute ())
		end

	is_mtautomatic_default_value (): BOOLEAN
		-- Check if MtAutomatic attribute value is set to its default value
		do
			Result := is_default_value (get_mtautomatic_attribute ())
		end

	get_mtsuccessors_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtSuccessors from the database
		do
			Result := mtdb.get_mtrelationship ("MtSuccessors", mtdb.get_mtclass("MTRELATIONSHIP"))
		end

	mtsuccessors, get_mtsuccessors (): ARRAY[MTCLASS]
		-- get the MtSuccessors relationship successors from the database
		local
			v_res: ARRAY[MTCLASS]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtsuccessors_relationship (), v_res)
			Result := v_res
		end

	mtsuccessors_size, get_mtsuccessors_size (): INTEGER_32
		-- get the MtSuccessors relationship size from the database
		do
			Result := get_successor_size (get_mtsuccessors_relationship ())
		end

	mtsuccessors_iterator (): MT_OBJECT_ITERATOR[MTCLASS]
		-- Opens an iterator on the MtSuccessors relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtsuccessors_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtinverserelationship_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtInverseRelationship from the database
		do
			Result := mtdb.get_mtrelationship ("MtInverseRelationship", mtdb.get_mtclass("MTRELATIONSHIP"))
		end

	mtinverserelationship, get_mtinverserelationship (): MTRELATIONSHIP
		-- get the MtInverseRelationship relationship successor from the database
		do
			Result ?= get_successor (get_mtinverserelationship_relationship ())
		end

	get_mtnamespacerelationshipof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceRelationshipOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceRelationshipOf", mtdb.get_mtclass("MTRELATIONSHIP"))
		end

	mtnamespacerelationshipof, get_mtnamespacerelationshipof (): MTNAMESPACE
		-- get the MtNamespaceRelationshipOf relationship successor from the database
		do
			Result ?= get_successor (get_mtnamespacerelationshipof_relationship ())
		end

	get_mtrelationshipof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtRelationshipOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtRelationshipOf", mtdb.get_mtclass("MTRELATIONSHIP"))
		end

	mtrelationshipof, get_mtrelationshipof (): ARRAY[MTCLASS]
		-- get the MtRelationshipOf relationship successors from the database
		local
			v_res: ARRAY[MTCLASS]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtrelationshipof_relationship (), v_res)
			Result := v_res
		end

	mtrelationshipof_size, get_mtrelationshipof_size (): INTEGER_32
		-- get the MtRelationshipOf relationship size from the database
		do
			Result := get_successor_size (get_mtrelationshipof_relationship ())
		end

	mtrelationshipof_iterator (): MT_OBJECT_ITERATOR[MTCLASS]
		-- Opens an iterator on the MtRelationshipOf relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtrelationshipof_relationship ().oid)
			create Result.make(c_stream, mtdb)
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

	set_mtcardinality (a_val: ARRAY [INTEGER_32])
		-- update MtCardinality attribute value in the database
		do
			set_integers (get_mtcardinality_attribute (), a_val)
		end

	remove_mtcardinality ()
		-- remove MtCardinality attribute value in the database
		do
			remove_value (get_mtcardinality_attribute ())
		end

	set_mtpreserveorder (a_val: BOOLEAN)
		-- update MtPreserveOrder attribute value in the database
		do
			set_boolean (get_mtpreserveorder_attribute (), a_val)
		end

	remove_mtpreserveorder ()
		-- remove MtPreserveOrder attribute value in the database
		do
			remove_value (get_mtpreserveorder_attribute ())
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

	set_mtautomatic (a_val: BOOLEAN)
		-- update MtAutomatic attribute value in the database
		do
			set_boolean (get_mtautomatic_attribute (), a_val)
		end

	remove_mtautomatic ()
		-- remove MtAutomatic attribute value in the database
		do
			remove_value (get_mtautomatic_attribute ())
		end

	set_mtsuccessors (succs: ARRAY[MTCLASS])
		-- Update MtSuccessors relationship successors
		do
			set_successors (get_mtsuccessors_relationship (), succs)
		end

	prepend_mtsuccessors (succ: MTCLASS)
		-- Update MtSuccessors relationship successors
		do
			prepend_successor (get_mtsuccessors_relationship (), succ)
		end

	append_mtsuccessors (succ: MTCLASS)
		-- Update MtSuccessors relationship successors
		do
			append_successor (get_mtsuccessors_relationship (), succ)
		end

	append_after_mtsuccessors (succ, after: MTCLASS)
		-- Update MtSuccessors relationship successors
		do
			add_successor_after (get_mtsuccessors_relationship (), succ, after)
		end

	append_num_mtsuccessors (succs: ARRAY[MTCLASS])
		-- Adds multiple objects to the end of the existing MtSuccessors successors list
		do
			add_successors (get_mtsuccessors_relationship (), succs)
		end

	remove_mtsuccessors (succ: MTCLASS)
		-- Remove one successor from the MtSuccessors relationship
		do
			remove_successor (get_mtsuccessors_relationship (), succ)
		end

	remove_num_mtsuccessors (succs: ARRAY[MTCLASS])
		-- Remove multiple successors from the MtSuccessors relationship
		do
			remove_successors (get_mtsuccessors_relationship (), succs)
		end

	clear_mtsuccessors ()
		-- Remove all MtSuccessors relationship successors
		do
			clear_successors (get_mtsuccessors_relationship ())
		end

	set_mtinverserelationship (succ: MTRELATIONSHIP)
		-- Update MtInverseRelationship relationship successor
		do
			set_successor (get_mtinverserelationship_relationship (), succ)
		end

	clear_mtinverserelationship ()
		-- Remove MtInverseRelationship relationship successor
		do
			clear_successors (get_mtinverserelationship_relationship ())
		end

	set_mtnamespacerelationshipof (succ: MTNAMESPACE)
		-- Update MtNamespaceRelationshipOf relationship successor
		do
			set_successor (get_mtnamespacerelationshipof_relationship (), succ)
		end

	clear_mtnamespacerelationshipof ()
		-- Remove MtNamespaceRelationshipOf relationship successor
		do
			clear_successors (get_mtnamespacerelationshipof_relationship ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTRELATIONSHIP

