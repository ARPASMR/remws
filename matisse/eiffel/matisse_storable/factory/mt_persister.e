note
	description: "MATISSE-Eiffel Binding: define the database session class"
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
	MT_PERSISTER

inherit
	MT_PERSISTER_BASE
		redefine
			version_access_started,
			version_access_ended,
			transaction_started,
			transaction_committed,
			transaction_aborted,
			connected,
			disconnected,
			flush_updated_objects,
			eif_object_from_oid
		end

	INTERNAL
		rename
			c_is_instance_of as internal_c_instance_of,
			is_instance_of as internal_instance_of
	   export
			{NONE} all
		end
    --MT_EXCEPTIONS
	 --	rename
	 --		trigger as trigger_exception --,
	 --	--	class_name as exceptin_class_name
    -- 	export
    --		{NONE} all
    --	end

create
	make

feature {ANY}-- Initialization

	version_access_started(new_version: INTEGER)
			-- A version access has just started
		local
			update_cache: BOOLEAN
		do
			in_tran_or_version := True
			update_cache := version_number /= new_version
			version_number := new_version
			if update_cache then
				-- update_objects_post_retrieved
			end
			load_mt_classes
		end

	version_access_ended
			-- A version access has just ended
		do
			in_tran_or_version := False
		end

	transaction_started(new_version: INTEGER)
			-- A transaction has just started
		local
			update_cache: BOOLEAN
		do
			in_tran_or_version := True
			update_cache := version_number /= new_version
			version_number := new_version
			if update_cache then
				-- update_objects_post_retrieved
			end
			create attr_modified_set.make
			create rl_modified_set.make
			create container_modified_set.make
			load_mt_classes
		end

	transaction_committed
			-- A transaction has just been committed.
		do
			attr_modified_set := Void
			rl_modified_set := Void
			container_modified_set := Void
			in_tran_or_version := False
		end

	transaction_aborted
			-- A transaction has just been aborted.
		do
			attr_modified_set := Void
			rl_modified_set := Void
			container_modified_set := Void
			in_tran_or_version := False
		end

	connected
			-- The connection has just been connected.
		do
			create eif_object_table.make (500)
			create objects_post_retrieved.make (1, 100)
			in_tran_or_version := False
		end

	disconnected
			-- The connection has just been disconnected.
		do
			in_tran_or_version := False
			eif_object_table := Void
			attr_modified_set := Void
			rl_modified_set := Void
			container_modified_set := Void
			objects_post_retrieved := Void
		end


feature {NONE} -- Status

	transaction_open: BOOLEAN
		do
			Result := rl_modified_set /= Void
		end

	current_logical_time: INTEGER

	previous_logical_time: INTEGER


-- feature {ANY}

	-- session_state: INTEGER

	-- set_session_state (a_state: INTEGER)
	--	do
	--		session_state := a_state
			--	end

feature {NONE}

	in_tran_or_version: BOOLEAN


feature {NONE} -- implementation

	mt_schema: HASH_TABLE [MT_CLASS, INTEGER]
			-- Key:   Eiffel type id
			-- Value: Instance of MT_CLASS

	eif_object_table: MT_OBJECT_TABLE [INTEGER, INTEGER]
			-- Cache table of replicated eiffel object
			--   Key:   MATISSE oid
			--   Value: Eiffel object's identifier (IDENTIFIED)

	identifier: IDENTIFIED
			-- Access to IDENTIFIED's features.
		once
			create Result
		ensure
			not_void: Result /= Void
		end

	attr_modified_set: BINARY_SEARCH_TREE_SET [INTEGER]
			-- Set of oid of objects whose attributes are modified

	rl_modified_set: BINARY_SEARCH_TREE_SET [INTEGER]
			-- Set of oid of objects whose relationships are modified

	container_modified_set: BINARY_SEARCH_TREE_SET [INTEGER]
			-- Set of container objects which are modified.

	objects_post_retrieved: ARRAY [INTEGER]
			-- OIDs of objects that execute 'post_retrieved'

	num_objects_post_retrieved: INTEGER

	update_objects_post_retrieved
		local
			i, num: INTEGER
			dummy:  BOOLEAN
			obj:    MT_STORABLE
		do
			num := num_objects_post_retrieved
			from
				i := 1
			until
				i > num
			loop
				obj := eif_object_from_oid_if_found (objects_post_retrieved.item(i))
				if obj /= Void then
					if mtdb.context.mt_oid_exist ( obj.oid) then
						dummy := obj.post_retrieved
					else
						remove_non_existent_object_from_cache (obj)
						objects_post_retrieved.put (-1, i)
					end
				end
				i := i + 1
			end

		end

  Class_not_found_error_message: STRING = "The specified class is not defined in the database";

