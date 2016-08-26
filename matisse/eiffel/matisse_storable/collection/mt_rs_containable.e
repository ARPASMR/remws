note
	description: "MATISSE-Eiffel Binding: define the relationship container class"
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

deferred class
	MT_RS_CONTAINABLE


feature -- Status

	is_persistent: BOOLEAN
			-- Are 'predecessor' and 'relationship' set?
		do
			Result := predecessor /= Void and then relationship /= Void
		end

feature {MT_RELATIONSHIP} -- Status setting

	revert_to_unloaded
		do
			wipe_out_at_reverting
			successors_loaded := False
		end

feature -- Primitive successor accessing

	mt_first_successor: MT_STORABLE
		do
			Result := relationship.first_successor (predecessor)
		end

feature -- {MT_RELATIONSHIP} -- Access

	set_relationship (a_rel: like relationship)
		do
			relationship := a_rel
		end

	set_predecessor (an_obj: like predecessor)
		do
			predecessor := an_obj
			mtdb := predecessor.mtdb
		end

feature {MT_RELATIONSHIP} -- Modification

	successors_loading_done
		do
			successors_loaded := True
		end

feature {NONE} -- Persistence

	check_persistence (an_obj: MT_STORABLE)
			-- Does an_obj belong to 'relatioship.database'?
			-- If not, promote an_obj to persistent one.
		do
			if not relationship.persister.has (an_obj) then
				relationship.persister.persist_transient_object (an_obj)
			end
		end

feature --{NONE} -- Implementation

	predecessor: MT_STORABLE
			-- If predecessor is Void, current object can not be used
			-- as a container of successors of MATISSE relationship.

	relationship: MT_MULTI_RELATIONSHIP
			-- If predecessor is set properly and relationship is void,
			-- current object could be a container of successors of
			-- MATISSE relationship (but not yet). That is, current
			-- object is created by you, not by Eiffel-MATISSE Interface
			-- program.

	successors_loaded: BOOLEAN

	load_successors
			-- Get all the successors of predecessor through relationship.
		do
	--		SM, 01/25/99: do not see the use of this line and worst, it implies errors
			relationship.persister.clear_all_properties_when_obsolete_wo_class (predecessor)
			if is_persistent and then ((not successors_loaded) or predecessor.is_obsolete) then
				if successors_loaded then
					revert_to_unloaded
				end
				successors_loaded := True
				relationship.load_successors (Current, predecessor)
				debug ("load_successors")
					io.put_string (generating_type + ".load_successors for relationship " + relationship.oid.out + "; predecessor " + predecessor.oid.out + "%N")
				end
			end
		end

	reload_successors is
			--
		deferred
		end

	mtdb: MT_DATABASE

feature -- Removal

	wipe_out_at_reverting
		deferred
		end

end -- class MT_RS_CONTAINABLE

