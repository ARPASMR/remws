note
	description: "Test cases for relationship."
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


deferred class TEST_RELATIONSHIP

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

feature -- Test very simple case, reading

	test_get_multi_rs1
		local
			ec1: EIFFEL_CLASS1
		do
			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1101", appl)

			assert_equal ("test_get_multi_rs1-1", "i1302", ec1.rs1.first.identifier)
			assert_equal ("test_get_multi_rs1-2", "i1301", ec1.rs1.last.identifier)
			assert_equal ("test_get_multi_rs1-3", 2, ec1.rs1.count)

			appl.abort_transaction
		end

	test_get_multi_rs2
		-- no successors, empty linked_list should be returned
		local
			ec1: EIFFEL_CLASS1
		do
			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1102", appl)

			assert_equal ("test_get_multi_rs2", 0, ec1.rs1.count)

			appl.abort_transaction
		end


	test_get_single_rs1
		-- very basic case
		local
			ec1: EIFFEL_CLASS1
		do
			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1101", appl)

			assert_equal ("test_get_single_rs1-1", "i1303", ec1.rs11.identifier)

			appl.abort_transaction
		end

	test_get_single_rs2
		-- no successor, void should be returned
		local
			ec3: EIFFEL_CLASS3
		do
			appl.start_transaction (0)
			ec3 ?= get_object_from_identifier ("i1301", appl)

			assert_equal ("test_get_single_rs2-1", Void, ec3.rs31)

			appl.abort_transaction
		end

feature -- Test very simple case, setting

	test_set_single_rs1
		local
			ec1: EIFFEL_CLASS1
			ec3: EIFFEL_CLASS3
		do
			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1102", appl)
			ec3 ?= get_object_from_identifier ("i1305", appl)

			ec1.set_rs11 (ec3)
			assert_equal ("test_set_single_rs1-1", "i1305", ec1.rs11.identifier)
			appl.commit ()

			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1102", appl)
			assert_equal ("test_set_single_rs1-2", "i1305", ec1.rs11.identifier)
			ec1.set_rs11 (Void)
			assert_equal ("test_set_single_rs1-3", Void, ec1.rs11)
			assert_equal ("test_set_single_rs1-4", Void, ec3.rs31)
			appl.commit ()
		end


	test_set_multi_rs1
		local
			ec1: EIFFEL_CLASS1
			ec3: EIFFEL_CLASS3
		do
			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1102", appl)
			ec3 ?= get_object_from_identifier ("i1305", appl)

			ec1.rs12.extend (ec3)
			assert_equal ("test_set_multi_rs1-1", "i1305", ec1.rs12.first.identifier)
			assert_equal ("test_set_multi_rs1-2", 1, ec1.rs12.count)
			appl.commit ()

			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1102", appl)
			assert_equal ("test_set_multi_rs1-3", "i1305", ec1.rs12.first.identifier)
			ec3 := ec1.rs12.first
			ec1.rs12.search (ec3)
			ec1.rs12.remove
			assert_equal ("test_set_multi_rs1-4", 0, ec1.rs12.count)
			assert_equal ("test_set_multi_rs1-5", Void, ec3.rs32)
			appl.commit ()
		end

feature -- Test

	test_multi_rs1
			-- create ec1 without db transaction,
			-- then make the object persistent.
		local
			ec1: EIFFEL_CLASS1
			-- ec3: EIFFEL_CLASS3
		do
			create ec1.make1
			appl.start_transaction (0)
			appl.persist (ec1)

			appl.abort_transaction
		end

	test_multi_rs2
			-- create ec1 without db transaction,
			-- then make the object persistent.
		local
			ec1: EIFFEL_CLASS1
			ec3: EIFFEL_CLASS3
		do
			create ec1.make1
			create ec3.make1
			ec1.rs1.extend (ec3)
			appl.start_transaction (0)
			appl.persist (ec1)

			appl.abort_transaction
		end

feature -- Test update of inverse for single relationship

	test_inverse_single_rs1
		-- rs11 <--inverse--> rs31
		local
			ec1: EIFFEL_CLASS1
			ec31, ec32: EIFFEL_CLASS3
		do
			create ec1.make1
			create ec31.make1
			create ec32.make1

			ec1.set_rs11 (ec31)

			appl.start_transaction (0)
			appl.persist (ec1)
			assert_equal ("inverse_single_rs-1.1", ec1, ec31.rs31)

			ec1.set_rs11 (ec32)
			assert_equal ("inverse_single_rs-1.2", Void, ec31.rs31)
			assert_equal ("inverse_single_rs-1.3", ec1, ec32.rs31)
			appl.abort_transaction

			-- Access without transaction
			assert_equal ("inverse_single_rs-1.4", ec32, ec1.rs11)
			assert_equal ("inverse_single_rs-1.5", Void, ec31.rs31)
			assert_equal ("inverse_single_rs-1.6", ec1, ec32.rs31)
		end

