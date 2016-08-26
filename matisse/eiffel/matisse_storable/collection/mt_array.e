note
	description: "MATISSE-Eiffel Binding: define the array class"
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
	MT_ARRAY [G -> MT_STORABLE]

inherit
	ARRAY [G]
		rename
			put as array_put,
			enter as array_enter,
			wipe_out as array_wipe_out
		export
			{NONE} array_put, array_enter, array_wipe_out
		redefine
			force, subcopy, clear_all, copy, prunable
		end

	ARRAY [G]
		rename
			put as array_put
		redefine
			enter, wipe_out, prunable, force, subcopy, clear_all, copy
		select
			enter, wipe_out
		end

	MT_RS_CONTAINABLE
		undefine
			is_equal, copy
		end

	MT_LINEAR_COLLECTION [G]
		undefine
			is_equal, copy
		end

create
	make

feature -- Access

	put, enter (v: like item; i: INTEGER)
		require else
			valid_key: valid_index (i)
		do
			if is_persistent then
				if item (i) /= Void then
					mt_remove (item (i))
				end
				if v /= Void then
					check_persistence (v)
					if i = lower then
						mt_add_first (v)
					else
						mt_add_after (v, item (i - 1))
					end
				end

				-- subscription management
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
			array_put (v, i)
		end

	force (v: like item; i: INTEGER)
			-- Assign item `v' to `i'-th entry.
			-- Always applicable: resize the array if `i' falls out of
			-- currently defined bounds; preserve existing items.
		do
			if i < lower then
				--auto_resize (i, upper)
				conservative_resize (i, upper)
			elseif i > upper then
				conservative_resize (lower, i)
				--auto_resize (lower, i)
			end
			put (v, i)
		end

	subcopy (other: like Current; start_pos, end_pos, index_pos: INTEGER)
			-- Copy items of `other' within bounds `start_pos' and `end_pos'
			-- to current array starting at index `index_pos'.
		local
			other_area: like area;
			other_lower, i: INTEGER;
			start0, end0, index0: INTEGER
		do
			if is_persistent then
				from
					i := other.lower
				until
					i > other.upper
				loop
					check_persistence (other.item (i))
					i := i + 1

					-- subscription management
					predecessor.persister.notify_irelationship_update (other.item (i), relationship.inverse_relationship)
				end
			end
			other_area := other.area;
			other_lower := other.lower;
			start0 := start_pos - other_lower;
			end0 := end_pos - other_lower;
			index0 := index_pos - lower;
			Precursor (other, start0, end0, index0)

			if is_persistent then
				mt_set_all
			end

			-- subscription management
			if other.upper >= other.lower then
				predecessor.persister.notify_relationship_update (predecessor, relationship)
			end
		end

	clear_all
			-- Reset all items to default values.
		do
			mt_remove_all
			Precursor

			-- subscription management
			predecessor.persister.notify_relationship_update (predecessor, relationship)
		end;

	wipe_out
			-- Make array empty.
		do
			mt_remove_all
			discard_items

			-- subscription management
			predecessor.persister.notify_relationship_update (predecessor, relationship)
		end

	prunable: BOOLEAN
			-- May items be removed? (Answer: yes.)
		do
			Result := True
		end;

feature -- Inapplicable

	copy (other: like Current)
			-- Reinitialize by copying all the items of `other'.
			-- (This is also used by `clone').
		do
		end

feature {NONE} -- Implementation

	mt_put_at_loading (new: G; i: INTEGER)
		do
			array_put (new, lower + i - 1)
		end

	mt_resize_at_loading (new_size: INTEGER)
		do
			conservative_resize (lower, lower + new_size - 1)
		end

	wipe_out_at_reverting
		do
			discard_items
		end

feature {MTRELATIONSHIP} -- Reloading

	reload_successors is
			-- reload successors if successors were already loaded at least once
		do
			discard_items
			relationship.load_successors (Current, predecessor)
		end
end -- class MT_ARRAY

