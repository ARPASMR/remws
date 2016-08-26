note
	description: "MATISSE-Eiffel Binding: define the hash_table class"
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
	MT_HASH_TABLE [G, H -> HASHABLE]

inherit
	HASH_TABLE [G, H]
		rename
			put as ht_put,
			force as ht_force,
			extend as ht_extend,
			replace as ht_replace,
			replace_key as ht_replace_key,
			remove as ht_remove,
			clear_all as ht_clear_all
		end

	HASH_TABLE [G, H]
		redefine
			put, force, extend,
			replace, replace_key,
			remove, clear_all
		select
			put, force, extend,
			replace, replace_key,
			remove, clear_all
		end

	MT_RS_CONTAINABLE
		undefine
			is_equal, copy, load_successors, is_persistent
		redefine
			mtdb
		end

	MT_CONTAINER_OBJECT
		redefine
			mtdb
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
				-- ht_put is necessary for 'load_successors'
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
			if is_persistent and then replaced then
				mt_obj ?= new_key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
				mt_obj ?= old_key
				if mt_obj /= Void then
					check_persistence (mt_obj)
				end
			end
		end

	remove (key: H)
		do
			relationship.persister.mark_container_modified (oid)
			ht_remove (key)
		end

	clear_all
		do
			relationship.persister.mark_container_modified (oid)
			wipe_out
		end

feature {MT_STORABLE} -- Persistence

	become_persistent_container (a_db: MT_DATABASE; a_predecessor: MT_STORABLE; field_position: INTEGER)
		local
			a_mt_class: MT_CLASS
			rs: MT_MULTI_RELATIONSHIP
			a_persister: MT_PERSISTER
		do
			a_persister ?= a_db.persister
			oid := a_persister.create_new_container ("HASH_TABLE")
			a_persister.register_container (Current)
			a_mt_class := a_persister.mt_class_from_object (a_predecessor)
			rs ?= a_mt_class.get_relationship_by_position (field_position, a_predecessor)
			set_predecessor (a_predecessor)
			set_relationship (rs)
			a_persister.append_successor (a_predecessor, field_position, Current)
			successors_loaded := True
			persister := a_persister
		end

feature

	load_successors
		local
			all_keys: ARRAY [H]
			all_values: ARRAY [G]
			value_indexes: ARRAY [INTEGER]
			i: INTEGER
			default_value: G
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
				end
			end
		end

feature {NONE} -- Loading & storing successors	

	mttype_ref: MT_TYPE  once create Result end

	start_loading
		do
			oid  := mtdb.context.get_single_successor (predecessor.oid, relationship.oid)
			relationship.persister.register_container (Current)
		end

	get_all_keys: ARRAY [H]
		local
			att: MT_ATTRIBUTE
			rel: MT_RELATIONSHIP
		do
			create att.make_from_names ("att_keys", "HASH_TABLE", persister.mtdb)
			Result ?= att.get_value (Current)
			if Result = Void then
				create rel.make ("obj_keys", persister.mtdb)
				Result ?= successors (rel)
			end
		end

	get_all_values: ARRAY [G]
		local
			att, has_default_att: MT_ATTRIBUTE
			rel: MT_RELATIONSHIP
			succ: ARRAY [G]
			default_key: H
			default_value: G
			att_type: INTEGER
			a_cell: CELL [G];
			any_cell: CELL [ANY]
			int_cell: CELL [INTEGER]
			float_cell: CELL [REAL]
			double_cell: CELL [DOUBLE]
		do
			create has_default_att.make_from_names ("has_default", "HASH_TABLE", persister.mtdb)
			create att.make_from_names ("att_values", "HASH_TABLE", persister.mtdb)
			Result ?= att.get_value (Current)
			if Result = Void then
				create rel.make ("obj_values", persister.mtdb)
				Result ?= successors (rel)
				if has_default_att.get_boolean (Current) then
					create rel.make ("void_key_obj_value", persister.mtdb)
					succ ?= successors (rel)
					if succ.is_empty then
						ht_put (default_value, default_key)
					else
						ht_put (succ.item (succ.lower), default_key)
					end
				end
			else
				if has_default_att.get_boolean (Current) then
					create att.make_from_names ("void_key_att_value", "HASH_TABLE", persister.mtdb)
					att_type := att.dynamic_att_type (Current)
					if att_type /= {MT_TYPE}.Mt_nil then
						inspect att_type
						when {MT_TYPE}.Mt_s32 then
							create  int_cell.put (att.get_integer (Current));
							a_cell ?= int_cell
						when {MT_TYPE}.Mt_s16 then
							create  int_cell.put (att.get_short (Current));
							a_cell ?= int_cell
						when {MT_TYPE}.Mt_float then
							create  float_cell.put (att.get_real (Current));
							a_cell ?= float_cell
						when {MT_TYPE}.Mt_double then
							create  double_cell.put (att.get_double (Current));
							a_cell ?= double_cell
						else
							a_cell ?= any_cell;
							create  any_cell.put (att.get_value (Current))
						end;
						ht_put (a_cell.item, default_key)
					end
				end
			end
		end

	get_value_indexes: ARRAY [INTEGER]
		local
			att: MT_ATTRIBUTE
		do
			create att.make_from_names ("value_index", "HASH_TABLE", persister.mtdb)
			Result ?= att.get_value (Current)
		end

