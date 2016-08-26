note
	description: "MATISSE-Eiffel Binding: Matisse index examples."
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
	INDEX_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db: STRING

		do
			print("%NRunning Index Examples:%N")
			host := "localhost"
			db := "example"

			create_objects (host, db)

			lookup_objects (host, db)

			iterate_index (host, db)

			lookup_objects_count (host, db)

			count_index_entries (host, db)

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
				p.set_firstname("John");
				p.set_lastname("Jones")

				create p.make_person (db)
				p.set_firstname("Fred");
				p.set_lastname("Jones")

				create p.make_person (db)
				p.set_firstname("John");
				p.set_lastname("Murray")

				create p.make_person (db)
				p.set_firstname("Fred");
				p.set_lastname("Flintstone")


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

					print("   " + p.firstname + " " + p.lastname + "%N")

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


feature {NONE} -- lookup Objects

	lookup_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			f_name, l_name: STRING
			p: PERSON
			filter: MTCLASS
			idxCls: MTINDEX
			key: ARRAY[ANY]
		do
			if impossible = False then
				print("%NTest Lookup Objects:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				idxCls := db.get_mtindex({PERSON}.personname_name);
				f_name := "John"
				l_name := "Murray"
				print("%NLooking for Person '" + f_name + " " + l_name + "'%N")

				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)
				p ?= idxCls.lookup (key, Void)

				if (p /= Void) then
					print(" found exactly one Person: "+ p.firstname + "%N")
				else
					print(" nobody found%N")
				end

				print("%NLooking for Manager '" + f_name + " " + l_name + "'%N")
				filter:= db.get_mtclass ("Manager")
				p ?= idxCls.lookup (key, filter)

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


feature {NONE} -- Iterate Index

	iterate_index (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			i: INTEGER
			from_f_name, from_l_name, to_f_name, to_l_name: STRING
			p: PERSON
			idxCls: MTINDEX
			start_key, end_key: ARRAY[ANY]
			p_iter: MT_OBJECT_ITERATOR[PERSON]
			o_iter: MT_OBJECT_ITERATOR[MTOBJECT]
		do
			if impossible = False then
				print("%NTest Iterate Index:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				idxCls := db.get_mtindex({PERSON}.personname_name);
				from_f_name := "Fred"
				from_l_name := "Jones"
				to_f_name := "John"
				to_l_name := "Murray"
				print("%NLookup from Person '"
						+ from_f_name + " " + from_l_name + "' to '"
						+ to_f_name + " " + to_l_name + "'%N")

				create start_key.make_filled(Void, 1, 2)
				start_key.put(from_l_name, 1)
				start_key.put(from_f_name, 2)

				create end_key.make_filled(Void, 1, 2)
				end_key.put(to_l_name, 1)
				end_key.put(to_f_name, 2)

				print("Solution 1%N")
				-- Solution 1: Create an iterator from the index
				create p_iter.make_empty_iterator ()
				idxCls.create_iterator (p_iter, start_key, end_key, Void, {MTINDEX}.Mt_Direct, {MT_DATABASE}.Mt_Max_Prefetching)
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
				print("" + i.out + " Person(s) found%N")

				print("Solution 2%N")
				-- Solution 2: Create an iterator from the index with the MTOBJECT
				-- base type
				o_iter := idxCls.iterator (start_key, end_key, Void, {MTINDEX}.Mt_Direct, {MT_DATABASE}.Mt_Max_Prefetching)
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
				print("" + i.out + " Person(s) found%N")

				print("%NLookup from Person '"
						+ from_f_name + " " + from_l_name + "' to '"
						+ to_f_name + " " + to_l_name + "' in reverse order%N")

				create p_iter.make_empty_iterator ()
				idxCls.create_iterator (p_iter, start_key, end_key, Void, {MTINDEX}.Mt_Reverse, {MT_DATABASE}.Mt_Max_Prefetching)
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
				print("" + i.out + " Person(s) found%N")

				print("%NLookup Persons up to '" + to_f_name + " " + to_l_name + "'%N")

				create p_iter.make_empty_iterator ()
				idxCls.create_iterator (p_iter, Void, end_key, Void, {MTINDEX}.Mt_Direct, {MT_DATABASE}.Mt_Max_Prefetching)
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
				print("" + i.out + " Person(s) found%N")


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
			f_name, l_name: STRING
			i: INTEGER
			filter: MTCLASS
			idxCls: MTINDEX
			key: ARRAY[ANY]
		do
			if impossible = False then
				print("%NTest Lookup Objects Count:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				idxCls := db.get_mtindex({PERSON}.personname_name);
				f_name := "John"
				l_name := "Murray"
				print("%NLooking for Person '" + f_name + " " + l_name + "'%N")

				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)

				i := idxCls.object_number (key, Void)

				print("  " + i.out + " objects retrieved%N")

				print("%NLooking for Manager '" + f_name + " " + l_name + "'%N")
				filter:= db.get_mtclass ("Manager")

				i := idxCls.object_number (key, filter)

				print("  " + i.out + " objects retrieved%N")



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



feature {NONE} -- Count Index Entries

	count_index_entries (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			i: INTEGER
			idxCls: MTINDEX
		do
			if impossible = False then
				print("%NTest Count Index Entries:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				idxCls := db.get_mtindex({PERSON}.personname_name);

				i := idxCls.index_entries_number ()

				print("" + i.out + " entries in the index%N")

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


end -- class INDEX_EXAMPLES
