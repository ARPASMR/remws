note
	description: "MATISSE-Eiffel Binding: define the Matisse meta-schema virtual class"
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
	MT_METASCHEMA

inherit
	MT_STORABLE

feature -- Access

	mt_name, name: STRING
			-- "MtName" of meta-schema object in Matisse
		do
			Result := mtdb.context.object_mt_name ( oid)
		end -- name

feature {MT_STREAM, MT_PERSISTER, MT_RS_CONTAINABLE}

	-- persister: MT_PERSISTER

	--set_persister (a_db: MT_DATABASE)
	--	require
	--		valid_database: a_db /= Void
	--	do
	--		persister := a_db.persister
	--	end

invariant

end -- class MT_METASCHEMA
