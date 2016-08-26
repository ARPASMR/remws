note
	description: "MATISSE-Eiffel Binding: Matisse entry-point dictionary examples."
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
	EPDICT_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db: STRING

		do
			print("%NRunning Entry-Point Dictionary Examples:%N")
			host := "localhost"
			db := "example"

			create_objects (host, db)

			iterate_epdict (host, db)

			lookup_objects_count (host, db)

			lookup_objects (host, db)

			delete_all_objects(host, db)

		end

feature {NONE} -- Create Objects

	create_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			cnt: INTEGER
			p: PERSON
			personCls: MTCLASS
			p_iter: MT_OBJECT_ITERATOR[PERSON]
		do
			if impossible = False then
				print("%NTest Create Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				create p.make_person (db)
				p.set_firstname("Jane");
				p.set_lastname("Jones")
            p.set_comment("in reality weak knees hindered many");
				p.set_gender("Female");
				p.set_collegegrad(True);

				create p.make_person (db)
				p.set_firstname("Paul");
				p.set_lastname("Ronaldson")
            p.set_comment("kill two birds with one stone");
				p.set_gender("Male");
				p.set_collegegrad(False);

				create p.make_person (db)
				p.set_firstname("Pamela");
				p.set_lastname("Ronaldson")
            p.set_comment("kill the goose that lays the golden egg");
				p.set_gender("Female");
				p.set_collegegrad(True);


				personCls := db.get_mtclass("Person");

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

				print("%NList all person(s):%N")
				create p_iter.make_class_instance_iterator (db, personCls, {MT_DATABASE}.Mt_Max_Prefetching)
				from
					p_iter.start
				until
					p_iter.exhausted
				loop
					p := p_iter.item

					print("   " + p.firstname + " " + p.lastname + " says " + p.comment + "%N")

					p_iter.forth
				end
				p_iter.close

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


feature {NONE} -- Iterate Entry-Point Dictionary

	iterate_epdict (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			i: INTEGER
			search_string: STRING
			p: PERSON
			epdictCls: MTENTRYPOINTDICTIONARY
			p_iter: MT_OBJECT_ITERATOR[PERSON]
			o_iter: MT_OBJECT_ITERATOR[MTOBJECT]
		do
			if impossible = False then
				print("%NTest Iterate Entry-Point Dictionary:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				epdictCls := db.get_mtentrypointdictionary({PERSON}.commentdict_name);
				search_string := "knees"
				print("%NLooking for Persons  with '" + search_string + "' in the 'comment' text%N")

				print("Solution 1%N")
				-- Solution 1: Create an iterator from the EP dict
				create p_iter.make_empty_iterator ()
				epdictCls.create_iterator (p_iter, search_string, Void, {MT_DATABASE}.Mt_Max_Prefetching)
				i := 0
				from
					p_iter.start
				until
					p_iter.exhausted
				loop
					p := p_iter.item

					print("   " + p.firstname + " " + p.lastname + "%N")
					i := i + 1

					p_iter.forth
				end
				p_iter.close
				print("" + i.out + " Person(s) with 'comment' containing '"+ search_string + "'%N")

				print("Solution 2%N")
				-- Solution 2: Create an iterator from the EP dict with the MTOBJECT
				-- base type
				o_iter := epdictCls.iterator (search_string, Void, {MT_DATABASE}.Mt_Max_Prefetching)
				i := 0
				from
					o_iter.start
				until
					o_iter.exhausted
				loop
					p ?= o_iter.item
					if (p /= Void) then
						print("   " + p.firstname + " " + p.lastname + "%N")
						i := i + 1
					end
					o_iter.forth
				end
				o_iter.close
				print("" + i.out + " Person(s) with 'comment' containing '"+ search_string + "'%N")

				print("%NLooking for College Graduate Persons%N")

				epdictCls := db.get_mtentrypointdictionary({PERSON}.collegegraddict_name);

				-- Solution 1: Create an iterator from the EP dict
				create p_iter.make_empty_iterator ()
				epdictCls.create_iterator (p_iter, "true", Void, {MT_DATABASE}.Mt_Max_Prefetching)
				i := 0
				from
					p_iter.start
				until
					p_iter.exhausted
				loop
					p := p_iter.item

					print("   " + p.firstname + " " + p.lastname + "%N")
					i := i + 1

					p_iter.forth
				end
				p_iter.close

				print("%N" + i.out + " Person(s) with College Graduate degree%N")

				print("%NLooking for Persons filtered by gender%N")

				epdictCls := db.get_mtentrypointdictionary({PERSON}.genderdict_name);

				-- Solution 1: Create an iterator from the EP dict
				create p_iter.make_empty_iterator ()
				epdictCls.create_iterator (p_iter, "Male", Void, {MT_DATABASE}.Mt_Max_Prefetching)
				i := 0
				from
					p_iter.start
				until
					p_iter.exhausted
				loop
					p := p_iter.item

					print("   " + p.firstname + " " + p.lastname + "%N")
					i := i + 1

					p_iter.forth
				end
				p_iter.close
				print("%N" + i.out + " Male Person(s)%N")

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


feature {NONE} -- lookup Objects Count

	lookup_objects_count (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			i: INTEGER
			search_string: STRING
			epdictCls: MTENTRYPOINTDICTIONARY
		do
			if impossible = False then
				print("%NTest Lookup Objects Count:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				epdictCls := db.get_mtentrypointdictionary({PERSON}.commentdict_name);
				search_string := "knees"
				print("%NLooking for Persons  with '" + search_string + "' in the 'comment' text%N")

				i := epdictCls.object_number (search_string, Void)

				print("" + i.out + " Person(s) with 'comment' containing '"+ search_string + "'%N")

				print("%NLooking for College Graduate Persons%N")

				epdictCls := db.get_mtentrypointdictionary({PERSON}.collegegraddict_name);

				i := epdictCls.object_number ("true", Void)

				print("%N" + i.out + " Person(s) with College Graduate degree%N")

				print("%NLooking for Persons filtered by gender%N")

				epdictCls := db.get_mtentrypointdictionary({PERSON}.genderdict_name);

				i := epdictCls.object_number ("Male", Void)
				print("%N" + i.out + " Male Person(s)%N")

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


feature {NONE} -- lookup Objects

	lookup_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			search_string: STRING
			p: PERSON
			epdictCls: MTENTRYPOINTDICTIONARY
		do
			if impossible = False then
				print("%NTest Lookup Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				epdictCls := db.get_mtentrypointdictionary({PERSON}.commentdict_name);
				search_string := "knees"
				print("%NLooking for one Person with '" + search_string + "' in the 'comment' text%N")

				p ?= epdictCls.lookup (search_string, Void)

				if (p /= Void) then
					print(" found exactly one Person: "+ p.firstname + "%N")
				else
					print(" nobody found%N")
				end

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


end -- class EPDICT_EXAMPLES
