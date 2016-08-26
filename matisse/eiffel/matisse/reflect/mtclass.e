
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class
	MTCLASS

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
	, make_mtclass
	, make_mtclass_full

feature -- Meta-Schema Class names

	MT_CLASS_NAME: STRING =                  "MtClass"
	MT_OBJECT_NAME: STRING =                 "MtObject"
	MT_ATTRIBUTE_NAME: STRING =              "MtAttribute"
	MT_RELATIONSHIP_NAME: STRING =           "MtRelationship"
	MT_TYPE_NAME: STRING =                   "MtType"
	MT_INDEX_NAME: STRING =                  "MtIndex"
	MT_ENTRY_POINT_DICTIONARY_NAME: STRING = "MtEntryPointDictionary"
	MT_METHOD_NAME: STRING =                 "MtMethod"
	MT_META_CLASS_NAME: STRING =             "MtMetaClass"
	MT_NAMESPACE_NAME: STRING =              "MtNamespace"

    MT_NAMESPACE_SEPARATOR: STRING =         "."

feature {NONE} -- Initialization


	make_from_mtname (a_db: MT_DATABASE; a_class_name: STRING)
		-- Build a Class Descriptor from the database object
		require
			string_not_void: a_class_name /= Void
			string_not_empty: not a_class_name.is_empty
			db_not_void: a_db /= Void
		local
			c_class_name: ANY
		do
			mtdb := a_db
			c_class_name := a_class_name.to_c
			oid := mtdb.context.get_class_from_name($c_class_name)
		end


	make_mtclass (a_db: MT_DATABASE; a_class_name: STRING)
		-- Create a new class
		require
			string_not_void: a_class_name /= Void
			string_not_empty: not a_class_name.is_empty
			db_not_void: a_db /= Void
		do
			make_from_mtclass (a_db.get_mtclass ({MTCLASS}.MT_CLASS_NAME))
			Current.set_mtname(a_class_name)
		end

	make_mtclass_full (a_db: MT_DATABASE; a_class_name: STRING; atts: ARRAY[MTATTRIBUTE]; rels: ARRAY[MTRELATIONSHIP])
		-- Create a new class
		require
			string_not_void: a_class_name /= Void
			string_not_empty: not a_class_name.is_empty
			db_not_void: a_db /= Void
		do
			make_mtclass (a_db, a_class_name)
			-- set atts
			if atts /= Void then
				Current.set_mtattributes(atts)
			end
			-- set rels
			if rels /= Void then
				Current.set_mtrelationships(rels)
			end
		end

	mtfullname, get_mtfullname (): STRING
		-- Gets the full name including namespace of the schema object.
		do
			Result := mtdb.context.get_schema_object_full_name (oid)
		end

feature  -- Schema creation

	addcls_num_mtrelationships (rels: ARRAY[MTRELATIONSHIP])
		-- add new relationships to a class
		local
			i: INTEGER_32
		do
				from
					i := 1
				until
					i > rels.count
				loop
					addcls_mtrelationship(rels.item(i))
					i := i + 1
				end
		end

	addcls_mtrelationship (rel: MTRELATIONSHIP)
		-- add one relationship to a class
		local
			inv_relname: STRING
			auto_inv_rel: MTRELATIONSHIP
		do
			if rel.get_mtinverserelationship() = Void then
				-- Create Automatic inverse
				inv_relname := "Inverse_of_"+ rel.mtname() + "_from_" + mtname()
				create auto_inv_rel.make_mtrelationship(mtdb, inv_relname, Current, 0, -1)
				auto_inv_rel.set_mtautomatic(True)
				rel.set_mtinverserelationship(auto_inv_rel)
			end
			append_mtrelationships(rel)
		end

