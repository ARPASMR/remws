indexing
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

	Contributor(s):
	]"


class COMMON_FEATURES

feature

	get_object_from_identifier (id: STRING; a_database: MT_STORABLE_DATABASE): MT_STORABLE is
		require
			valid_a_database: a_database /= Void
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
		do
			create ep.make_with_db ("IdentifierDictionary", Void, a_database)
			res_objs := ep.retrieve (id, Void);
			Result := res_objs.item(1)
		end

feature -- Constants

	target_host: STRING is "localhost"

	target_database: STRING is "example"

end
