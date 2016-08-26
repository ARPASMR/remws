note
	description: "Summary description for {TEST_MT_LINKED_LIST}."
	author: ""
	date: "$Date: 2010/10/24 02:22:54 $"
	revision: "$Revision: 1.1.1.1 $"
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
	Neal Lester
	]"

deferred class

	TEST_MT_LINKED_LIST

inherit

	TS_TEST_CASE
		redefine
			set_up, tear_down
		end
	COMMON_FEATURES

feature

	test_mt_remove_from_list is
			-- Does calling mt_remove on item in list remove it from the list?
		local
			container: EIFFEL_CLASS1
			l_item: EIFFEL_CLASS3
		do
			appl.start_transaction (0)
			create container.make1
			container.set_identifier ("container1")
			appl.persist (container)
			create l_item.make1
			l_item.set_identifier ("item1")
			appl.persist (l_item)
			container.rs1.extend (l_item)
			create l_item.make1
			l_item.set_identifier ("item2")
			appl.persist (l_item)
			container.rs1.extend (l_item)
			create l_item.make1
			l_item.set_identifier ("item3")
			appl.persist (l_item)
			container.rs1.extend (l_item)
			appl.commit
			appl.start_version_access (Void)
			assert_equal ("linked_list_count", 3, container.rs1.count)
			assert_equal ("linked_list_item_2_identifier", "item2", container.rs1.i_th (2).identifier)
			appl.end_version_access
			appl.start_transaction (0)
			container.rs1.start
			container.rs1.item.mt_remove
			assert_equal ("linked_list_count 2", 2, container.rs1.count)
			container.rs1.item.mt_remove
			assert_equal ("linked_list_count 1", 1, container.rs1.count)
			container.rs1.item.mt_remove
			assert ("linked_list_empty", container.rs1.is_empty)
			appl.commit
			appl.start_version_access (Void)
			assert ("linked_list_empty 2", container.rs1.is_empty)
			appl.end_version_access
		end


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

feature {NONE} -- Implementation

	appl: MT_STORABLE_DATABASE

end
