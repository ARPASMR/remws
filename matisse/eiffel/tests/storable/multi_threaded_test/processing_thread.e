note
	description: "Processor to test multi-threaded Matisse Applications"
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

	Contributor(s): Didier Cabannes
                   Neal Lester
	]"

class

	PROCESSING_THREAD

inherit

	THREAD
	QUICK_LOGGER
	EXCEPTIONS

create

	make

feature -- Execution

	execute
		local
			counter: INTEGER
			current_parent: PARENT
			active_parent_the_strings: LINKED_LIST [STRING]
			sql_statement: MT_STATEMENT
			sql_results: MT_RESULT_SET
		do
			create active_parent_the_strings.make
			finish_flag.lock
			start_flag.signal
			start_flag.wait (finish_flag)
			from
				counter := 1
			until
				counter >= iteration_count
			loop
--				if (counter \\ 5) = 0 then
--					log ("clearing object table")
--					db.clear_object_table
--					log ("object table cleared")
--				end
				current_parent := new_parent (counter)
				log ("execute.starting version_access 1")
				db.start_version_access
				log ("execute.started version_access 1")
				active_parent_the_strings.put_front (current_parent.the_string)
				log ("execute.ending version_access 1")
				db.end_version_access
				log ("reading current_parent 1")
				read_attributes (current_parent)
				read_children (current_parent)
				if active_parent_the_strings.count >= 10 then
					log ("execute.starting version_access 2")
					db.start_version_access
					log ("execute.started version_access 2")
					sql_statement := db.create_statement
					log ("execute.sql_statement created")
					sql_results := sql_statement.execute_query ("select ref (parent) from parent where the_string = %'" + active_parent_the_strings.last + "%'")
					log ("execute.sql_statement executed")
					sql_results.start
					log ("execute.current_parent ?= sql_result")
					current_parent ?= sql_results.get_object (1)
					log ("execute.closing sql statement")
					sql_statement.close
					log ("execute.ending version_access 2")
					db.end_version_access
					log ("execute.ended version_access 2")
					read_attributes (current_parent)
					log ("execute.starting transaction 1")
					db.start_transaction
					log ("execute.transaction started 1")
					current_parent.mt_remove
					log ("execute.committing transaction 1")
					db.commit
					active_parent_the_strings.finish
					active_parent_the_strings.remove
				log ("execute.transaction comitted 1")
				end
				counter := counter + 1
			end
			finish_flag.unlock
			log ("Finished")
		end

	start_flag: CONDITION_VARIABLE
	finish_flag: MUTEX

