note
	description: "MATISSE-Eiffel Binding"
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
	MT_INDEX_STREAM

inherit
	MT_STREAM

create
	make, make_from_index

feature {MTENTRYPOINTDICTIONARY} -- Implementation

	make (index_name: STRING; one_class: MT_CLASS; direction: INTEGER;
			crit_start_array, crit_end_array: ARRAY [ANY])
			-- Open Stream.
		require
			index_name_not_void: index_name /= Void
			index_name_not_empty: not index_name.is_empty
			direction_is_direct_or_reverse: direction = {MT_INDEX}.Mt_Direct or else direction = {MT_INDEX}.Mt_Reverse
			index_criteria_supplied: crit_start_array /= Void and crit_end_array /= Void
		local
			c_index_name, c_class_name: ANY
			c_crit_start_array, c_crit_end_array: ARRAY [POINTER]
			one_string: STRING
			c_one_string: ANY
			i: INTEGER
		do
			persister := one_class.persister
			mtdb := persister.mtdb
			c_index_name := index_name.to_c
			c_class_name := one_class.name.to_c

			create c_crit_start_array.make (crit_start_array.lower, crit_start_array.upper)
			create c_crit_end_array.make (crit_end_array.lower, crit_end_array.upper)

			from
				i:= crit_start_array.lower
			until
				i=crit_start_array.upper + 1
			loop
				if crit_start_array.item (i) /= Void then
					one_string ?= crit_start_array.item (i)
					if one_string /= Void then
					c_one_string := one_string.to_c
					c_crit_start_array.put ($c_one_string, i)
				else
					-- should be cases for other types, e.g. DATE
				end
			end
			if crit_end_array.item (i) /= Void then
				one_string ?= crit_end_array.item (i)
				if one_string /= Void then
					c_one_string := one_string.to_c
					c_crit_end_array.put($c_one_string,i)
				else
					-- should be cases for other types, e.g. DATE
				end
			end
			i := i + 1
		end

		c_stream := mtdb.context.open_index_entries_stream_by_name ( $c_index_name, $c_class_name,
						direction, $c_crit_start_array, $c_crit_end_array, 0)
	end


	make_from_index (an_index: MT_INDEX)
		require
			index_not_void: an_index /= Void
		local
			c_crit_start_array, c_crit_end_array: ARRAY [POINTER];
			sv, ev: ANY
			one_string: STRING
			i, class_oid: INTEGER
			c_one_string: ANY
		do
			persister := an_index.persister
			mtdb := persister.mtdb
			create c_crit_start_array.make (0, an_index.criteria_count - 1)
			create c_crit_end_array.make (0, an_index.criteria_count - 1)
			from
				i := 1
			until
				i > an_index.criteria.upper
			loop
				sv := an_index.criteria.item (i).start_value
				if sv /= void then
					one_string ?= sv
					if one_string /= void then
						c_one_string := one_string.to_c
						c_crit_start_array.put ($c_one_string, i - 1)
					else
						c_crit_start_array.put ($sv, i - 1)
					end
				end
				ev := an_index.criteria.item (i).end_value
				if ev /= void then
					one_string ?= ev
					if one_string /= void then
						c_one_string := one_string.to_c
						c_crit_end_array.put ($c_one_string, i - 1)
					else
						c_crit_end_array.put ($ev, i - 1)
					end
				end
				i := i + 1
			end

			if an_index.constraint_class /= Void then
				class_oid := an_index.constraint_class.oid
			end

			c_stream := mtdb.context.open_index_entries_stream ( an_index.oid, class_oid,
					an_index.scan_direction, an_index.criteria_count,
					$c_crit_start_array, $c_crit_end_array, 0)
		end

end -- class MT_INDEX_STREAM
