note
	description: "MATISSE-Eiffel Binding: define the linear_collection class"
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
	MT_LINEAR_COLLECTION [G -> MT_STORABLE]

feature -- Status

	is_persistent: BOOLEAN
		deferred
		end

	count: INTEGER
		deferred
		end

	successors_loaded: BOOLEAN
		deferred
		end

	mtdb: MT_DATABASE
		deferred
		end

feature -- Stream

	open_stream: MT_RELATIONSHIP_STREAM
		require
			predecessor_and_relationship_not_void: is_persistent
		do
			create Result.make (predecessor, relationship)
		end

feature {NONE} -- Element change

	mt_append (new_successor: G)
			-- Store new successor to OOS.
		do
			if is_persistent then
				mtdb.context.add_successor_append ( predecessor.oid, relationship.oid, new_successor.oid)

				-- inverse relationship is also updated.
				new_successor.become_obsolete

				-- subscription management
				predecessor.persister.notify_irelationship_update (new_successor, relationship.inverse_relationship)
			end
		end

	mt_add_first (new_successor: G)
			-- Store new successor to OOS.
		do
			if is_persistent then
				mtdb.context.add_successor_first ( predecessor.oid, relationship.oid, new_successor.oid)

				-- inverse relationship is also updated.
				new_successor.become_obsolete

				-- subscription management
				predecessor.persister.notify_irelationship_update (new_successor, relationship.inverse_relationship)
			end
		end

	mt_add_after (new_successor, after_this_object: G)
			-- Store new successor to OOS.
		do
			if is_persistent then
				mtdb.context.add_successor_after ( predecessor.oid, relationship.oid,
															 new_successor.oid, after_this_object.oid)

				-- inverse relationship is also updated.
				new_successor.become_obsolete

				-- subscription management
				predecessor.persister.notify_irelationship_update (new_successor, relationship.inverse_relationship)
			end
		end

	mt_add_all
			-- Append all the successors.
		local
			linear_rep: LINEAR [G]
		do
		   if is_persistent then
			linear_rep := linear_representation
			from
				linear_rep.start
			until
				linear_rep.off
			loop
				mt_append (linear_rep.item)
				linear_rep.forth

				-- subscription management
				predecessor.persister.notify_irelationship_update (linear_rep.item, relationship.inverse_relationship)
			end
		   end
		end

	mt_set_all
		local
			linear_rep: LINEAR [G]
			succ_oids: ARRAY [INTEGER]
			i: INTEGER
		do
			if is_persistent then
				linear_rep := linear_representation
				create succ_oids.make (0, count - 1)

				from
					linear_rep.start
					i := 0
				until
					linear_rep.off
				loop
					succ_oids.put (linear_rep.item.oid, i)

					-- inverse relationship is also updated.
					linear_rep.item.become_obsolete
					linear_rep.forth
					i := i + 1
				end

				mtdb.context.set_successors ( predecessor.oid, relationship.oid,
						succ_oids.count, $succ_oids)
			end
		end

	mt_remove (a_successor: G)
			-- Remove a successor.
		do
			if is_persistent then
				mtdb.context.remove_successor ( predecessor.oid, relationship.oid, a_successor.oid)

				-- inverse relationship is also updated.
				a_successor.become_obsolete

				-- subscription management
				predecessor.persister.notify_irelationship_update (a_successor, relationship.inverse_relationship)
			end
		end

	mt_remove_all
			-- Remove all successors.
		local
			linear_rep: LINEAR [G]
		do
			if is_persistent then
				mtdb.context.remove_all_successors ( predecessor.oid, relationship.oid)

				linear_rep := linear_representation
				from
					linear_rep.start
				until
					linear_rep.off
				loop
					-- inverse relationship is also updated.
					linear_rep.item.become_obsolete

					-- subscription management
					predecessor.persister.notify_irelationship_update (linear_rep.item, relationship.inverse_relationship)

					linear_rep.forth
				end
			end
		end

	mt_remove_ignore_nosuchsucc (a_successor: G)
			-- Remove a successor.
			-- Ignoring the error MATISSE_NOSUCHSUCC.
		do
			if is_persistent then
				mtdb.context.remove_successor_ignore_NOSUCHSUCC
					 ( predecessor.oid, relationship.oid, a_successor.oid)
			end
		end

feature {MT_RELATIONSHIP, MT_PERSISTER} -- Conversion

	linear_representation: LINEAR [G]
		deferred
		end

feature -- Loading

	mt_put_at_loading (new: G; i: INTEGER)
			-- Put the new item which is at the i-th position in the relationship.
			-- Some descendant classes ignore the argument 'i'.
		deferred
		end

	mt_resize_at_loading (new_size: INTEGER)
		deferred
		end

feature {MT_RELATIONSHIP} -- Modification

	successors_loading_done
		deferred
		end

feature {NONE} -- Implementation

	predecessor: MT_STORABLE
		deferred
		end

	relationship: MT_RELATIONSHIP
		deferred
		end

end -- class MT_LINEAR_COLLECTION

