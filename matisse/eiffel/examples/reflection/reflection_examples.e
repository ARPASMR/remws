note
	description: "MATISSE-Eiffel Binding: Matisse object reflection examples."
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
	REFLECTION_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db: STRING
		do
			print("%NRunning Object Relection Examples:%N")
			host := "localhost"
			db := "example"

			create_objects(host, db)

			list_objects(host, db)

			index_lookup (host, db)

			entry_point_lookup (host, db)

			list_object_properties (host, db)

			add_class (host, db)

			delete_all_objects(host, db)

			delete_class (host, db)
		end


feature {NONE} -- Create Objects

	create_objects (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			factory: MT_CORE_OBJECT_FACTORY
			db: MT_DATABASE
			personCls, employeeCls, managerCls: MTCLASS
			fnAtt, lnAtt, cgAtt, hdAtt, slAtt: MTATTRIBUTE
			tmRshp: MTRELATIONSHIP
			p, e, m: MTOBJECT
			salary: DECIMAL
			hiredate: DATE
			tmbrs: ARRAY[MTOBJECT]
		do
			if impossible = False then
				print("%NTest Create Objects:%N")
				-- Use the MT_CORE_OBJECT_FACTORY since there is need for
				-- dynamic object creation, it is all MTOBJECT
				create factory.make
				create db.make_factory(host, dbname, factory)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				personCls := db.get_mtclass("Person");
				employeeCls := db.get_mtclass("Employee");
				managerCls := db.get_mtclass("Manager");
				fnAtt := db.get_mtattribute("FirstName", personCls)
				lnAtt := db.get_mtattribute("LastName", personCls)
				cgAtt := db.get_mtattribute("collegeGrad", personCls)
				hdAtt := db.get_mtattribute("hireDate", employeeCls)
				slAtt := db.get_mtattribute("salary", employeeCls)
				tmRshp := db.get_mtrelationship("team", managerCls)
				print("%NCreating one Person...%N")
				create p.make_from_mtclass (personCls)
				p.set_string(fnAtt, "John");
				p.set_string(lnAtt, "Smith")
				p.set_boolean(cgAtt, False)

				print("%NCreating one Employee...%N")
				create e.make_from_mtclass (employeeCls)
				e.set_string(fnAtt, "James");
				e.set_string(lnAtt, "Roberts")
				e.set_boolean(cgAtt, True)
				create salary.make_from_string ("5123.25")
				e.set_numeric(slAtt, salary)
				create hiredate.make (2009,09,09)
				e.set_date(hdAtt, hiredate)

				print("%NCreating one Manager...%N")
				create m.make_from_mtclass (managerCls)
				m.set_string(fnAtt, "Andy");
				m.set_string(lnAtt, "Brown")
				m.set_boolean(cgAtt, True)
				create salary.make_from_string ("5123.25")
				m.set_numeric(slAtt, salary)
				create hiredate.make (2008,08,08)
				m.set_date(hdAtt, hiredate)
				create tmbrs.make_filled(Void, 1, 2)
				tmbrs.put(m, 1)
				tmbrs.put(e, 2)
				m.set_successors(tmRshp, tmbrs)

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
			factory: MT_CORE_OBJECT_FACTORY
			db: MT_DATABASE
			cnt: INTEGER
			personCls: MTCLASS
			fnAtt, lnAtt, cgAtt: MTATTRIBUTE
			o_iter: MT_OBJECT_ITERATOR[MTOBJECT]
			p: MTOBJECT
		do
			if impossible = False then
				print("%NTest List Objects:%N")
				-- Use the MT_CORE_OBJECT_FACTORY since there is need for
				-- dynamic object creation, it is all MTOBJECT
				create factory.make
				create db.make_factory(host, dbname, factory)
				db.open()

				db.start_version_access(Void)

				personCls := db.get_mtclass("Person");
				fnAtt := db.get_mtattribute("FirstName", personCls)
				lnAtt := db.get_mtattribute("LastName", personCls)
				cgAtt := db.get_mtattribute("collegeGrad", personCls)

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

				o_iter := personCls.instance_iterator ({MT_DATABASE}.Mt_Max_Prefetching)
				from
					o_iter.start
				until
					o_iter.exhausted
				loop
					p := o_iter.item

					print("   " + p.mtclass.mtname + " #" + p.oid.out)
					print(" - " + p.get_string(fnAtt) + " " + p.get_string(lnAtt))
					print(" collegeGrad="+ p.get_boolean(cgAtt).out + "%N")

					o_iter.forth
				end
				o_iter.close

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


feature {NONE} -- Index Lookup

	index_lookup (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			factory: MT_CORE_OBJECT_FACTORY
			db: MT_DATABASE
			personCls: MTCLASS
			fnAtt, lnAtt, cgAtt: MTATTRIBUTE
			f_name, l_name: STRING
			idxCls: MTINDEX
			o_iter: MT_OBJECT_ITERATOR[MTOBJECT]
			p: MTOBJECT
			i: INTEGER
			key: ARRAY[ANY]
		do
			if impossible = False then
				print("%NTest Index Lookup:%N")
				-- Use the MT_CORE_OBJECT_FACTORY since there is need for
				-- dynamic object creation, it is all MTOBJECT
				create factory.make
				create db.make_factory(host, dbname, factory)
				db.open()

				db.start_version_access(Void)

				personCls := db.get_mtclass("Person");
				fnAtt := db.get_mtattribute("FirstName", personCls)
				lnAtt := db.get_mtattribute("LastName", personCls)
				cgAtt := db.get_mtattribute("collegeGrad", personCls)

				idxCls := db.get_mtindex("personName");

				-- Get the number of entries in the index
				i := idxCls.index_entries_number ()

				print("" + i.out + " entries in the index%N")

				f_name := "James"
				l_name := "Roberts"
				print("%NLooking for Person '" + f_name + " " + l_name + "'%N")

				-- Create the key
				create key.make_filled(Void, 1, 2)
				key.put(l_name, 1)
				key.put(f_name, 2)

				-- lookup for the number of objects matching the key
				i := idxCls.object_number (key, Void)

				print("  " + i.out + " objects retrieved%N")

				if i > 1 then
				o_iter := idxCls.iterator (key, key, Void, {MTINDEX}.Mt_Direct, {MT_DATABASE}.Mt_Max_Prefetching)
				i := 0
				from
					o_iter.start
				until
					o_iter.exhausted
				loop
					p := o_iter.item

					print("  found " + p.mtclass.mtname + " #" + p.oid.out)
					print(" - " + p.get_string(fnAtt) + " " + p.get_string(lnAtt))
					print(" collegeGrad="+ p.get_boolean(cgAtt).out + "%N")
					i := i + 1

					o_iter.forth
				end
				o_iter.close
				print("" + i.out + " Person(s) found%N")

				else
					p := idxCls.lookup (key, Void)

					if (p /= Void) then
						print(" found exactly one Person: "+ p.get_string(fnAtt) + " " + p.get_string(lnAtt) + "%N")
					else
						print(" nobody found%N")
					end
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


feature {NONE} -- Entry Point Lookup

	entry_point_lookup (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			factory: MT_CORE_OBJECT_FACTORY
			db: MT_DATABASE
			personCls: MTCLASS
			fnAtt, lnAtt, cgAtt: MTATTRIBUTE
			search_string: STRING
			o_iter: MT_OBJECT_ITERATOR[MTOBJECT]
			p: MTOBJECT
			i: INTEGER
			epdictCls: MTENTRYPOINTDICTIONARY
		do
			if impossible = False then
				print("%NTest Entry Point Lookup:%N")
				-- Use the MT_CORE_OBJECT_FACTORY since there is need for
				-- dynamic object creation, it is all MTOBJECT
				create factory.make
				create db.make_factory(host, dbname, factory)
				db.open()

				db.start_version_access(Void)

				personCls := db.get_mtclass("Person");
				fnAtt := db.get_mtattribute("FirstName", personCls)
				lnAtt := db.get_mtattribute("LastName", personCls)
				cgAtt := db.get_mtattribute("collegeGrad", personCls)

				epdictCls := db.get_mtentrypointdictionary("collegeGradDict");

				search_string := "True"
				print("%NLooking for Persons with CollegeGrad=" + search_string + "%N")

				i := epdictCls.object_number (search_string, Void)

				if  i > 1 then
					o_iter := epdictCls.iterator (search_string, Void, {MT_DATABASE}.Mt_Max_Prefetching)
					i := 0
					from
						o_iter.start
					until
						o_iter.exhausted
					loop
						p ?= o_iter.item

						print("  found exactly one Person:" + " #" + p.oid.out)
						print(" - " + p.get_string(fnAtt) + " " + p.get_string(lnAtt))
						print(" collegeGrad="+ p.get_boolean(cgAtt).out + "%N")
						i := i + 1

						o_iter.forth
					end
					o_iter.close
					print("" + i.out + " Person(s) with collegeGrad="+ search_string + "%N")
				else
					p := epdictCls.lookup (search_string, Void)

					if (p /= Void) then
						print("  found exactly one Person:" + " #" + p.oid.out)
						print(" - " + p.get_string(fnAtt) + " " + p.get_string(lnAtt))
						print(" collegeGrad="+ p.get_boolean(cgAtt).out + "%N")
					else
						print(" nobody found%N")
					end
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



feature {NONE} -- List Object Properties

	list_object_properties (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			factory: MT_CORE_OBJECT_FACTORY
			db: MT_DATABASE
			cnt, att_type, val_type: INTEGER
			personCls: MTCLASS
			o_iter: MT_OBJECT_ITERATOR[MTOBJECT]
			p: MTOBJECT
			att_iter: MT_PROPERTY_ITERATOR[MTATTRIBUTE]
			att: MTATTRIBUTE
			rel_iter: MT_PROPERTY_ITERATOR[MTRELATIONSHIP]
			rel: MTRELATIONSHIP
		do
			if impossible = False then
				print("%NTest List Objects:%N")
				-- Use the MT_CORE_OBJECT_FACTORY since there is need for
				-- dynamic object creation, it is all MTOBJECT
				create factory.make
				create db.make_factory(host, dbname, factory)
				db.open()

				db.start_version_access(Void)

				personCls := db.get_mtclass("Person");

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

				o_iter := personCls.instance_iterator ({MT_DATABASE}.Mt_Max_Prefetching)
				from
					o_iter.start
				until
					o_iter.exhausted
				loop
					p := o_iter.item

					print("- " + p.mtclass.mtname + " #" + p.oid.out + "%N")

					print("  Attributes:%N")
					att_iter := p.attributes_iterator()
					from
						att_iter.start
					until
						att_iter.exhausted
					loop
						att := att_iter.item
						att_type := att.get_mttype()
						val_type := p.get_type(att)
						print("    " + att.mtname + "(type=" + att_type.out + "): ")
						if val_type = {MTTYPE}.Mt_Null then
							print("MT_NULL")
						else
							print(p.get_value(att).out)
						end
						print(" (valtype=" + val_type.out + ")")
						print("%N")
						att_iter.forth
					end
					att_iter.close


					print("  Relationships:%N")
					rel_iter := p.relationships_iterator()
					from
						rel_iter.start
					until
						rel_iter.exhausted
					loop
						rel := rel_iter.item

						print("    " + rel.mtname + ": " + p.get_successor_size(rel).out + "%N")

						rel_iter.forth
					end
					rel_iter.close

					print("  Inverse Relationships:%N")
					rel_iter := p.inverse_relationships_iterator()
					from
						rel_iter.start
					until
						rel_iter.exhausted
					loop
						rel := rel_iter.item

						print("    " + rel.mtname + ": " + p.get_successor_size(rel).out + "%N")

						rel_iter.forth
					end
					rel_iter.close

					o_iter.forth
				end
				o_iter.close

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


feature {NONE} -- Add Class

	add_class (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			factory: MT_CORE_OBJECT_FACTORY
			db: MT_DATABASE
			personCls, addrCls: MTCLASS
			cAtt, pcAtt: MTATTRIBUTE
			attrs: ARRAY[MTATTRIBUTE]
			ad_rel: MTRELATIONSHIP
		do
			if impossible = False then
				print("%NTest Add Class:%N")
				-- Use the MT_CORE_OBJECT_FACTORY since there is need for
				-- dynamic object creation, it is all MTOBJECT
				create factory.make
				create db.make_factory(host, dbname, factory)

				-- open connection in DDL mode
				db.set_data_access_mode({MT_DATABASE}.Mt_Data_Definition)

				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				personCls := db.get_mtclass("Person");

				-- Create new attributes
				create cAtt.make_mtattribute(db, "City", {MTTYPE}.Mt_String )
				create pcAtt.make_mtattribute(db, "PostalCode", {MTTYPE}.Mt_String )

				-- Create a new Class
				create attrs.make_filled(Void, 1, 2)
				attrs.force(cAtt, 1)
				attrs.force(pcAtt, 2)
				create addrCls.make_mtclass_full(db, "PostalAddress", attrs, Void)

				-- List the new PostalAddress class to Person
				create ad_rel.make_mtrelationship(db, "Address", addrCls, 0, 1)
				personCls.addcls_mtrelationship(ad_rel);

				print("Done.%N")

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
			cnt: INTEGER
			factory: MT_CORE_OBJECT_FACTORY
		do
			if impossible = False then
				print("%NTest Delete All Objects:%N")
				create factory.make
				create db.make_factory(host, dbname, factory)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				personCls := db.get_mtclass("Person");

				cnt := personCls.instance_number ()
				print("%N" + cnt.out + " Person(s) in the database.%N")

				print("%NDeleting all Persons...%N")
				personCls.remove_all_instances ()

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



feature {NONE} -- Delete Class

	delete_class (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			factory: MT_CORE_OBJECT_FACTORY
			db: MT_DATABASE
			addrCls: MTCLASS
		do
			if impossible = False then
				print("%NTest Delete Class:%N")
				-- Use the MT_CORE_OBJECT_FACTORY since there is need for
				-- dynamic object creation, it is all MTOBJECT
				create factory.make
				create db.make_factory(host, dbname, factory)

				-- open connection in DDL mode
				db.set_data_access_mode({MT_DATABASE}.Mt_Data_Definition)

				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				addrCls := db.get_mtclass("PostalAddress");

				addrCls.deep_remove()

				print("Done.%N")

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


end -- class REFLECTION_EXAMPLES
