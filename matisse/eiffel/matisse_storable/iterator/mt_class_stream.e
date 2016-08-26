note
	description: "MATISSE-Eiffel Binding: define the class-stream class"
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
	MT_CLASS_STREAM

inherit
	MT_STREAM

create {MT_CLASS}
	make

feature {NONE} -- Implementation

	make (class_id: INTEGER; a_db: MT_DATABASE)
			-- Open Stream.
		do
			persister ?= a_db.persister
			mtdb := a_db
			c_stream := mtdb.context.open_instances_stream ( class_id, 0)
		end -- make


end -- class MT_CLASS_STREAM

