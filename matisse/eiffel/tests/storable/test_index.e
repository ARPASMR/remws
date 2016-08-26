note
	description: "Test cases for index."
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


deferred class TEST_INDEX

inherit
	TS_TEST_CASE
		redefine
			set_up, tear_down
		end

	COMMON_FEATURES

	MT_EXCEPTIONS

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

	test_index1
		local
		--	an_index: MTINDEX
		--	index_stream: MT_STREAM
		--	criterion: MT_INDEX_CRITERION
		do
--			create an_index.make("lname_index")

		end

feature -- Test unique key

	test_index_unique_key1
		local
			an_index: MT_INDEX
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index1")
			assert_equal ("test_index_unique_key-1", True, an_index.unique_key)
			appl.abort_transaction
		end

	test_index_unique_key2
		local
			an_index: MT_INDEX
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index3")
			assert_equal ("test_index_unique_key-2", False, an_index.unique_key)
			appl.abort_transaction
		end

feature -- Test lookup

	test_index_lookup1
			-- Find one object
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index1")
			obj ?= an_index.lookup ("i201", Void, Void, Void)
			assert_equal ("index_lookup-1", "i201", obj.identifier)
			appl.abort_transaction
		end

	test_index_lookup2
			-- Find no object
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index1")
--			obj ?= an_index.lookup ("foobarfoobar", Void, Void, Void)
			assert_equal ("index_lookup-2", Void, obj)
			appl.abort_transaction
		end

	test_index_lookup3
			-- Find one object with class filtering
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
			constraint_cls: MT_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index1")
			create constraint_cls.make_from_name_with_db ("Index_Class", appl)
			an_index.set_class (constraint_cls)
			obj ?= an_index.lookup ("i201", Void, Void, Void)
			assert_equal ("index_lookup-3", "i201", obj.identifier)
			appl.abort_transaction
		end

	test_index_lookup4
			-- Try to find object with irrelevant class filtering
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
			constraint_cls: MT_CLASS
			retried: BOOLEAN
		do
			if not retried then
				appl.start_transaction (0)
				an_index := appl.create_index("test_index1")
				create constraint_cls.make_from_name_with_db ("Numeric_Class", appl)
				an_index.set_class (constraint_cls)
				obj ?= an_index.lookup ("i201", Void, Void, Void)
				appl.abort_transaction
			else
				if appl.is_transaction_in_progress then
					appl.abort_transaction
				end
			end
		rescue
			assert_equal ("index_lookup-4.1", Developer_exception, exception)
			assert_equal ("index_lookup-4.2", Matisse_Nosuchclassindex, matisse_exception_code)
			retried := True
			retry
		end

	test_index_lookup5
			-- Find many objects (exception)
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
			retried: BOOLEAN
		do
			if not retried then
				appl.start_transaction (0)
				an_index := appl.create_index("test_index3")
				obj ?= an_index.lookup (Void, 1, Void, Void)
				appl.abort_transaction
			else
				if appl.is_transaction_in_progress then
					appl.abort_transaction
				end
			end
		rescue
			assert_equal ("index_lookup-5.1", Developer_exception, exception)
			assert_equal ("index_lookup-5.2", MtEif_Too_Many_Objects, matisse_exception_code)
			retried := True
			retry
		end

	test_index_lookup6
			-- Find one object using two criteria
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index3")
			obj ?= an_index.lookup ("i202", 1, Void, Void)
			assert_equal ("index_lookup-6", "i202", obj.identifier)
			appl.abort_transaction
		end

	test_index_lookup7
			-- Try to find object without any value
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
			retried: BOOLEAN
		do
			if not retried then
				appl.start_transaction (0)
				an_index := appl.create_index("test_index3")
				obj ?= an_index.lookup (Void, Void, Void, Void)
				appl.abort_transaction
			else
				if appl.is_transaction_in_progress then
					appl.abort_transaction
				end
			end
		rescue
			assert_equal ("index_lookup-7.1", Developer_exception, exception)
			assert_equal ("index_lookup-7.2", MtEif_Too_Many_Objects, matisse_exception_code)
			retried := True
			retry
		end

	test_index_lookup8
			-- Pass more values than needed
			-- "test_index1" needs only one criterion value, but pass two.
			-- (Just ignored)
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index1")
			obj ?= an_index.lookup ("i202", 1, Void, Void)
			assert_equal ("index_lookup-8", "i202", obj.identifier)
			appl.abort_transaction
		end

	test_index_lookup9
			-- Pass incompatible type value as criterion
			-- "test_index1" needs string, but pass integer
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index1")
--			obj ?= an_index.lookup (12345, Void, Void, Void)
			assert_equal ("index_lookup-9", Void, obj)
			appl.abort_transaction
		end

	test_index_lookup10
			-- Pass incompatible type value as criterion
			-- "test_index3" needs integer, but pass string
		local
			an_index: MT_INDEX
			obj: INDEX_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index3")
			obj ?= an_index.lookup (Void, "foobar", Void, Void)
			assert_equal ("index_lookup-10", Void, obj)
			appl.abort_transaction
		end

feature -- Subclass

	test_index_subclass1
		local
			an_index: MT_INDEX
			obj: INDEX_SUB_CLASS
			-- obj2: INDEX_CLASS
		do
			appl.start_transaction (0)
			an_index := appl.create_index("test_index1")

			obj ?= an_index.lookup ("i300", Void, Void, Void)
			assert_equal ("index_subclass1-1", "i300", obj.identifier)
			appl.abort_transaction
		end

feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE

	dummy1: MT_LINKED_LIST[INDEX_CLASS]
	dummy2: MT_ARRAY[INDEX_CLASS]
	dummy3: MT_ARRAYED_LIST[INDEX_CLASS]
end
