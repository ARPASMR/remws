note
	description: "MATISSE-Eiffel Binding: Matisse SQL examples."
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

	Contributor(s): Kazuhiro Nakao
                   Didier Cabannes
                   Neal Lester
                   Luca Paganotti
	]"

class
	SQL_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db: STRING

		do
			print("%NRunning SQL Examples:%N")
			host := "localhost"
			db := "example"

			clear_objects (host, db)

			insert_objects (host, db)

			select_objects (host, db)

			select_values (host, db)

		end


feature {NONE} -- Clear Objects

	clear_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			stmt: MT_STATEMENT
			result_set: MT_RESULT_SET
			query: STRING
			cnt, stmt_type: INTEGER
		do
			if impossible = False then
				print("%NTest Clear Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				print("%NCounting all Persons...%N");
				-- create s SQL statement
				stmt := db.create_statement ()
				query := "SELECT count(*) FROM Person"
				result_set := stmt.execute_query (query)

				-- Get the single result from the result-set
				result_set.start
				cnt := result_set.get_integer(1)
				result_set.close
				print("   " + cnt.out + " Person(s) in the database.%N");

				print("%NDeleting all Persons...%N");
				-- execute an update statement
				query := "DELETE FROM Person"
				cnt := stmt.execute_update (query)
				stmt_type := stmt.statement_type ()
				print("   '" + stmt.stmt_type_to_string(stmt_type) + "' statement executed affecting " + cnt.out + " objects in the database.%N");

				print("%NRecounting all Persons...%N");

				query := "SELECT count(*) FROM Person"
				result_set := stmt.execute_query (query)
				result_set.start
				cnt := result_set.get_integer(1)
				result_set.close
				print("   " + cnt.out + " Person(s) in the database.%N");

				stmt.close()

				db.commit()

				db.close()
			end
		rescue
			dev_ex ?= (create {EXCEPTION_MANAGER}).last_exception
			if dev_ex /= Void then
				print("%NException occurred on " + db.out + "%N")
				print("%NERROR message: " + dev_ex.message + "%N")
				if {MT_EXCEPTIONS}.c_matisse_exception_code = {MT_EXCEPTIONS}.MATISSE_NOSUCHDB then
					print("Unable to connect to: " + db.out + "%N")
					print("Make sure the database is started%N")
				end
			end
			impossible := True
			retry
		end

feature {NONE} -- Insert Objects

	insert_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			pstmt: MT_PREPARED_STATEMENT
			stmt: MT_STATEMENT
			cmd_text: STRING
			inserted, cnt: INTEGER
			r_set: BOOLEAN
		do
			if impossible = False then
				print("%NTest Insert Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				cmd_text := "INSERT INTO Person (FirstName, LastName, Age) VALUES (?, ?, ?)"
				pstmt := db.prepare_statement (cmd_text)

				-- Set parameters
				pstmt.set_string(1, "James")
				pstmt.set_string(2, "Watson")
				pstmt.set_int(3, 75)

				print ("Executing: " + pstmt.stmt_text() + "%N")

				-- Execute the INSERT statement
				inserted := pstmt.execute_update()

				print ("Inserted: " + inserted.out + "%N")

				-- Set parameters for the next execution
				pstmt.set_string(1, "Elizabeth")
				pstmt.set_string(2, "Watson")
				pstmt.set_null(3);

				print ("Executing: " + pstmt.stmt_text() + "%N")

				-- Execute the INSERT statement with new parameters
				inserted := pstmt.execute_update()

				print ("Inserted: " + inserted.out + "%N")

				-- Clean up
				pstmt.close()

				stmt := db.create_statement ()

				-- Set the relationship 'Spouse' between these two Person objects
				cmd_text := "SELECT REF(p) FROM Person p WHERE FirstName = 'James' AND LastName = 'Watson' INTO p1;"
				r_set := stmt.execute(cmd_text)
				cmd_text := "UPDATE Person SET Spouse = p1 WHERE FirstName = 'Elizabeth' AND LastName = 'Watson';"
				cnt := stmt.execute_update(cmd_text)

				-- Create a Manager object and two Employee objects who report to the manager
				cmd_text := "INSERT INTO Manager (FirstName, LastName, HireDate, Salary) " +
				"VALUES ('Steve', 'Smith', DATE '2000-09-01', 65000.00) RETURNING INTO theManager;"
				inserted := stmt.execute_Update(cmd_text)

				cmd_text := "INSERT INTO Employee (FirstName, LastName, HireDate, Salary, ReportsTo) " +
					"VALUES ('John', 'Doe', DATE '2001-11-10', 45000.00, theManager);"
				inserted := stmt.execute_Update(cmd_text)

				cmd_text := "INSERT INTO Employee (FirstName, LastName, HireDate, Salary, ReportsTo) " +
					"VALUES ('Dave', 'Edwards', DATE '2002-03-10', 40000.00, theManager);"
				inserted := stmt.execute_Update(cmd_text)

				cmd_text := "INSERT INTO Employee (FirstName, LastName, HireDate, Salary) " +
					"VALUES ('Richard', 'Brown', DATE '2003-03-10', 50000.00);"
				inserted := stmt.execute_Update(cmd_text)

				stmt.close()

				db.commit()

				db.close()
			end
		rescue
			dev_ex ?= (create {EXCEPTION_MANAGER}).last_exception
			if dev_ex /= Void then
				print("%NException occurred on " + db.out + "%N")
				print("%NERROR message: " + dev_ex.message + "%N")
				if {MT_EXCEPTIONS}.c_matisse_exception_code = {MT_EXCEPTIONS}.MATISSE_NOSUCHDB then
					print("Unable to connect to: " + db.out + "%N")
					print("Make sure the database is started%N")
				end
			end
			impossible := True
			retry
		end


feature {NONE} -- Select Objects

	select_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			db: MT_DATABASE
			dev_ex: DEVELOPER_EXCEPTION
			stmt: MT_STATEMENT
			result_set: MT_RESULT_SET
			p: PERSON
			query: STRING
		do
			if impossible = False then
				print("%NTest Select Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				-- create s SQL statement
				stmt := db.create_statement ()
				query := "SELECT REF(p) FROM Person p WHERE LastName = 'Watson';"
				result_set := stmt.execute_query (query)

				print ("Total selected:  " + result_set.total_num_objects().out + "%N")
				print ("Total qualified: " + result_set.total_num_qualified().out + "%N")
				print ("Total columns:   " + result_set.column_count ().out +"%N")

				from
					result_set.start
				until
					result_set.exhausted
				loop
					p ?= result_set.get_object(1)
					print("   " + p.mtclass().mtname() + " " + p.firstname() + " " + p.lastname() +
							" married to " + p.spouse().firstname() + "%N");

					result_set.forth
				end

				result_set.close ()

				stmt.close()

				db.end_version_access()

				db.close()
			end
		rescue
			dev_ex ?= (create {EXCEPTION_MANAGER}).last_exception
			if dev_ex /= Void then
				print("%NException occurred on " + db.out + "%N")
				print("%NERROR message: " + dev_ex.message + "%N")
				if {MT_EXCEPTIONS}.c_matisse_exception_code = {MT_EXCEPTIONS}.MATISSE_NOSUCHDB then
					print("Unable to connect to: " + db.out + "%N")
					print("Make sure the database is started%N")
				end
			end
			impossible := True
			retry
		end


feature {NONE} -- Select Values

	select_values (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			pstmt: MT_PREPARED_STATEMENT
			result_set: MT_RESULT_SET
			i, colnum: INTEGER
			cmd_text, fname, lname, sfname, age: STRING
		do
			if impossible = False then
				print("%NTest Select Values:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				cmd_text := "SELECT FirstName, LastName, Spouse.FirstName AS Spouse, Age FROM Person WHERE LastName = ? LIMIT 10;"
				pstmt := db.prepare_statement (cmd_text)

				-- Set parameters
				pstmt.set_string(1, "Watson")

				print ("Executing: " + pstmt.stmt_text() + "%N")

				result_set := pstmt.execute_query ()

				colnum := result_set.column_count ()

				print ("Total selected:  " + result_set.total_num_objects().out + "%N")
				print ("Total qualified: " + result_set.total_num_qualified().out + "%N")
				print ("Total columns:   " + colnum.out +"%N")

				-- List column names
				from
					i := 1
				until
					i > colnum
				loop
					print(result_set.column_name(i) + "     ")
				   i := i + 1
				end
				print("%N");
				print("---%N");

				-- List rows
				from
					result_set.start
				until
					result_set.exhausted
				loop
					fname := result_set.get_string(1)
					lname := result_set.get_string(2)
					sfname := result_set.get_string(3)
					if not result_set.is_null(4) then
						age := result_set.get_integer(4).out
					else
						age := "NULL"
					end
					print(fname + " , " + lname + " , " + sfname + " , " + age + "%N");

					result_set.forth
				end

				result_set.close ()

				pstmt.close()

				db.end_version_access()

				db.close()
			end
		rescue
			dev_ex ?= (create {EXCEPTION_MANAGER}).last_exception
			if dev_ex /= Void then
				print("%NException occurred on " + db.out + "%N")
				print("%NERROR message: " + dev_ex.message + "%N")
				if {MT_EXCEPTIONS}.c_matisse_exception_code = {MT_EXCEPTIONS}.MATISSE_NOSUCHDB then
					print("Unable to connect to: " + db.out + "%N")
					print("Make sure the database is started%N")
				end
			end
			impossible := True
			retry
		end


end -- class SQL_EXAMPLES
