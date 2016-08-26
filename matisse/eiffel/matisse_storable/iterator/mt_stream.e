note
	description: "MATISSE-Eiffel Binding: define the base-stream class"
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
	MT_STREAM

inherit
	LINEAR [MT_STORABLE]
		redefine
			exhausted
		end

feature -- Access

	next_object: MT_OBJECT
			-- Get Next object in stream.
			-- This function is provided just because of backward compatibility.
		do
			forth
			if not after then
				Result := item
			end
		end

	item: MT_STORABLE
		do
			Result := persister.eif_object_from_oid (current_oid)
		end

	index: INTEGER

feature -- Status report

	after: BOOLEAN
		do
			Result := current_oid = End_of_stream
		end

	is_empty: BOOLEAN
		do
			Result := index = 0 and after
		end

	exhausted: BOOLEAN
		do
			Result := after
		end

	started: BOOLEAN
		do
			Result := current_oid /= Current_object_not_retrieved
		end

feature -- Cursor movement

	start
		do
			if current_oid = Current_object_not_retrieved then
				current_oid := mtdb.context.next_object ( c_stream)
			end
			if current_oid /= End_of_stream then
				index := 1
			end
		end

	finish
		local
			an_oid: INTEGER
		do
			if not after then
				from
				until
					an_oid = End_of_stream
				loop
					an_oid := mtdb.context.next_object ( c_stream)
					if an_oid /= End_of_stream then
						current_oid := an_oid
					end
				end
			end
		end

	forth
		do
			current_oid := mtdb.context.next_object ( c_stream)
			index := index + 1
		end
feature -- Close

	close
			-- Close Stream
		do
			mtdb.context.close_stream ( c_stream)
		end

feature {NONE} -- Implementation

	c_stream: INTEGER

	persister: MT_PERSISTER

	mtdb: MT_DATABASE

feature {NONE}

	current_oid: INTEGER

	End_of_stream: INTEGER = -1

	Current_object_not_retrieved: INTEGER = 0

invariant
	c_stream_valid: c_stream > 0
	database_not_void: persister /= Void

end -- class MT_STREAM
