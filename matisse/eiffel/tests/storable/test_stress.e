indexing
	description: "Test cases for stress testing."
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

	Contributor(s):
	]"


deferred class TEST_STRESS

inherit
	TS_TEST_CASE
		redefine
			set_up, tear_down
		end

	COMMON_FEATURES

	MT_EXCEPTIONS

feature -- Setting

	set_up is
		do
			-- create appl.set_login(target_host, target_database)
			-- appl.set_base
			create appl.make(target_host, target_database)
			appl.open
		end

	tear_down is
		do
			if appl.is_transaction_in_progress then
				appl.abort_transaction
			elseif appl.is_version_access_in_progress then
				appl.end_version_access
			end
			appl.close
		end

feature -- Creating many objects

	test_create_many_objects is
		local
			obj: SUPER
			i: INTEGER
			each_id: STRING
			a_class: MT_CLASS
			all_instances: ARRAY[MT_STORABLE]
			obj_count: INTEGER
			found_count: INTEGER
		do
			obj_count := 100 -- number of object to be created
			appl.start_transaction (0)

			from
				i := 0
			until
				i = obj_count
			loop
				create each_id.make_from_string("tmp000")
				each_id.append(i.out)
				create obj.make(each_id)
				appl.persist (obj)
				i := i + 1
			end

			appl.commit ()

			appl.start_transaction (0)
			create a_class.make_from_name_with_db ("Super", appl)
			all_instances := a_class.all_instances
			from
				i := all_instances.lower
			until
				i > all_instances.upper
			loop
				obj ?= all_instances.item(i)
				if obj /= Void then
					if obj.identifier.substring(1, 3).is_equal("tmp") then
						found_count := found_count + 1
					end
				end
				i := i + 1
			end
			assert_equal("stress create many objects", obj_count, found_count)
			appl.abort_transaction
		end

	test_index1 is
		local
			an_index: MT_INDEX
			index_stream: MT_STREAM
			criterion: MT_INDEX_CRITERION
			a_super: SUPER
		do
			appl.start_transaction (0)
			an_index := appl.create_index ("test_index1")
			criterion := an_index.criteria.item(1)
			criterion.set_start_value ("tmp")
			--criterion.set_end_value ("tmpZZZ")
			index_stream := an_index.open_stream
			from
				index_stream.start
			until
				index_stream.exhausted
			loop
				a_super ?= index_stream.item
				if a_super /= Void then
					print ("%N  ")
					print (a_super.identifier)
				end
				index_stream.forth
			end
			index_stream.close

			appl.abort_transaction
		end

feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE
	dummy: MT_LINKED_LIST[MT_STORABLE]
	dummy1: ATTRS_CLASS
	dummy2: EIFFEL_CLASS1
	dummy3: EIFFEL_CLASS3
	dummy4: INDEX_CLASS
	dummy5: INDEX_SUB_CLASS
	dummy6: NUMERIC_CLASS

end