feature -- Schema

	load_mt_classes
			-- Load all instances of "MtClass" without using
			-- this binding mechanism
		local
			cids: ARRAY [INTEGER]
			i: INTEGER
			a_class: MT_CLASS
		do
			if mt_schema = Void then
				cids := oids_of_all_classes
				create mt_schema.make (cids.count)
				from
					i := cids.lower
				until
					i > cids.upper
				loop
					create a_class.make_from_oid_and_db (cids.item (i), Current.mtdb)
					mt_schema.put (a_class, a_class.eiffel_type_id)
					i := i + 1
				end
			end
		end

	load_mt_schema
		local
			a_class, each_class: MT_CLASS
			all_classes: ARRAY [MT_OBJECT]
			i: INTEGER
		do
			create a_class.make_from_name_with_db ("MtClass", Current.mtdb)
			all_classes := a_class.all_instances
			create mt_schema.make (all_classes.count)

			from
				i := all_classes.lower
			until
				i > all_classes.upper
			loop
				each_class ?= all_classes.item (i)
				each_class.set_persister (Current)
				mt_schema.put (each_class, each_class.eiffel_type_id)
				i := i + 1
			end
		end

	mt_class_from_object (an_object: ANY): MT_CLASS
		require
			not_void: an_object /= Void
		do
			mt_schema.search (dynamic_type (an_object))
			if mt_schema.found then
				Result := mt_schema.found_item
			end
		end

	get_mt_class_from_name (a_class_name: STRING): MT_CLASS
		require
			not_void: a_class_name /= Void
		local
			c_class_name: ANY
			type_id: INTEGER
		do
			c_class_name := a_class_name.to_c
			type_id := {MT_NATIVE}.c_get_eif_type_id ($c_class_name, False)
			Result := mt_schema.item (type_id)
		end

	get_attribute_from_name (attr_name, a_class_name: STRING): MT_ATTRIBUTE
		require
			attr_name_not_void: attr_name /= Void
		local
			aid, type_id, i: INTEGER
			c_class_name, c_attr_name: ANY
			a_class: MT_CLASS
			attributes: ARRAY [MT_ATTRIBUTE]
			an_attr: MT_ATTRIBUTE
			ex: MT_EXCEPTIONS
		do
			if a_class_name /= Void then
				c_class_name := a_class_name.to_c
				type_id := {MT_NATIVE}.c_get_eif_type_id ($c_class_name, False)
				a_class := mt_schema.item (type_id)
        if a_class = Void then
        	create ex
          	ex.raise (Class_not_found_error_message);
        end

				if a_class.properties_initialized then
					attributes := a_class.attributes
				else
					attributes := a_class.get_attributes
				end
				from
					i := attributes.lower
				until
					i > attributes.upper or Result /= Void
				loop
					an_attr := attributes.item (i)
					if an_attr /= Void then
						if an_attr.eiffel_name.is_equal (attr_name) then
							Result := an_attr
						end
					end
					i := i + 1
				end
			end

			if Result = Void then
				c_attr_name := attr_name.to_c
				aid := mtdb.context.get_attribute ( $c_attr_name)
					-- If no attribute is found, an exception will be raised
					-- from C environment.
				create Result.make_from_id (Current.mtdb, aid)
			end
		ensure
			Result_not_void: Result /= Void
				-- If no attribute is found, an exception will be raised
				-- from C environment.
		end


feature {MT_STORABLE} -- Modification marking

	mark_attrs_modified (an_oid: INTEGER)
			-- All attributes of the object are set a mark of modification.
		local
			ex: MT_EXCEPTIONS
		do
			if not transaction_open then
				create ex
				ex.trigger_dev_exception ({MT_EXCEPTIONS}.Matisse_Notrans, "Transaction not opened")
			else
				attr_modified_set.put (an_oid)
			end
		end

	mark_rls_modified (an_oid: INTEGER)
			-- All relationships of the object are set a mark of modification.
		local
			ex: MT_EXCEPTIONS
		do
			if not transaction_open then
				create ex
				ex.trigger_dev_exception ({MT_EXCEPTIONS}.Matisse_Notrans, "Transaction not opened")
			else
				rl_modified_set.put (an_oid)
			end
		end

	mark_container_modified (an_oid: INTEGER)
		-- This is used for container object such as HASH_TABLE.
		local
			ex: MT_EXCEPTIONS
		do
			if not transaction_open then
				create ex
				ex.trigger_dev_exception ({MT_EXCEPTIONS}.Matisse_Notrans, "Transaction not opened")
			else
				container_modified_set.put (an_oid)
			end
		end

	add_post_retireved (an_oid: INTEGER)
		do
			-- If there is no more space, make room.
			if objects_post_retrieved.capacity = num_objects_post_retrieved then
				objects_post_retrieved.grow (objects_post_retrieved.capacity + 500)
			end
			num_objects_post_retrieved := num_objects_post_retrieved + 1
			objects_post_retrieved.put (an_oid, num_objects_post_retrieved)
		end

