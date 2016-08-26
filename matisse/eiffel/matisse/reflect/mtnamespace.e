
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class 
	MTNAMESPACE

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
	, make_from_mtname
	, make_mtnamespace

--
-- You may add your own code here...
--

feature {NONE} -- Initialization


	make_from_mtname (a_db: MT_DATABASE; a_ns_name: STRING)
		-- Build a Namespace Descriptor from the database object
		require
			string_not_void: a_ns_name /= Void
			string_not_empty: not a_ns_name.is_empty
			db_not_void: a_db /= Void
		local
			c_ns_name: ANY
		do
			mtdb := a_db
			c_ns_name := a_ns_name.to_c
			oid := mtdb.context.get_namespace($c_ns_name)
		end

	make_mtnamespace (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("MTNAMESPACE"))
		end

	mtfullname, get_mtfullname (): STRING
		-- Gets the full name including namespace of the schema object.
		do
			Result := mtdb.context.get_schema_object_full_name (oid)
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
			Result := mtdb.get_mtattribute("MtName", mtdb.get_mtclass("MTNAMESPACE"))
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

	get_mtnamespaceof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceOf", mtdb.get_mtclass("MTNAMESPACE"))
		end

	mtnamespaceof, get_mtnamespaceof (): MTNAMESPACE
		-- get the MtNamespaceOf relationship successor from the database
		do
			Result ?= get_successor (get_mtnamespaceof_relationship ())
		end

	get_mtnamespaces_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaces from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaces", mtdb.get_mtclass("MTNAMESPACE"))
		end

	mtnamespaces, get_mtnamespaces (): ARRAY[MTNAMESPACE]
		-- get the MtNamespaces relationship successors from the database
		local
			v_res: ARRAY[MTNAMESPACE]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtnamespaces_relationship (), v_res)
			Result := v_res
		end

	mtnamespaces_size, get_mtnamespaces_size (): INTEGER_32
		-- get the MtNamespaces relationship size from the database
		do
			Result := get_successor_size (get_mtnamespaces_relationship ())
		end

	mtnamespaces_iterator (): MT_OBJECT_ITERATOR[MTNAMESPACE]
		-- Opens an iterator on the MtNamespaces relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtnamespaces_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtnamespaceclasses_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceClasses from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceClasses", mtdb.get_mtclass("MTNAMESPACE"))
		end

	mtnamespaceclasses, get_mtnamespaceclasses (): ARRAY[MTCLASS]
		-- get the MtNamespaceClasses relationship successors from the database
		local
			v_res: ARRAY[MTCLASS]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtnamespaceclasses_relationship (), v_res)
			Result := v_res
		end

	mtnamespaceclasses_size, get_mtnamespaceclasses_size (): INTEGER_32
		-- get the MtNamespaceClasses relationship size from the database
		do
			Result := get_successor_size (get_mtnamespaceclasses_relationship ())
		end

	mtnamespaceclasses_iterator (): MT_OBJECT_ITERATOR[MTCLASS]
		-- Opens an iterator on the MtNamespaceClasses relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtnamespaceclasses_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtnamespaceindexes_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceIndexes from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceIndexes", mtdb.get_mtclass("MTNAMESPACE"))
		end

	mtnamespaceindexes, get_mtnamespaceindexes (): ARRAY[MTINDEX]
		-- get the MtNamespaceIndexes relationship successors from the database
		local
			v_res: ARRAY[MTINDEX]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtnamespaceindexes_relationship (), v_res)
			Result := v_res
		end

	mtnamespaceindexes_size, get_mtnamespaceindexes_size (): INTEGER_32
		-- get the MtNamespaceIndexes relationship size from the database
		do
			Result := get_successor_size (get_mtnamespaceindexes_relationship ())
		end

	mtnamespaceindexes_iterator (): MT_OBJECT_ITERATOR[MTINDEX]
		-- Opens an iterator on the MtNamespaceIndexes relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtnamespaceindexes_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtnamespacedictionaries_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceDictionaries from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceDictionaries", mtdb.get_mtclass("MTNAMESPACE"))
		end

	mtnamespacedictionaries, get_mtnamespacedictionaries (): ARRAY[MTENTRYPOINTDICTIONARY]
		-- get the MtNamespaceDictionaries relationship successors from the database
		local
			v_res: ARRAY[MTENTRYPOINTDICTIONARY]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtnamespacedictionaries_relationship (), v_res)
			Result := v_res
		end

	mtnamespacedictionaries_size, get_mtnamespacedictionaries_size (): INTEGER_32
		-- get the MtNamespaceDictionaries relationship size from the database
		do
			Result := get_successor_size (get_mtnamespacedictionaries_relationship ())
		end

	mtnamespacedictionaries_iterator (): MT_OBJECT_ITERATOR[MTENTRYPOINTDICTIONARY]
		-- Opens an iterator on the MtNamespaceDictionaries relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtnamespacedictionaries_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtnamespaceattributes_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceAttributes from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceAttributes", mtdb.get_mtclass("MTNAMESPACE"))
		end

	mtnamespaceattributes, get_mtnamespaceattributes (): ARRAY[MTATTRIBUTE]
		-- get the MtNamespaceAttributes relationship successors from the database
		local
			v_res: ARRAY[MTATTRIBUTE]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtnamespaceattributes_relationship (), v_res)
			Result := v_res
		end

	mtnamespaceattributes_size, get_mtnamespaceattributes_size (): INTEGER_32
		-- get the MtNamespaceAttributes relationship size from the database
		do
			Result := get_successor_size (get_mtnamespaceattributes_relationship ())
		end

	mtnamespaceattributes_iterator (): MT_OBJECT_ITERATOR[MTATTRIBUTE]
		-- Opens an iterator on the MtNamespaceAttributes relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtnamespaceattributes_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtnamespacerelationships_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceRelationships from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceRelationships", mtdb.get_mtclass("MTNAMESPACE"))
		end

	mtnamespacerelationships, get_mtnamespacerelationships (): ARRAY[MTRELATIONSHIP]
		-- get the MtNamespaceRelationships relationship successors from the database
		local
			v_res: ARRAY[MTRELATIONSHIP]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtnamespacerelationships_relationship (), v_res)
			Result := v_res
		end

	mtnamespacerelationships_size, get_mtnamespacerelationships_size (): INTEGER_32
		-- get the MtNamespaceRelationships relationship size from the database
		do
			Result := get_successor_size (get_mtnamespacerelationships_relationship ())
		end

	mtnamespacerelationships_iterator (): MT_OBJECT_ITERATOR[MTRELATIONSHIP]
		-- Opens an iterator on the MtNamespaceRelationships relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtnamespacerelationships_relationship ().oid)
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

	set_mtnamespaceof (succ: MTNAMESPACE)
		-- Update MtNamespaceOf relationship successor
		do
			set_successor (get_mtnamespaceof_relationship (), succ)
		end

	clear_mtnamespaceof ()
		-- Remove MtNamespaceOf relationship successor
		do
			clear_successors (get_mtnamespaceof_relationship ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTNAMESPACE

