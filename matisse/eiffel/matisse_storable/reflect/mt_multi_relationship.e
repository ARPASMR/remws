note
	description: "MATISSE-Eiffel Binding: define the multiple cardinality Relationship class"
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
	MT_MULTI_RELATIONSHIP

inherit
	MT_RELATIONSHIP
		redefine
			is_single,
			current_successors_of,
			set_successors_of,
			setup_field,
			successors_of,
			persist_successors_of,
			revert_to_unloaded,
			reload_successors
		select
			is_equal
		end

	MT_CONTAINER_TYPES
		rename
			is_equal as another_is_equal
		undefine
			copy
		end

create
	make, make_from_names, make_from_id

feature

	is_single: BOOLEAN
		once
			Result := False
		end

	container_type: STRING

feature {MT_CLASS} -- Schema initialization

	setup_field (a_field_index: INTEGER; sample_obj: MT_STORABLE; a_db: MT_DATABASE)
			-- Initialize current as a relationship for a speicif class,
			-- which is the class of sample_obj.
		do
			set_field_index (a_field_index)
			persister ?= a_db.persister
			container_type := get_container_type (sample_obj)
		end

	get_container_type (object: MT_STORABLE): STRING
		local
			n: STRING
		do
			if persister /= Void then
				n := persister.mt_class_from_object (object).name
			else
				create n.make(1)
			end
			n.append ("__")
			n.append (name)
			Result := container_class_for_relationship (n)
		end

feature {MT_CLASS, MT_PERSISTER, MT_RS_CONTAINABLE} -- Successors loading

	successors_of (an_object: MT_STORABLE): MT_RS_CONTAINABLE
			-- Return the successors of an_object through the current relationship.
			-- (If no object found, return empty collection).
		local
			a: ANY
		do
			a := type_name_of_type (field_static_type_of_type (eif_field_index, dynamic_type (an_object))).to_c
			Result ?= mtdb.context.create_empty_rs_container ( $a, an_object.oid, oid)
			Result.set_predecessor (an_object)
			Result.set_relationship (Current)
		end

	load_successors (a_container: MT_RS_CONTAINABLE; an_obj: MT_STORABLE)
			-- Fill in a_container with all the successors of an_obj through
			-- the current relationship.
		local
			a_count, i: INTEGER
			succ_oids: ARRAY [INTEGER]
			a_mt_collection: MT_LINEAR_COLLECTION [MT_STORABLE]
		do
			a_mt_collection ?= a_container
			if a_mt_collection /= Void then
				succ_oids := mtdb.context.get_successors ( an_obj.oid, oid)
				a_count := succ_oids.count
				if a_count > 0 then
					a_mt_collection.mt_resize_at_loading (a_count)
					from
						i := 1
					until
						i > a_count
					loop
						a_mt_collection.mt_put_at_loading (persister.new_eif_object_from_oid(succ_oids.item(i)), i)
						i := i + 1
					end
				end
			end
		end

	reload_successors (an_obj: MT_STORABLE) is
			-- reload successors if it was already loaded
		local
			a_container: MT_RS_CONTAINABLE
		do
			a_container ?= field (eif_field_index, an_obj)
			if a_container /= Void and then a_container.successors_loaded then
				a_container.reload_successors
			end
		end

feature {MT_PERSISTER} -- Persistence

	persist_successors_of (a_pred: MT_STORABLE)
		local
			a: MT_LINEAR_COLLECTION [MT_STORABLE]
			linear_rep: LINEAR [MT_STORABLE]
		do
			a ?= field (eif_field_index, a_pred)
			if a /= Void then
				linear_rep := a.linear_representation
				from
					linear_rep.start
				until
					linear_rep.off
				loop
					if linear_rep.item /= Void then
						persist_if_not (linear_rep.item)
						mtdb.context.append_successor_ignore_alreadysucc ( a_pred.oid, oid, linear_rep.item.oid)
					end
					linear_rep.forth
				end
				a.successors_loading_done
			end
		end

	current_successors_of (an_object: MT_OBJECT): ARRAY [MT_STORABLE]
			-- Get the successor(s) of `an_object' through the current relationship.
			-- If the successor collection isn't filled in with successor objects,
			-- just return an empty collection.
		local
			collection: MT_LINEAR_COLLECTION [MT_STORABLE]
			linear_rep: LINEAR [MT_STORABLE]
			i: INTEGER
		do
			collection ?= field (eif_field_index, an_object)
			if collection = Void then
				create Result.make (1, 0)
					-- Return an empty array
			else
				create Result.make (1, collection.count)
				linear_rep := collection.linear_representation
				from
					linear_rep.start
					i := 1
				until
					linear_rep.exhausted
				loop
					Result.put (linear_rep.item, i)
					linear_rep.forth
					i := i + 1
				end
			end
		end

	set_successors_of (an_object: MT_STORABLE)
			-- Remove the old successors of an_object through the current
			-- relationship, then add the current successors of an_object
			-- which is held by an_object.
		local
			succs: MT_LINEAR_COLLECTION [MT_STORABLE]
			linear_rep: LINEAR [MT_STORABLE]
		do
			succs ?= field (eif_field_index, an_object)
			if succs /= Void and then succs.successors_loaded then
				linear_rep := succs.linear_representation
				mtdb.context.remove_all_succs_ignore_nosuccessors ( oid, an_object.oid)
				from
					linear_rep.start
				until
					linear_rep.exhausted
				loop
					mtdb.context.add_successor_append ( an_object.oid, oid, linear_rep.item.oid)
					linear_rep.forth
				end
			end
		end

	revert_to_unloaded (an_obj: MT_STORABLE)
		local
			a_container: MT_RS_CONTAINABLE
		do
			a_container ?= field (eif_field_index, an_obj)
			if a_container /= Void then
				a_container.revert_to_unloaded
			end
		end

feature {MT_STORABLE} -- Container

	empty_container_for (a_predecessor: MT_STORABLE; a_field_type: INTEGER): MT_RS_CONTAINABLE
			-- Return an empty container object.
			-- The container is initialized so that it can load successors later.
			-- ('predecessor' and 'relationship' are set to `a_predecesor' and `Current'.)
		local
			a: ANY
		do
			a := type_name_of_type (a_field_type).to_c
			Result ?= mtdb.context.create_empty_rs_container ( $a, a_predecessor.oid, oid)
			Result.set_predecessor (a_predecessor)
			Result.set_relationship (Current)
		end

end -- class MT_MULTI_RELATIONSHIP
