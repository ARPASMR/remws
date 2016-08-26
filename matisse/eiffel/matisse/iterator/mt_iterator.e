note
	description: "MATISSE-Eiffel Binding: define the base iterator class"
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
	MT_ITERATOR [G]

inherit
	LINEAR [G]
		redefine
			exhausted
		end

feature -- Access

	item: G deferred 	end

	index: INTEGER_32

feature -- Status report

	after: BOOLEAN
		do
			Result := current_itm = End_of_stream
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
			Result := current_itm /= Current_item_not_retrieved
		end

feature -- Cursor movement

	start
		do
			if current_itm = Current_item_not_retrieved then
				current_itm := next_item ()
			end
			if current_itm /= End_of_stream then
				index := 1
			end
		end

	finish
		local
			an_itm: INTEGER_32
		do
			if not after then
				from
				until
					an_itm = End_of_stream
				loop
					an_itm := next_item ()
					if an_itm /= End_of_stream then
						current_itm := an_itm
					end
				end
			end
		end

	forth
		do
			current_itm := next_item ()
			index := index + 1
		end
feature -- Close

	close
		-- Close Stream
		do
			mtdb.context.close_stream ( c_stream)
		end

feature {NONE} -- Implementation

	c_stream: INTEGER_32

	mtdb: MT_DATABASE

feature {NONE}

	next_item (): INTEGER_32 deferred end
	
	current_itm: INTEGER_32

	End_of_stream: INTEGER_32 = -1

	Current_item_not_retrieved: INTEGER_32 = 0

invariant
	c_stream_valid: c_stream > 0
	database_not_void: mtdb /= Void

end -- class MT_ITERATOR
