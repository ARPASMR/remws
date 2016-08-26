note
	description: "MATISSE-Eiffel Binding: define the HASH_TABLE class with key and value of type MtRelationship"
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
	MT_RR_HASH_TABLE [G -> MT_OBJECT, H -> HASHABLE]

inherit
	MT_HASH_TABLE [G, H]
		redefine
			load_successors,
			store_updates,
			get_all_keys,
			get_all_values,
			put, force, extend, replace, replace_key
		end

create
	make

feature -- Redefinition of HASH_TABLE API

	put (new: G; key: H)
		local
			mt_obj: MT_STORABLE
		do
			relationship.persister.mark_container_modified (oid)
			ht_put (new, key)
			if is_persistent and then inserted then
				mt_obj ?= new
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
				mt_obj ?= key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
			end
		end

	force (new: G; key: H)
		local
			mt_obj: MT_STORABLE
		do
			relationship.persister.mark_container_modified (oid)
			ht_force (new, key)
			if is_persistent then
				mt_obj ?= new
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
				mt_obj ?= key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
			end
		end

	extend (new: G; key: H)
		local
			mt_obj: MT_STORABLE
		do
			relationship.persister.mark_container_modified (oid)
			ht_extend (new, key)
			if is_persistent then
				mt_obj ?= new
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
				mt_obj ?= key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
			end
		end

	replace (new: G; key: H)
		local
			mt_obj: MT_STORABLE
		do
			relationship.persister.mark_container_modified (oid)
			ht_replace (new, key)
			if is_persistent and then replaced then
				mt_obj ?= new
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
				mt_obj ?= key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
			end
		end

	replace_key (new_key: H; old_key: H)
		local
			mt_obj: MT_STORABLE
		do
			relationship.persister.mark_container_modified (oid)
			ht_replace_key (new_key, old_key)
			if is_persistent then
				mt_obj ?= new_key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
			end
		end

feature {MT_HASH_TABLE} -- Loading & storing successors	

	load_successors
		local
			all_keys: ARRAY [H]
			all_values: ARRAY [G]
			value_indexes: ARRAY [INTEGER]
			i: INTEGER
			rel: MT_SINGLE_RELATIONSHIP
			has_default_att: MT_ATTRIBUTE
			succ: ARRAY [G]
			default_value: G
			default_key: H
		do
			if not successors_loaded then
				successors_loaded := True
				if is_persistent then
					from
						start_loading
						all_keys := get_all_keys
						all_values := get_all_values
						value_indexes := get_value_indexes
						i := all_keys.lower
					until
						i > all_keys.upper
					loop
						if value_indexes.item (i) = 0 then
							ht_force (default_value, all_keys.item (i))
						else
							ht_force (all_values.item (value_indexes.item (i)), all_keys.item (i))
						end
						i := i + 1
					end

					create has_default_att.make_from_names ("has_default", "HASH_TABLE", persister.mtdb)
					if has_default_att.get_boolean (Current) then
						create rel.make_from_names ("void_key_obj_value", "HASH_TABLE", persister.mtdb)
						succ ?= successors (rel)
						if succ.is_empty then
							ht_force (default_value, default_key)
						else
							ht_force (succ.item (succ.lower), default_key)
						end
					end
				end
			end
		end

	store_updates
		local
			all_keys: ARRAYED_LIST [MT_OBJECT]
			all_values: ARRAYED_LIST [G]
			a_linear: ARRAYED_LIST [G]
			index_att, has_default_att: MT_ATTRIBUTE
			key_rs, value_rs, void_key_rs: MT_RELATIONSHIP
			default_key: H
			i, j, index, key_count: INTEGER
			indexes: ARRAY [INTEGER]
			mt_obj: MT_OBJECT
		do
			create all_keys.make (count)
			create all_values.make (count)
			create indexes.make (1, count)
			create key_rs.make_from_names ("obj_keys", "HASH_TABLE", persister.mtdb)
			create value_rs.make_from_names ("obj_values", "HASH_TABLE", persister.mtdb)
			create index_att.make_from_names ("value_index", "HASH_TABLE", persister.mtdb)
			j := 1
			from
				i := 0
			until
				i = keys.count
					-- item at upper is used for default key
			loop
				if keys.item (i) /= default_key then
					key_count := key_count + 1
					mt_obj ?= keys.item (i)
					if mt_obj /= Void then
						all_keys.extend (mt_obj)
						if content.item (i) = Void then
							indexes.put (0, key_count)
						else
							index := all_values.index_of (content.item (i), 1)
							if index = 0 then
								indexes.put (j, key_count)
								all_values.extend (content.item (i))
								j := j + 1
							else
								indexes.put (index, key_count)
							end
						end
					end
				end
				i := i + 1
			end
			key_rs.set_successors (Current, all_keys)
			value_rs.set_successors (Current, all_values)
			index_att.set_integer_array_value (Current, indexes)

			create has_default_att.make_from_names ("has_default", "HASH_TABLE", persister.mtdb)
			if has_default then
				has_default_att.set_boolean_value (Current, True)
				create void_key_rs.make_from_names ("void_key_obj_value", "HASH_TABLE", persister.mtdb)
				create a_linear.make (1)
				if default_key_value /= Void then
					a_linear.extend (default_key_value)
				end
				void_key_rs.set_successors (Current, a_linear)
			else
				has_default_att.set_boolean_value (Current, False)
			end
		end

feature {NONE}

	get_all_keys: ARRAY [H]
		local
			rel: MT_MULTI_RELATIONSHIP
		do
			create rel.make_from_names ("obj_keys", "HASH_TABLE", persister.mtdb)
			Result ?= successors (rel)
		end

	get_all_values : ARRAY [G]
		local
			rel: MT_MULTI_RELATIONSHIP
		do
			create rel.make_from_names ("obj_values", "HASH_TABLE", persister.mtdb)
			Result ?= successors (rel)
		end

end -- class MT_RR_HASH_TABLE

