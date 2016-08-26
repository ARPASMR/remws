note
	description: "Dynamic Object Factory class for the binding"
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
	MT_DYNAMIC_OBJECT_FACTORY

inherit
	MT_OBJECT_FACTORY

	INTERNAL
		rename
			c_is_instance_of as internal_c_instance_of,
			is_instance_of as internal_instance_of
	   export
			{NONE} all
		end

create
	make, make_namespace


feature {NONE} -- Implementation

feature -- Initialization

	make
		do
		end

	make_namespace (a_db_ns: STRING)
		require
			not_void: a_db_ns /= Void
		do
			mtdbnamespace := a_db_ns
		end

feature -- Interface Implementation

	mtdbnamespace: STRING

	get_eiffel_class (mtcls_name: STRING): INTEGER_32
		-- return the Eiffel type id for a Matisse Class or EIF_NO_TYPE if not found
		local
			c_cls_name: ANY
		do
			-- NOTE: we may need to cache these if it is costly to
			-- retrieve
			c_cls_name := mtcls_name.to_c
			Result := {MT_NATIVE}.c_get_eif_type_id ($c_cls_name, True)
		end

   get_database_class (eif_cls_name: STRING): STRING
		-- return the database class name from the eiffel class name
		do
            -- need to check for meta-schema classes which should map to the root namespace
			if mtdbnamespace /= Void then
			    Result := mtdbnamespace + {MTCLASS}.MT_NAMESPACE_SEPARATOR + eif_cls_name
            else
			    Result := eif_cls_name
            end
		end

   get_object_instance (db: MT_DATABASE; mt_oid: INTEGER_32): MT_OBJECT
		-- Create an instance of the matching schema class
		-- OR an instance of a sub class that exists in the system
		-- OR an instance of MTOBJECT as the last resort
		local
			--type_id, cls_oid: INTEGER_32
			--cls_name: STRING
			--vcls: MTCLASS
			obj: MTOBJECT
		do
			if mt_oid > 0 then
				-- This is the way, a developer would define its own
				-- oject factory
				--cls_oid := db.context.get_object_class (mt_oid)
				--create vcls.make_from_mtoid(db, cls_oid)
				--cls_name := vcls.get_mtname ()
				--type_id := Current.get_eiffel_class (cls_name)
				-- should be Eif_no_type instead of -1
				-- but don't know where it is defined
				--if type_id = -1 then
					-- could look into sub-classes before going MtObject
				--	type_id := Current.get_eiffel_class ({MTCLASS}.MT_OBJECT_NAME)
				--end
				--obj ?= new_instance_of (type_id);

				-- to change the assignement
				-- (1) get rid of MT_OBJECT which is done when STORABLE disappears
				-- or (2) move mtdb into MT_OBJECT
				obj := db.context.dynamic_create_proxi_eif_object (mt_oid)
				obj.make_from_mtoid(db, mt_oid)
				Result := obj
			end
		end

end
