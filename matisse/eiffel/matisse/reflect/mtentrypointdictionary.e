
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class 
	MTENTRYPOINTDICTIONARY

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
	, make_mtentrypointdictionary

feature -- Meta-Schema Entry Point Dictionary names

  MT_NAME_DICTIONARY_NAME: STRING = "MtNameDictionary"

feature {MT_DATABASE}

	make_from_mtname (a_db: MT_DATABASE; a_dict_name: STRING)
		require
			dict_name_not_void: a_dict_name /= Void
			dict_name_not_empty: not a_dict_name.is_empty
			db_not_void: a_db /= Void
		local
			c_dict_name: ANY
		do
			mtdb := a_db
			c_dict_name := a_dict_name.to_c
			oid := mtdb.context.get_entry_point_dictionary ( $c_dict_name)
		end

	make_mtentrypointdictionary (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("MtEntryPointDictionary"))
		end


	mtfullname, get_mtfullname (): STRING
		-- Gets the full name including namespace of the schema object.
		do
			Result := mtdb.context.get_schema_object_full_name (oid)
		end

feature -- Retrieval

	create_iterator (iter: MT_OBJECT_ITERATOR[MTOBJECT]; ep_string: STRING; filter_cls: MTCLASS; num_preftech: INTEGER_32)
		-- Open an object iterator on all matches of an entry-point search.
		require
			ep_string_not_void: ep_string /= Void
			ep_string_not_empty: not ep_string.is_empty
		local
			c_stream : INTEGER_32
			c_ep_string: ANY
         cid: INTEGER_32
		do
			c_ep_string := ep_string.to_c
         cid := 0
			if Void /= filter_cls then
				cid := filter_cls.oid
			end
			c_stream := mtdb.context.open_entry_point_stream ($c_ep_string, oid, cid, num_preftech)
			iter.set_iterator(c_stream, mtdb)
		end

	iterator (ep_string: STRING; filter_cls: MTCLASS; num_preftech: INTEGER_32): MT_OBJECT_ITERATOR[MTOBJECT]
		-- Open an object iterator on all matches of an entry-point search.
		require
			ep_string_not_void: ep_string /= Void
			ep_string_not_empty: not ep_string.is_empty
		local
			c_stream : INTEGER_32
			c_ep_string: ANY
         cid: INTEGER_32
		do
			c_ep_string := ep_string.to_c
         cid := 0
			if Void /= filter_cls then
				cid := filter_cls.oid
			end
			c_stream := mtdb.context.open_entry_point_stream ($c_ep_string, oid, cid, num_preftech)
			create Result.make(c_stream, mtdb)
		end

	lookup (ep_string: STRING; filter_cls: MTCLASS): MTOBJECT
		-- Gets a single MATISSE object by entry point.
		-- If more than one object matches, lookup throws an Exception
		require
			not_void: ep_string /= Void
			ep_string_not_empty: not ep_string.is_empty
		local
			c_ep_string: ANY
			cid: INTEGER_32
		do
			c_ep_string := ep_string.to_c
         cid := 0
			if Void /= filter_cls then
				cid := filter_cls.oid
			end

			Result ?= mtdb.upcast (mtdb.context.get_object_from_entry_point ($c_ep_string, oid, cid))
		end

	object_number, get_object_number (ep_string: STRING; filter_cls: MTCLASS): INTEGER_32
		-- Gets a single MATISSE object by entry point.
		-- If more than one object matches, lookup throws an Exception
		require
			not_void: ep_string /= Void
			ep_string_not_empty: not ep_string.is_empty
		local
			c_ep_string: ANY
			cid: INTEGER_32
		do
			c_ep_string := ep_string.to_c
         cid := 0
			if Void /= filter_cls then
				cid := filter_cls.oid
			end

			Result := mtdb.context.get_object_number_from_entry_point ($c_ep_string, oid, cid)

		end



