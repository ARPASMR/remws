note
	description: "MATISSE-Eiffel Binding: Matisse read write object examples."
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
	READWRITE_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db: STRING

		do
			print("%NRunning Read Write Objects Examples:%N")
			host := "localhost"
			db := "example"

			create_objects(host, db)

			list_objects(host, db)

			list_own_objects(host, db)

			remove_object_values (host, db)

			load_objects(host, db)

			delete_objects(host, db)

			delete_all_objects(host, db)

		end

feature {NONE} -- Create Objects

	create_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			p: PERSON
			e: EMPLOYEE
			a: POSTALADDRESS
			salary: DECIMAL
			hiredate: DATE
		do
			if impossible = False then
				print("%NTest Create Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				create p.make_person (db)
				p.set_firstname("John");
				p.set_lastname("Smith")
				p.set_age(42)
				create a.make_postaladdress (db)
				a.set_city("Portland")
				a.set_postalcode("97201")
				p.set_address(a)
				print("%NPerson John Smith from Portland created.%N")

				create e.make_employee (db)
				e.set_firstname("Jane");
				e.set_lastname("Jones")
				-- Age is nullable we can leave it unset
				create salary.make_from_string ("85000.00")
				e.set_salary(salary)
				create hiredate.make (2010,10,10)
				e.set_hiredate(hiredate)
				print("%NEmployee Jane Jones created.%N")

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


feature {NONE} -- List Objects

	list_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			p: PERSON
			cnt: INTEGER
			personCls: MTCLASS
			addressCls: MTCLASS
			p_iter1, p_iter2: MT_OBJECT_ITERATOR[PERSON]
			o_iter3: MT_OBJECT_ITERATOR[MTOBJECT]

		do
			if impossible = False then
				print("%NTest List Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)
				personCls := db.get_mtclass("Person");
				addressCls := db.get_mtclass("PostalAddress");

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")
				cnt := addressCls.instance_number ()
				print("" + cnt.out + " Address(s) in the database.%N")

				print("%NList all person(s) - Solution 1:%N")
				-- Solution 1: Create an iterator from the class
				create p_iter1.make_empty_iterator ()
				personCls.create_instance_iterator (p_iter1, {MT_DATABASE}.Mt_Max_Prefetching)

				from
					p_iter1.start
				until
					p_iter1.exhausted
				loop
					p := p_iter1.item
					print("   " + p.firstname + " " + p.lastname + " from ")
					if (p.address /= Void) then
						print(p.address.city)
					else
						print("???")
					end

					print(" is a "+ p.mtclass.mtname + "%N")
					p_iter1.forth
				end
				p_iter1.close

				print("%NList all person(s) - Solution 2:%N")
				-- Solution 2: Create an iterator with the class
				create p_iter2.make_class_instance_iterator (db, personCls, {MT_DATABASE}.Mt_Max_Prefetching)

				from
					p_iter2.start
				until
					p_iter2.exhausted
				loop
					p := p_iter2.item
					print("   " + p.firstname + " " + p.lastname + " from ")
					if (p.address /= Void) then
						print(p.address.city)
					else
						print("???")
					end

					print(" is a "+ p.mtclass.mtname + "%N")

					p_iter2.forth
				end
				p_iter2.close

				print("%NList all person(s) - Solution 3:%N")
				-- Solution 3: Create an iterator from the class with the MTOBJECT
				-- base type
				o_iter3 := personCls.instance_iterator ({MT_DATABASE}.Mt_Max_Prefetching)
				from
					o_iter3.start
				until
					o_iter3.exhausted
				loop
					p ?= o_iter3.item
					if (p /= Void) then
						print("   " + p.firstname + " " + p.lastname + " from ")
						if (p.address /= Void) then
							print(p.address.city)
						else
							print("???")
						end

						print(" is a "+ p.mtclass.mtname + "%N")
					end
					o_iter3.forth
				end
				o_iter3.close

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

feature {NONE} -- List Own Objects

	list_own_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			p: PERSON
			cnt: INTEGER
			personCls: MTCLASS
			p_iter1, p_iter2: MT_OBJECT_ITERATOR[PERSON]

		do
			if impossible = False then
				print("%NTest List Own Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)
				personCls := db.get_mtclass("Person");

				cnt := personCls.own_instance_number ()
				print("%N" + cnt.out + " Person(s) (excluding subclasses) in the database.%N")

				print("%NList all person(s) (excluding subclasses) - Solution 1:%N")
				-- Solution 1: Create an iterator from the class
				create p_iter1.make_empty_iterator ()
				personCls.create_own_instance_iterator (p_iter1, {MT_DATABASE}.Mt_Max_Prefetching)

				from
					p_iter1.start
				until
					p_iter1.exhausted
				loop
					p := p_iter1.item
					print("   " + p.firstname + " " + p.lastname + " from ")
					if (p.address /= Void) then
						print(p.address.city)
					else
						print("???")
					end

					print(" is a "+ p.mtclass.mtname + "%N")
					p_iter1.forth
				end
				p_iter1.close

				print("%NList all person(s) (excluding subclasses) - Solution 2:%N")
				-- Solution 2: Create an iterator with the class
				create p_iter2.make_class_own_instance_iterator (db, personCls, {MT_DATABASE}.Mt_Max_Prefetching)

				from
					p_iter2.start
				until
					p_iter2.exhausted
				loop
					p := p_iter2.item
					print("   " + p.firstname + " " + p.lastname + " from ")
					if (p.address /= Void) then
						print(p.address.city)
					else
						print("???")
					end

					print(" is a "+ p.mtclass.mtname + "%N")

					p_iter2.forth
				end
				p_iter2.close


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


feature {NONE} -- Load Objects

	load_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			e: EMPLOYEE
			a: POSTALADDRESS
			fname, lname, city, zipcode: STRING
			salary: DECIMAL
			hiredate: DATE
			age, i, nb_emp, n, nb_prealloc, nb_objs_per_tran: INTEGER
		do
			if impossible = False then
				nb_emp := 100
				nb_prealloc := 50
				nb_objs_per_tran := 20
				print("%NTest load Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				n := db.preallocate(nb_prealloc)
				from
					i := 1
				until
					i > nb_emp
				loop
					fname := "Jane"
					lname := "Jones"
					age := 21 + (i \\ 30)
					create salary.make_from_string ("85000.00")
					n := i \\ 12
					create hiredate.make (2000+n,1+n,1+n)
					city := "Portland"
					zipcode := "97201"
					create e.make_employee (db)
					e.set_firstname(fname);
					e.set_lastname(lname)
					e.set_age(age)
					e.set_salary(salary)
					e.set_hiredate(hiredate)
					create a.make_postaladdress (db)
					a.set_city(city)
					a.set_postalcode(zipcode)
					e.set_address(a)
					print("   Employee #" + i.out + " - " + fname + " " + lname + " created.%N")

					if (i \\ nb_objs_per_tran) = 0 then
						db.commit()
						db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)
					end

					if db.num_preallocated () < 2 then
						n := db.preallocate(nb_prealloc)
					end
					i := i + 1
				end

				if db.is_transaction_in_progress() then
					db.commit()
				end

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




feature {NONE} -- Remove Object Values

	remove_object_values (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			e: EMPLOYEE
			employeeCls: MTCLASS
			e_iter: MT_OBJECT_ITERATOR[EMPLOYEE]
			cnt: INTEGER
		do
			if impossible = False then
				print("%NTest Remove Object Values:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				employeeCls := db.get_mtclass("Employee");

				cnt := employeeCls.instance_number ()
				print("%N" + cnt.out + " Employee(s) in the database.%N")

				-- prefetch only on object
				create e_iter.make_class_instance_iterator (db, employeeCls, 1)
				e_iter.start
				e := e_iter.item
				e_iter.close

				-- Removing value returns attribute to default
				e.remove_age();
				e.remove_dependents();
				e.set_comment("Age & Dependents Value Removed");

				-- Getting again to show effect of removing value
				print("%NComment:" + e.comment () + "%N")
				if not e.is_age_null () then
					print("Age:" + e.age ().out + "%N")
				else
					print("Age: NULL")
					if e.is_age_default_value () then
						print(" (default value)")
					end
					print("%N")
				end

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

feature {NONE} -- Delete Objects

	delete_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			p: PERSON
			personCls: MTCLASS
			p_iter: MT_OBJECT_ITERATOR[PERSON]
			cnt, i : INTEGER
		do
			if impossible = False then
				print("%NTest Delete Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				personCls := db.get_mtclass("Person");

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

				cnt := 25
				print("%NDelete up to " + cnt.out + " person(s):%N")
				create p_iter.make_class_instance_iterator (db, personCls, {MT_DATABASE}.Mt_Max_Prefetching)
				from
					p_iter.start
					i := 1
				until
					p_iter.exhausted or i > cnt
				loop
					p := p_iter.item

					p.deep_remove()

					p_iter.forth
					i := i + 1
				end
				p_iter.close

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

feature {NONE} -- Delete All Objects

	delete_all_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			personCls: MTCLASS
			addressCls: MTCLASS
			cnt: INTEGER
		do
			if impossible = False then
				print("%NTest Delete All Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				personCls := db.get_mtclass("Person");
				addressCls := db.get_mtclass("PostalAddress");

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

				print("%NDeleting all remaining Persons...%N")
				personCls.remove_all_instances()

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")
				cnt := addressCls.instance_number ()
				print("" + cnt.out + " Address(s) in the database.%N")

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


end -- class READWRITE_EXAMPLES