feature -- Object cache

	has (an_object: MT_STORABLE): BOOLEAN
			-- Is an_object included in the cache table?
		local
			obj: MT_STORABLE
		do
			eif_object_table.search (an_object.oid)
			if eif_object_table.found then
				obj ?= identifier.id_object (eif_object_table.found_item)
				if obj = Void then
					Result := False
				else
					Result := obj = an_object
				end
			else
				Result := False
			end
		end

	persist_transient_object (an_object: MT_STORABLE)
			-- Adopt an_object as MATISSE persistent object.
			-- Create new MATISSE object (using MtCreateObject),
			-- add an_object into cache eif_object_table, add oid of
			-- an_object into attr_modified_set and rl_modified_set
			-- so that all values of an_object are stored in a database.
		require
			 object_not_persistent: not has (an_object)
		local
			a_class: MT_CLASS
			index, new_oid: INTEGER
			relationships: ARRAY [MT_RELATIONSHIP]
			attributes: ARRAY [MT_ATTRIBUTE]
			a_rs: MT_RELATIONSHIP
			an_att: MT_ATTRIBUTE
			ex: MT_EXCEPTIONS
		do
			a_class := mt_schema.item (dynamic_type (an_object))
      if a_class = Void then
      	create ex
        ex.raise (Class_not_found_error_message);
      end

			new_oid := mtdb.context.create_object_from_cid ( a_class.oid)
			an_object.set_oid (new_oid)
			a_class.init_properties (an_object)
				-- Initialize attributes and relationships before calling mt_make ()
			an_object.mt_make (a_class)
				-- Initialize an_object as a persistent object.
			eif_object_table.extend (an_object.object_id, new_oid)
			attributes := a_class.attributes
			from
				index := attributes.lower
			until
				index > attributes.upper
			loop
				an_att := attributes.item (index)
				if an_att /= Void then
					an_att.set_value_not_default (an_object)
				end
					-- In the explicit promotion to persistent object, if attribute
					-- value is void then do nothing (its attribute value in the
					-- database object remains unspecified)
				index := index + 1
			end

			relationships := a_class.relationships
			from
				index := relationships.lower
			until
				index > relationships.upper
			loop
				a_rs := relationships.item (index)
				if a_rs /= Void then
					a_rs.persist_successors_of (an_object)
				end
				index := index + 1
			end

			-- added by SM, 01/07/99
			-- As the `an_object' is just created, its attributes
			-- and relationships can be considered as loaded.
			an_object.loading_attrs_done
			an_object.loading_relationships_done
			an_object.become_persistent (Current.mtdb, version_number)
		ensure
			object_in_cache: has (an_object)
			object_is_persistent: an_object.is_persistent
		end

	safe_wean (an_obj: MT_STORABLE)
			-- Discard an_obj from eif_obj_table
		do
			if not (attr_modified_set.has (an_obj.oid) or rl_modified_set.has (an_obj.oid)) then
				eif_object_table.remove (an_obj.oid)
				an_obj.mt_dispose
			end
		end

	delete_object (an_obj: MT_STORABLE)
			-- Delete an_obj from the database and also from the 'eif_obj_table'
		local
			predecessors_to_be_updated: ARRAY[TUPLE[INTEGER, ARRAY[MT_STORABLE]]]
		do
			delete_composite_part (an_obj)
			an_obj.mt_load_all_successors  -- needed so that reload_successors_after_delete works correctly
			predecessors_to_be_updated := predecessors_thru_readonly_rshp (an_obj)
			an_obj.set_persister (Void)  -- this needs to be called before c_remove because of assertions
			mtdb.context.remove_object ( an_obj.oid)
			reload_successors_after_delete (an_obj, predecessors_to_be_updated)
			eif_object_table.remove (an_obj.oid)
			an_obj.set_oid (0) -- become transient
		end

	delete_composite_part (an_obj: MT_STORABLE)
		-- Delete part objects of an_obj
		-- (supporting CompositeRelationship concept.
		local
			a_class: MT_CLASS
			relationships: ARRAY [MT_RELATIONSHIP]
			co_rel: MT_COMPOSITE_RELATIONSHIP
			s_co_rel: MT_SINGLE_COMPOSITE_RELATIONSHIP
			m_co_rel: MT_MULTI_COMPOSITE_RELATIONSHIP
			i: INTEGER
			a_storable: MT_STORABLE
			linear_collection: MT_LINEAR_COLLECTION [MT_STORABLE]
			linear_rep: LINEAR [MT_STORABLE]
			rs_containable: MT_RS_CONTAINABLE
		do
			a_class := mt_class_from_object (an_obj)
			a_class.init_properties (an_obj)
			relationships := a_class.relationships
			from
				i := relationships.lower
			until
				i > relationships.upper
			loop
				co_rel ?= relationships.item (i)
				if co_rel /= Void then
					s_co_rel ?= co_rel
					if s_co_rel /= Void then
						a_storable ?= field (s_co_rel.eif_field_index, an_obj)
						if a_storable /= Void then
							delete_object (a_storable)
						else
							a_storable := s_co_rel.first_successor (an_obj)
							if a_storable /= Void then
								delete_object (a_storable)
							end
						end
					else
						m_co_rel ?= co_rel
						linear_collection ?= field (m_co_rel.eif_field_index, an_obj)
						if linear_collection /= Void then
							rs_containable ?= linear_collection
							rs_containable.load_successors
							linear_rep := linear_collection.linear_representation
							from
								linear_rep.start
							until
								linear_rep.off
							loop
								delete_object (linear_rep.item)
								linear_rep.forth
							end
						end
					end
				end
				i := i + 1
			end
		end

	persist, check_persistence (an_object: MT_STORABLE)
		do
			if an_object /= Void and then not has (an_object) then
				persist_transient_object (an_object)
			end
		end

	clear_object_table
		do
			eif_object_table := Void
			create eif_object_table.make (500)
		end

feature -- New eiffel object

	new_eif_object_from_oid, eif_object_from_oid (a_mt_oid: INTEGER): MT_STORABLE
		require else
			positive_oid: a_mt_oid > 0
		local
			a_class: MT_CLASS
		do
			eif_object_table.search (a_mt_oid)
			if eif_object_table.found then
				Result ?= identifier.id_object (eif_object_table.found_item)
				if Result = Void then
					-- The cached object has been garbage-collected
					eif_object_table.remove (a_mt_oid)
					Result := new_eif_object_from_oid (a_mt_oid)
				end
			else
				Result ?= mtdb.context.dynamic_create_storable_eif_object (a_mt_oid)
				eif_object_table.extend (Result.object_id, a_mt_oid)
				Result.set_oid (a_mt_oid)
				a_class := mt_class_from_object (Result)
				a_class.init_properties (Result)
				Result.mt_make (a_class)
				Result.become_persistent (Current.mtdb, version_number) -- now 'Result' becomes persistent
			end
		ensure then
			result_in_cache: has (Result)
			result_is_persistent: Result.is_persistent
		end

	eif_object_from_oid_if_found (a_mt_oid: INTEGER): MT_STORABLE
			-- If the oid is found in the object table, return the Eiffel object
			-- Otherwise, return Void
		do
			eif_object_table.search (a_mt_oid)
			if eif_object_table.found then
				Result ?= identifier.id_object (eif_object_table.found_item)
				if Result = Void then
					-- The cached object has been garbage-collected
					eif_object_table.remove (a_mt_oid)
				end
			else
				Result := Void
			end
		end

feature {MT_CONTAINER_OBJECT} -- New eiffel container object

	create_new_container (a_class_name: STRING): INTEGER
		local
			to_c: ANY
		do
			to_c := a_class_name.to_c
			Result := mtdb.context.create_object ( $to_c)
		end

	register_container (a_container: MT_STORABLE)
		do
			eif_object_table.force (a_container.object_id, a_container.oid)
		end

feature -- Retrieving, storing and removing attribute value

	get_attr_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : ANY
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_value (an_obj)
			end
		end

	get_attr_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): ANY
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_value (an_obj)
			end
		end

	-- MT_BOOLEAN --
	get_boolean_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): BOOLEAN
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := boolean_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_boolean (an_obj)
			end
		end

	get_boolean_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): BOOLEAN
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := boolean_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_boolean (an_obj)
			end
		end

	get_boolean_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [BOOLEAN]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_boolean_list (an_obj)
			end
		end

	get_boolean_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [BOOLEAN]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_boolean_list (an_obj)
			end
		end

	-- MT_DATE --
	get_date_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): DATE
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_date (an_obj)
			end
		end

	get_date_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): DATE
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_date (an_obj)
			end
		end

	get_date_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [DATE]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_date_list (an_obj)
			end
		end

	get_date_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [DATE]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_date_list (an_obj)
			end
		end

	-- MT_TIMESTAMP --
	get_timestamp_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): DATE_TIME
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_timestamp (an_obj)
			end
		end

	get_timestamp_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): DATE_TIME
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_timestamp (an_obj)
			end
		end

	get_timestamp_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [DATE_TIME]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_timestamp_list (an_obj)
			end
		end

	get_timestamp_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [DATE_TIME]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_timestamp_list (an_obj)
			end
		end

	-- MT_INTERVAL --
	get_time_interval_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): DATE_TIME_DURATION
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_time_interval (an_obj)
			end
		end

	get_time_interval_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): DATE_TIME_DURATION
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_time_interval (an_obj)
			end
		end

	get_time_interval_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [DATE_TIME_DURATION]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_time_interval_list (an_obj)
			end
		end

	get_time_interval_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [DATE_TIME_DURATION]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_time_interval_list (an_obj)
			end
		end

	-- MT_S32 --	
	get_integer_64_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): INTEGER_64
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_64_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_integer_64 (an_obj)
			end
		end

	get_integer_64_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): INTEGER_64
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_64_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_integer_64 (an_obj)
			end
		end

	get_integer_64_array_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): ARRAY [INTEGER_64]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_integer_64_array (an_obj)
			end
		end

	get_integer_64_array_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : ARRAY [INTEGER_64]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_integer_64_array (an_obj)
			end
		end

	get_integer_64_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [INTEGER_64]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_integer_64_list (an_obj)
			end
		end

	get_integer_64_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [INTEGER_64]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_integer_64_list (an_obj)
			end
		end


	-- MT_S32 --	
	get_integer_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): INTEGER
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_integer (an_obj)
			end
		end

	get_integer_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): INTEGER
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_integer (an_obj)
			end
		end

	get_integer_array_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): ARRAY [INTEGER]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_integer_array (an_obj)
			end
		end

	get_integer_array_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : ARRAY [INTEGER]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_integer_array (an_obj)
			end
		end

	get_integer_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [INTEGER]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_integer_list (an_obj)
			end
		end

	get_integer_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [INTEGER]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_integer_list (an_obj)
			end
		end

	-- MT_S16 --	
	get_short_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): INTEGER
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_short (an_obj)
			end
		end

	get_short_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): INTEGER_16
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_16_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_short (an_obj)
			end
		end

	get_short_array_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : ARRAY [INTEGER_16]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_short_array (an_obj)
			end
		end

	get_short_array_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): ARRAY [INTEGER_16]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_short_array (an_obj)
			end
		end

	get_short_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [INTEGER_16]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_short_list (an_obj)
			end
		end

	get_short_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [INTEGER_16]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_short_list (an_obj)
			end
		end


	-- MT_U8 --	
	get_byte_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : INTEGER
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_byte (an_obj)
			end
		end

	get_byte_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : NATURAL_8
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := natural_8_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_byte (an_obj)
			end
		end

	get_byte_array_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : ARRAY [NATURAL_8]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_byte_array (an_obj)
			end
		end

	get_byte_array_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : ARRAY [NATURAL_8]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_byte_array (an_obj)
			end
		end

	get_byte_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : ARRAY[NATURAL_8]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_byte_list (an_obj)
			end
		end

	get_byte_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : ARRAY[NATURAL_8]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_byte_list (an_obj)
			end
		end

	get_byte_list_elements_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER;
			buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := integer_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_byte_list_elements (an_obj, buffer, count, offset)
			end
		end

	-- MT_NUMERIC --
	get_decimal_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): DECIMAL
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_decimal (an_obj)
			end
		end

	get_decimal_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): DECIMAL
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_decimal (an_obj)
			end
		end

	get_decimal_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING): LINKED_LIST [DECIMAL]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_decimal_list (an_obj)
			end
		end

	get_decimal_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER): LINKED_LIST [DECIMAL]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_decimal_list (an_obj)
			end
		end

	-- MT_FLOAT --
	get_real_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : REAL
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := real_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_real (an_obj)
			end
		end

	get_real_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : REAL
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := real_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_real (an_obj)
			end
		end

	get_real_array_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : ARRAY [REAL]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_real_array (an_obj)
			end
		end

	get_real_array_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : ARRAY [REAL]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_real_array (an_obj)
			end
		end

	get_real_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : LINKED_LIST [REAL]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_real_list (an_obj)
			end
		end

	get_real_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : LINKED_LIST [REAL]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_real_list (an_obj)
			end
		end

	-- MT_DOUBLE --
	get_double_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : DOUBLE
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := double_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_double (an_obj)
			end
		end

	get_double_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : DOUBLE
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := double_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_double (an_obj)
			end
		end

	get_double_array_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : ARRAY [DOUBLE]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_double_array (an_obj)
			end
		end

	get_double_array_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : ARRAY [DOUBLE]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_double_array (an_obj)
			end
		end

	get_double_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : LINKED_LIST [DOUBLE]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_double_list (an_obj)
			end
		end

	get_double_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : LINKED_LIST [DOUBLE]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_double_list (an_obj)
			end
		end

	-- MT_CHAR --
	get_char_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : CHARACTER
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := character_field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_character (an_obj)
			end
		end

	get_char_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : CHARACTER
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result := character_field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_character (an_obj)
			end
		end

	-- MT_STRING --
	get_string_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : STRING
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_string (an_obj)
			end
		end

	get_string_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : STRING
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_string (an_obj)
			end
		end

	get_string_array_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : ARRAY [STRING]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_string_array (an_obj)
			end
		end

	get_string_array_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : ARRAY [STRING]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_string_array (an_obj)
			end
		end

	get_string_list_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : LINKED_LIST [STRING]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_string_list (an_obj)
			end
		end

	get_string_list_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : LINKED_LIST [STRING]
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_string_list (an_obj)
			end
		end

	-- MT_STRING (UTF8) --
	get_string_utf8_value_of_object_by_name (an_obj: MT_STORABLE; attr_name: STRING) : UC_STRING
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			attr := c.get_attribute_by_name (attr_name, an_obj)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (attr.eif_field_index, an_obj)
			else
				Result := attr.get_string_utf8 (an_obj)
			end
		end

	get_string_utf8_value_of_object_by_position (an_obj: MT_STORABLE; index: INTEGER) : UC_STRING
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)

			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				attr := c.get_attribute_by_position (index, an_obj)
				Result := attr.get_string_utf8 (an_obj)
			end
		end

feature
	set_attribute_value (an_obj: MT_STORABLE; field_index: INTEGER)
		-- Store the value of 'field_index'-th field of 'an_obj'
		local
			a_class: MT_CLASS
		do
			a_class := mt_class_from_object (an_obj)
			a_class.init_properties (an_obj)
			a_class.attributes.item (field_index).set_value (an_obj)
		end

	set_char_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_character (an_obj)
		end

	set_boolean_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_boolean (an_obj)
		end

	set_boolean_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_boolean_list (an_obj)
		end

	set_date_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_date (an_obj)
		end

	set_date_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_date_list (an_obj)
		end

	set_timestamp_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_timestamp (an_obj)
		end

	set_timestamp_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_timestamp_list (an_obj)
		end

	set_time_interval_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_time_interval (an_obj)
		end

	set_time_interval_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_time_interval_list (an_obj)
		end

	set_byte_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_byte (an_obj)
		end

	set_byte_array_by_position (an_obj: MT_STORABLE; field_index: INTEGER; mttype: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_byte_array (an_obj, mttype)
		end

	set_byte_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_byte_list (an_obj)
		end

	set_byte_list_elements_by_position (an_obj: MT_STORABLE; field_index: INTEGER;
			buffer: ARRAY [NATURAL_8]; buffer_size: INTEGER; offset: INTEGER; discard_after: BOOLEAN)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_byte_list_elements (an_obj, buffer, buffer_size, offset, discard_after)
		end

  -- MT_S16, MT_SHORT --
	set_short_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_short (an_obj)
		end

	set_short_array_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_short_array (an_obj)
		end

	set_short_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_short_list (an_obj)
		end

  -- MT_S32, MT_INTEGER --
	set_integer_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_integer (an_obj)
		end

	set_integer_array_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_integer_array (an_obj)
		end

	set_integer_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_integer_list (an_obj)
		end

  -- MT_LONG --
  	set_integer_64_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_integer_64 (an_obj)
		end

	set_integer_64_array_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_integer_64_array (an_obj)
		end

	set_integer_64_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_integer_64_list (an_obj)
		end

  -- MT_NUMERIC --
	set_decimal_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_decimal (an_obj)
		end

	set_decimal_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_decimal_list (an_obj)
		end

  -- MT_STRING --
	set_string_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_string (an_obj, {MT_TYPE}.Mt_string)
		end

	set_string_array_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_string_array (an_obj, {MT_TYPE}.Mt_string_array)
		end

	set_string_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_string_list (an_obj, {MT_TYPE}.Mt_string_list)
		end

	-- MT_STRING (UTF8) --
	set_string_utf8_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_string_utf8 (an_obj, {MT_TYPE}.Mt_string)
		end

	set_text_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_string (an_obj, {MT_TYPE}.Mt_text)
		end

	set_double_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_double (an_obj)
		end

	set_double_array_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_double_array (an_obj)
		end

	set_double_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_double_list (an_obj)
		end

	set_real_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_real (an_obj)
		end

	set_real_array_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_real_array (an_obj)
		end

	set_real_list_by_position (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			c: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			c := mt_class_from_object (an_obj)
			attr := c.get_attribute_by_position (field_index, an_obj)
			attr.set_real_list (an_obj)
		end

feature
	remove_value_by_name (an_obj: MT_STORABLE; attr_name: STRING)
			-- Remove a value of field named `attr_name'.
		local
			a_class: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			a_class := mt_class_from_object (an_obj)
			attr := a_class.get_attribute_by_name (attr_name, an_obj)
			attr.remove_value (an_obj)
		end

	remove_value_by_position (an_obj: MT_STORABLE; index: INTEGER)
			-- Remove a value of field positioned at `index'.
		local
			a_class: MT_CLASS
			attr: MT_ATTRIBUTE
		do
			a_class := mt_class_from_object (an_obj)
			a_class.init_properties (an_obj)
			attr := a_class.get_attribute_by_position (index, an_obj)
			attr.remove_value (an_obj)
		end

feature -- Successors & Predecessors

	get_rs_successors_by_name (an_obj: MT_STORABLE; rs_name: STRING) : MT_RS_CONTAINABLE
		local
			c: MT_CLASS
			rs: MT_RELATIONSHIP
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			rs := c.get_relationship_by_name (rs_name, an_obj)
			Result := rs.successors_of (an_obj)
		end

	get_rs_successors_by_position (an_obj: MT_STORABLE; index: INTEGER) : MT_RS_CONTAINABLE
		local
			c: MT_CLASS
			rs: MT_RELATIONSHIP
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				rs := c.relationships.item (index)
				Result := rs.successors_of (an_obj)
			end
		end

	get_rs_successor_by_name (an_obj: MT_STORABLE; rs_name: STRING) : MT_STORABLE
		local
			c: MT_CLASS
			rs: MT_RELATIONSHIP
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			rs := c.get_relationship_by_name (rs_name, an_obj)
			Result := rs.first_successor (an_obj)
		end

	get_rs_successor_by_position (an_obj: MT_STORABLE; index: INTEGER) : MT_STORABLE
		local
			c: MT_CLASS
			rs: MT_RELATIONSHIP
		do
			c := mt_class_from_object (an_obj)
			c.init_properties (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
			if an_obj.persister = Void then
				-- an_obj does not exist in the database
				Result ?= field (index, an_obj)
			else
				rs := c.relationships.item (index)
				Result := rs.first_successor (an_obj)
			end
		end

  get_rs_predecessor_by_name (an_obj: MT_STORABLE; rs_name: STRING) : MT_STORABLE
		local
			c: MT_CLASS
      c_name: ANY
      preds: ARRAY [INTEGER]
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
      c_name := rs_name.to_c
			preds := mtdb.context.get_predecessors_by_name ( an_obj.oid, $c_name)
      if preds.count > 0 then
        Result := eif_object_from_oid (preds.item(1))
      end
		end

  get_rs_predecessors_by_name (an_obj: MT_STORABLE; rs_name: STRING) : ARRAY[MT_STORABLE]
		local
			c: MT_CLASS
      c_name: ANY
      preds: ARRAY [INTEGER]
      i, num: INTEGER
		do
			c := mt_class_from_object (an_obj)
			clear_all_properties_when_obsolete (an_obj, c)
      c_name := rs_name.to_c
			preds := mtdb.context.get_predecessors_by_name ( an_obj.oid, $c_name)
      num := preds.count
      create Result.make (1, num)
      from
        i := 1
      until
        i > num
      loop
        Result.put (eif_object_from_oid (preds.item(i)), i)
        i := i + 1
      end
		end

	set_single_successor (an_obj: MT_STORABLE; field_index: INTEGER)
		local
			a_class: MT_CLASS
		do
			a_class := mt_class_from_object (an_obj)
			a_class.init_properties (an_obj)
			a_class.relationships.item (field_index).set_successors_of (an_obj)
		end

	append_successor (a_predecessor: MT_STORABLE; field_index: INTEGER; new_successor: MT_STORABLE)
		local
			a_class: MT_CLASS
		do
			a_class := mt_class_from_object (a_predecessor)
			a_class.init_properties (a_predecessor)
			a_class.relationships.item (field_index).append_successor (a_predecessor, new_successor)
		end

	reload_successors (obj: MT_STORABLE; rid: INTEGER) is
			-- force reloading successor(s) for relationthip specified by rid
		require
			not_void: obj /= Void
		local
			myclass: MT_CLASS
			rshp: MT_RELATIONSHIP
		do
			myclass := mt_class_from_object (obj)
			rshp := myclass.get_relationship_by_oid (rid, obj)

			-- reload successors only when inverse relationship is not read-only
			if rshp /= Void then
				rshp.reload_successors (obj)
			end
		end

	reload_successors_after_delete (an_obj: MT_STORABLE; inv_rshp_and_preds: ARRAY[TUPLE[INTEGER, ARRAY[MT_STORABLE]]]) is
			-- an_obj is just deleted (i.e., an_obj.mt_remove). Reload successors of all the relationships in which an_obj participated as a successor
		require
			not_void: an_obj /= Void
		local
			myclass: MT_CLASS
			relationships: ARRAY [MT_RELATIONSHIP]
			curr_succs, preds: ARRAY [MT_STORABLE]
			rel : MT_RELATIONSHIP
			i, j, upper, upper2, inv_rshp: INTEGER
			a_tuple: TUPLE [INTEGER, ARRAY[MT_STORABLE]]
		do
			myclass := mt_class_from_object (an_obj)

			-- update predecessors that are accessible from an_obj
			relationships := myclass.relationships
			upper := relationships.upper
			from
				i :=  relationships.lower
			until
				i > upper
			loop
				rel := relationships.item (i)
				if rel /= Void then
					curr_succs := rel.current_successors_of (an_obj)
					upper2 := curr_succs.upper
					from
						j := curr_succs.lower
					until
						j > upper2
					loop
						if curr_succs.item (j) /= Void then
							reload_successors (curr_succs.item (j), rel.inverse_relationship)
						end
						j := j + 1
					end
				end
				i := i + 1
			end

			-- update predecessors that are accessible only through read-only relationship
			upper := inv_rshp_and_preds.upper
			from
				i := inv_rshp_and_preds.lower
			until
				i > upper
			loop
				a_tuple := inv_rshp_and_preds.item (i)
				if a_tuple /= Void then
					inv_rshp := a_tuple.integer_item (1)
					preds ?= a_tuple.reference_item (2)
					if preds /= Void then
						upper2 := preds.upper
						from
							j := preds.lower
						until
							j > upper2
						loop
							if preds.item (j) /= Void then
								preds.item (j).mt_reload_successors (inv_rshp)
							end
							j := j + 1
						end
					end
				end
				i := i + 1
			end
		end

	predecessors_thru_readonly_rshp (an_obj: MT_STORABLE): ARRAY[TUPLE[INTEGER, ARRAY[MT_STORABLE]]] is
			-- Returns predecessor objects for an_obj that are already in the object table (i.e., retrieved)
			-- TUPLE is {oid_of_inverse_relationship, ARRAY[MT_STORABLE)}
		require
			not_void: an_obj /= Void
		local
			myclass: MT_CLASS
			readonly_rshps: ARRAY [MT_RELATIONSHIP]
			preds: ARRAY [MT_STORABLE]
			i, upper: INTEGER
			a_pair: TUPLE [INTEGER, ARRAY[MT_STORABLE]]
		do
			myclass := mt_class_from_object (an_obj)
			readonly_rshps := myclass.inverse_relationships
			Create Result.make (readonly_rshps.lower, readonly_rshps.upper)
			upper := readonly_rshps.upper
			from
				i := readonly_rshps.lower
			until
				i > upper
			loop
				if readonly_rshps.item(i) /= Void then
					Create a_pair
					a_pair.put_integer (readonly_rshps.item(i).inverse_relationship, 1)
					preds := an_obj.current_predecessors_by_oid (readonly_rshps.item(i).inverse_relationship)
					a_pair.put_reference (preds, 2)
					Result.enter (a_pair, i)
				end
				i := i + 1
			end

		end


feature -- Status

	set_state (a_state: INTEGER)
			-- Set the latest state on db session controller
		do
		end

	invalid_object: MT_STORABLE
			-- Returns the object that caused the problem at the last commit time
		local
			retried: BOOLEAN
		do
			if not retried then
				Result := eif_object_from_oid (mtdb.context.get_invalid_object())
			else
				Result := Void
			end
		rescue
			retried := True
		end

	is_tran_or_version_open: BOOLEAN
		do
			--	Result := session_state = {MT_DATABASE}.Mt_Transaction or session_state =
			--	{MT_DATABASE}.Mt_Version
			-- Result := mtdb.is_transaction_in_progress () or mtdb.is_version_access_in_progress ()
			Result := in_tran_or_version
		end

feature -- Transaction

	flush_updated_objects
		do
			store_dirty_object_attributes
			store_dirty_object_relationships
			store_dirty_container
		end

	store_dirty_container
		local
			count, total: INTEGER
			a_container: MT_CONTAINER_OBJECT
		do
			total := container_modified_set.count
			from
				container_modified_set.start
			until
				count = total
			loop
				if container_modified_set.item /= 0 then
					count  := count + 1
					a_container ?= identifier.id_object (eif_object_table.item (container_modified_set.item))
					if a_container /= Void then
						a_container.store_updates
					end
				end
				container_modified_set.forth
			end
		end

	store_dirty_object_attributes
		local
			an_oid, count, total_count: INTEGER
			obj: MT_STORABLE
		do
			total_count := attr_modified_set.count
			count := 0
			from
				attr_modified_set.start
			until
				count = total_count
			loop
				an_oid := attr_modified_set.item
				if an_oid /= 0 then
					obj ?= identifier.id_object(eif_object_table.item (an_oid))
					store_values_of_attributes (obj)
					count := count + 1
					io.new_line
					io.putint (an_oid)
				end
				attr_modified_set.forth
			end
		end

	store_values_of_attributes (an_object: MT_STORABLE)
		-- Store values of all attributes
		require
			not_void: an_object /= Void
		local
			a_mt_class: MT_CLASS
			attributes: ARRAY [MT_ATTRIBUTE]
			index: INTEGER
			ex: MT_EXCEPTIONS
		do
			a_mt_class := mt_schema.item (dynamic_type (an_object))
      if a_mt_class = Void then
      	create ex
        ex.raise (Class_not_found_error_message);
      end

			a_mt_class.init_properties (an_object)
			attributes := a_mt_class.attributes
			from
				index := attributes.lower
			until
				index > attributes.upper
			loop
				if attributes.item (index) /= Void then
					attributes.item (index).set_value (an_object)
				end
				index := index + 1
			end
		end

	store_dirty_object_relationships
		local
			an_oid, count, total_count: INTEGER
			obj: MT_STORABLE
		do
			total_count := rl_modified_set.count
			count := 0
			from
				rl_modified_set.start
			until
				count = total_count
			loop
				an_oid := rl_modified_set.item
				if an_oid /= 0 then
					obj ?= identifier.id_object(eif_object_table.item (an_oid))
					store_successors_of_relationships (obj)
					count := count + 1
				end
				rl_modified_set.forth
			end
		end

	store_successors_of_relationships (an_object: MT_STORABLE)
		-- Store successors of all relationships
		require
			not_void: an_object /= Void
		local
			a_mt_class: MT_CLASS
			relationships: ARRAY [MT_RELATIONSHIP]
			i: INTEGER
			exptn: MT_EXCEPTIONS
		do
			a_mt_class := mt_schema.item (dynamic_type (an_object))
      		if a_mt_class = Void then
      			create exptn
        		exptn.raise (Class_not_found_error_message);
      		end

			a_mt_class.init_properties (an_object)
			relationships := a_mt_class.relationships
			from
				i := relationships.lower
			until
				i > relationships.upper
			loop
				if relationships.item (i) /= Void then
					relationships.item (i).set_successors_of (an_object)
				end
				i := i + 1
			end
		end

feature -- Locking

	lock_composite (an_object: MT_STORABLE; a_lock: INTEGER)
		local
			a_class: MT_CLASS
			relationships: ARRAY [MT_RELATIONSHIP]
			co_rel: MT_COMPOSITE_RELATIONSHIP
			s_co_rel: MT_SINGLE_COMPOSITE_RELATIONSHIP
			m_co_rel: MT_MULTI_COMPOSITE_RELATIONSHIP
			i: INTEGER
			a_storable: MT_STORABLE
			linear_collection: MT_LINEAR_COLLECTION [MT_STORABLE]
			linear_rep: LINEAR [MT_STORABLE]
			rs_containable: MT_RS_CONTAINABLE
		do
			an_object.lock (a_lock)
			a_class := mt_class_from_object (an_object)
			a_class.init_properties (an_object)
			relationships := a_class.relationships
			from
				i := relationships.lower
			until
				i > relationships.upper
			loop
				co_rel ?= relationships.item (i)
				if co_rel /= Void then
					s_co_rel ?= co_rel
					if s_co_rel /= Void then
						a_storable ?= field (s_co_rel.eif_field_index, an_object)
						if a_storable /= Void then
							lock_composite (a_storable, a_lock)
						else
							a_storable := s_co_rel.first_successor (an_object)
							if a_storable /= Void then
								lock_composite (a_storable, a_lock)
							end
						end
					else
						m_co_rel ?= co_rel
						linear_collection ?= field (m_co_rel.eif_field_index, an_object)
						if linear_collection /= Void then
							rs_containable ?= linear_collection
							rs_containable.load_successors
							linear_rep := linear_collection.linear_representation
							from
								linear_rep.start
							until
								linear_rep.off
							loop
								lock_composite (linear_rep.item, a_lock)
								linear_rep.forth
							end
						end
					end
				end
				i := i + 1
			end
		end

feature -- Clone

	copy_object (object: MT_STORABLE): MT_STORABLE
			-- Create a new transient object copying `object'
		do
			Result := object.deep_twin
			clear_oids (Result)
		end

