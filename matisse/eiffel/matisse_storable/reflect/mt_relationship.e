note
	description: "MATISSE-Eiffel Binding: define Matisse MtRelationship meta-class"
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
	MT_RELATIONSHIP

inherit
	MT_PROPERTY
		rename
			id as rid,
			successors as mt_successors,
			check_persistence as mt_storable_check_p
		redefine
			predefined_eif_field
		end

create
	make, make_from_names, make_from_id

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
  MT_TRIGGERS_NAME: STRING =                       "MtTriggers"
  MT_TRIGGER_OF_NAME: STRING =                     "MtTriggerOf"

feature {NONE} -- Initialization

	make (relationship_name: STRING; a_db: MT_DATABASE)
			-- Get relationship from database.
			-- An error raised if `relationship_name' is not unique in the schema.
		require
			string_not_void: relationship_name /= Void
			string_not_empty: not relationship_name.is_empty
		local
			relationship_name_to_c: ANY
		do
			persister ?= a_db.persister
			mtdb := a_db
			relationship_name_to_c := relationship_name.to_c
			oid := mtdb.context.get_relationship_from_name ( $relationship_name_to_c)
			inverse_relationship := mtdb.context.get_inverse_relationship ( oid)
		end

	make_from_names (relationship_name, cl_name: STRING; a_db: MT_DATABASE)
			-- Get relationship from database.
		require
			rel_not_void: relationship_name /= Void
			rel_not_empty: not relationship_name.is_empty
			cl_not_void: cl_name /= Void
			cl_not_empty: not cl_name.is_empty
		local
			relationship_name_to_c: ANY
			cl_name_to_c: ANY
		do
			persister ?= a_db.persister
			mtdb := a_db
			relationship_name_to_c := relationship_name.to_c
			cl_name_to_c := cl_name.to_c
			oid := mtdb.context.get_relationship_from_names ( $relationship_name_to_c, $cl_name_to_c)
			inverse_relationship := mtdb.context.get_inverse_relationship ( oid)
		end

feature {MT_CLASS} -- Initialization

	make_from_id (a_db: MT_DATABASE; rel_id: INTEGER)
			-- Use id retrieved in Matisse to create Eiffel object
		do
			persister ?= a_db.persister
			mtdb := a_db
			oid := rel_id
			inverse_relationship := mtdb.context.get_inverse_relationship ( oid)
		end

feature -- Status Report

	check_relationship (one_object: MT_OBJECT): BOOLEAN
			-- Check if relationship is OK
		do
			mtdb.context.check_relationship ( oid, one_object.oid)
		end

feature -- Accessing
	successor_classes: ARRAY [MT_CLASS]
			-- Types of objets available via relationship
		local
			a_stream: MT_RELATIONSHIP_STREAM
			a_class: MT_CLASS
			i: INTEGER
		do
			create a_stream.make_from_name (persister, Current, "MtSuccessors")
			create Result.make (0, 1)
			from
				a_stream.start
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

	inverse_relationship: INTEGER

feature {MT_CLASS} -- Schema

	setup_field (field_index: INTEGER; sample_obj: MT_STORABLE; a_db: MT_DATABASE)
			-- Initialize current as a relationship for a speicif class,
			-- which is the class of sample_obj
		do
			-- Descendants should redefine this.
			-- If this class can be a deferred class, this procedure
			-- can be deferred.
		end

	predefined_eif_field (a_field_name: STRING): BOOLEAN
			-- Is a_field_name an attribute defined in this class?
		do
			Result := a_field_name.is_equal ("oid") or
					a_field_name.is_equal ("db") or
					a_field_name.is_equal ("attributes_loaded") or
					a_field_name.is_equal ("relationships_loaded") or
					a_field_name.is_equal ("eif_field_index") or
					a_field_name.is_equal ("is_single") or
					a_field_name.is_equal ("stream")
		end

	setup_single
		do
		end

	is_single: BOOLEAN
			-- Is the current relationship's maximum cardinality 1?
		do
			Result := mtdb.context.get_max_cardinality ( oid) = 1
		end

feature -- Successors

	first_successor (an_object: MT_OBJECT): MT_STORABLE
			-- Return the first successor of an_object through the current relationship
			-- (If no object found, return Void)
		local
			oids: ARRAY[INTEGER]
		do
			oids := mtdb.context.get_successors ( an_object.oid, oid)
			if oids.count = 0 then
				Result := Void
			else
				Result := persister.new_eif_object_from_oid (oids.item(1))
			end
		end

	successors_of (an_object: MT_OBJECT): MT_RS_CONTAINABLE
			-- Return all the successors of an_object through the current relationship.
			-- (If no object found, return empty array)
		do
		end

	reload_successors (an_object: MT_STORABLE) is
			-- Force reloading successor(s) for this relationship of an_object
		do
		end

feature {MT_PERSISTER} -- Persistence

	current_successors_of (an_object: MT_OBJECT): ARRAY [MT_STORABLE]
			-- Get the successor(s) of an_object through the current relationship.
			-- If the successor collection isn't filled in with successor objects,
			-- just return an empty collection.
		local
			collection: MT_ARRAY [MT_STORABLE]
			temp: MT_STORABLE
			i: INTEGER
		do
			if is_single then
				create Result.make (1, 1)
				temp ?= field (eif_field_index, an_object)
				Result.put (temp, 1)
			else
				collection ?= field (eif_field_index, an_object)
				if collection = Void then
					create Result.make (1, 0)
				else
					create Result.make (collection.lower, collection.upper)
					from
						i := collection.lower
					until
						i > collection.upper
					loop
						Result.put (collection.item (i), i)
						i := i + 1
					end
				end
			end
		end

	set_successors_of (an_object: MT_STORABLE)
			-- Remove the old successors of an_object through the current
			-- relationship, then add the current successors of an_object
			-- which is held by an_object.
		do
		end

	append_successor (a_predecessor, new_successor: MT_STORABLE)
		do
			if new_successor /= Void then
				mtdb.context.add_successor_append ( a_predecessor.oid, oid, new_successor.oid)
			end
		end

	persist_successors_of (a_pred: MT_STORABLE)
		do
			--deferred
		end

	persist_if_not (an_obj: MT_STORABLE)
		require
			not_void: an_obj /= Void
		do
			if not persister.has (an_obj) then
				persister.persist_transient_object (an_obj)
			end
		end

	revert_to_unloaded (an_obj: MT_STORABLE)
		do
			-- do nothing
			-- Descendants should redefine this.
		end

feature -- Storing

	set_successors (a_predecessor: MT_OBJECT; a_linear: LINEAR [MT_OBJECT])
		do
			mtdb.context.remove_all_succs_ignore_nosuccessors ( oid, a_predecessor.oid)
			from
				a_linear.start
			until
				a_linear.exhausted
			loop
				mtdb.context.add_successor_append ( a_predecessor.oid, oid, a_linear.item.oid)
				a_linear.forth
			end
		end

invariant
	inverse_rshp_set: inverse_relationship /= 0

end -- class MTRELATIONSHIP