feature {NONE} -- Implementaiton

	read_attributes (a_attribute_container: ATTRIBUTE_CONTAINER)
		require
			valid_a_attribute_container: a_attribute_container /= Void
			no_access_open: not db.is_access_open
		local
			l_string: STRING
			l_integer: INTEGER
			l_boolean: BOOLEAN
			l_timestamp: DATE_TIME
			l_date: DATE
			l_string_list: LINKED_LIST [STRING]
			l_image: ARRAY [NATURAL_8]
			l_numeric: DECIMAL
			l_float: REAL
		do
			log ("read_attributes.starting version access 1")
			db.start_version_access
			log ("read_attributes.reading the_string 1")
			l_string := a_attribute_container.the_string
			log ("read_attributes.reading the_integer 1")
			l_integer := a_attribute_container.the_integer
			log ("read_attributes.reading the_boolean 1")
			l_boolean := a_attribute_container.the_boolean
			log ("read_attributes.reading the_timestamp 1")
			l_timestamp := a_attribute_container.the_timestamp
			log ("read_attributes.reading the_date 1")
			l_date := a_attribute_container.the_date
			log ("read_attributes.reading the_string_list 1")
			l_string_list := a_attribute_container.the_string_list
			log ("read_attributes.reading the_image 1")
			l_image := a_attribute_container.the_image
			log ("read_attributes.reading the_numeric 1")
			l_numeric := a_attribute_container.the_numeric
			log ("read_attributes.reading the_float 1")
			l_float := a_attribute_container.the_float
			log ("read_attributes.ending version access 1")
			db.end_version_access
			log ("read_attributes.ended version access 1")
		ensure
			no_access_open: not db.is_access_open
		end


	read_children (parent: PARENT)
		require
			valid_a_parent: parent /= Void
			no_access_open: not db.is_access_open
		local
			child: CHILD
			child_oid: INTEGER
			inverse_parent: PARENT
		do
			log ("read_children.starting_version_access 1")
			db.start_version_access
			log ("reading_children.read child")
			child := parent.child
			child_oid := child.oid

			log ("read_children.ending_version_access 1")
			db.end_version_access
			log ("read_children.starting_version_access 2")
			db.start_version_access
			log ("read_chidlren.reading children")
			child := parent.children.first
			child_oid := child.oid
			log ("read_children.ending_version_access 2")
			db.end_version_access
			if is_child_with_null_parent_in_db (child_oid) then
				raise ("ChildNullParent")
			end
			log ("read_children.starting_version_access 3")
			db.start_version_access
			log ("read_children.reading child_no_inverse")
			child := parent.child_without_inverse
			if child.oid /= child_oid then
				raise ("ChildOidChanged")
			end
			log ("read_children.ending_version_access 3")
			db.end_version_access
			log ("read_children.starting_version_access 4")
			if is_child_with_null_parent_in_db (child_oid) then
				raise ("ChildNullParent")
			end
			db.start_version_access
			log ("read_children.reading children_no_inverse")
			child := parent.children_without_inverse.first
			log ("read_children.ending_version_access 4")
			if child.oid /= child_oid then
				raise ("ChildOidChanged")
			end
			db.end_version_access
			log ("read_children.starting_version_access 5")
			if is_child_with_null_parent_in_db (child_oid) then
				raise ("ChildNullParent")
			end
			db.start_version_access
			log ("read_children.reading child.parent")
			inverse_parent := child.parent
			log ("read_children.ending_version_access 5")
			db.end_version_access
			log ("read_children.starting_version_access 6")
			if is_child_with_null_parent_in_db (child_oid) then
				raise ("ChildNullParent")
			end
			db.start_version_access
			log ("read_chidlren.reading child.parents")
			inverse_parent := child.parents.first
			log ("read_children.ending_version_access 6")
			db.end_version_access

		end


	new_parent (a_id: INTEGER): PARENT
		require
			no_access_open: not db.is_access_open
		local
			child: CHILD
			child_oid: INTEGER
		do
			log ("new_parent.starting_transaction 1")
			db.start_transaction
			log ("new_parent.creating_result")
			create Result
			log ("new_parent.persist Result")
			db.persist (Result)
			log ("new_parent.commit 1")
			db.commit
			log ("Setting attributes for parent")
			set_attributes (Result, a_id)
			log ("new_parent.starting_transaction 2")
			db.start_transaction
			log ("new_parent.creating child")
			create child
			log ("new_parent persisting child")
			db.persist (child)
			log ("new_parent.commit 2")
			child_oid := child.oid
			db.commit
			log ("new_parent.starting_transaction 3")
			db.start_transaction
			log ("new_parent.setting child")
			Result.set_child (child)
			log ("new_parent.commit 3")
			db.commit
			log ("new_parent committed 3")
			if is_child_with_null_parent_in_db (child_oid) then
				raise ("ChildNullParent")
			end
			log ("new_parent.starting_transaction 4")
			db.start_transaction
			log ("new_parent.setting child_without_inverse")
			Result.set_child_without_inverse (child)
			log ("new_parent.commit 4")
			db.commit
			log ("new_parent.starting_transaction 5")
			db.start_transaction
			log ("new_parent.setting children")
			Result.children.force (child)
			log ("new_parent.commit 5")
			db.commit
			log ("new_parent.starting_transaction 6")
			db.start_transaction
			log ("new_parent.setting children_without_inverse")
			Result.children_without_inverse.force (child)
			log ("new_parent.commit 6")
			db.commit
			log ("new_parent.commited 6")

		end

	set_attributes (a_container: ATTRIBUTE_CONTAINER; a_id: INTEGER)
		require
			valid_a_container: a_container /= Void
			is_access_open: db.is_transaction_open
		local
			a_list: LINKED_LIST  [STRING]
		do
			log ("set_attributes.starting transaction for set_the_string")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_string")
			a_container.set_the_string (id + ":" + a_id.out)
			log ("set_attributes.committing transaction for set_the_string")
			db.commit
			log ("set_attributes.starting transaction for set_the_integer")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_integer")
			a_container.set_the_integer (a_id)
			log ("set_attributes.committing transaction for set_the_integer")
			db.commit
			log ("set_attributes.starting transaction for set_the_boolean")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_boolean")
			a_container.set_the_boolean (a_id.integer_remainder (2) = 0)
			log ("set_attributes.committing transaction for set_the_boolean")
			db.commit
			log ("set_attributes.starting transaction for set_the_timestamp")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_timestamp")
			a_container.set_the_timestamp (create {DATE_TIME}.make_from_epoch (a_id))
			log ("set_attributes.committing transaction for set_the_timestamp")
			db.commit
			log ("set_attributes.starting transaction for set_the_date")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_date")
			a_container.set_the_date (create {DATE}.make_by_days (a_id))
			log ("set_attributes.committing transaction for set_the_date")
			db.commit
			log ("set_attributes.starting transaction for set_the_image")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_image")
			a_container.set_the_image (<<200, 200, 200, 200>>)
			log ("set_attributes.committing transaction for set_the_image")
			db.commit
			log ("set_attributes.committed transaction for set_the_image")
			create a_list.make
			a_list.force ("one")
			a_list.force ("two")
			a_list.force ("three")
			log ("set_attributes.starting transaction for set_the_string_list")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_string_list")
			a_container.set_the_string_list (a_list)
			log ("set_attributes.committing transaction for set_the_string_list")
			db.commit
			log ("set_attributes.starting transaction for set_the_numeric")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_numeric")
			a_container.set_the_numeric (create {DECIMAL}.make_from_string (a_id.out + ".00"))
			log ("set_attributes.committing transaction for set_the_numeric")
			db.commit
			log ("set_attributes.starting transaction for set_the_float")
			db.start_transaction
			log ("set_attributes.transaction started for set_the_float")
			a_container.set_the_float (a_id.to_real)
			log ("set_attributes.committing transaction for set_the_float")
			db.commit
			log ("set_attributes.committed transaction for set_the_float")

		end

	is_child_with_null_parent_in_db (oid: INTEGER): BOOLEAN is
		require
			no_access_open: not db.is_access_open
		local
			sql_statement: MT_STATEMENT
			sql_results: MT_RESULT_SET
		do
			sql_statement := db.create_statement
			db.start_version_access
			sql_results := sql_statement.execute_query ("select ref(child) from child where oid = %'" + oid.out + "%' and parent is null")
			sql_results.start
			Result := not sql_results.after
			sql_statement.close
			db.end_version_access
		ensure
			no_access_open: not db.is_access_open
		end


	iteration_count: INTEGER is 1000000

	db: MULTI_THREADED_DATABASE_MANAGER

feature {NONE} -- Creation

	make (a_db: MULTI_THREADED_MATISSE_APPL; a_id: STRING) is
		require
			valid_a_db: a_db /= Void
			valid_a_id: a_id /= Void
		do
			create db.make (a_db)
			id := a_id
			create start_flag.make
			create finish_flag.make
		end
invariant

	vald_finish_flag: finish_flag /= Void
	valid_db: db /= Void

end
