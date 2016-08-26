note
	description: "MATISSE-Eiffel Binding: define the Matisse property virtual class"
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
	MT_PROPERTY

inherit
	MT_METASCHEMA

feature -- Status Report

	check_property (one_object: MT_OBJECT): BOOLEAN
			-- Is property ok?
		do
			Result := mtdb.context.check_property ( id, one_object.oid)
		end -- check

feature  -- Access

	id: INTEGER
		do
			Result := oid
		end

	eiffel_name: STRING
		local
			i: INTEGER
			v_mt_name: STRING
		do
			v_mt_name := name.twin
			v_mt_name.to_lower
			i := v_mt_name.substring_index ("__", 1)
			if i = 0 then
				i := v_mt_name.substring_index ("::", 1)
			end
			if i = 0 then
				Result := v_mt_name
			else
				create Result.make (v_mt_name.count - i - 1)
				Result.set (v_mt_name, i + 2, v_mt_name.count)
			end
			Result.append ("_")
		end

feature -- Schema

	eif_field_index: INTEGER
		-- The current property corresponds to field_index-th field of Eiffel object

	set_field_index (i: INTEGER)
			-- Assign `i' to `eif_field_index'
		do
			eif_field_index := i
		end

	class_oid: INTEGER
		-- 'class_id' is oid of the class where the current property (attribute
		-- or relationship) is defined.
		-- At the moment, this is used only by relationship. 98.11.21 K. Nakao

	set_class_oid (an_id: INTEGER)
		do
			class_oid := an_id
		end
end -- class MT_PROPERTY
