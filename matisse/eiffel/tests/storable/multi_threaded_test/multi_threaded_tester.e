note
	description: "External methods for class MT_ATTRIBUTE."
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
	MULTI_THREADED_TESTER

inherit

	QUICK_LOGGER
	EXECUTION_ENVIRONMENT
	MEMORY

create

	make


feature {NONE} -- Creation

	make
		local
			db1, db2, active_db: MULTI_THREADED_MATISSE_APPL
			processors: LINKED_LIST [PROCESSING_THREAD]
			processor_count, counter: INTEGER
			sql_statement: MT_STATEMENT
			sql_results: INTEGER
			db1_container, db2_container: MULTI_THREADED_DATABASE_MANAGER
		do
			id := "QUICK_LOGGER"
			create processors.make
			create db1.make ("localhost", "example")
			create db2.make ("localhost", "example")
			db1.connect
			db2.connect
			create db1_container.make (db1)
			create db2_container.make (db2)
			from
				processor_count := 1
			until
				processor_count > number_of_processors
			loop
				if (processor_count \\ 2) = 0 then
					active_db := db1
				else
					active_db := db2
				end
				processors.extend (new_processor (active_db, "P" + processor_count.out))
				processor_count := processor_count + 1
			end
			sql_statement := db1_container.create_statement
			db1_container.start_transaction
			sql_results := sql_statement.execute_update ("delete from parent")
			sql_statement.close
			db1_container.commit
			sql_statement := db1_container.create_statement
			db1_container.start_transaction
			sql_results := sql_statement.execute_update ("delete from child")
			sql_statement.close
			db1_container.commit

			from
				processors.do_all (agent launch_processor (?))
				counter := 1
			until
				processors.for_all (agent (a_processor: PROCESSING_THREAD): BOOLEAN do Result := a_processor.finish_flag.try_lock end)
			loop
				log ("Start of loop")
				sleep (7000000)
				log ("Full Collect Starting")
				full_collect
				log ("Full Collect Ended")
				counter := counter + 1
			end
			db1.disconnect
			db2.disconnect
			processors.do_all (agent (a_processor: PROCESSING_THREAD) do a_processor.finish_flag.unlock end)
			log ("Finished")
		end

	number_of_processors: INTEGER is 12

	launch_processor (a_processor: PROCESSING_THREAD)
		require
			valid_a_processor: a_processor /= Void
		do
			a_processor.launch
			a_processor.start_flag.wait (a_processor.finish_flag)
			a_processor.finish_flag.unlock
			a_processor.start_flag.signal
		end


	new_processor (a_db: MULTI_THREADED_MATISSE_APPL; a_id: STRING): PROCESSING_THREAD
		require
			valid_db: a_db /= Void
			valid_a_id: a_id /= Void
		do
			create Result.make (a_db, a_id)
			Result.finish_flag.lock
		end

end -- class MULTI_THREADED_TESTER