feature {MT_RELATIONSHIP} -- Reloading successors

	reload_successors is
			-- Reload successors
		do

		end

feature {MT_HASH_TABLE} -- Loading & storing successors	

	store_updates
		local
			all_keys: ARRAY [H]
			all_values: ARRAY [G]
			key_att, value_att, index_att, att, has_default_att: MT_ATTRIBUTE
			key_rs, value_rs, rs: MT_RELATIONSHIP
			default_key: H
			default_value: G
			i, values_count, index, key_count: INTEGER
			indexes: ARRAY [INTEGER]
			mt_keys_type, mt_values_type: INTEGER
			a_linear: ARRAYED_LIST [MT_OBJECT]
			mt_obj: MT_OBJECT
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
				if is_attribute (mt_keys_type) then
					all_keys.put (default_key, count)
					if default_key_value = default_value then
						indexes.put (0, count)
					else
						index := first_index_of (default_key_value, all_values)
						if index = 0 then
							values_count := values_count + 1
							indexes.put (values_count, count)
							all_values.put (default_key_value, values_count)
						else
							indexes.put (index, count)
						end
					end
				else -- keys are relationship
					if is_attribute (mt_values_type) then
						create att.make_from_names ("void_key_att_value", "HASH_TABLE", persister.mtdb)
						if default_key_value = Void then
							att.set_string_value (Current, {MT_TYPE}.Mt_string, Void)
						else
							att.set_dynamic_value (Current, default_key_value)
						end
					else
						create rs.make ("void_key_obj_value", persister.mtdb)
						create a_linear.make (1)
						if default_key_value /= default_value then
							mt_obj ?= default_key_value
							if mt_obj /= Void then
								a_linear.extend (mt_obj)
							end
						end
						rs.set_successors (Current, a_linear)
					end
				end
			else
				has_default_att.set_boolean_value (Current, False)
			end

			create index_att.make_from_names ("value_index", "HASH_TABLE", persister.mtdb)
			index_att.set_integer_array_value (Current, indexes)

			if is_attribute (mt_keys_type) then
				create key_att.make_from_names ("att_keys", "HASH_TABLE", persister.mtdb)
				key_att.set_dynamic_value (Current, all_keys)
			else
				create key_rs.make ("obj_keys", persister.mtdb)
				a_linear ?= all_keys.linear_representation
				if has_default then
					a_linear.finish
					a_linear.remove
				end
				if a_linear /= Void then
					key_rs.set_successors (Current, a_linear)
				end
			end

			if is_attribute (mt_values_type) then
				create value_att.make_from_names ("att_values", "HASH_TABLE", persister.mtdb)
				if values_count = 0 then
					create all_values.make (1, 0)
					value_att.set_dynamic_value (Current, all_values)
				else
					value_att.set_dynamic_value (Current, all_values.subarray (1, values_count))
				end
			else
				create value_rs.make ("obj_values", persister.mtdb)
				if values_count = 0 then
					create all_values.make (1, 0)
					a_linear ?= all_values.linear_representation
				else
					a_linear ?= all_values.subarray (1, values_count).linear_representation
				end
				if a_linear /= Void then
					value_rs.set_successors (Current, a_linear)
				end
			end
		end

	mtdb: MT_DATABASE

