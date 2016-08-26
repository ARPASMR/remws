note
	description: "Test cases for persistence."
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


deferred class TEST_PERSISTENCE

inherit
	TS_TEST_CASE
		redefine
			set_up, tear_down
		end

	COMMON_FEATURES

	MEMORY

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

	test_persistence1
		local
			obj: SUPER
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)
			assert_equal ("persistence-1.1", True, obj.is_persistent)
			appl.abort_transaction

			assert_equal ("persistence-1.2", False, obj.is_persistent)

			appl.start_transaction (0)
			assert_equal ("persistence-1.3", True, obj.is_persistent)
			appl.abort_transaction

			assert_equal ("persistence-1.4", False, obj.is_persistent)
		end

	test_persistence2
		local
			obj: SUPER
		do
			appl.start_version_access (Void)
			obj ?= get_object_from_identifier ("i101", appl)
			assert_equal ("persistence-2.1", True, obj.is_persistent)
			appl.end_version_access

			assert_equal ("persistence-2.2", False, obj.is_persistent)

			appl.start_version_access (Void)
			assert_equal ("persistence-2.3", True, obj.is_persistent)
			appl.end_version_access

			assert_equal ("persistence-2.4", False, obj.is_persistent)
		end

	test_persistence3
		local
			obj: SUPER
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)
			assert_equal ("persistence-3.1", True, obj.is_persistent)
			appl.abort_transaction

			assert_equal ("persistence-3.2", False, obj.is_persistent)

			appl.start_version_access (Void)
			assert_equal ("persistence-3.3", True, obj.is_persistent)
			appl.end_version_access

			assert_equal ("persistence-3.4", False, obj.is_persistent)
		end