feature -- Lock objects

	lock_objects (a_lock: INTEGER_32; ep_string: STRING; filter_cls: MTCLASS)
		-- Lock all objects matching the specified keyword.
		require
			lock_is_read_or_is_write: a_lock = {MT_DATABASE}.Mt_Read or a_lock = {MT_DATABASE}.Mt_Write
			ep_not_void: ep_string /= Void
			ep_string_not_empty: not ep_string.is_empty
		local
			c_ep_string: ANY
			cid: INTEGER_32
		do
			c_ep_string := ep_string.to_c
         cid := 0
			if Void /= filter_cls then
				cid := filter_cls.oid
			end

			mtdb.context.lock_objects_from_entry_point (a_lock, $c_ep_string, oid, cid)
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
			Result := mtdb.get_mtattribute("MtName", mtdb.get_mtclass("MTENTRYPOINTDICTIONARY"))
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

	get_mtuniquekey_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtUniqueKey from the database
		do
			Result := mtdb.get_mtattribute("MtUniqueKey", mtdb.get_mtclass("MTENTRYPOINTDICTIONARY"))
		end

	mtuniquekey, get_mtuniquekey (): BOOLEAN
		-- get the value of MtUniqueKey from the database
		do
			Result := get_boolean (get_mtuniquekey_attribute ())
		end

	is_mtuniquekey_default_value (): BOOLEAN
		-- Check if MtUniqueKey attribute value is set to its default value
		do
			Result := is_default_value (get_mtuniquekey_attribute ())
		end

	get_mtcasesensitive_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtCaseSensitive from the database
		do
			Result := mtdb.get_mtattribute("MtCaseSensitive", mtdb.get_mtclass("MTENTRYPOINTDICTIONARY"))
		end

	mtcasesensitive, get_mtcasesensitive (): BOOLEAN
		-- get the value of MtCaseSensitive from the database
		do
			Result := get_boolean (get_mtcasesensitive_attribute ())
		end

	is_mtcasesensitive_default_value (): BOOLEAN
		-- Check if MtCaseSensitive attribute value is set to its default value
		do
			Result := is_default_value (get_mtcasesensitive_attribute ())
		end

	get_mtmakeentryfunction_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtMakeEntryFunction from the database
		do
			Result := mtdb.get_mtattribute("MtMakeEntryFunction", mtdb.get_mtclass("MTENTRYPOINTDICTIONARY"))
		end

	mtmakeentryfunction, get_mtmakeentryfunction (): STRING
		-- get the value of MtMakeEntryFunction from the database
		do
			Result := get_string (get_mtmakeentryfunction_attribute ())
		end

	is_mtmakeentryfunction_default_value (): BOOLEAN
		-- Check if MtMakeEntryFunction attribute value is set to its default value
		do
			Result := is_default_value (get_mtmakeentryfunction_attribute ())
		end

	get_mtentrypointof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtEntryPointOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtEntryPointOf", mtdb.get_mtclass("MTENTRYPOINTDICTIONARY"))
		end

	mtentrypointof, get_mtentrypointof (): MTATTRIBUTE
		-- get the MtEntryPointOf relationship successor from the database
		do
			Result ?= get_successor (get_mtentrypointof_relationship ())
		end

	get_mtnamespacedictionaryof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceDictionaryOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceDictionaryOf", mtdb.get_mtclass("MTENTRYPOINTDICTIONARY"))
		end

	mtnamespacedictionaryof, get_mtnamespacedictionaryof (): MTNAMESPACE
		-- get the MtNamespaceDictionaryOf relationship successor from the database
		do
			Result ?= get_successor (get_mtnamespacedictionaryof_relationship ())
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

	set_mtuniquekey (a_val: BOOLEAN)
		-- update MtUniqueKey attribute value in the database
		do
			set_boolean (get_mtuniquekey_attribute (), a_val)
		end

	remove_mtuniquekey ()
		-- remove MtUniqueKey attribute value in the database
		do
			remove_value (get_mtuniquekey_attribute ())
		end

	set_mtcasesensitive (a_val: BOOLEAN)
		-- update MtCaseSensitive attribute value in the database
		do
			set_boolean (get_mtcasesensitive_attribute (), a_val)
		end

	remove_mtcasesensitive ()
		-- remove MtCaseSensitive attribute value in the database
		do
			remove_value (get_mtcasesensitive_attribute ())
		end

	set_mtmakeentryfunction (a_val: STRING)
		-- update MtMakeEntryFunction attribute value in the database
		do
			set_string (get_mtmakeentryfunction_attribute (), a_val)
		end

	remove_mtmakeentryfunction ()
		-- remove MtMakeEntryFunction attribute value in the database
		do
			remove_value (get_mtmakeentryfunction_attribute ())
		end

	set_mtentrypointof (succ: MTATTRIBUTE)
		-- Update MtEntryPointOf relationship successor
		do
			set_successor (get_mtentrypointof_relationship (), succ)
		end

	clear_mtentrypointof ()
		-- Remove MtEntryPointOf relationship successor
		do
			clear_successors (get_mtentrypointof_relationship ())
		end

	set_mtnamespacedictionaryof (succ: MTNAMESPACE)
		-- Update MtNamespaceDictionaryOf relationship successor
		do
			set_successor (get_mtnamespacedictionaryof_relationship (), succ)
		end

	clear_mtnamespacedictionaryof ()
		-- Remove MtNamespaceDictionaryOf relationship successor
		do
			clear_successors (get_mtnamespacedictionaryof_relationship ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTENTRYPOINTDICTIONARY

