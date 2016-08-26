note
	description: "MATISSE-Eiffel Binding: define Matisse MtClass meta-class"
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
	MT_CLASS

inherit
	MT_METASCHEMA
		rename
			is_ok as check_instance,
			copy as identified_copy
		redefine
			predefined_eif_field
		select
			is_equal,
			identified_copy
		end

	OPERATING_ENVIRONMENT
		rename
			is_equal as general_is_equal
		export
			{NONE} all
		end

	MT_EXCEPTIONS
		rename
			is_equal as general_is_equal
		export
			{NONE} all
		end
	EXECUTION_ENVIRONMENT
		undefine
			is_equal
		end

create
	--make_from_mtobject,
	make_from_object, make_from_oid_and_db,
	make_from_name_with_db

feature -- Meta-Schema Class names

	MT_CLASS_NAME: STRING =                  "MtClass"
	MT_OBJECT_NAME: STRING =                 "MtObject"
	MT_ATTRIBUTE_NAME: STRING =              "MtAttribute"
	MT_RELATIONSHIP_NAME: STRING =           "MtRelationship"
	MT_TYPE_NAME: STRING =                   "MtType"
	MT_DOMAIN_NAME: STRING =                 "MtDomain"
	MT_INDEX_NAME: STRING =                  "MtIndex"
	MT_ENTRY_POINT_DICTIONARY_NAME: STRING = "MtEntryPointDictionary"
	MT_METHOD_NAME: STRING =                 "MtMethod"
	MT_TRIGGER_NAME: STRING =                "MtTrigger"


--feature {MTOBJECT} -- Initialization

--	make_from_mtobject (one_object: MTOBJECT)
			-- Get class from object id
--		do
--			mtdb := one_object.get_mtdatabase ()
--			oid := mtdb.context.get_object_class ( one_object.oid)
--		end

feature {NONE} -- Initialization

	make_from_object (one_object: MT_STORABLE)
			-- Get class from object id
		do
			mtdb := one_object.mtdb
			oid := mtdb.context.get_object_class ( one_object.oid)
		end

	make_from_oid_and_db (a_oid: INTEGER; a_db: MT_DATABASE) is
			-- Make object from oid and a_db
		require
			a_db_not_void: a_db /= Void
		do
			persister ?= a_db.persister
			mtdb := a_db
			make_from_oid (a_oid)
		end


	make_from_name_with_db (a_class_name: STRING; a_db: MT_DATABASE)
			-- Get class id from database and fills its name.
		require
			string_not_void: a_class_name /= Void
			string_not_empty: not a_class_name.is_empty
			db_not_void: a_db /= Void
		local
			class_name_to_c: ANY
		do
			persister ?= a_db.persister
			mtdb := a_db
			class_name_to_c := a_class_name.to_c
			oid := mtdb.context.get_class_from_name ( $class_name_to_c)
		end

feature  -- Access

	instance_number, instance_count, instances_count: INTEGER
			-- Count instances of current class in database
		do
			Result := mtdb.context.get_instances_number ( oid)
		end

	own_instance_number, own_instance_count, own_instances_count: INTEGER
			-- Count instances of current class in database
		do
			Result := mtdb.context.get_own_instances_number ( oid)
		end

	instance_iterator, instances_iterator (num_preftech: INTEGER): MT_OBJECT_ITERATOR[MT_STORABLE]
		-- Open an iterator on the intances of this class and all subclasses
		local
			c_stream : INTEGER
		do
			c_stream := mtdb.context.open_instances_stream ( oid, num_preftech)
			create Result.make(c_stream, mtdb)
		end


	own_instance_iterator, own_instances_iterator (num_preftech: INTEGER): MT_OBJECT_ITERATOR[MT_STORABLE]
		-- Open an iterator on the intances of this class only (excluding all subclasses)
		local
			c_stream : INTEGER
		do
			c_stream := mtdb.context.open_own_instances_stream ( oid, num_preftech)
			create Result.make(c_stream, mtdb)
		end

	eiffel_type_id: INTEGER
			-- Return dynamic type id of Eiffel class corresponding to Current
		local
			c_class_name: ANY
		do
			c_class_name := name.to_c
			Result := {MT_NATIVE}.c_get_eif_type_id ($c_class_name, False)
		end

	attributes: ARRAY [MT_ATTRIBUTE]
			-- Before call this function, call init_properties to
			-- initialize attributes and relationships
		require
			properties_initialized: properties_initialized
		do
			Result := saved_attributes
		end


	get_attributes: ARRAY [MT_ATTRIBUTE]
			-- Attributes of current class according to database schema
		local
			keys_count, i: INTEGER
			one_attribute: MT_ATTRIBUTE
			buffer: ARRAY[INTEGER]
			to_c: ANY
		do
			keys_count := mtdb.context.get_attributes_count ( oid)
			create buffer.make (1, keys_count)
			to_c := buffer.to_c
			mtdb.context.get_all_attributes ( oid, keys_count, $to_c)
			create Result.make (1, keys_count)
			from
				i := 1
			until
				i= keys_count + 1
			loop
				create one_attribute.make_from_id (persister.mtdb, buffer.item (i))
				Result.force (one_attribute, i)
				i := i + 1
			end -- loop
		end -- attributes

	get_attribute_by_position (index: INTEGER; an_obj: MT_STORABLE): MT_ATTRIBUTE
		do
			init_properties (an_obj)
			Result := attributes.item (index)
			if Result = Void then
				trigger_dev_exception (100004, "Invalid attribute position")
			end
		end

	get_attribute_by_name (attr_name: STRING; an_obj: MT_STORABLE): MT_ATTRIBUTE
			-- Find an attribute using name. Name follows either Eiffel field name ("name")
			-- or MATISSE name ("PERSON::name", or "name"). Name mangling does not matter.
			-- Eiffel field name is recommended.
			-- (If nothing is found, Void is returned).
		local
			i, att_oid: INTEGER
			attr: MT_ATTRIBUTE
			name_to_c: ANY
		do
			init_properties (an_obj)
			from
				i := attributes.lower
			until
				i > attributes.upper or Result /= Void
			loop
				attr := attributes.item (i)
				if attr /= Void then
					if attr.eiffel_name.is_equal (attr_name) then
						Result := attr
					end
				end
				i := i + 1
			end

			if Result = Void then
				-- 'attr_name' may be the form of "CLASS__attribute"
				name_to_c := attr_name.to_c
				att_oid := mtdb.context.get_attribute ( $name_to_c)
				from
					i := attributes.lower
				until
					i > attributes.upper or Result /= Void
				loop
					attr := attributes.item (i)
					if attr /= Void then
						if attr.oid = att_oid then
							Result := attr
						end
					end
					i := i + 1
				end
			end
			if Result = Void then
				trigger_dev_exception (100003, "Invalid attribute name")
			end
		end

	relationships: ARRAY [MT_RELATIONSHIP]
			-- Before call this function, call init_properties to
			-- initialize attributes and relationships
		require
			properties_initialized: properties_initialized
		do
			Result := saved_relationships
		end

	get_relationships : ARRAY [MT_RELATIONSHIP]
			-- Relationships of current class according to database schema
		local
			keys_count, i: INTEGER
			one_relationship: MT_RELATIONSHIP
			buffer: ARRAY[INTEGER]
			to_c: ANY
		do

			keys_count := mtdb.context.get_relationships_count ( oid)
			create buffer.make (1, keys_count)
			to_c := buffer.to_c
			mtdb.context.get_all_relationships ( oid, keys_count, $to_c)
			create Result.make (1, keys_count)
			from
				i := 1
			until
				i= keys_count + 1
			loop
				create one_relationship.make_from_id (persister.mtdb, buffer.item (i))
				Result.force (one_relationship, i)
				i := i + 1
			 end -- loop
		end

	get_relationship_by_position (index: INTEGER; an_obj: MT_STORABLE): MT_RELATIONSHIP
		do
			init_properties (an_obj)
			Result := relationships.item (index)
			if Result = Void then
				trigger_dev_exception (100004, "Invalid relationship position")
			end
		end

	get_relationship_by_name (rs_name: STRING; an_obj: MT_STORABLE): MT_RELATIONSHIP
			-- Find an relationship using name. Name follows
			-- MATISSE convention.
			-- (If nothing is found, Void is returned).
		local
			i, rs_oid: INTEGER
			rs: MT_RELATIONSHIP
			name_to_c: ANY
		do
			init_properties (an_obj)
			from
				i := relationships.lower
			until
				i > relationships.upper or Result /= void
			loop
				rs := relationships.item (i)
				if rs /= void then
					if rs.eiffel_name.is_equal (rs_name) then
						Result := rs
					end
				end
				i := i + 1
			end
			if Result = Void then
				name_to_c := rs_name.to_c
				rs_oid := mtdb.context.get_relationship_from_name ( $name_to_c)
				from
					i := relationships.lower
				until
					i > relationships.upper or Result /= Void
				loop
					rs := relationships.item (i)
					if rs /= Void then
						if rs.oid = rs_oid then
							Result := rs
						end
					end
					i := i + 1
				end
			end
			if Result = Void then
				trigger_dev_exception (100005, "Invalid relationship name")
			end
		end


	get_relationship_by_oid (rs_oid: INTEGER; an_obj: MT_STORABLE): MT_RELATIONSHIP is
			-- Find an relationship using OID.
			-- (If nothing is found, Void is returned).
		local
			i: INTEGER
			rs: MT_RELATIONSHIP
		do
			init_properties (an_obj)
			from
				i := relationships.lower
			until
				i > relationships.upper or Result /= void
			loop
				rs := relationships.item (i)
				if rs /= void then
					if rs.oid = rs_oid then
						Result := rs
					end
				end
				i := i + 1
			end
		end

	inverse_relationships: ARRAY [MT_RELATIONSHIP]
			-- Inverse relationships of current class according to database schema.
		local
			keys_count, i: INTEGER
			one_object: MT_RELATIONSHIP
			buffer: ARRAY[INTEGER]
			to_c: ANY
			debug_message: STRING
		do
			keys_count := mtdb.context.get_inverse_relationships_count ( oid)
			create buffer.make (1, keys_count)
			to_c := buffer.to_c
			debug ("inverse_relationships_multithreaded")
				io.put_string (oid.out + "calling mtdb.context.get_all_inverse_relationships%N")
			end
			mtdb.context.get_all_inverse_relationships ( oid, keys_count, $to_c)
			debug ("inverse_relationships_multithreaded")
				debug_message := oid.out + ": keys_count: " + keys_count.out + "; Inverse Relationship Oids: "
				buffer.do_all (agent (an_integer: INTEGER; a_message: STRING) do a_message.append (an_integer.out + "|") end (?, debug_message))
				io.put_string (debug_message + "%N")
			end
			create Result.make (1, keys_count)
			from
				i := 1
			until
				i= keys_count + 1
			loop
				create one_object.make_from_id (persister.mtdb, buffer.item (i))
				Result.force (one_object, i)
				i := i + 1
			end
		end

	subclasses: ARRAY [MT_CLASS]
			-- Subclasses of current class
		local
			keys_count, i: INTEGER
			one_object: MT_CLASS
			buffer: ARRAY[INTEGER]
			to_c: ANY
		do
			keys_count := mtdb.context.get_subclasses_count ( oid)
			create buffer.make (1, keys_count)
			to_c := buffer.to_c
			mtdb.context.get_all_subclasses ( oid, keys_count, $to_c)
			create Result.make (1, keys_count)
			from
				i := 1
			until
 				i = keys_count + 1
			loop
				create one_object.make_from_oid_and_db (buffer.item (i), persister.mtdb)
 				Result.force (one_object, i)
				i := i + 1
			end
		end

	superclasses: ARRAY [MT_CLASS]
			-- Superclasses of current class
		local
			keys_count, i: INTEGER
			one_object: MT_CLASS
			buffer: ARRAY[INTEGER]
			to_c: ANY
		do
			keys_count := mtdb.context.get_superclasses_count ( oid)
			create buffer.make (1, keys_count)
			to_c := buffer.to_c
			mtdb.context.get_all_superclasses ( oid, keys_count, $to_c)
			create Result.make (1, keys_count)
			from
				i := 1
			until
				i= keys_count + 1
			loop
				create one_object.make_from_oid_and_db (buffer.item (i), persister.mtdb)
				Result.force (one_object, i)
				i := i + 1
			end
		end

	parents: ARRAY [MT_CLASS]
		-- Direct parents
		local
			a_stream: MT_RELATIONSHIP_STREAM
			a_class: MT_CLASS
			i: INTEGER
		do
			create a_stream.make_from_name (persister, Current, "MtSuperclasses")
			create Result.make (0, 1)
			from
				a_stream.start
				i := 0
			until
				a_stream.exhausted
			loop
				a_class ?= a_stream.item
				if a_class /= Void then
					Result.put (a_class, i)
					i := i + 1
				end
				a_stream.forth
			end
			a_stream.close
		end

	all_instances: ARRAY [MT_STORABLE]
		obsolete "Use {MT_CLASS}.instance_iterator"
		local
			a_stream: MT_CLASS_STREAM
			i: INTEGER
		do
			create Result.make (0, instances_count - 1)
			create a_stream.make (oid, persister.mtdb)
			from
				a_stream.start
				i := 0
			until
				a_stream.exhausted
			loop
				Result.put (a_stream.item, i)
				a_stream.forth
				i := i + 1
			end
			a_stream.close
		end

	n_first_instances (n: INTEGER): ARRAY [MT_STORABLE]
			-- array of `n' first instances of Current class
			-- or all if `n' > `instance_count'
		local
			a_stream: MT_CLASS_STREAM
			i: INTEGER
		do
			if n >= instances_count then
				Result := all_instances
			else
				create Result.make (0, n - 1)
				create a_stream.make (oid, persister.mtdb)
				from
					a_stream.start
					i := 0
				until
					a_stream.exhausted or i > n - 1
				loop
					Result.put (a_stream.item, i)
					a_stream.forth
					i := i + 1
				end
				a_stream.close
			end
		end


	all_index_names: ARRAYED_LIST [STRING]
			-- List of all index names for this class and its all ancesters.
		local
			i, j: INTEGER
			rel: MT_RELATIONSHIP
			an_obj: MT_STORABLE
			an_att: MT_ATTRIBUTE
			objs: ARRAY [MT_OBJECT]
			str: STRING
			supers: ARRAY [MT_CLASS]
		do
			create Result.make (0)
			create rel.make ("MtIndexes", persister.mtdb)
			create an_att.make ("MtName", persister.mtdb)

			supers := superclasses
			supers.force (Current, supers.upper + 1)
			from
				i := supers.lower
			until
				i > supers.upper
			loop
				create an_obj.make_from_oid (supers.item (i).oid)
				objs := an_obj.successors (rel)
				from
					j := objs.lower
				until
					j > objs.upper
				loop
					str := an_att.get_string (objs.item (j))
					if str /= Void then
						Result.extend (str)
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	oid_of_property (prop_name: STRING) : INTEGER
		local
			to_c: ANY
		do
			to_c := prop_name.to_c
			Result := mtdb.context.get_class_property_from_name ( $to_c, oid)
		end

feature -- Delete

	remove_all_instances()
			-- Remove all instances of current class in database
		local
			iter: MT_OBJECT_ITERATOR[MT_STORABLE]
			obj : MT_STORABLE
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


feature -- Attribute values loading and setting

	load_attr_values_of_object (an_object: MT_STORABLE)
		local
			i: INTEGER
			value: ANY
			each_attr: MT_ATTRIBUTE
			a_char: CHARACTER
			a_bool: BOOLEAN
			an_integer: INTEGER
			a_real: REAL
			a_double: DOUBLE
		do
			init_properties (an_object)

			from
				i := 1
			until
				i > attributes.count
			loop
				each_attr := attributes.item (i)
				if  each_attr /= Void then
					inspect each_attr.eif_field_type
					when Reference_type then
						value := each_attr.get_value (an_object)
						set_reference_field (each_attr.eif_field_index, an_object, value)
					when Character_type then
						a_char := each_attr.get_character (an_object)
						set_character_field (each_attr.eif_field_index, an_object, a_char)
					when Boolean_type then
						a_bool := each_attr.get_boolean (an_object)
						set_boolean_field (each_attr.eif_field_index, an_object, a_bool)
					when Integer_type then
						an_integer := each_attr.get_integer_type_value (an_object)
						set_integer_field (each_attr.eif_field_index, an_object, an_integer)
					when Real_type then
						a_real := each_attr.get_real (an_object)
						set_real_field (each_attr.eif_field_index, an_object, a_real)
					when Double_type then
						a_double := each_attr.get_double (an_object)
						set_double_field (each_attr.eif_field_index, an_object, a_double)
					else
					end
				end
				i := i + 1
			end
		end

	set_all_attribute_values (an_object: MT_STORABLE)
		local
			each_attr: MT_ATTRIBUTE
			i: INTEGER
		do
			init_properties (an_object)
			from
				i := 1
			until
				i > attributes.count
			loop
				each_attr := attributes.item (i)
				if  each_attr /= Void then
					each_attr.set_value (an_object)
				end
				i := i + 1
			end
		end

feature -- Relationship successors loading

	load_rs_successors_of_object (an_object: MT_STORABLE)
		local
			i: INTEGER
			each_rel: MT_RELATIONSHIP
			a_container: MT_RS_CONTAINABLE
		do
			init_properties (an_object)

			from
				i := 1
			until
				i > relationships.count
			loop
				each_rel := relationships.item (i)
				if  each_rel /= Void then
					if each_rel.is_single then
						set_reference_field (each_rel.eif_field_index,
										an_object,
										each_rel.first_successor (an_object))
					else
						a_container := each_rel.successors_of (an_object)
						a_container.load_successors
							-- value_conforms_to_field_static_type: value /= Void implies field_conforms_to (dynamic_type (value), field_static_type_of_type (i, dynamic_type (object)))

						-- io.put_string (type_name_of_type (dynamic_type (a_container)) + "; " + type_name_of_type (field_static_type_of_type (each_rel.eif_field_index, dynamic_type (an_object))) + "%N")
						set_reference_field (each_rel.eif_field_index, an_object, a_container)
					end
				end
				i := i + 1
			end
		end

feature {MT_PERSISTER} -- Meta-schema

	init_properties (sample_obj: MT_STORABLE)
			-- Set up each field of `sample_obj' if not already done.
		local
			attribute_table: HASH_TABLE [MT_ATTRIBUTE, STRING]
			i, keys_count, an_oid: INTEGER
			an_attribute: MT_ATTRIBUTE
			a_name : STRING
			rel_table: HASH_TABLE [MT_RELATIONSHIP, STRING]
			a_relationship: MT_RELATIONSHIP
			a_count: INTEGER
			buffer: ARRAY[INTEGER]
			to_c: ANY
				-- Relationship class name
		do
			if not properties_initialized then
				keys_count := mtdb.context.get_attributes_count ( oid)
				create buffer.make (1, keys_count)
				to_c := buffer.to_c
				mtdb.context.get_all_attributes ( oid, keys_count, $to_c)
				create attribute_table.make (keys_count)
				from
					i := 1
				until
					i = keys_count + 1
				loop
					create an_attribute.make_from_id (persister.mtdb, buffer.item (i))
					attribute_table.put (an_attribute, an_attribute.eiffel_name)
					i := i + 1
				end

				keys_count := mtdb.context.get_relationships_count ( oid)
				create buffer.make (1, keys_count)
				to_c := buffer.to_c
				mtdb.context.get_all_relationships ( oid, keys_count, $to_c)
				create rel_table.make (keys_count)
				from
					i := 1
				until
					i = keys_count + 1
				loop
					an_oid := buffer.item (i)
					a_relationship := make_relationship (persister.mtdb, an_oid)
					rel_table.put (a_relationship, a_relationship.eiffel_name)
					i := i + 1
				end

				a_count := field_count (sample_obj)
				create saved_attributes.make (1, a_count)
				create saved_relationships.make (1, a_count)
				from
					i := 1
				until
					i > a_count
				loop
					a_name := field_name (i, sample_obj)
					a_name.to_lower
					attribute_table.search (a_name)
					if attribute_table.found then
						an_attribute := attribute_table.found_item
						an_attribute.setup_field (i, sample_obj, persister.mtdb)
						saved_attributes.put (an_attribute, i)
					else
						rel_table.search (a_name)
						if rel_table.found then
							a_relationship := rel_table.found_item
							a_relationship.setup_field (i, sample_obj, persister.mtdb)
							saved_relationships.put (a_relationship, i)
						else
							if not sample_obj.predefined_eif_field (a_name) then
								sample_obj.property_undefined (i, a_name)
							end
						end
					end
					i := i + 1
				end
				properties_initialized := True
			end
		end

feature {NONE} -- Meta-schema

	predefined_eif_field (a_field_name: STRING): BOOLEAN
			-- Is `a_field_name' an attribute defined in classes MT_STORABLE,
			-- MT_OBJECT, or their ancestors?
		do
			Result := a_field_name.is_equal ("oid") or
					a_field_name.is_equal ("db") or
					a_field_name.is_equal ("attributes_loaded") or
					a_field_name.is_equal ("relationships_loaded") or
					a_field_name.is_equal ("properites_initialized") or
					a_field_name.is_equal ("saved_attributes") or
					a_field_name.is_equal ("saved_relationships") or
					a_field_name.is_equal ("stream")
		end

	setup_attribute (an_attr: MT_ATTRIBUTE; field_index: INTEGER; sample_obj: ANY)
		do
			an_attr.set_field_index (field_index)
			an_attr.set_field_type (field_type(field_index, sample_obj))
			an_attr.set_mt_type (an_attr.type)
				-- This should be changed so that it consider Eiffel class field type
		end

	make_relationship (a_db: MT_DATABASE; rid: INTEGER): MT_RELATIONSHIP
			-- rid: oid of relationship object
		local
			single_rs: MT_SINGLE_RELATIONSHIP
			multi_rs: MT_MULTI_RELATIONSHIP
			ht_rs: MT_HASH_TABLE_RELATIONSHIP
			m_co_rs: MT_MULTI_COMPOSITE_RELATIONSHIP
			s_co_rs: MT_SINGLE_COMPOSITE_RELATIONSHIP
			rs_class_name: STRING
		do
			if mtdb.context.get_object_class ( rid) = Mt_Relationship_oid then
				if mtdb.context.get_max_cardinality ( rid) = 1 then
					create single_rs.make_from_id (a_db, rid)
					Result := single_rs
				else
					create multi_rs.make_from_id (a_db, rid)
					Result := multi_rs
				end
			else
				rs_class_name := mtdb.context.get_relationship_class_name ( rid)
				if rs_class_name.is_equal (HashTableRelationship) then
					create ht_rs.make_from_id (a_db, rid)
					Result := ht_rs
				elseif rs_class_name.is_equal (CompositeRelationship) then
					if mtdb.context.get_max_cardinality ( rid) = 1 then
						create s_co_rs.make_from_id (a_db, rid)
						Result := s_co_rs
					else
						create m_co_rs.make_from_id (a_db, rid)
						Result := m_co_rs
					end
				end
			end
		end

feature -- Attributes

	properties_initialized: BOOLEAN
		-- Attributes and relationships are initialized?

feature -- Streaming

	open_stream: MT_CLASS_STREAM
		do
			create Result.make (oid, persister.mtdb)
		end

feature {NONE} -- Implementation

	saved_attributes: ARRAY [MT_ATTRIBUTE]

	saved_relationships: ARRAY [MT_RELATIONSHIP]

	Mt_Relationship_oid: INTEGER
		local
			to_c: ANY
			a_class_name: STRING
		once
			a_class_name := "MtRelationship"
			to_c := a_class_name.to_c
			Result := mtdb.context.get_class_from_name ( $to_c)
		end

	HashTableRelationship: STRING = "HashTableRelationship"

	CompositeRelationship: STRING = "CompositeRelationship"

end -- class MT_CLASS