feature -- Persistence of relationships

	test_rs_persistence1
			-- Access to relationship within transaction, and then without
			-- transaction.
			-- Multiple relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.close
			appl.open
			appl.start_transaction (0)
			e1 ?= get_object_from_identifier ("i1101", appl)
			assert_equal ("rs_persistence-1.1", 2, e1.rs1.count)
			assert_equal ("rs_persistence-1.2", True, e1.rs1.first.is_persistent)
			appl.abort_transaction

			assert_equal ("rs_persistence-1.3", 2, e1.rs1.count)
			assert_equal ("rs_persistence-1.4", False, e1.rs1.first.is_persistent)
			assert_equal ("rs_persistence-1.5", Void, e1.rs1.first.att1_nullable)

			appl.start_transaction (0)
			assert_equal ("rs_persistence-1.6", 2, e1.rs1.count)
			assert_equal ("rs_persistence-1.7", True, e1.rs1.first.is_persistent)
			assert_equal ("rs_persistence-1.8", "a string", e1.rs1.first.att1_nullable)
			appl.abort_transaction

			assert_equal ("rs_persistence-1.9", 2, e1.rs1.count)
			assert_equal ("rs_persistence-1.10", False, e1.rs1.first.is_persistent)
			assert_equal ("rs_persistence-1.11", "a string", e1.rs1.first.att1_nullable)
		end

	test_rs_persistence2
			-- Access to relationshipo without transaction, and then within
			-- transaction.
			-- Multiple relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.close
			appl.open
			appl.start_transaction (0)
			e1 ?= get_object_from_identifier ("i1101", appl)
			appl.abort_transaction

			assert_equal ("rs_persistence-2.1", 0, e1.rs12.count)

			appl.start_transaction (0)
			assert_equal ("rs_persistence-2.2", "i1304", e1.rs12.first.identifier)
			assert_equal ("rs_persistence-2.3", 1, e1.rs12.count)
			appl.abort_transaction

			assert_equal ("rs_persistence-2.4", "i1304", e1.rs12.first.identifier)
			assert_equal ("rs_persistence-2.5", 1, e1.rs12.count)
		end

	test_rs_persistence11
			-- Access to relationship within transaction, and then without
			-- transaction.
			-- Single relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.start_transaction (0)
			e1 ?= get_object_from_identifier ("i1101", appl)
			assert_equal ("rs_persistence-11.1", "i1303", e1.rs11.identifier)
			appl.abort_transaction

			assert_equal ("rs_persistence-11.2", "i1303", e1.rs11.identifier)

			appl.start_transaction (0)
			assert_equal ("rs_persistence-11.3", "i1303", e1.rs11.identifier)
			appl.abort_transaction

		end

	test_rs_persistence12
			-- Access to relationship within transaction, and then without
			-- transaction.
			-- Single relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.start_transaction (0)
			e1 ?= get_object_from_identifier ("i1101", appl)
			appl.abort_transaction

			assert_equal ("rs_persistence-12.1", Void, e1.rs11)


			appl.start_transaction (0)
			assert_equal ("rs_persistence-12.2", "i1303", e1.rs11.identifier)
			appl.abort_transaction

			assert_equal ("rs_persistence-12.3", "i1303", e1.rs11.identifier)
		end


	test_rs_persistence101
			-- Access to relationship within transaction, and then without
			-- transaction.
			-- Multiple relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.start_version_access (Void)
			e1 ?= get_object_from_identifier ("i1101", appl)
			assert_equal ("rs_persistence-101.1", 2, e1.rs1.count)
			assert_equal ("rs_persistence-101.2", True, e1.rs1.first.is_persistent)
			appl.end_version_access

			assert_equal ("rs_persistence-101.3", 2, e1.rs1.count)
			assert_equal ("rs_persistence-101.4", False, e1.rs1.first.is_persistent)
			assert_equal ("rs_persistence-101.5", Void, e1.rs1.first.att1_nullable)

			appl.start_version_access (Void)
			assert_equal ("rs_persistence-101.6", 2, e1.rs1.count)
			assert_equal ("rs_persistence-101.7", True, e1.rs1.first.is_persistent)
			assert_equal ("rs_persistence-101.8", "a string", e1.rs1.first.att1_nullable)
			appl.end_version_access

			assert_equal ("rs_persistence-101.9", 2, e1.rs1.count)
			assert_equal ("rs_persistence-101.10", False, e1.rs1.first.is_persistent)
			assert_equal ("rs_persistence-101.11", "a string", e1.rs1.first.att1_nullable)
		end

	test_rs_persistence102
			-- Access to relationshipo without transaction, and then within
			-- transaction.
			-- Multiple relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.start_version_access (Void)
			e1 ?= get_object_from_identifier ("i1101", appl)
			appl.end_version_access

			assert_equal ("rs_persistence-102.1", 0, e1.rs12.count)

			appl.start_version_access (Void)
			assert_equal ("rs_persistence-102.2", "i1304", e1.rs12.first.identifier)
			assert_equal ("rs_persistence-102.3", 1, e1.rs12.count)
			appl.end_version_access

			assert_equal ("rs_persistence-102.4", "i1304", e1.rs12.first.identifier)
			assert_equal ("rs_persistence-102.5", 1, e1.rs12.count)
		end

	test_rs_persistence111
			-- Access to relationship within transaction, and then without
			-- transaction.
			-- Single relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.start_version_access (Void)
			e1 ?= get_object_from_identifier ("i1101", appl)
			assert_equal ("rs_persistence-111.1", "i1303", e1.rs11.identifier)
			appl.end_version_access

			assert_equal ("rs_persistence-111.2", "i1303", e1.rs11.identifier)

			appl.start_version_access (Void)
			assert_equal ("rs_persistence-111.3", "i1303", e1.rs11.identifier)
			appl.end_version_access

		end

	test_rs_persistence112
			-- Access to relationship within transaction, and then without
			-- transaction.
			-- Single relationship.
		local
			e1: EIFFEL_CLASS1
		do
			appl.start_version_access (Void)
			e1 ?= get_object_from_identifier ("i1101", appl)
			appl.end_version_access

			assert_equal ("rs_persistence-112.1", Void, e1.rs11)


			appl.start_version_access (Void)
			assert_equal ("rs_persistence-112.2", "i1303", e1.rs11.identifier)
			appl.end_version_access

			assert_equal ("rs_persistence-112.3", "i1303", e1.rs11.identifier)
		end

feature -- Object life-cycle anc cache

	test_cache1
			-- A cached object is deleted by someone else between transactions
			--
		local
			s1, s2: SUPER
			other_appl: MT_STORABLE_DATABASE
			-- tmp: STRING
		do
			-- create a new object
			appl.start_transaction (0)
			create s1.make ("tmp_i4455")
			appl.persist (s1)
			appl.commit ()

			-- delete the object from other connection
			-- create other_appl.make (target_host, target_database)
			-- other_appl.set_base
			create other_appl.make(target_host, target_database)
			other_appl.open
			other_appl.start_transaction (0)
			s2 ?= get_object_from_identifier ("tmp_i4455", other_appl)
			s2.mt_remove
			other_appl.commit ()
			other_appl.close

			-- try to access the object s1,
			appl.start_transaction (0)
			assert_equal ("cache1-1", "tmp_i4455", s1.identifier)
			assert_equal ("cache1-2", False, s1.is_persistent)
			appl.abort_transaction
		end

	test_cache2
			-- A cached object is deleted by someone else between transactions
		local
			s1, s2: SUPER
			other_appl: MT_STORABLE_DATABASE
		do
			-- create a new object
			appl.start_transaction (0)
			create s1.make ("tmp_i5566")
			appl.persist (s1)
			appl.commit ()

			-- delete the object from other connection
			-- create other_appl.make (target_host, target_database)
			-- other_appl.set_base
			create other_appl.make(target_host, target_database)
			other_appl.open
			other_appl.start_transaction (0)
			s2 ?= get_object_from_identifier ("tmp_i5566", other_appl)
			s2.mt_remove
			other_appl.commit ()
			other_appl.close

			-- try to access the object s1 using name-interface,
			appl.start_transaction (0)
			assert_equal ("cache2-1", "tmp_i5566", s1.mtget_string("identifier"))
			assert_equal ("cache2-2", False, s1.is_persistent)
			appl.abort_transaction
		end

	test_cache3
			-- An object is garbage-collectible.
		local
			obj: SUPER
		do
			appl.start_transaction (0)
			sub_cache3
			full_collect
			obj ?= get_object_from_identifier ("i219", appl)
			assert_equal ("cache3-1", "i219", obj.identifier)
			appl.abort_transaction
		end

	sub_cache3
		local
			obj: SUPER
		do
			obj ?= get_object_from_identifier ("i219", appl)
			obj := Void
			collection_on
			full_collect
		end


feature -- post_retrieved

	test_post_retrieved1
			-- post_retrieved that is called after the object retrieved
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("post_retrieved1", -90, obj.for_post_retrieved)
			appl.abort_transaction
		end

	TBD_test_post_retrieved2
		-- post_retrieved that is called after the object is re-persisted
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("post_retrieved2-1", -90, obj.for_post_retrieved)
			obj.set_identifier (obj.identifier) -- just to increment version number
			appl.commit ()

			obj.set_for_post_retrieved (223344)
			appl.start_transaction (0)
			assert_equal ("post_retrieved2-2", -90, obj.for_post_retrieved)
			-- this fails. this is a known problem
			appl.abort_transaction
		end

	test_post_retrieved2a
		-- post_retrieved is not called because version number has not changed
		local
			obj: ATTRS_CLASS
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i301", appl)
			assert_equal ("post_retrieved2a-1", -90, obj.for_post_retrieved)
			appl.abort_transaction

			obj.set_for_post_retrieved (223344)
			appl.start_transaction (0)
			assert_equal ("post_retrieved2a-2", 223344, obj.for_post_retrieved)
			appl.abort_transaction
		end

	TBD_test_post_retrieved3
			-- post_retrieved that accesses another persistent object
		local
			obj: EIFFEL_CLASS1
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i1101", appl)
			assert_equal ("post_retrieved3-1", "i1302", obj.id_for_post_retrieved)
			obj.set_identifier (obj.identifier) -- just to increment version number
			appl.commit ()

			obj.set_id_for_post_retrieved ("foooo")
			appl.start_transaction (0)
			assert_equal ("post_retrieved3-2", "i1302", obj.id_for_post_retrieved)
			-- this fails. this is a known problem.
			appl.abort_transaction
		end

	test_post_retrieved3a
			-- post_retrieved is not called because version number has not changed
		local
			obj: EIFFEL_CLASS1
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i1101", appl)
			assert_equal ("post_retrieved3-1", "i1302", obj.id_for_post_retrieved)
			appl.abort_transaction

			obj.set_id_for_post_retrieved ("foooo")
			appl.start_transaction (0)
			assert_equal ("post_retrieved3-2", "foooo", obj.id_for_post_retrieved)
			appl.abort_transaction
		end

feature -- Test transient & is_obsolete

	test_transient1
		local
			obj: SUPER
		do
			appl.start_transaction (0)
			create obj.make ("initial id")
			obj.set_identifier ("real id")
			assert_equal ("test_transient1", "real id", obj.identifier)
			appl.abort_transaction
		end


feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE

end