feature {MT_DATABASE, MT_PROPERTY, MT_LINEAR_COLLECTION} -- Subscription

	set_subscription_manager (a_manager: MT_SUBSCRIPTION_MANAGER)
		require
			not_void: a_manager /= Void
		do
			subscription_manager := a_manager
		end

	subscription_manager: MT_SUBSCRIPTION_MANAGER

	is_managing_subscription: BOOLEAN
		do
			Result := subscription_manager /= Void
		end

	notify_attribute_update (obj: MT_STORABLE; property: MT_ATTRIBUTE)
		-- If we're managing subscription, issue a notification to the subscription manager
		require
			not_void: obj /= Void and property /= Void
		do
			if is_managing_subscription then
				subscription_manager.notify_property_updated (obj, property.oid)
			end
		end

	notify_relationship_update (obj: MT_STORABLE; property: MT_RELATIONSHIP)
		-- If we're managing subscription, issue a notification to the subscription manager
		require
			not_void: obj /= Void and property /= Void
		do
			if is_managing_subscription then
				subscription_manager.notify_property_updated (obj, property.oid)
			end
		end

	notify_irelationship_update (obj: MT_STORABLE; ir_oid: INTEGER)
		-- If we're managing subscription, issue a notification to the subscription manager.
		-- Note: we need a different routine from notify_relationship_update simply because
		-- we hold only OID for inverse relationship currently.
		require
			not_void: obj /= Void
		do
			if is_managing_subscription then
				subscription_manager.notify_property_updated (obj, ir_oid)
			end
		end

