note
	description: "Test cases for exception."
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


deferred class TEST_EXCEPTION

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

feature -- Test no eiffel class mapping the Matisse class

	test_no_such_eiffel_class01
		local
			sql_stmt: MT_STATEMENT
			rset: MT_RESULT_SET
			retried: BOOLEAN
			obj: MT_STORABLE
		do
			if not retried then
				appl.start_transaction (0)
				sql_stmt := appl.create_statement
				rset := sql_stmt.execute_query
				("SELECT REF(UndefClass1) FROM UndefClass1")
				from
					rset.start
				until
					rset.exhausted
				loop
					obj ?= rset.get_object(1)
					rset.forth
				end
				rset.close
				sql_stmt.close

				appl.abort_transaction
			end
		rescue
			assert_equal ("test_no_such_eiffel_class01-1", MtEif_No_Such_Class, matisse_exception_code)
			assert_equal ("test_no_such_eiffel_class01-2", Developer_Exception, exception)
			if rset.is_open then
				rset.close
			end
			sql_stmt.close
			appl.abort_transaction
			retried := True
			retry
		end

feature {NONE} -- DB

	appl: MT_STORABLE_DATABASE

end
