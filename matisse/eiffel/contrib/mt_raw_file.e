note
	description: "MATISSE-Eiffel Binding: Extension of RAW_FILE with byte array capability"
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
	MT_RAW_FILE

inherit
	RAW_FILE

creation
	make, make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature
	last_bytes: ARRAY [CHARACTER]
	
	last_bytes_count: INTEGER
		-- Number of bytes read from the file
		
	read_bytes (nb_bytes: INTEGER)
			-- Read bytes of at most 'nb_bytes' bound bytes
			-- or until end of file.
			-- Make result available in 'last_bytes'.
		require
			is_readable: file_readable
		local
			bytes_area: ANY
		do
			create last_bytes.make (1, nb_bytes)
			bytes_area := last_bytes.area
			last_bytes_count := file_read_bytes (file_pointer, $bytes_area, nb_bytes)
		end

feature {NONE} -- Implementation

	file_read_bytes (file: POINTER; byte_array: POINTER; length: INTEGER) : INTEGER
		external 
			"C"
		end
	
end -- class MT_RAW_FILE
