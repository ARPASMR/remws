note
	description: "MATISSE-Eiffel Binding: define the Matisse Object iterator class"
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
	MT_OBJECT_ITERATOR[G -> MT_OBJECT]

inherit
	MT_ITERATOR[G]
	redefine
		item
	end

create
   make
	, make_class_instance_iterator
	, make_class_own_instance_iterator
	, make_empty_iterator

	
feature {NONE} -- Implementation

	make (cls_stream_id: INTEGER_32; a_db: MT_DATABASE)
		-- Create an object iterator
		do
			mtdb := a_db
			c_stream := cls_stream_id
		end 

	make_class_instance_iterator (a_db: MT_DATABASE; a_cls: MTCLASS; num_preftech: INTEGER_32)
		-- Create a class instance iterator
		do
			mtdb := a_db
			c_stream := mtdb.context.open_instances_stream ( a_cls.oid, num_preftech)
		end 

	make_class_own_instance_iterator (a_db: MT_DATABASE; a_cls: MTCLASS; num_preftech: INTEGER_32)
		-- Create a class own instance iterator
		do
			mtdb := a_db
			c_stream := mtdb.context.open_own_instances_stream ( a_cls.oid, num_preftech)
		end 

	make_empty_iterator ()
		-- Create an empty object iterator of the expected target class
		do
		end 

feature {MTCLASS, MTINDEX, MTENTRYPOINTDICTIONARY} -- Set iterator

	set_iterator (cls_stream_id: INTEGER_32; a_db: MT_DATABASE)
		-- Set iterator properties
		-- internal use only
		do
			mtdb := a_db
			c_stream := cls_stream_id
		end 


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
			current_oid := mtdb.context.next_object (c_stream)
			Result := current_oid
		end

	current_oid: INTEGER_32

end -- class MT_OBJECT_ITERATOR

