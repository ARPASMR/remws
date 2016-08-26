note
	description: "MATISSE-Eiffel Binding: define the Matisse index criterion class"
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
	MT_INDEX_CRITERION

inherit
	INTERNAL
		rename
			c_is_instance_of as internal_c_instance_of,
			is_instance_of as internal_instance_of
	   export
			{NONE} all
		end

create
	make

feature -- Initialization

	make (a_db: MT_DATABASE; an_oid, a_type, a_size, an_ordering: INTEGER)
		require
			ascend_or_descend: an_ordering = {MT_INDEX}.Mt_Ascend or else an_ordering = {MT_INDEX}.Mt_Descend
		do
			persister ?= a_db.persister
			mtdb := a_db
			attr_oid := an_oid
			type := a_type
			size := a_size
			ordering := an_ordering
		end

feature -- Status Report

	type: INTEGER

	size: INTEGER

	ordering: INTEGER
		-- Ordering of the indexation for the criterion as described in the meta-schema

	attribute_name: STRING
		do
			Result := mtdb.context.object_mt_name (attr_oid)
		end

	persister: MT_PERSISTER
	mtdb: MT_DATABASE

feature -- Criterion values

	start_value: ANY

	end_value: ANY

feature -- Setting criterion value

	set_start_value (s_value: ANY)
		do
			if s_value /= Void then
				start_value := s_value.twin
			else
				start_value := Void
			end

		end

	set_end_value (e_value: ANY)
		do
			if e_value /= Void then
				start_value := e_value.twin
			else
				start_value := Void
			end
		end

feature {MT_INDEX_STREAM} -- Implementation

	copy_values_to_c (i: INTEGER)
		local
			one_string: STRING
			c_one_string: ANY
		do
			if start_value /= void then
				one_string ?= start_value
				if one_string /= void then
					c_one_string := one_string.to_c
				else
					inspect dynamic_type (start_value)
					when Integer_type then
					when Real_type then
					when Double_type then
					else
					end
				end

			end
		end

feature {NONE}

	attr_oid: INTEGER -- Attribute identifier in database

end -- class MT_INDEX_CRITERION
