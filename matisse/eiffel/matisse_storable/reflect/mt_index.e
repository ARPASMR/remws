note
	description: "MATISSE-Eiffel Binding: define Matisse MtIndex meta-class"
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
	MT_INDEX

inherit
	MT_METASCHEMA

	MT_EXCEPTIONS
		export
			{NONE} all
		undefine
			is_equal, copy
		end

create

	make_with_db

feature -- Initilization

			-- To be moved out
feature -- Direction

	Mt_Direct: INTEGER = 1
	Mt_Reverse: INTEGER = -1

			-- To be moved out
feature -- Ordering

	Mt_Descend: INTEGER = 0
	Mt_Ascend: INTEGER = 1

feature {MT_DATABASE}

	make_with_db (an_index_name: STRING; a_db: MT_DATABASE)
		require
			index_name_not_void: an_index_name /= Void
			index_name_not_empty: not an_index_name.is_empty
			db_not_void: a_db /= Void
		local
			c_index_name: ANY
			a_criterion: MT_INDEX_CRITERION
			a_class: MT_CLASS
			i, num_classes: INTEGER
			index_name: STRING
			att_unique: MT_ATTRIBUTE
			crit_class_oids, attrs, types, sizes, orders: ARRAY[INTEGER]
			to_c, attrs_c, sizes_c, types_c, orders_c: ANY
		do
			persister ?= a_db.persister
			mtdb := a_db
			index_name := an_index_name.twin
			c_index_name := index_name.to_c
			oid := mtdb.context.get_index ( $c_index_name)
			create crit_class_oids.make (1, 4)
			create attrs.make (1, 4)
			create types.make (1, 4)
			create sizes.make (1, 4)
			create orders.make (1, 4)
			to_c := crit_class_oids.to_c
			attrs_c := attrs.to_c
			types_c := types.to_c
			sizes_c := sizes.to_c
			orders_c := orders.to_c

			mtdb.context.load_index_info ( oid, $num_classes, $to_c, $criteria_count,
												 $attrs_c, $types_c, $sizes_c, $orders_c)

			create criteria.make (1, criteria_count)
			from
				i := 1
			until
				i > criteria_count
			loop
				create a_criterion.make (persister.mtdb,
					attrs.item (i),
					types.item (i),
					sizes.item (i),
					orders.item (i))
				criteria.put (a_criterion, i)
				i := i + 1
			end

			create classes.make (1, num_classes)
			from
				i := 1
			until
				i > num_classes
			loop
				a_class ?= persister.eif_object_from_oid (crit_class_oids.item(i))
				classes.put (a_class, i)
				i := i + 1
			end
			scan_direction := Mt_Direct

			-- Get unique key
			create att_unique.make_from_names ("MtUniqueKey", "MtIndex", persister.mtdb)
			unique_key := att_unique.get_boolean (Current)
		ensure
			criteria_count: 0 < criteria_count and criteria_count < 5
			criteria: criteria /= Void and criteria.lower = 1 and criteria.upper = criteria_count
		end -- make

feature -- Status Report

	entries_count: INTEGER
			-- The number of entries in the index.
			-- Not implemented
		do
			Result := mtdb.context.index_entries_count ( oid)
		end -- entries_count

	criteria_count: INTEGER -- Number of criteria

	classes_count: INTEGER
			-- Number of classes in the index
		do
			Result := classes.count
		end

	classes: ARRAY [MT_CLASS]

	stream_opened: BOOLEAN
		do
			Result := stream /= void
		end

	unique_key: BOOLEAN

feature -- Look up

	lookup (key1, key2, key3, key4: ANY): MT_STORABLE
			-- Search object from keys, i.e., both starting and ending criterion
			-- are same key values.
			-- Return Void if no object is found.
			-- Return the object if exactly one object is found.
			-- Raise exception if more than one object are found.
		local
			i, class_oid, found_oid: INTEGER
			c_crit_start_array: ARRAY [POINTER];
			sv, c_one_string: ANY
			one_string: STRING
		do
			i := criteria.lower
			if criteria_count > 3 then
				criteria.item(i + 3).set_start_value (key4)
			end
			if criteria_count > 2 then
				criteria.item(i + 2).set_start_value (key3)
			end
			if criteria_count > 1 then
				criteria.item(i + 1).set_start_value (key2)
			end
			if criteria_count > 0 then
				criteria.item(i).set_start_value (key1)
			end

			create c_crit_start_array.make (0, criteria_count - 1)
			from
				i := 1
			until
				i > criteria_count
			loop
				sv := criteria.item (i).start_value
				if sv /= void then
					one_string ?= sv
					if one_string /= void then
						c_one_string := one_string.to_c
						c_crit_start_array.put ($c_one_string, i - 1)
					else
						c_crit_start_array.put ($sv, i - 1)
					end
				end
				i := i + 1
			end

			if constraint_class /= Void then
				class_oid := constraint_class.oid
			end

			found_oid := mtdb.context.index_lookup ( oid, class_oid,
															criteria_count,
															$c_crit_start_array)
			if found_oid > 0 then
				Result := persister.eif_object_from_oid (found_oid)
			elseif found_oid < 0 then
				trigger_dev_exception (MtEif_Too_Many_Objects,
															 "More than one object found for lookup operation")
			end

		end

feature -- Access

	criteria: ARRAY [MT_INDEX_CRITERION]
		-- Criterions of current index

feature -- Stream

	open_stream: MT_INDEX_STREAM
		do
			create stream.make_from_index (Current)
			Result := stream
		end

feature -- Criterion value

	scan_direction: INTEGER
		-- Mt_Reverse or Mt_Direct.

	constraint_class: MT_CLASS

feature -- Setting criterion

	set_scan_direction (direction: INTEGER)
		require
			direction = Mt_Reverse or else direction = Mt_Direct
		do
			scan_direction := direction
		end

	set_class (a_class: MT_CLASS)
		do
			constraint_class := a_class
		end

feature {MT_INDEX_STREAM} -- Implementation

	stream: MT_INDEX_STREAM
		-- Stream of objects in Index.

invariant

	valid_persister: persister /= Void
	consistent_criteria: criteria.count = criteria_count

end -- class MTINDEX
