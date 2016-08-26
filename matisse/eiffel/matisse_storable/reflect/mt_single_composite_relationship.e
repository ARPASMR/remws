note
	description: "MATISSE-Eiffel Binding: define single cardinality Composite Relationship class"
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
	MT_SINGLE_COMPOSITE_RELATIONSHIP

inherit
	MT_COMPOSITE_RELATIONSHIP
		undefine
			is_equal, copy
		end

	MT_SINGLE_RELATIONSHIP
		redefine
			set_successors_of
		end

create
	make_from_id

feature {MATISSE}

	set_successors_of (a_predecessor: MT_STORABLE)
			-- Remove the old successor of a_predecessor through the current
			-- relationship by deleting it and then add the current
			-- successor of a_predecessor which is held by an_object.
		local
			a_succ: MT_STORABLE
			sid: INTEGER
		do
			a_succ ?= field (eif_field_index, a_predecessor)
			if a_succ = Void then
				mtdb.context.remove_all_succs_ignore_nosuccessors ( oid, a_predecessor.oid)
			else
				sid := mtdb.context.get_single_successor ( a_predecessor.oid, oid)
				if sid = 0 then
					mtdb.context.add_successor_first ( a_predecessor.oid, oid, a_succ.oid)
				elseif sid /= a_succ.oid then
					mtdb.context.remove_object ( sid)
					mtdb.context.add_successor_first ( a_predecessor.oid, oid, a_succ.oid)
				end
				a_succ.become_obsolete
			end
		end


end -- class MT_SINGLE_COMPOSITE_RELATIONSHIP
