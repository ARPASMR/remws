note
	description: "Test cases for session."
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


deferred class TEST_SESSION

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

feature -- Test getting MT_STORABLE_DATABASE from MT_STORABLE

	test_session1
		local
			obj: SUPER
		do
			appl.start_transaction (0)
			obj ?= get_object_from_identifier ("i101", appl)
			assert_equal ("session-1.1", True, obj.is_persistent)
			appl.abort_transaction

--			assert_equal ("session-1.2", True, obj.db_session.is_connected)
--			assert_equal ("session-1.3", False, obj.db_session.is_transaction_open)
--			assert_equal ("session-1.4", False, obj.is_persistent)

--			obj.db_session.start_transaction (0)
--			assert_equal ("session-1.5", True, obj.is_persistent)
--			obj.db_session.abort_transaction
		end

feature -- Connection options

	test_locking_policy1
		do
			assert_equal ("test_locking_policy1-1", {MT_STORABLE_DATABASE}.Mt_Default_Access,
										appl.locking_policy)
			appl.close
			appl.set_locking_policy ({MT_STORABLE_DATABASE}.Mt_Access_For_Update)
			assert_equal ("test_locking_policy1-2", {MT_STORABLE_DATABASE}.Mt_Access_For_Update,
										appl.locking_policy)
			appl.open
--			appl.start_transaction (0)
--			appl.set_locking_policy ({MT_STORABLE_DATABASE}.Mt_Access_For_Update)
--			assert_equal ("test_locking_policy1-3", {MT_STORABLE_DATABASE}.Mt_Access_For_Update,
--										appl.locking_policy)
--			appl.abort_transaction

		end

feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE

end
