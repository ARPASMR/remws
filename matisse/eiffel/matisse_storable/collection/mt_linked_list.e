note
   description: "MATISSE-Eiffel Binding: define the linked_list class"
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
	MT_LINKED_LIST [G -> MT_STORABLE]

inherit
	LINKED_LIST [G]
		redefine
			put_front, extend, put_left, put_right,
			replace, merge_left, merge_right, remove,
			remove_left, remove_right, wipe_out, swap
		select
			extend, wipe_out
		end

	LINKED_LIST [G]
		rename
			extend as list_extend,
			wipe_out as list_wipe_out
		export
			{NONE} list_extend, list_wipe_out
		redefine
			put_front, put_left, put_right, replace, merge_left,
			merge_right, remove, remove_left, remove_right, swap
		end

	MT_RS_CONTAINABLE
		undefine
			copy, is_equal
		end

	MT_LINEAR_COLLECTION [G]
		undefine
			copy, is_equal
		end

create
	make

feature -- Element change

	put_front (v: like item)
			-- Add `v' to beginning.
			-- Do not move cursor.
		do
			Precursor (v)
			if v /= Void and then is_persistent then
				check_persistence (v)
				mt_remove_ignore_nosuchsucc (v)
				mt_add_first (v)

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	extend (v: like item)
			-- Add `v' to end.
			-- Do not move cursor.
		do
			Precursor (v)
			if v /= Void and then is_persistent then
				check_persistence (v)
				mt_remove_ignore_nosuchsucc (v)
				mt_append (v)

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	put_left (v: like item)
			-- Add `v' to the left of cursor position.
			-- Do not move cursor.
		local
			p, old_active: like first_element
		do
			if is_empty then
				put_front (v)
			elseif after then
				back
				put_right (v)
				move (2)
			else
				p := new_cell (active.item)
				p.put_right (active.right)
				active.put (v)
				active.put_right (p)
				active := p
				count := count + 1
				-- Processing for MATISSE
				if v /= Void and then is_persistent then
					old_active := active
					move (-2)
					check_persistence (v)
					mt_remove_ignore_nosuchsucc (v)
					if before then
						mt_add_first (v)
					else
						mt_add_after (v, active.item)
					end
          move (2)

					-- subscription management
					predecessor.persister.notify_relationship_update (predecessor, relationship)
				end
			end
		end

	put_right (v: like item)
			-- Add `v' to the right of cursor position.
			-- Do not move cursor.
		do
			Precursor (v)
			if v /= Void and then is_persistent then
				check_persistence (v)
				mt_remove_ignore_nosuchsucc (v)
				if before then
					mt_add_first (v)
				else
					mt_add_after (v, active.item)
				end

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	replace (v: like item)
			-- Replace current item by `v'.
		do
			if active.item /= Void and then is_persistent then
				mt_remove (active.item)
			end
			Precursor (v)
			if v /= Void and then is_persistent then
				check_persistence (v)
				mt_remove_ignore_nosuchsucc (v)
				if active = first_element then
					mt_add_first (v)
				else
					mt_add_after (v, previous.item)
				end
			end

			-- subscription management
			predecessor.persister.notify_relationship_update (predecessor, relationship)
		end

	merge_left (other: like Current)
			-- Merge `other' into current structure before cursor
			-- position. Do not move cursor. Empty `other'.
		local
			pos: CURSOR
		do
			if other.count > 0 then
				if is_persistent then
					from
						other.start
					until
						other.after
					loop
						check_persistence (other.item)
						other.forth
					end
				end
				other.start
				Precursor (other)
				pos := cursor
				mt_set_all
				go_to (pos)

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	merge_right (other: like Current)
			-- Merge `other' into current structure after cursor
			-- position. Do not move cursor. Empty `other'.
		local
			pos: CURSOR
		do
			if other.count > 0 then
				if is_persistent then
					from
						other.start
					until
						other.after
					loop
						check_persistence (other.item)
						other.forth
					end
				end
				Precursor (other)
				pos := cursor
				mt_set_all
				go_to (pos)

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	swap (new_i: INTEGER)
		local
			old_i: INTEGER
			old_item, new_item: like item
		do
			old_i := index
			old_item := item
			go_i_th (new_i)
			new_item := item
			remove  -- remove item at i
			start
			search (old_item)
			remove
			if old_i < new_i then
				go_i_th (old_i - 1)
				put_right (new_item)
				go_i_th (new_i - 1)
				put_right (old_item)
			else
				go_i_th (new_i - 1)
				put_right (old_item)
				go_i_th (old_i - 1)
				put_right (new_item)
			end
		end

feature -- Removal

	remove
			-- Remove current item.
			-- Move cursor to right neighbor.
			-- (or `after' if no right neighbor).
		local
			current_item: G
		do
			current_item := active.item
			Precursor
			if current_item /= Void and then current_item.is_persistent then
				mt_remove (current_item)

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	remove_left
			-- Remove item to the left of cursor position.
			-- Do not move cursor.
		do
			if index > 1 then
				Precursor
			end
		end

	remove_right
			-- Remove item to the right of cursor position.
			-- Do not move cursor.
		local
			to_be_removed: G
		do
			if before then
				to_be_removed := first_element.item
			else
				to_be_removed := active.right.item
			end
			Precursor
			if to_be_removed /= Void then
				mt_remove (to_be_removed)

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	wipe_out
			-- Remove all items.
		do
			mt_remove_all
			Precursor

			-- subscription management
			predecessor.persister.notify_relationship_update (predecessor, relationship)
		end

	persistent_wipe_out is
			-- Remove items from database
		do
			do_all (agent (an_item: G) do an_item.mt_remove end)
			wipe_out
		end

feature {NONE} -- Implementation

	mt_put_at_loading (v: G; i: INTEGER)
		do
			list_extend (v)
		end

	mt_resize_at_loading (new_size: INTEGER)
			-- Do nothing
		do
		end

	wipe_out_at_reverting
		do
			list_wipe_out
		end

feature {MTRELATIONSHIP} -- Reloading

	reload_successors is
			-- reload successors when it was already loaded at least once
		require else
			loaded: successors_loaded
		local
			index_before: INTEGER
		do
			index_before := index
			internal_wipe_out
			relationship.load_successors (Current, predecessor)
			if index_before <= count + 1 then
				go_i_th (index_before)
			else
				go_i_th (count + 1)
			end
		end

end -- class MT_LINKED_LIST