feature -- Implementation

	version_number: INTEGER

feature {NONE} -- Implementation	

	clear_oids (object: MT_STORABLE)
			-- Make `object' transient,
		local
			relationships: ARRAY [MT_RELATIONSHIP]
			s_rel: MT_SINGLE_RELATIONSHIP
			m_rel: MT_MULTI_RELATIONSHIP
			i: INTEGER
			its_class: MT_CLASS
			a_storable: MT_STORABLE
			linear_collection: MT_LINEAR_COLLECTION [MT_STORABLE]
			linear_rep: LINEAR [MT_STORABLE]
			rs_containable: MT_RS_CONTAINABLE
		do
			if object.oid /= 0 then
				its_class := mt_class_from_object (object)
				its_class.init_properties (object)
				relationships := its_class.relationships
				from
					i :=  relationships.lower
				until
					i > relationships.upper
				loop
					s_rel ?= relationships.item (i)
					m_rel ?= relationships.item (i)
					if s_rel /= Void then
						a_storable ?= field (s_rel.eif_field_index, object)
						if a_storable /= Void then
							clear_oids (a_storable)
						else
							a_storable := s_rel.first_successor (object)
							if a_storable /= Void then
								clear_oids (a_storable)
							end
						end
					elseif m_rel /= Void then
						linear_collection ?= field (m_rel.eif_field_index, object)
						if linear_collection /= Void then
							rs_containable ?= linear_collection
							rs_containable.load_successors
							linear_rep := linear_collection.linear_representation
							from
								linear_rep.start
							until
								linear_rep.off
							loop
								clear_oids (linear_rep.item)
								linear_rep.forth
							end
						end
					end
					i := i + 1
				end
			end
		end


	oids_of_all_classes: ARRAY [INTEGER]
		local
			num_classes: INTEGER
			to_c: ANY
		do
			num_classes := mtdb.context.get_classes_count ()
			create Result.make (1, num_classes)
			to_c := Result.to_c
			mtdb.context.get_oids_of_classes ( num_classes, $to_c)
		end

	clear_all_properties_when_obsolete (an_obj: MT_STORABLE; its_class: MT_CLASS)
			-- If an_obj is obsolete,
			-- first, check if the object still exist in the database.
			-- if it still exists, set all attributes' values to default value and
			-- wipe out all successors.
			-- Note an object retrieved from the database in a transaction will become
			-- obsolete if the object still exists in the application when a next transaction
			-- or version access starts and it has different logical time.
		do
			if an_obj.is_obsolete then
				-- Does the object still exist in the database?
				if mtdb.context.mt_oid_exist ( an_obj.oid) then
					clear_all_properties (an_obj, its_class)
					an_obj.set_version (version_number) -- become up-to-date
					an_obj.relationships_unloaded
					an_obj.attributes_unloaded
				else
					remove_non_existent_object_from_cache (an_obj)
				end
			end
		end

	clear_all_properties (an_obj: MT_STORABLE; its_class: MT_CLASS)
		require
			properties_initialized: its_class.properties_initialized
		local
			attributes: ARRAY [MT_ATTRIBUTE]
			relationships: ARRAY [MT_RELATIONSHIP]
			att: MT_ATTRIBUTE
			rel: MT_RELATIONSHIP
			i, upper: INTEGER
		do
			attributes := its_class.attributes
			upper := attributes.upper
			from
				i := attributes.lower
			until
				i > upper
			loop
				att := attributes.item (i)
				if att /= Void then
					att.revert_to_unloaded (an_obj)
				end
				i := i + 1
			end

			relationships := its_class.relationships
			upper := relationships.upper
			from
				i :=  relationships.lower
			until
				i > upper
			loop
				rel := relationships.item (i)
				if rel /= Void then
					rel.revert_to_unloaded (an_obj)
				end
				i := i + 1
			end
		end

	remove_non_existent_object_from_cache (an_obj: MT_STORABLE)
			-- an_obj is still in current's cache, but it does not
			-- exist in the database any more. Remove an_obj from the
			-- cache and make it transient.
		require
			obj_not_exist_in_db: not mtdb.context.mt_oid_exist ( an_obj.oid)
			obj_still_in_cache: has (an_obj)
		do
			eif_object_table.remove (an_obj.oid)
			an_obj.set_persister (Void)
		end

feature {MT_RS_CONTAINABLE} -- Object life cycle

	clear_all_properties_when_obsolete_wo_class (an_obj: MT_STORABLE)
			-- Same as clear_all_properties_when_obsolete except that this
			-- does not take second argument of type MT_CLASS.
		local
			its_class: MT_CLASS
		do
			if an_obj.is_obsolete then
				-- Does the object still exist in the database?
				if mtdb.context.mt_oid_exist ( an_obj.oid) then
					its_class := mt_class_from_object (an_obj)
					clear_all_properties (an_obj, its_class)
					an_obj.set_version (version_number) -- become up-to-date
					an_obj.relationships_unloaded
					an_obj.attributes_unloaded
				else
					remove_non_existent_object_from_cache (an_obj)
				end
			end
		end

end -- class MT_PERSISTER

