note
	description: "MATISSE-Eiffel Binding: define single cardinality Relationship class"
	description: ""
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
	MT_SINGLE_RELATIONSHIP

inherit
	MT_RELATIONSHIP
		redefine
			is_single,
			current_successors_of,
			set_successors_of,
			setup_field,
			successors_of,
			persist_successors_of,
			revert_to_unloaded
		end

create
	make, make_from_names, make_from_id

feature

	is_single: BOOLEAN
		once
			Result := True
		end

feature {MT_CLASS} -- Schema initialization

	setup_field (a_field_index: INTEGER; sample_obj: MT_STORABLE; a_db: MT_DATABASE)
			-- Initialize current as a relationship for a speicif class,
			-- which is the class of sample_obj
		do
			set_field_index (a_field_index)
			persister ?= a_db.persister
		end

feature  -- Successors

	successors_of (an_object: MT_OBJECT): MT_ARRAY [MT_STORABLE]
			-- Return the successor of an_object through the current relationship.
			-- (If no object found, return Void)
		local
			oids: ARRAY[INTEGER]
		do
			oids := mtdb.context.get_successors ( an_object.oid, oid)
			if oids.count = 0 then
				create Result.make (1, 0)
			else
				create {MT_ARRAY [MT_STORABLE]} Result.make (1, 1)
				Result.put(persister.new_eif_object_from_oid (oids.item(1)), 1)
			end
		end

feature {MT_PERSISTER} -- Persistence

	current_successors_of (an_object: MT_OBJECT): ARRAY [MT_STORABLE]
			-- Get the successor(s) of an_object through the current relationship.
			-- (If the successor collection isn't filled in with successor objects,
			-- just return an empty collection).
		local
			temp: MT_STORABLE
		do
			create Result.make (1, 1)
			temp ?= field (eif_field_index, an_object)
			Result.put (temp, 1)
		end

	set_successors_of (a_predecessor: MT_STORABLE)
			-- Remove the old successor of an_object through the current
			-- relationship, then add the current successor of an_object
			-- which is held by an_object.
		local
			a_succ, old_succ: MT_STORABLE
			old_succ_oids: ARRAY [INTEGER]
			i: INTEGER
		do
			a_succ ?= field (eif_field_index, a_predecessor)

			-- get the old successors. They can be more than one, because
			-- object can be in invalid state
			old_succ_oids := mtdb.context.get_successors ( a_predecessor.oid, oid)
			mtdb.context.remove_all_succs_ignore_nosuccessors ( oid, a_predecessor.oid)
			if a_succ /= Void then
				mtdb.context.add_successor_first ( a_predecessor.oid, oid, a_succ.oid)
			end

			-- make the old successor(s) obsolete
			from
				i := 1
			until
				i > old_succ_oids.upper
			loop
				old_succ := persister.eif_object_from_oid_if_found (old_succ_oids.item(i))
				if ( old_succ /= Void ) then
					old_succ.become_obsolete
				end
				i := i + 1
			end

			if a_succ /= Void then
				a_succ.become_obsolete
			end

			-- subscription management
			persister.notify_relationship_update (a_predecessor, Current)
			if a_succ /= Void then
				persister.notify_irelationship_update (a_succ, inverse_relationship)
			end
			if old_succ /= Void then
				persister.notify_irelationship_update (old_succ, inverse_relationship)
			end
		end

	persist_successors_of (a_pred: MT_STORABLE)
		local
			a: MT_STORABLE
		do
			a ?= field (eif_field_index, a_pred)
			if a /= Void then
				persist_if_not (a)
				mtdb.context.add_successor_first_ignore_alreadysucc ( a_pred.oid, oid, a.oid)
			end
		end

	revert_to_unloaded (an_obj: MT_STORABLE)
		do
			set_reference_field (eif_field_index, an_obj, Void)
		end

end -- class MT_SINGLE_RELATIONSHIP
