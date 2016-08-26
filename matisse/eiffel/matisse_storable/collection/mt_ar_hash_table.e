note
	description: "MATISSE-Eiffel Binding: define the HASH_TABLE class with key of type MtRelationship and value of type MtAttribute"
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
	MT_AR_HASH_TABLE [G, H -> HASHABLE]

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
			if is_persistent and then replaced then
				mt_obj ?= new_key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
			end
		end

feature

	load_successors
		local
			all_keys: ARRAY [H]
			all_values: ARRAY [G]
			value_indexes: ARRAY [INTEGER]
			i: INTEGER
			att, has_default_att: MT_ATTRIBUTE
			att_type: INTEGER
			a_cell: CELL [G]
			any_cell: CELL [ANY]
			int_cell: CELL [INTEGER]
			float_cell: CELL [REAL]
			double_cell: CELL [DOUBLE]
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
						create att.make_from_names ("void_key_att_value", "HASH_TABLE", persister.mtdb)
						att_type := att.dynamic_att_type (Current)
						if att_type /= {MT_TYPE}.Mt_nil then
							inspect att_type
							when {MT_TYPE}.Mt_s32 then
								create int_cell.put (att.get_integer (Current))
								a_cell ?= int_cell
							when {MT_TYPE}.Mt_s16 then
								create int_cell.put (att.get_short (Current))
								a_cell ?= int_cell
							when {MT_TYPE}.Mt_float then
								create float_cell.put (att.get_real (Current))
								a_cell ?= float_cell
							when {MT_TYPE}.Mt_double then
								create double_cell.put (att.get_double (Current))
								a_cell ?= double_cell
							else
								create any_cell.put (att.get_value (Current))
								a_cell ?= any_cell
							end
							ht_force (a_cell.item, default_key)
						end
					end
				end
			end
		end

	store_updates
		local
			all_keys: ARRAY [H]
			all_values: ARRAY [G]
			value_att, index_att, att, has_default_att: MT_ATTRIBUTE
			key_rs: MT_RELATIONSHIP
			default_key: H
			default_value: G
			i, values_count, index, key_count: INTEGER
			indexes: ARRAY [INTEGER]
			mt_keys_type, mt_values_type: INTEGER
			a_linear: ARRAYED_LIST [MT_OBJECT]
		do
			mt_keys_type := mt_property_type_of_keys
			mt_values_type := mt_property_type_of_values

			create all_keys.make (1, count)
			create all_values.make (1, count)
			create indexes.make (1, count)
			from
				values_count := 0
				i := 0
			until
				i = keys.count
			loop
				if keys.item (i) /= default_key then
					key_count := key_count + 1
					all_keys.put (keys.item (i), key_count)
					if content.item (i) = default_value then
						indexes.put (0, key_count)
					else
						index := first_index_of (content.item (i), all_values)
						if index = 0 then
							values_count := values_count + 1
							indexes.put (values_count, key_count)
							all_values.put (content.item (i), values_count)
						else
							indexes.put (index, key_count)
						end
					end
				end
				i := i + 1
			end

			create has_default_att.make_from_names ("has_default", "HASH_TABLE", persister.mtdb)
			if has_default then
				has_default_att.set_boolean_value (Current, True)
				create att.make_from_names ("void_key_att_value", "HASH_TABLE", persister.mtdb)
				if default_key_value = Void then
					-- this attribute should be string
					att.set_string_value (Current, {MT_TYPE}.Mt_string, Void)
				else
					att.set_dynamic_value (Current, default_key_value)
				end
			else
				has_default_att.set_boolean_value (Current, False)
			end

			create index_att.make_from_names ("value_index", "HASH_TABLE", persister.mtdb)
			index_att.set_integer_array_value (Current, indexes)

			create key_rs.make_from_names ("obj_keys", "HASH_TABLE", persister.mtdb)
			a_linear ?= all_keys.linear_representation
			if has_default then
				a_linear.finish
				a_linear.remove
			end
			if a_linear /= Void then
				key_rs.set_successors (Current, a_linear)
			end

			create value_att.make_from_names ("att_values", "HASH_TABLE", persister.mtdb)
			if values_count = 0 then
				create all_values.make (1, 0)
				value_att.set_dynamic_value (Current, all_values)
			else
				value_att.set_dynamic_value (Current, all_values.subarray (1, values_count))
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

	get_all_values: ARRAY [G]
		local
			att: MT_ATTRIBUTE
		do
			create att.make_from_names ("att_values", "HASH_TABLE", persister.mtdb)
			Result ?= att.get_value (Current)
		end

end -- class MT_AR_HASH_TABLE

