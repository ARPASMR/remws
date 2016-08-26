note
	description: "Core Object Factory class for the binding"
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
	MT_CORE_OBJECT_FACTORY

inherit
	MT_OBJECT_FACTORY

create
	make

feature {NONE} -- Implementation

feature -- Initialization

	make
		do
		end

feature {NONE} -- Implementation

	get_mtclass_oid(db: MT_DATABASE) : INTEGER_32
		local
			to_c: ANY
		once
			to_c := {MTCLASS}.MT_CLASS_NAME.to_c
			Result := db.context.get_class_from_name($to_c)
		end

	get_mtattribute_oid(db: MT_DATABASE) : INTEGER_32
		local
			to_c: ANY
		once
			to_c := {MTCLASS}.MT_ATTRIBUTE_NAME.to_c
			Result := db.context.get_class_from_name($to_c)
		end

	get_mtrelationship_oid(db: MT_DATABASE) : INTEGER_32
		local
			to_c: ANY
		once
			to_c := {MTCLASS}.MT_RELATIONSHIP_NAME.to_c
			Result := db.context.get_class_from_name($to_c)
		end

	get_mttype_oid(db: MT_DATABASE) : INTEGER_32
		local
			to_c: ANY
		once
			to_c := {MTCLASS}.MT_TYPE_NAME.to_c
			Result := db.context.get_class_from_name($to_c)
		end

	get_mtindex_oid(db: MT_DATABASE) : INTEGER_32
		local
			to_c: ANY
		once
			to_c := {MTCLASS}.MT_INDEX_NAME.to_c
			Result := db.context.get_class_from_name($to_c)
		end

	get_mtentrypointdictionary_oid(db: MT_DATABASE) : INTEGER_32
		local
			to_c: ANY
		once
			to_c := {MTCLASS}.MT_ENTRY_POINT_DICTIONARY_NAME.to_c
			Result := db.context.get_class_from_name($to_c)
		end

	get_mtmethod_oid(db: MT_DATABASE) : INTEGER_32
		local
			to_c: ANY
		once
			to_c := {MTCLASS}.MT_METHOD_NAME.to_c
			Result := db.context.get_class_from_name($to_c)
		end

	get_mtobject_type_id (): INTEGER_32
		-- return the Eiffel type id for Matisse MTOBJECT
		local
			c_cls_name: ANY
		once
			c_cls_name := {MTCLASS}.MT_OBJECT_NAME.to_c
			Result := {MT_NATIVE}.c_get_eif_type_id ($c_cls_name, True)
		end


feature -- Interface Implementation

	get_eiffel_class (mtcls_name: STRING): INTEGER_32
		-- return the Eiffel type id  for Matisse MTOBJECT
		do
			Result := get_mtobject_type_id ()
		end

   get_database_class (eif_cls_name: STRING): STRING
		-- return the database class name from the eiffel class name
		do
			Result := eif_cls_name
		end

   get_object_instance (db: MT_DATABASE; mt_oid: INTEGER_32): MT_OBJECT
    	-- Return an instance of the appropriate base class
		local
			vobj: MTOBJECT
			vcls: MTCLASS
			vatt: MTATTRIBUTE
			vrel: MTRELATIONSHIP
			vtyp: MTTYPE
			vidx: MTINDEX
			vepd: MTENTRYPOINTDICTIONARY
			vmth: MTMETHOD
		do
			if mt_oid > 0 then
			if db.context.is_instance_of (mt_oid,get_mtclass_oid(db)) then
				create vcls.make_from_mtoid (db, mt_oid)
				Result := vcls
			else
				if db.context.is_instance_of (mt_oid,get_mtattribute_oid(db)) then
					create vatt.make_from_mtoid (db, mt_oid)
					Result := vatt
				else
					if db.context.is_instance_of (mt_oid,get_mtrelationship_oid(db)) then
						create vrel.make_from_mtoid (db, mt_oid)
						Result := vrel
					else
						if db.context.is_instance_of (mt_oid,get_mttype_oid(db)) then
							create vtyp.make_from_mtoid (db, mt_oid)
							Result := vtyp
						else
							if db.context.is_instance_of (mt_oid,get_mtindex_oid(db)) then
								create vidx.make_from_mtoid (db, mt_oid)
								Result := vidx
							else
								if db.context.is_instance_of (mt_oid,get_mtentrypointdictionary_oid(db)) then
									create vepd.make_from_mtoid (db, mt_oid)
									Result := vepd
								else
									if db.context.is_instance_of (mt_oid,get_mtmethod_oid(db)) then
										create vmth.make_from_mtoid (db, mt_oid)
										Result := vmth
									else
										create vobj.make_from_mtoid (db, mt_oid)
										Result := vobj
									end
								end
							end
						end
					end
				end
			end
			end
		end

end
