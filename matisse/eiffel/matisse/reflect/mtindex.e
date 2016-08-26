
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class
	MTINDEX

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
	, make_mtindex
feature -- Direction

	Mt_Direct: INTEGER = 1
	Mt_Reverse: INTEGER = -1

feature -- Ordering

	Mt_Descend: INTEGER = 0
	Mt_Ascend: INTEGER = 1

feature -- Initilization

	make_from_mtname (a_db: MT_DATABASE; an_index_name: STRING)
		require
			index_name_not_void: an_index_name /= Void
			index_name_not_empty: not an_index_name.is_empty
			db_not_void: a_db /= Void
		local
			c_index_name: ANY
		do
			mtdb := a_db
			c_index_name := an_index_name.to_c
			oid := mtdb.context.get_index ( $c_index_name)
		end


	make_mtindex (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("MtIndex"))
		end

	mtfullname, get_mtfullname (): STRING
		-- Gets the full name including namespace of the schema object.
		do
			Result := mtdb.context.get_schema_object_full_name (oid)
		end

feature -- Lookup

	lookup (a_key: ARRAY[ANY]; filter_cls: MTCLASS): MTOBJECT
			-- Search object from a composed-key
			-- Return Void if no object is found.
			-- Return the object if exactly one object is found.
			-- Raise exception if more than one object are found.
		require
			key_not_void: a_key /= Void
			key_not_empty: not a_key.is_empty
		local
			i, class_oid: INTEGER
			c_crit_array: ARRAY [POINTER];
			key_elt, c_string: ANY
			dummy_string: STRING
		do
			-- build the multi-segment key
			-- LIMITATION: does not work for any type other than string and
			-- integers, for the other types use a SQL statement to filter
			-- NOTE: to do it for the other datatypes (i.e. numeric,
			-- date, etc.), convert the value to string and in the C
			-- layer re-create the value from a string
			create c_crit_array.make_filled (Default_Pointer, 0, a_key.count - 1)
			from
				i := 1
			until
				i > a_key.count
			loop
				key_elt := a_key.item(i)
				if key_elt /= void then
					dummy_string ?= key_elt
					if dummy_string /= void then
						c_string := dummy_string.to_c
						c_crit_array.put ($c_string, i - 1)
					else
						c_crit_array.put ($key_elt, i - 1)
					end
				end
				i := i + 1
			end

			class_oid := 0
			if filter_cls /= Void then
				class_oid := filter_cls.oid
			end

			Result ?= mtdb.upcast(mtdb.context.index_lookup_object (oid, class_oid, c_crit_array.count, $c_crit_array))

		end

feature -- Index Object Number

	object_number, get_object_number (a_key: ARRAY[ANY]; filter_cls: MTCLASS): INTEGER
			-- Search object from a composed-key
		require
			key_not_void: a_key /= Void
			key_not_empty: not a_key.is_empty
		local
			i, class_oid: INTEGER
			c_crit_array: ARRAY [POINTER];
			key_elt, c_string: ANY
			dummy_string: STRING
		do
			-- build the multi-segment key
			-- LIMITATION: does not work for any type other than string and
			-- integers, for the other types use a SQL statement to filter
			-- NOTE: to do it for the other datatypes (i.e. numeric,
			-- date, etc.), convert the value to string and in the C
			-- layer re-create the value from a string
			create c_crit_array.make_filled (Default_Pointer, 0, a_key.count - 1)
			from
				i := 1
			until
				i > a_key.count
			loop
				key_elt := a_key.item(i)
				if key_elt /= void then
					dummy_string ?= key_elt
					if dummy_string /= void then
						c_string := dummy_string.to_c
						c_crit_array.put ($c_string, i - 1)
					else
						c_crit_array.put ($key_elt, i - 1)
					end
				end
				i := i + 1
			end

			class_oid := 0
			if filter_cls /= Void then
				class_oid := filter_cls.oid
			end

			Result := mtdb.context.index_object_number (oid, class_oid, c_crit_array.count, $c_crit_array)

		end