feature  -- Access

	instance_number (): INTEGER_32
		-- Gets the number of instances of this class and its subclasses.
		-- Does not load the object list.
		do
			Result := mtdb.context.get_instances_number ( oid)
		end

	own_instance_number (): INTEGER_32
		-- Gets the number of instances of this class only (and not its subclasses).
		-- Does not load the object list.
		do
			Result := mtdb.context.get_own_instances_number ( oid)
		end

	create_instance_iterator (iter: MT_OBJECT_ITERATOR[MTOBJECT]; num_preftech: INTEGER_32)
		-- Open an iterator on the instances of this class and all subclasses
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_instances_stream ( oid, num_preftech)
			iter.set_iterator(c_stream, mtdb)
		end

	instance_iterator, instances_iterator (num_preftech: INTEGER_32): MT_OBJECT_ITERATOR[MTOBJECT]
		-- Open an iterator on the instances of this class and all subclasses
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_instances_stream ( oid, num_preftech)
			create Result.make(c_stream, mtdb)
		end

	create_own_instance_iterator (iter: MT_OBJECT_ITERATOR[MTOBJECT]; num_preftech: INTEGER_32)
		-- Open an iterator on the instances of this class only (excluding all subclasses)
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_own_instances_stream ( oid, num_preftech)
			iter.set_iterator(c_stream, mtdb)
		end

	own_instance_iterator, own_instances_iterator (num_preftech: INTEGER_32): MT_OBJECT_ITERATOR[MTOBJECT]
		-- Open an iterator on the instances of this class only (excluding all subclasses)
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_own_instances_stream ( oid, num_preftech)
			create Result.make(c_stream, mtdb)
		end

	get_all_mtattributes: ARRAY [MTATTRIBUTE]
			-- Retrieves all attributes (own and inherited) of this class.
		local
			v_cnt: INTEGER_32
			v_oids: ARRAY[INTEGER_32]
			c_oids: ANY
			v_res: ARRAY[MTATTRIBUTE]
		do
			v_cnt := mtdb.context.get_attributes_count (oid)
			create v_res.make_filled (Void, 1, v_cnt)
			if v_cnt > 0 then
				create v_oids.make_filled (0, 1, v_cnt)
				c_oids := v_oids.to_c
				mtdb.context.get_all_attributes (oid, v_cnt, $c_oids)
				mtdb.upcasts( v_oids, v_res )
			end
			Result := v_res
		end

	get_all_mtrelationships : ARRAY [MTRELATIONSHIP]
			-- Retrieves all relationships (own and inherited) of this class.
		local
			v_cnt: INTEGER_32
			v_oids: ARRAY[INTEGER_32]
			c_oids: ANY
			v_res: ARRAY[MTRELATIONSHIP]
		do
			v_cnt := mtdb.context.get_relationships_count (oid)
			create v_res.make_filled (Void, 1, v_cnt)
			if v_cnt > 0 then
				create v_oids.make_filled (0, 1, v_cnt)
				c_oids := v_oids.to_c
				mtdb.context.get_all_relationships (oid, v_cnt, $c_oids)
				mtdb.upcasts( v_oids, v_res )
			end
			Result := v_res
		end


	get_all_mtinverserelationships : ARRAY [MTRELATIONSHIP]
     -- Retrieves all inverse relationships (own and inherited) of this class.
		local
			v_cnt: INTEGER_32
			v_oids: ARRAY[INTEGER_32]
			c_oids: ANY
			v_res: ARRAY[MTRELATIONSHIP]
		do
			v_cnt := mtdb.context.get_inverse_relationships_count (oid)
			create v_res.make_filled (Void, 1, v_cnt)
			if v_cnt > 0 then
				create v_oids.make_filled (0, 1, v_cnt)
				c_oids := v_oids.to_c
				mtdb.context.get_all_inverse_relationships (oid, v_cnt, $c_oids)
				mtdb.upcasts( v_oids, v_res )
			end
			Result := v_res
		end

	get_all_mtsuperclasses: ARRAY [MTCLASS]
     -- Retrieves all superclasses (direct and indirect) of this class.
		local
			v_cnt: INTEGER_32
			v_oids: ARRAY[INTEGER_32]
			c_oids: ANY
			v_res: ARRAY[MTCLASS]
		do
			v_cnt := mtdb.context.get_superclasses_count (oid)
			create v_res.make_filled (Void, 1, v_cnt)
			if v_cnt > 0 then
				create v_oids.make_filled (0, 1, v_cnt)
				c_oids := v_oids.to_c
				mtdb.context.get_all_superclasses (oid, v_cnt, $c_oids)
				mtdb.upcasts( v_oids, v_res )
			end
			Result := v_res
		end

	get_all_mtsubclasses: ARRAY [MTCLASS]
     -- Retrieves all subclasses (direct and indirect) of this class.
		local
			v_cnt: INTEGER_32
			v_oids: ARRAY[INTEGER_32]
			c_oids: ANY
			v_res: ARRAY[MTCLASS]
		do
			v_cnt := mtdb.context.get_subclasses_count (oid)
			create v_res.make_filled (Void, 1, v_cnt)
			if v_cnt > 0 then
				create v_oids.make_filled (0, 1, v_cnt)
				c_oids := v_oids.to_c
				mtdb.context.get_all_subclasses (oid, v_cnt, $c_oids)
				mtdb.upcasts( v_oids, v_res )
			end
			Result := v_res
		end

	get_all_mtmethods: ARRAY [MTMETHOD]
     -- Retrieves all methods (own and inherited) of this class.
		local
			v_cnt: INTEGER_32
			v_oids: ARRAY[INTEGER_32]
			c_oids: ANY
			v_res: ARRAY[MTMETHOD]
		do
			v_cnt := mtdb.context.get_methods_count (oid)
			create v_res.make_filled (Void, 1, v_cnt)
			if v_cnt > 0 then
				create v_oids.make_filled (0, 1, v_cnt)
				c_oids := v_oids.to_c
				mtdb.context.get_all_methods (oid, v_cnt, $c_oids)
				mtdb.upcasts( v_oids, v_res )
			end
			Result := v_res
		end

