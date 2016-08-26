note
	description: "Test cases for entry points."
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


deferred class TEST_ENTRYPOINT

inherit
	TS_TEST_CASE
		redefine
			set_up, tear_down
		end

	COMMON_FEATURES

feature -- Setting

	set_up
		do
			-- create appl.set_login(target_host, target_database)
			-- appl.set_base
			create appl.make(target_host, target_database)
			appl.open
		end

	tear_down
		do
			if appl.is_transaction_in_progress then
				appl.abort_transaction
			elseif appl.is_version_access_in_progress then
				appl.end_version_access
			end
			appl.close
		end

feature -- Test

	test_ep1
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
			obj: SUPER
		do
			appl.start_transaction (0)

			create ep.make_with_db ("IdentifierDictionary", Void, appl)
			res_objs := ep.retrieve_objects ("i001");

			assert_equal ("ep-1.1", 1, res_objs.count)

			obj ?= res_objs.item(1)
			if obj = Void then
				assert_equal ("ep-1.2", "i001", "could not get object")
			else
				assert_equal ("ep-1.3", "i001", obj.identifier)
			end

			appl.abort_transaction
		end

	test_ep2
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
		do
			appl.start_transaction (0)

			create ep.make_with_db ("IdentifierDictionary", Void, appl)
			res_objs := ep.retrieve_objects ("i001");

			assert_equal ("ep-2", 1, res_objs.count)

			appl.abort_transaction
		end

	test_ep3
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
		do
			appl.start_transaction (0)

			create ep.make_with_db ("IdentifierDictionary", "SUPER", appl)
			res_objs := ep.retrieve_objects ("i001");

			assert_equal ("ep-3", 1, res_objs.count)

			appl.abort_transaction
		end

	test_ep_many_objs1
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
			s: SUPER
		do
			appl.start_transaction (0)

			create ep.make_with_db ("IdentifierDictionary", "SUPER", appl)
			res_objs := ep.retrieve_objects ("duplicate001");

			assert_equal ("ep_many_objs1-1", 12, res_objs.count)
			s ?= res_objs.item(1)
			assert_equal ("ep_many_objs1-2", "duplicate001", s.identifier)
			appl.abort_transaction
		end

	test_ep_many_objs2
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
			s: SUPER
		do
			appl.start_transaction (0)

			create ep.make_with_db ("IdentifierDictionary", "SUPER", appl)
			res_objs := ep.retrieve_n_firsts ("duplicate001", 5);

			assert_equal ("ep_many_objs2-1", 5, res_objs.count)
			s ?= res_objs.item(1)
			assert_equal ("ep_many_objs2-2", "duplicate001", s.identifier)
			appl.abort_transaction
		end

	test_ep_many_objs3
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
			s: SUPER
		do
			appl.start_transaction (0)

			create ep.make_with_db ("IdentifierDictionary", "SUPER", appl)
			res_objs := ep.retrieve_n_firsts ("duplicate001", 100);

			assert_equal ("ep_many_objs3-1", 12, res_objs.count)
			s ?= res_objs.item(1)
			assert_equal ("ep_many_objs3-2", "duplicate001", s.identifier)
			appl.abort_transaction
		end


	test_ep_retrieve1
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
			s: SUPER
		do
			appl.start_transaction (0)

			ep := appl.create_entry_point_dictionary ("IdentifierDictionary")
			res_objs := ep.retrieve ("duplicate001", "SUPER");

			assert_equal ("ep_retrieve1-1", 12, res_objs.count)
			s ?= res_objs.item(1)
			assert_equal ("ep_retrieve1-2", "duplicate001", s.identifier)
			appl.abort_transaction
		end

	test_ep_retrieve2
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
			s: SUPER
		do
			appl.start_transaction (0)

			ep := appl.create_entry_point_dictionary ("IdentifierDictionary")
			res_objs := ep.retrieve_some ("duplicate001", "SUPER", 5);

			assert_equal ("ep_retrieve2-1", 5, res_objs.count)
			s ?= res_objs.item(1)
			assert_equal ("ep_retrieve2-2", "duplicate001", s.identifier)
			appl.abort_transaction
		end

	test_ep_retrieve3
		local
			ep: MT_ENTRYPOINTDICTIONARY
			res_objs: ARRAY[MT_STORABLE]
			s: SUPER
		do
			appl.start_transaction (0)

			ep := appl.create_entry_point_dictionary ("IdentifierDictionary")
			res_objs := ep.retrieve_some ("duplicate001", "SUPER", 100);

			assert_equal ("ep_retrieve3-1", 12, res_objs.count)
			s ?= res_objs.item(1)
			assert_equal ("ep_retrieve3-2", "duplicate001", s.identifier)
			appl.abort_transaction
		end

	test_ep_retrieve_first1
		local
			ep: MT_ENTRYPOINTDICTIONARY
			s: SUPER
		do
			appl.start_transaction (0)

			ep := appl.create_entry_point_dictionary ("IdentifierDictionary")
			s ?= ep.retrieve_first ("duplicate001");

			assert_equal ("ep_retrieve_first1", "duplicate001", s.identifier)
			appl.abort_transaction
		end

feature -- Locking

	test_ep_lock1
		local
			ep: MT_ENTRYPOINTDICTIONARY
		do
			appl.start_transaction (0)

			ep := appl.create_entry_point_dictionary ("IdentifierDictionary")
			ep.lock_objects ({MT_STORABLE_DATABASE}.Mt_Read, "duplicate001", "SUPER");

			appl.abort_transaction
		end

feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE
	dummy: MT_LINKED_LIST[MT_STORABLE]
	dummy0: MT_ARRAY[MT_STORABLE]
	dummy1: ATTRS_CLASS
	dummy2: EIFFEL_CLASS1
	dummy3: EIFFEL_CLASS3
	dummy4: INDEX_CLASS
	dummy5: INDEX_SUB_CLASS
	dummy6: NUMERIC_CLASS

end