feature -- Iterate

	create_iterator (iter: MT_OBJECT_ITERATOR[MTOBJECT]; start_key, end_key: ARRAY [ANY];
						  filter_cls: MTCLASS; direction, num_preftech: INTEGER)
		-- Opens an iterator on an index.
		require
			direction_is_direct_or_reverse: direction = {MTINDEX}.Mt_Direct or else direction = {MTINDEX}.Mt_Reverse
		local
			c_start_key, c_end_key: ARRAY [POINTER]
			dummy_string: STRING
			key_elt, c_string: ANY
			i, seg_count, c_stream, class_oid: INTEGER
		do
			-- build the multi-segment key
			-- LIMITATION: does not work for any type or than string and
			-- integers, for the other type use a SQL statement to filter
			-- NOTE: to do it for the other datatypes (i.e. numeric,
			-- date, etc.), convert the value to string and in the C
			-- layer re-create the value from a string

			seg_count := 0

			if start_key /= Void then
				seg_count := start_key.count
				create c_start_key.make_filled (Default_Pointer, 0, start_key.count - 1)
				from
					i:= 1
				until
					i > start_key.count
				loop
					key_elt := start_key.item(i)
					if key_elt /= void then
						dummy_string ?= key_elt
						if dummy_string /= void then
							c_string := dummy_string.to_c
							c_start_key.put ($c_string, i - 1)
						else
							c_start_key.put ($key_elt, i - 1)
						end
					end
					i := i + 1
				end
			end

			if end_key /= Void then
				if seg_count > 0 then
					if end_key.count < seg_count then
						seg_count := end_key.count
					end
				else
					seg_count := end_key.count
				end
				create c_end_key.make_filled (Default_Pointer, 0, end_key.count - 1)
				from
					i:= 1
				until
					i > end_key.count
				loop
					key_elt := end_key.item(i)
					if key_elt /= void then
						dummy_string ?= key_elt
						if dummy_string /= void then
							c_string := dummy_string.to_c
							c_end_key.put ($c_string, i - 1)
						else
							c_end_key.put ($key_elt, i - 1)
						end
					end
					i := i + 1
				end
			end

			class_oid := 0
			if filter_cls /= Void then
				class_oid := filter_cls.oid
			end

			c_stream := mtdb.context.open_index_object_stream (oid, class_oid, direction, seg_count,
																				$c_start_key, $c_end_key, num_preftech)
			iter.set_iterator(c_stream, mtdb)
		end

	iterator (start_key, end_key: ARRAY [ANY]; filter_cls: MTCLASS;
				direction, num_preftech: INTEGER): MT_OBJECT_ITERATOR[MTOBJECT]
		-- Opens an iterator on an index.
		local
			o_iter: MT_OBJECT_ITERATOR[MTOBJECT]
		do
			create o_iter.make_empty_iterator ()
			create_iterator (o_iter, start_key, end_key, filter_cls, direction, num_preftech)
			Result := o_iter
		end

