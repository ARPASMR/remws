note
	description: "MATISSE-Eiffel Binding: define Matisse MtEntryPointDictionary meta-class"
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
	MT_ENTRYPOINTDICTIONARY

inherit
	MT_METASCHEMA

create

	make_with_db

feature -- Meta-Schema Entry Point Dictionary names

  MT_NAME_DICTIONARY_NAME: STRING = "MtNameDictionary"

feature {MT_DATABASE}

	make_with_db (a_dict_name, a_class_name: STRING; a_db: MT_DATABASE)
		require
			dict_name_not_void: a_dict_name /= Void
			dict_name_not_empty: not a_dict_name.is_empty
			db_not_void: a_db /= Void
		local
			c_dict_name, c_class_name: ANY
			CID: INTEGER
		do
			persister ?= a_db.persister
			mtdb := a_db
			c_dict_name := a_dict_name.to_c
			oid := mtdb.context.get_entry_point_dictionary ( $c_dict_name)
			if a_class_name /= Void then
				ep_class_name := a_class_name.twin
				c_class_name := ep_class_name.to_c
				cid := mtdb.context.get_class_from_name ( $c_class_name)
				create ep_class.make_from_oid_and_db (cid, persister.mtdb)
			end
		end

feature -- Retrieval

	retrieve_objects (ep_string: STRING): ARRAY [MT_STORABLE]
			-- Retrieve objects accessed through entrypoint value 'ep_string'.
		obsolete "Use {MTENTRYPOINTDICTIONARY}.retrieve"
		local
			c_ep_string: ANY
			i, cid: INTEGER
			one_object: MT_STORABLE
			matched_keys: ARRAY [INTEGER]
		do
			c_ep_string := ep_string.to_c
			if Void = ep_class then
				cid := 0
			else
				cid := ep_class.oid
			end
			matched_keys := mtdb.context.get_objects_from_entry_point ( oid, cid, $c_ep_string)

			create Result.make (1, matched_keys.count)
			from
 				i := matched_keys.lower
			until
				i > matched_keys.upper
			loop
				one_object := persister.new_eif_object_from_oid (matched_keys.item(i))
				Result.put (one_object, i)
				i := i + 1
			end -- loop
		end

	retrieve (ep_string, a_class_name: STRING): ARRAY [MT_STORABLE]
			-- Retrieve objects accessible through entry-point value 'ep_string'
			-- If a_class_name specified, retrieve objects of the class 'a_class_name'
			-- or its subclasses.
		require
			not_void: ep_string /= Void
		local
			c_ep_string, c_class_name: ANY
			i, cid: INTEGER
			one_object: MT_STORABLE
			matched_keys: ARRAY [INTEGER]
		do
			c_ep_string := ep_string.to_c
			if Void = a_class_name then
				cid := 0
			else
				c_class_name := a_class_name.to_c
				cid := mtdb.context.get_class_from_name ( $c_class_name)
			end

			matched_keys :=
				mtdb.context.get_objects_from_entry_point ( oid, cid, $c_ep_string)
			create Result.make (1, matched_keys.count)
			from
 				i := matched_keys.lower
			until
				i > matched_keys.upper
			loop
				one_object := persister.new_eif_object_from_oid (matched_keys.item(i))
				Result.put (one_object, i)
				i := i + 1
			end -- loop
		end

	retrieve_n_firsts (ep_string: STRING; n: INTEGER): ARRAY [MT_STORABLE]
			-- Return `n' firsts objects accessed through the entrypoint.
		obsolete "Use {MTENTRYPOINTDICTIONARY}.retrieve_some"
		local
			c_ep_string: ANY
			i, cid: INTEGER
			one_object: MT_STORABLE
			matched_keys: ARRAY [INTEGER]
		do
			c_ep_string := ep_string.to_c
			if Void = ep_class then
				cid := 0
			else
				cid := ep_class.oid
			end
			matched_keys := mtdb.context.get_objects_from_entry_point ( oid, cid, $c_ep_string)

			create Result.make (1, n.min(matched_keys.count))
			from
 				i := Result.lower
			until
				i > Result.upper
			loop
				one_object := persister.new_eif_object_from_oid (matched_keys.item(i))
				Result.put (one_object, i)
				i := i + 1
			end
		end

	retrieve_some (ep_string, a_class_name: STRING; n: INTEGER): ARRAY [MT_STORABLE]
			-- Return n first objects accessed through the entrypoint.
		require
			not_void: ep_string /= Void
		local
			c_ep_string, c_class_name: ANY
			i, cid: INTEGER
			one_object: MT_STORABLE
			matched_keys: ARRAY [INTEGER]
		do
			c_ep_string := ep_string.to_c
			if Void = a_class_name then
				cid := 0
			else
				c_class_name := a_class_name.to_c
				cid := mtdb.context.get_class_from_name ( $c_class_name)
			end

			matched_keys := mtdb.context.get_objects_from_entry_point ( oid, cid, $c_ep_string)
			create Result.make (1, n.min(matched_keys.count))
			from
 				i := Result.lower
			until
				i > Result.upper
			loop
				one_object := persister.new_eif_object_from_oid (matched_keys.item(i))
				Result.put (one_object, i)
				i := i + 1
			end
		end


	retrieve_first (ep_string: STRING): MT_STORABLE
			-- Return just a first object accessed through the entry point.
		local
			a_stream: MT_ENTRYPOINT_STREAM
		do
			a_stream := open_stream (ep_string)
			a_stream.start
			if not a_stream.exhausted then
				Result := a_stream.item
			end
			a_stream.close
		end

	open_stream (ep_string: STRING): MT_ENTRYPOINT_STREAM
		do
			create Result.make (ep_string, Current, ep_class)
		end

feature -- Lock objects

	lock_objects (a_lock: INTEGER; ep_string, a_class_name: STRING)
			-- Lock objects of entrypoint
		require
			lock_is_read_or_is_write: a_lock = {MT_DATABASE}.Mt_Read or a_lock = {MT_DATABASE}.Mt_Write
			ep_not_void: ep_string /= Void
		local
			c_ep_string, c_class_name: ANY
			cid: INTEGER
		do
			c_ep_string := ep_string.to_c
			if Void = a_class_name then
				cid := 0
			else
				c_class_name := a_class_name.to_c
				cid := mtdb.context.get_class_from_name ( $c_class_name)
			end

			mtdb.context.lock_objects_from_entry_point ( a_lock, $c_ep_string, oid, cid)
		end

feature {NONE} -- Implementation

	ep_class: MT_CLASS
		-- Associated class

	ep_class_name: STRING
		-- Name of `ep_class'

end -- class MTENTRYPOINTDICTIONARY