feature -- remove

	deep_remove ()
		-- Overrides {MTOBJECT}.deep_remove() to remove non-shared properties, indexes and
		-- methods.
		local
			i: INTEGER_32
			indexes: ARRAY[MTINDEX]
			attributes: ARRAY[MTATTRIBUTE]
			relationships: ARRAY[MTRELATIONSHIP]
		do
			-- Remove indexes
			indexes := get_mtindexes ()
			from
				i := 1
			until
				i > indexes.count
			loop
				indexes.item(i).deep_remove()
				i := i + 1
			end
			-- Remove Attributes
			attributes := get_mtattributes ()
			from
				i := 1
			until
				i > attributes.count
			loop
				attributes.item(i).deep_remove()
				i := i + 1
			end
			-- Remove relationships
			relationships := get_mtrelationships ()
			from
				i := 1
			until
				i > relationships.count
			loop
				relationships.item(i).deep_remove()
				i := i + 1
			end
			-- Remove Read-only relationships
			relationships := get_mtsuccessorof ()
			from
				i := 1
			until
				i > relationships.count
			loop
				relationships.item(i).deep_remove()
				i := i + 1
			end
			remove ()
		end

feature -- Delete

	remove_all_instances()
		-- Delete all the instances of the Class (including subclasses).
		local
			iter: MT_OBJECT_ITERATOR[MTOBJECT]
			obj : MTOBJECT
		do
			iter := Current.instance_iterator({MT_DATABASE}.Mt_Max_Prefetching)
			from
				iter.start
			until
				iter.exhausted
			loop
				obj := iter.item

				obj.deep_remove()

				iter.forth
			end
			iter.close
		end


	remove_all_own_instances()
		-- Delete all the instances of the Class only (excluding subclasses).
		local
			iter: MT_OBJECT_ITERATOR[MTOBJECT]
			obj : MTOBJECT
		do
			iter := Current.own_instance_iterator({MT_DATABASE}.Mt_Max_Prefetching)
			from
				iter.start
			until
				iter.exhausted
			loop
				obj := iter.item

				obj.deep_remove()

				iter.forth
			end
			iter.close
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
			Result := mtdb.get_mtattribute("MtName", mtdb.get_mtclass("MTCLASS"))
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

	get_mtattributes_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtAttributes from the database
		do
			Result := mtdb.get_mtrelationship ("MtAttributes", mtdb.get_mtclass("MTCLASS"))
		end

	mtattributes, get_mtattributes (): ARRAY[MTATTRIBUTE]
		-- get the MtAttributes relationship successors from the database
		local
			v_res: ARRAY[MTATTRIBUTE]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtattributes_relationship (), v_res)
			Result := v_res
		end

	mtattributes_size, get_mtattributes_size (): INTEGER_32
		-- get the MtAttributes relationship size from the database
		do
			Result := get_successor_size (get_mtattributes_relationship ())
		end

	mtattributes_iterator (): MT_OBJECT_ITERATOR[MTATTRIBUTE]
		-- Opens an iterator on the MtAttributes relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtattributes_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtrelationships_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtRelationships from the database
		do
			Result := mtdb.get_mtrelationship ("MtRelationships", mtdb.get_mtclass("MTCLASS"))
		end

	mtrelationships, get_mtrelationships (): ARRAY[MTRELATIONSHIP]
		-- get the MtRelationships relationship successors from the database
		local
			v_res: ARRAY[MTRELATIONSHIP]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtrelationships_relationship (), v_res)
			Result := v_res
		end

	mtrelationships_size, get_mtrelationships_size (): INTEGER_32
		-- get the MtRelationships relationship size from the database
		do
			Result := get_successor_size (get_mtrelationships_relationship ())
		end

	mtrelationships_iterator (): MT_OBJECT_ITERATOR[MTRELATIONSHIP]
		-- Opens an iterator on the MtRelationships relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtrelationships_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtsuperclasses_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtSuperclasses from the database
		do
			Result := mtdb.get_mtrelationship ("MtSuperclasses", mtdb.get_mtclass("MTCLASS"))
		end

	mtsuperclasses, get_mtsuperclasses (): ARRAY[MTCLASS]
		-- get the MtSuperclasses relationship successors from the database
		local
			v_res: ARRAY[MTCLASS]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtsuperclasses_relationship (), v_res)
			Result := v_res
		end

	mtsuperclasses_size, get_mtsuperclasses_size (): INTEGER_32
		-- get the MtSuperclasses relationship size from the database
		do
			Result := get_successor_size (get_mtsuperclasses_relationship ())
		end

	mtsuperclasses_iterator (): MT_OBJECT_ITERATOR[MTCLASS]
		-- Opens an iterator on the MtSuperclasses relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtsuperclasses_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtnamespaceclassof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceClassOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceClassOf", mtdb.get_mtclass("MTCLASS"))
		end

	mtnamespaceclassof, get_mtnamespaceclassof (): MTNAMESPACE
		-- get the MtNamespaceClassOf relationship successor from the database
		do
			Result ?= get_successor (get_mtnamespaceclassof_relationship ())
		end

	get_mtsuccessorof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtSuccessorOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtSuccessorOf", mtdb.get_mtclass("MTCLASS"))
		end

	mtsuccessorof, get_mtsuccessorof (): ARRAY[MTRELATIONSHIP]
		-- get the MtSuccessorOf relationship successors from the database
		local
			v_res: ARRAY[MTRELATIONSHIP]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtsuccessorof_relationship (), v_res)
			Result := v_res
		end

	mtsuccessorof_size, get_mtsuccessorof_size (): INTEGER_32
		-- get the MtSuccessorOf relationship size from the database
		do
			Result := get_successor_size (get_mtsuccessorof_relationship ())
		end

	mtsuccessorof_iterator (): MT_OBJECT_ITERATOR[MTRELATIONSHIP]
		-- Opens an iterator on the MtSuccessorOf relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtsuccessorof_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtsubclasses_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtSubclasses from the database
		do
			Result := mtdb.get_mtrelationship ("MtSubclasses", mtdb.get_mtclass("MTCLASS"))
		end

	mtsubclasses, get_mtsubclasses (): ARRAY[MTCLASS]
		-- get the MtSubclasses relationship successors from the database
		local
			v_res: ARRAY[MTCLASS]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtsubclasses_relationship (), v_res)
			Result := v_res
		end

	mtsubclasses_size, get_mtsubclasses_size (): INTEGER_32
		-- get the MtSubclasses relationship size from the database
		do
			Result := get_successor_size (get_mtsubclasses_relationship ())
		end

	mtsubclasses_iterator (): MT_OBJECT_ITERATOR[MTCLASS]
		-- Opens an iterator on the MtSubclasses relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtsubclasses_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtmethods_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtMethods from the database
		do
			Result := mtdb.get_mtrelationship ("MtMethods", mtdb.get_mtclass("MTCLASS"))
		end

	mtmethods, get_mtmethods (): ARRAY[MTMETHOD]
		-- get the MtMethods relationship successors from the database
		local
			v_res: ARRAY[MTMETHOD]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtmethods_relationship (), v_res)
			Result := v_res
		end

	mtmethods_size, get_mtmethods_size (): INTEGER_32
		-- get the MtMethods relationship size from the database
		do
			Result := get_successor_size (get_mtmethods_relationship ())
		end

	mtmethods_iterator (): MT_OBJECT_ITERATOR[MTMETHOD]
		-- Opens an iterator on the MtMethods relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtmethods_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtindexes_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtIndexes from the database
		do
			Result := mtdb.get_mtrelationship ("MtIndexes", mtdb.get_mtclass("MTCLASS"))
		end

	mtindexes, get_mtindexes (): ARRAY[MTINDEX]
		-- get the MtIndexes relationship successors from the database
		local
			v_res: ARRAY[MTINDEX]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtindexes_relationship (), v_res)
			Result := v_res
		end

	mtindexes_size, get_mtindexes_size (): INTEGER_32
		-- get the MtIndexes relationship size from the database
		do
			Result := get_successor_size (get_mtindexes_relationship ())
		end

	mtindexes_iterator (): MT_OBJECT_ITERATOR[MTINDEX]
		-- Opens an iterator on the MtIndexes relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtindexes_relationship ().oid)
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

	set_mtattributes (succs: ARRAY[MTATTRIBUTE])
		-- Update MtAttributes relationship successors
		do
			set_successors (get_mtattributes_relationship (), succs)
		end

	prepend_mtattributes (succ: MTATTRIBUTE)
		-- Update MtAttributes relationship successors
		do
			prepend_successor (get_mtattributes_relationship (), succ)
		end

	append_mtattributes (succ: MTATTRIBUTE)
		-- Update MtAttributes relationship successors
		do
			append_successor (get_mtattributes_relationship (), succ)
		end

	append_after_mtattributes (succ, after: MTATTRIBUTE)
		-- Update MtAttributes relationship successors
		do
			add_successor_after (get_mtattributes_relationship (), succ, after)
		end

	append_num_mtattributes (succs: ARRAY[MTATTRIBUTE])
		-- Adds multiple objects to the end of the existing MtAttributes successors list
		do
			add_successors (get_mtattributes_relationship (), succs)
		end

	remove_mtattributes (succ: MTATTRIBUTE)
		-- Remove one successor from the MtAttributes relationship
		do
			remove_successor (get_mtattributes_relationship (), succ)
		end

	remove_num_mtattributes (succs: ARRAY[MTATTRIBUTE])
		-- Remove multiple successors from the MtAttributes relationship
		do
			remove_successors (get_mtattributes_relationship (), succs)
		end

	clear_mtattributes ()
		-- Remove all MtAttributes relationship successors
		do
			clear_successors (get_mtattributes_relationship ())
		end

	set_mtrelationships (succs: ARRAY[MTRELATIONSHIP])
		-- Update MtRelationships relationship successors
		do
			set_successors (get_mtrelationships_relationship (), succs)
		end

	prepend_mtrelationships (succ: MTRELATIONSHIP)
		-- Update MtRelationships relationship successors
		do
			prepend_successor (get_mtrelationships_relationship (), succ)
		end

	append_mtrelationships (succ: MTRELATIONSHIP)
		-- Update MtRelationships relationship successors
		do
			append_successor (get_mtrelationships_relationship (), succ)
		end

	append_after_mtrelationships (succ, after: MTRELATIONSHIP)
		-- Update MtRelationships relationship successors
		do
			add_successor_after (get_mtrelationships_relationship (), succ, after)
		end

	append_num_mtrelationships (succs: ARRAY[MTRELATIONSHIP])
		-- Adds multiple objects to the end of the existing MtRelationships successors list
		do
			add_successors (get_mtrelationships_relationship (), succs)
		end

	remove_mtrelationships (succ: MTRELATIONSHIP)
		-- Remove one successor from the MtRelationships relationship
		do
			remove_successor (get_mtrelationships_relationship (), succ)
		end

	remove_num_mtrelationships (succs: ARRAY[MTRELATIONSHIP])
		-- Remove multiple successors from the MtRelationships relationship
		do
			remove_successors (get_mtrelationships_relationship (), succs)
		end

	clear_mtrelationships ()
		-- Remove all MtRelationships relationship successors
		do
			clear_successors (get_mtrelationships_relationship ())
		end

	set_mtsuperclasses (succs: ARRAY[MTCLASS])
		-- Update MtSuperclasses relationship successors
		do
			set_successors (get_mtsuperclasses_relationship (), succs)
		end

	prepend_mtsuperclasses (succ: MTCLASS)
		-- Update MtSuperclasses relationship successors
		do
			prepend_successor (get_mtsuperclasses_relationship (), succ)
		end

	append_mtsuperclasses (succ: MTCLASS)
		-- Update MtSuperclasses relationship successors
		do
			append_successor (get_mtsuperclasses_relationship (), succ)
		end

	append_after_mtsuperclasses (succ, after: MTCLASS)
		-- Update MtSuperclasses relationship successors
		do
			add_successor_after (get_mtsuperclasses_relationship (), succ, after)
		end

	append_num_mtsuperclasses (succs: ARRAY[MTCLASS])
		-- Adds multiple objects to the end of the existing MtSuperclasses successors list
		do
			add_successors (get_mtsuperclasses_relationship (), succs)
		end

	remove_mtsuperclasses (succ: MTCLASS)
		-- Remove one successor from the MtSuperclasses relationship
		do
			remove_successor (get_mtsuperclasses_relationship (), succ)
		end

	remove_num_mtsuperclasses (succs: ARRAY[MTCLASS])
		-- Remove multiple successors from the MtSuperclasses relationship
		do
			remove_successors (get_mtsuperclasses_relationship (), succs)
		end

	clear_mtsuperclasses ()
		-- Remove all MtSuperclasses relationship successors
		do
			clear_successors (get_mtsuperclasses_relationship ())
		end

	set_mtnamespaceclassof (succ: MTNAMESPACE)
		-- Update MtNamespaceClassOf relationship successor
		do
			set_successor (get_mtnamespaceclassof_relationship (), succ)
		end

	clear_mtnamespaceclassof ()
		-- Remove MtNamespaceClassOf relationship successor
		do
			clear_successors (get_mtnamespaceclassof_relationship ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTCLASS

