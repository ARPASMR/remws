note
	description: "MATISSE-Eiffel Binding: define the Hashtable Relationship class"
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
	MT_HASH_TABLE_RELATIONSHIP

inherit
	MT_MULTI_RELATIONSHIP
		redefine
			get_container_type,
			empty_container_for
		end

create
	make_from_id

feature

	get_container_type (object: MT_STORABLE): STRING
		do
			Result := "MT_HASH_TABLE"
		end

feature {MT_STORABLE} -- Container

	empty_container_for(a_predecessor: MT_STORABLE; a_field_type: INTEGER): MT_RS_CONTAINABLE
			-- Return an empty container object (HASH_TABLE).
			-- The container is initialized so that it can load successors later.
			-- ('predecessor' and 'relationship' is set to `a_predecessor' and `Current'.)
		local
			a: ANY
      container_obj: MT_STORABLE
		do
			a := type_name_of_type (a_field_type).to_c
			Result ?= mtdb.context.create_empty_rs_container ( $a, a_predecessor.oid, oid)
			if Result /= Void then
				Result.set_predecessor (a_predecessor)
				Result.set_relationship (Current)
        container_obj ?= Result
        if container_obj /= Void then
          container_obj.set_persister (persister)
        end
			end
		end

feature {NONE}  -- dummy declaration for dynamic object creation

	aaii: MT_AA_HASH_TABLE[INTEGER, INTEGER] once end
	aaic: MT_AA_HASH_TABLE[INTEGER, CHARACTER] once end
	aair: MT_AA_HASH_TABLE[INTEGER, REAL] once end
	aaid: MT_AA_HASH_TABLE[INTEGER, DOUBLE] once end
	aaib: MT_AA_HASH_TABLE[INTEGER, BOOLEAN] once end
	aais: MT_AA_HASH_TABLE[INTEGER, STRING] once end

	aaci: MT_AA_HASH_TABLE[CHARACTER, INTEGER] once end
	aacc: MT_AA_HASH_TABLE[CHARACTER, CHARACTER] once end
	aacr: MT_AA_HASH_TABLE[CHARACTER, REAL] once end
	aacd: MT_AA_HASH_TABLE[CHARACTER, DOUBLE] once end
	aacb: MT_AA_HASH_TABLE[CHARACTER, BOOLEAN] once end
	aacs: MT_AA_HASH_TABLE[CHARACTER, STRING] once end

	aari: MT_AA_HASH_TABLE[REAL, INTEGER] once end
	aarc: MT_AA_HASH_TABLE[REAL, CHARACTER] once end
	aarr: MT_AA_HASH_TABLE[REAL, REAL] once end
	aard: MT_AA_HASH_TABLE[REAL, DOUBLE] once end
	aarb: MT_AA_HASH_TABLE[REAL, BOOLEAN] once end
	aars: MT_AA_HASH_TABLE[REAL, STRING] once end

	aadi: MT_AA_HASH_TABLE[DOUBLE, INTEGER] once end
	aadc: MT_AA_HASH_TABLE[DOUBLE, CHARACTER] once end
	aadr: MT_AA_HASH_TABLE[DOUBLE, REAL] once end
	aadd: MT_AA_HASH_TABLE[DOUBLE, DOUBLE] once end
	aadb: MT_AA_HASH_TABLE[DOUBLE, BOOLEAN] once end
	aads: MT_AA_HASH_TABLE[DOUBLE, STRING] once end

	aabi: MT_AA_HASH_TABLE[BOOLEAN, INTEGER] once end
	aabc: MT_AA_HASH_TABLE[BOOLEAN, CHARACTER] once end
	aabr: MT_AA_HASH_TABLE[BOOLEAN, REAL] once end
	aabd: MT_AA_HASH_TABLE[BOOLEAN, DOUBLE] once end
	aabb: MT_AA_HASH_TABLE[BOOLEAN, BOOLEAN] once end
	aabs: MT_AA_HASH_TABLE[BOOLEAN, STRING] once end

	aasi: MT_AA_HASH_TABLE[STRING, INTEGER] once end
	aasc: MT_AA_HASH_TABLE[STRING, CHARACTER] once end
	aasr: MT_AA_HASH_TABLE[STRING, REAL] once end
	aasd: MT_AA_HASH_TABLE[STRING, DOUBLE] once end
	aasb: MT_AA_HASH_TABLE[STRING, BOOLEAN] once end
	aass: MT_AA_HASH_TABLE[STRING, STRING] once end


	rari: MT_RA_HASH_TABLE[MT_OBJECT, INTEGER] once end
	rarc: MT_RA_HASH_TABLE[MT_OBJECT, CHARACTER] once end
	rarr: MT_RA_HASH_TABLE[MT_OBJECT, REAL] once end
	rard: MT_RA_HASH_TABLE[MT_OBJECT, DOUBLE] once end
	rarb: MT_RA_HASH_TABLE[MT_OBJECT, BOOLEAN] once end
	rars: MT_RA_HASH_TABLE[MT_OBJECT, STRING] once end


	arir: MT_AR_HASH_TABLE[INTEGER, STRING] once end
	arcr: MT_AR_HASH_TABLE[CHARACTER, STRING] once end
	arrr: MT_AR_HASH_TABLE[REAL, STRING] once end
	ardr: MT_AR_HASH_TABLE[DOUBLE, STRING] once end
	arbr: MT_AR_HASH_TABLE[BOOLEAN, STRING] once end
	arsr: MT_AR_HASH_TABLE[STRING, STRING] once end

	rrrr: MT_RR_HASH_TABLE[MT_OBJECT, STRING] once end

end -- class MT_HASH_TABLE_RELATIONSHIP