feature -- Test update of inverse for multiple relationship

	test_inverse_multiple_rs1
		-- rs12 <--[1, n]--> rs32
		local
			e1: EIFFEL_CLASS1
			e3: EIFFEL_CLASS3
		do
			create e1.make1
			create e3.make1

			appl.start_transaction (0)
			appl.persist (e1)
			e1.rs12.extend (e3)

			assert_equal ("inverse_multiple_rs1-1.1", e1, e3.rs32)

			e1.rs12.start
			e1.rs12.prune (e3)
			assert_equal ("inverse_multiple_rs1-1.2", Void, e3.rs32)

			appl.abort_transaction
		end

feature -- Test MT_LINKED_LIST

  -- test put_left

  test_linked_list_put_left
    local
      ec1: EIFFEL_CLASS1
			ec3: EIFFEL_CLASS3
		do
			appl.start_transaction (0)
			ec1 ?= get_object_from_identifier ("i1101", appl)

      assert_equal ("test_linked_list_put_left", 2, ec1.rs1.count)

      create ec3.make1
      ec3.set_identifier ("test1234")

      ec1.rs1.start
      ec1.rs1.put_left (ec3)

      assert_equal ("test_linked_list_put_left 2", 3, ec1.rs1.count)
      assert_equal ("test_linked_list_put_left 3", "test1234", ec1.rs1.first.identifier)

      appl.abort_transaction
    end


  -- test wipe_out for empty linked_list

  test_linked_list_wipe_out
    local
      ec1: EIFFEL_CLASS1
    do
      appl.start_transaction (0)
      ec1 ?= get_object_from_identifier ("i1102", appl)

      ec1.rs1.wipe_out

      assert_equal ("test_linked_list_wipe_out", 0, ec1.rs1.count)

      appl.abort_transaction
    end


  -- test forth

  test_linked_list_forth
    local
      ec1: EIFFEL_CLASS1
      ec3: EIFFEL_CLASS3
      list: LINKED_LIST[EIFFEL_CLASS3]
      cnt: INTEGER
    do
      appl.start_transaction (0)
      ec1 ?= get_object_from_identifier ("i1101", appl)
      list := ec1.rs1

      from
        list.start
      until
        list.after
      loop
        cnt := cnt + 1;
        ec3 := list.item
        list.forth
      end

      assert_equal ("test_linked_list_forth 1", 2, cnt)

      appl.abort_transaction
    end



feature -- Predecessors

  test_predecessor1
      -- get one predecessor
    local
      ec1: EIFFEL_CLASS1
      ec3: EIFFEL_CLASS3
    do
      appl.start_transaction (0)
      ec3 ?= get_object_from_identifier ("i1301", appl)
      ec1 ?= ec3.mt_get_predecessor_by_name ("rs1")

      assert_equal ("test_predecessor1-1", true, ec1 /= Void)
      assert_equal ("test_predecessor1-2", "i1101", ec1.identifier)

      appl.abort_transaction
    end

  test_predecessors1
      -- get one predecessor
    local
      preds: ARRAY[MT_STORABLE]
      ec1: EIFFEL_CLASS1
      ec3: EIFFEL_CLASS3
    do
      appl.start_transaction (0)
      ec3 ?= get_object_from_identifier ("i1301", appl)
      preds ?= ec3.mt_get_predecessors_by_name ("rs1")

      assert_equal ("test_predecessors1-1", 1, preds.count)

      ec1 ?= preds.item(1)
      assert_equal ("test_predecessors1-2", true, ec1 /= Void)
      assert_equal ("test_predecessors1-3", "i1101", ec1.identifier)

      appl.abort_transaction
    end

  test_predecessors2
      -- get zero predecessor
    local
      preds: ARRAY[MT_STORABLE]
      --ec1: EIFFEL_CLASS1
      ec3: EIFFEL_CLASS3
    do
      appl.start_transaction (0)
      ec3 ?= get_object_from_identifier ("i1305", appl)
      preds ?= ec3.mt_get_predecessors_by_name ("rs1")

      assert_equal ("test_predecessors2-1", 0, preds.count)

      appl.abort_transaction
    end

  test_predecessors3
      -- get more than a predecessor
    local
      preds: ARRAY[MT_STORABLE]
      ec1: EIFFEL_CLASS1
      ec3: EIFFEL_CLASS3
    do
      appl.start_transaction (0)
      ec1 ?= get_object_from_identifier ("i1101", appl)
      preds ?= ec1.mt_get_predecessors_by_name ("rs1_of")

      assert_equal ("test_predecessors3-1", 2, preds.count)

      ec3 ?= preds.item(1)
      assert_equal ("test_predecessors3-2", true, ec3 /= Void)
      assert_equal ("test_predecessors3-3", "i1302", ec3.identifier)

      appl.abort_transaction
    end


feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE

end
