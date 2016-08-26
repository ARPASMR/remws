note
	description: "MATISSE-Eiffel Binding: define the relationship-stream class"
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
	MT_RELATIONSHIP_STREAM

inherit
	MT_STREAM

create

    make, make_from_name

feature  {NONE} -- Creation

	make (an_object: MT_OBJECT; a_relationship: MT_RELATIONSHIP)
			-- Open Stream.
		do
			mtdb := a_relationship.mtdb
			persister := a_relationship.persister
			c_stream := mtdb.context.open_successors_stream ( an_object.oid, a_relationship.rid)
		end

	make_from_name (a_persister: MT_PERSISTER; an_object: MT_OBJECT; relationship_name: STRING)
		local
			c_name: ANY
		do
			persister := a_persister
			c_name := relationship_name.to_c
			c_stream := mtdb.context.open_successors_stream_by_name ( an_object.oid, $c_name)
		end

end -- class MT_RELATIONSHIP_STREAM