feature {NONE} -- Implementation

	first_index_of (v: G; an_array: ARRAY [G]): INTEGER
			-- Index of first occurence of 'v'.
			-- 0 if none.
		require
			one_start_index: an_array.lower = 1
		local
			i, upper_bound: INTEGER
		do
			upper_bound := an_array.upper
			if an_array.object_comparison then
				if v = Void then
					Result := 0
				else
					from
						i := an_array.lower
					until
						i > upper_bound or else
						  (an_array.item (i) /= Void and then an_array.item (i).is_equal (v))
					loop
						i := i + 1
					end
					if i > upper_bound then
						Result := 0
					else
						Result := i
					end
				end
			else
				from
					i := an_array.lower
				until
					i > upper_bound or else (an_array.item (i) = v)
				loop
					i := i + 1
				end
				if i > upper_bound then
					Result := 0
				else
					Result := i
				end
			end
		end

	mt_property_type_of_keys: INTEGER
			-- Is the keys of the current object stored as MATISSE attribute
			-- or relationship? Return 'A' for attribute or 'R' for relationship.
		local
			keys_type: INTEGER
			str: STRING
			a_date: DATE
			default_key: H
			i: INTEGER
		do
			keys_type := dynamic_type (keys)
			if keys_type = mttype_ref.Eif_integer_array_type then
				Result := {MT_TYPE}.Mt_s32_array
			elseif keys_type = mttype_ref.Eif_real_array_type then
				Result := {MT_TYPE}.Mt_float_array
			elseif keys_type = mttype_ref.Eif_double_array_type then
				Result := {MT_TYPE}.Mt_double_array
			else
				from
					i := 0
				until
					i = keys.count or keys.item (i) /= default_key
				loop
					i := i + 1
				end

				if i = keys.count then
					Result := -1  -- relationship
				else
					str ?= keys.item (i)
					if str /= Void then
						Result := {MT_TYPE}.Mt_string_array
					else
						a_date ?= keys.item (i)
						if a_date /= Void then
							-- to be done
						else
							Result := -1 -- relationship
						end
					end
				end
			end
		end

	mt_property_type_of_values: INTEGER
		-- Is the values of the current object stored as MATISSE attribute
		-- or relationship? Return 'A' for attribute or 'R' for relationship.
		local
			values_type: INTEGER
			str: STRING
			a_date: DATE
			default_value: G
			i: INTEGER
		do
			values_type := dynamic_type (content)
			if values_type = mttype_ref.Eif_integer_array_type then
				Result := {MT_TYPE}.Mt_s32_array
			elseif values_type = mttype_ref.Eif_real_array_type then
				Result := {MT_TYPE}.Mt_float_array
			elseif values_type = mttype_ref.Eif_double_array_type then
				Result := {MT_TYPE}.Mt_double_array
			else
				from
					i := 0
				until
					i = content.count or content.item (i) /= default_value
				loop
					i := i + 1
				end

				if i = content.count then
					Result := -1
				else
					str ?= content.item (i)
					if str /= Void then
						Result := {MT_TYPE}.Mt_string_array
					else
						a_date ?= content.item (i)
						if a_date /= Void then
							-- to be done
						else
							Result := -1
						end
					end
				end
			end
		end

	is_attribute (a_mt_type: INTEGER): BOOLEAN
		do
			Result := a_mt_type > 0
		end

	wipe_out_at_reverting
		do
			wipe_out
		end

end -- class MT_HASH_TABLE

