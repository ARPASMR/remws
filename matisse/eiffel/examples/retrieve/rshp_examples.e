note
	description: "MATISSE-Eiffel Binding: Matisse relationship examples."
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
	RSHP_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db: STRING

		do
			print("%NRunning Relationship Examples:%N")
			host := "localhost"
			db := "example"

			set_relationships (host, db)

			add_to_relationships (host, db)

			remove_from_relationships (host, db)

			iterate_relationships (host, db)

			relationship_size (host, db)

			delete_all_objects(host, db)

		end

feature {NONE} -- Set Relationships

	set_relationships (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			salary: DECIMAL
			hiredate: DATE
			i: INTEGER
			m1, m2: MANAGER
			e: EMPLOYEE
			team: ARRAY[EMPLOYEE]
			assistants: ARRAY[Manager]
		do
			if impossible = False then
				print("%NTest Create Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				create m1.make_manager (db)
				m1.set_firstname("James");
				m1.set_lastname("Dithers")
				create hiredate.make (2010,10,10)
				m1.set_hiredate(hiredate)
				create salary.make_from_string ("43")
				m1.set_salary(salary)
				-- Set a relationship
				-- Need to report to someone since the relationship
				-- cardinality minimum is set to 1
            	m1.set_reportsto(m1);

				create m2.make_manager (db)
				m2.set_firstname("Dagwood");
				m2.set_lastname("Bumstead")
				create hiredate.make (2010,10,10)
				m2.set_hiredate(hiredate)
				create salary.make_from_string ("42")
				m2.set_salary(salary)
				-- Set a relationship
            	m2.set_reportsto(m1);

				create e.make_employee (db)
				e.set_firstname("Elmo");
				e.set_lastname("Tuttle")
				-- Age is nullable we can leave it unset
				create salary.make_from_string ("22")
				e.set_salary(salary)
				create hiredate.make (2010,10,10)
				e.set_hiredate(hiredate)
				-- Set a relationship
            	e.set_reportsto(m2);

				-- Set a relationship
            	m1.set_assistant(e);
				-- Set a relationship
            	m2.set_assistant(e);

            	print("%NInitial settings:%N");
				print("   " + m1.mtclass().mtname() + " " + m1.firstname() +
						" reports to " + m1.reportsto().firstname() + "%N");
				print("   " + m2.mtclass().mtname() + " " + m2.firstname() +
						" reports to " + m2.reportsto().firstname() + "%N");
				print("   " + e.mtclass().mtname() + " " +	e.firstname() +
						" reports to " + e.reportsto().firstname() + "%N");
				print("   " + m1.mtclass().mtname() + " " +  m1.firstname() +
						" assitant is " + m1.assistant().firstname() + "%N");
				print("   " + m2.mtclass().mtname() + " " +  m2.firstname() +
						" assitant is " + m2.assistant().firstname() + "%N");

            print("%NInverse relationships are automatically updated:%N");
            -- team is automatically updated
				team := m1.team();
				print("   " + m1.firstname() + " team is: ");
				from
					i := 1
				until
					i > team.count
				loop
					print(" " + team.item (i).firstname());
					i := i + 1
				end
            print("%N");

            -- assistantOf is automatically updated
				assistants := e.AssistantOf();
				from
					i := 1
				until
					i > assistants.count
				loop
					print("   " + e.firstname() + " is "
                     + assistants[i].firstname() + "'s assistant");
					i := i + 1
				end
            print("%N");

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


feature {NONE} -- Add to Relationships

	add_to_relationships (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			f_name, l_name: STRING
			c1,c2,c3: PERSON
			m: MANAGER
			idxCls: MTINDEX
			key: ARRAY[ANY]
			children: ARRAY[PERSON]
		do
			if impossible = False then
				print("%NTest Add to Relationships:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				idxCls := db.get_mtindex({PERSON}.personname_name);
				f_name := "Dagwood"
				l_name := "Bumstead"
				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)
				m ?= idxCls.lookup (key, Void)

				create c1.make_person (db)
				c1.set_firstname("Alexander");
				c1.set_lastname("Bumstead")

				create c2.make_person (db)
				c2.set_firstname("Cookie");
				c2.set_lastname("Bumstead")

				create children.make_filled(Void, 1,2)
				children.put(c1, 1)
				children.put(c2, 2)
            -- Set successors
            m.set_children(children);

            -- father is automatically updated
				print("   " + c1.firstname() +
						" is " + c1.father().firstname() + "'s child %N");
				print("   " + c2.firstname() +
						" is " + c2.father().firstname() + "'s child %N");

				create c3.make_person (db)
				c3.set_firstname("Baby");
				c3.set_lastname("Bumstead")

				-- add successors
            m.append_children(c3)

            print("%NAdd another successor:%N")
            print("   Now " + m.firstname() + " has "
              + m.children().count.out + " children");

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


feature {NONE} -- Remove from Relationships

	remove_from_relationships (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			f_name, l_name: STRING
			c2: PERSON
			m: MANAGER
			idxCls: MTINDEX
			key: ARRAY[ANY]
		do
			if impossible = False then
				print("%NTest Remove from Relationships:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				idxCls := db.get_mtindex({PERSON}.personname_name);
				f_name := "Dagwood"
				l_name := "Bumstead"
				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)
				m ?= idxCls.lookup (key, Void)

				f_name := "Cookie"
				l_name := "Bumstead"
				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)
				c2 ?= idxCls.lookup (key, Void)

				m.remove_children(c2)

				print("%NRemove one successor:%N")
            print("   Now " + m.firstname() + " has "
              + m.children().count.out + " children");

            -- clearing all successors (this only breaks links, it does
            -- not remove objects)
            m.clear_children();
				-- second time as not effect
            m.clear_children();

				print("%NClear successors:%N")
            print("   Now " + m.firstname() + " has "
              + m.children().count.out + " children");

				-- NOTE: rollback changes so next sample can still see 3 children
				db.rollback()

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


feature {NONE} -- Iterate Relationships

	iterate_relationships (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			f_name, l_name: STRING
			m: MANAGER
			c: PERSON
			idxCls: MTINDEX
			key: ARRAY[ANY]
			iter: MT_OBJECT_ITERATOR[PERSON]
		do
			if impossible = False then
				print("%NTest Iterate Relationships:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				idxCls := db.get_mtindex({PERSON}.personname_name);
				f_name := "Dagwood"
				l_name := "Bumstead"
				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)
				m ?= idxCls.lookup (key, Void)

				print("%NIterate " + m.firstname() + "'s children:%N");

            -- Iterate when the relationship is large is always more efficient
				iter := m.children_iterator ()
				from
					iter.start
				until
					iter.exhausted
				loop
					c := iter.item

					print("   " + c.firstname + " " + c.lastname + "%N")

					iter.forth
				end
				iter.close

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


feature {NONE} -- Relationship Size

	relationship_size (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			f_name, l_name: STRING
			cnt: INTEGER
			m: MANAGER
			idxCls: MTINDEX
			key: ARRAY[ANY]
		do
			if impossible = False then
				print("%NTest Relationship Size:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				idxCls := db.get_mtindex({PERSON}.personname_name);
				f_name := "Dagwood"
				l_name := "Bumstead"
				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)
				m ?= idxCls.lookup (key, Void)

				-- Get the relationship size without loading the Java objects
				-- which is the fast way to get the size
				cnt := m.children_size()
            print("   " + m.firstname() + " has " + cnt.out + " children");

				-- an alternative to get the relationship size
				-- but the Eiffel objects are loaded before you can get the count
				cnt := m.children().count
            print("   " + m.firstname() + " has " + cnt.out + " children");

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

feature {NONE} -- Delete All Objects

	delete_all_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			personCls: MTCLASS
			cnt: INTEGER
		do
			if impossible = False then
				print("%NTest Delete All Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				personCls := db.get_mtclass("Person");

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

				print("%NDeleting all Persons...%N")
				personCls.remove_all_instances()

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

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


end -- class RSHP_EXAMPLES
