note
	description: "MATISSE-Eiffel Binding: define the linked_stack class"
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
	MT_LINKED_STACK [G -> MT_STORABLE]

inherit
	LINKED_STACK [G]
		redefine
			linear_representation
		end
		
	MT_RS_CONTAINABLE
		undefine
			copy, is_equal
		end
	
creation
	make

feature

	mt_put_at_loading (v: G; i: INTEGER)
		do
			extend (v)
		end

	mt_resize_at_loading (new_size: INTEGER)
			-- Do nothing.
		do
		end

	linear_representation: ARRAYED_LIST [G]
			-- Representation as a linear structure.
			-- (order is the same of original order of insertion).
		local
			old_cursor: CURSOR
		do
			old_cursor := cursor;
			from
				create Result.make (count);
				start
			until
				after
			loop
				Result.put_front (ll_item);
				forth
			end
			go_to (old_cursor)
		end

	wipe_out_at_reverting
		do
		end	

end -- class MT_LINKED_STACK


