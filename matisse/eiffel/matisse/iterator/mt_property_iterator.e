note
	description: "MATISSE-Eiffel Binding: define the Matisse Object Property iterator class"
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
	MT_PROPERTY_ITERATOR[G -> MT_OBJECT]

inherit
	MT_ITERATOR[G]
	redefine
		item
	end

create
	make

feature {NONE} -- Implementation

	make (cls_stream_id: INTEGER_32; a_db: MT_DATABASE)
		-- Create an object iterator
		do
			mtdb := a_db
			c_stream := cls_stream_id
		end -- make

feature -- Access

	item (): G
		do
			-- Works only if the STORABLE binding uses a 
			-- MT_STORABLE_DATABASE that redefines upcast
			Result ?= mtdb.upcast (current_oid)
		end

feature {NONE}

	next_item (): INTEGER_32
		do
			current_oid := mtdb.context.next_property (c_stream)
			Result := current_oid
		end

	current_oid: INTEGER_32

end -- class MT_PROPERTY_ITERATOR