feature -- Index Entries Number

	index_entries_number, get_index_entries_number: INTEGER
		-- The number of entries in the index.
		do
			Result := mtdb.context.index_entries_count (oid)
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
			Result := mtdb.get_mtattribute("MtName", mtdb.get_mtclass("MTINDEX"))
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
			Result := mtdb.get_mtattribute("MtUniqueKey", mtdb.get_mtclass("MTINDEX"))
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

	get_mtcriteriaorder_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of MtCriteriaOrder from the database
		do
			Result := mtdb.get_mtattribute("MtCriteriaOrder", mtdb.get_mtclass("MTINDEX"))
		end

	mtcriteriaorder, get_mtcriteriaorder (): ARRAY [INTEGER_32]
		-- get the value of MtCriteriaOrder from the database
		do
			Result := get_integers (get_mtcriteriaorder_attribute ())
		end

	is_mtcriteriaorder_default_value (): BOOLEAN
		-- Check if MtCriteriaOrder attribute value is set to its default value
		do
			Result := is_default_value (get_mtcriteriaorder_attribute ())
		end

	get_mtclasses_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtClasses from the database
		do
			Result := mtdb.get_mtrelationship ("MtClasses", mtdb.get_mtclass("MTINDEX"))
		end

	mtclasses, get_mtclasses (): ARRAY[MTCLASS]
		-- get the MtClasses relationship successors from the database
		local
			v_res: ARRAY[MTCLASS]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtclasses_relationship (), v_res)
			Result := v_res
		end

	mtclasses_size, get_mtclasses_size (): INTEGER_32
		-- get the MtClasses relationship size from the database
		do
			Result := get_successor_size (get_mtclasses_relationship ())
		end

	mtclasses_iterator (): MT_OBJECT_ITERATOR[MTCLASS]
		-- Opens an iterator on the MtClasses relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtclasses_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtcriteria_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtCriteria from the database
		do
			Result := mtdb.get_mtrelationship ("MtCriteria", mtdb.get_mtclass("MTINDEX"))
		end

	mtcriteria, get_mtcriteria (): ARRAY[MTATTRIBUTE]
		-- get the MtCriteria relationship successors from the database
		local
			v_res: ARRAY[MTATTRIBUTE]
		do
			create v_res.make_filled (Void, 1, 0)
			get_successors_upcast (get_mtcriteria_relationship (), v_res)
			Result := v_res
		end

	mtcriteria_size, get_mtcriteria_size (): INTEGER_32
		-- get the MtCriteria relationship size from the database
		do
			Result := get_successor_size (get_mtcriteria_relationship ())
		end

	mtcriteria_iterator (): MT_OBJECT_ITERATOR[MTATTRIBUTE]
		-- Opens an iterator on the MtCriteria relationship's successors.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, get_mtcriteria_relationship ().oid)
			create Result.make(c_stream, mtdb)
		end

	get_mtnamespaceindexof_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of MtNamespaceIndexOf from the database
		do
			Result := mtdb.get_mtrelationship ("MtNamespaceIndexOf", mtdb.get_mtclass("MTINDEX"))
		end

	mtnamespaceindexof, get_mtnamespaceindexof (): MTNAMESPACE
		-- get the MtNamespaceIndexOf relationship successor from the database
		do
			Result ?= get_successor (get_mtnamespaceindexof_relationship ())
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

	set_mtcriteriaorder (a_val: ARRAY [INTEGER_32])
		-- update MtCriteriaOrder attribute value in the database
		do
			set_integers (get_mtcriteriaorder_attribute (), a_val)
		end

	remove_mtcriteriaorder ()
		-- remove MtCriteriaOrder attribute value in the database
		do
			remove_value (get_mtcriteriaorder_attribute ())
		end

	set_mtclasses (succs: ARRAY[MTCLASS])
		-- Update MtClasses relationship successors
		do
			set_successors (get_mtclasses_relationship (), succs)
		end

	prepend_mtclasses (succ: MTCLASS)
		-- Update MtClasses relationship successors
		do
			prepend_successor (get_mtclasses_relationship (), succ)
		end

	append_mtclasses (succ: MTCLASS)
		-- Update MtClasses relationship successors
		do
			append_successor (get_mtclasses_relationship (), succ)
		end

	append_after_mtclasses (succ, after: MTCLASS)
		-- Update MtClasses relationship successors
		do
			add_successor_after (get_mtclasses_relationship (), succ, after)
		end

	append_num_mtclasses (succs: ARRAY[MTCLASS])
		-- Adds multiple objects to the end of the existing MtClasses successors list
		do
			add_successors (get_mtclasses_relationship (), succs)
		end

	remove_mtclasses (succ: MTCLASS)
		-- Remove one successor from the MtClasses relationship
		do
			remove_successor (get_mtclasses_relationship (), succ)
		end

	remove_num_mtclasses (succs: ARRAY[MTCLASS])
		-- Remove multiple successors from the MtClasses relationship
		do
			remove_successors (get_mtclasses_relationship (), succs)
		end

	clear_mtclasses ()
		-- Remove all MtClasses relationship successors
		do
			clear_successors (get_mtclasses_relationship ())
		end

	set_mtcriteria (succs: ARRAY[MTATTRIBUTE])
		-- Update MtCriteria relationship successors
		do
			set_successors (get_mtcriteria_relationship (), succs)
		end

	prepend_mtcriteria (succ: MTATTRIBUTE)
		-- Update MtCriteria relationship successors
		do
			prepend_successor (get_mtcriteria_relationship (), succ)
		end

	append_mtcriteria (succ: MTATTRIBUTE)
		-- Update MtCriteria relationship successors
		do
			append_successor (get_mtcriteria_relationship (), succ)
		end

	append_after_mtcriteria (succ, after: MTATTRIBUTE)
		-- Update MtCriteria relationship successors
		do
			add_successor_after (get_mtcriteria_relationship (), succ, after)
		end

	append_num_mtcriteria (succs: ARRAY[MTATTRIBUTE])
		-- Adds multiple objects to the end of the existing MtCriteria successors list
		do
			add_successors (get_mtcriteria_relationship (), succs)
		end

	remove_mtcriteria (succ: MTATTRIBUTE)
		-- Remove one successor from the MtCriteria relationship
		do
			remove_successor (get_mtcriteria_relationship (), succ)
		end

	remove_num_mtcriteria (succs: ARRAY[MTATTRIBUTE])
		-- Remove multiple successors from the MtCriteria relationship
		do
			remove_successors (get_mtcriteria_relationship (), succs)
		end

	clear_mtcriteria ()
		-- Remove all MtCriteria relationship successors
		do
			clear_successors (get_mtcriteria_relationship ())
		end

	set_mtnamespaceindexof (succ: MTNAMESPACE)
		-- Update MtNamespaceIndexOf relationship successor
		do
			set_successor (get_mtnamespaceindexof_relationship (), succ)
		end

	clear_mtnamespaceindexof ()
		-- Remove MtNamespaceIndexOf relationship successor
		do
			clear_successors (get_mtnamespaceindexof_relationship ())
		end


-- END of Matisse SDL generation of accessors


end -- class MTINDEX

