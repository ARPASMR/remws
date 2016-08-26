note
	description: "Eiffel-MATISSE Binding: define the entry-point dictionary stream class"
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
	MT_ENTRYPOINT_STREAM

inherit
	MT_STREAM

create
	make

feature {MT_ENTRYPOINTDICTIONARY} -- Implementation

	make (ep_string: STRING; one_ep_dict: MT_ENTRYPOINTDICTIONARY; one_class: MT_CLASS)
			-- Open Stream.
		require
			ep_string_not_void: ep_string /= Void
			ep_string_not_empty: not ep_string.is_empty
		local
			c_ep_string: ANY
                        cid: INTEGER
		do
			persister := one_ep_dict.persister
			mtdb := persister.mtdb
			c_ep_string := ep_string.to_c
                        if Void = one_class then
                                cid := 0
                        else
                                cid := one_class.oid
                        end
			c_stream := mtdb.context.open_entry_point_stream ( $c_ep_string, one_ep_dict.oid, cid, 0)
		end -- make


end -- class MT_ENTRYPOINT_STREAM
