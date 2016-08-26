note
	description: "MATISSE-Eiffel Binding: Matisse connection examples."
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
	CONNECT_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db: STRING

		do
			print("%NRunning Connection Examples:%N")
			host := "localhost"
			db := "example"

			basic_connect(host, db)

			version_connect(host, db)

			advanced_connect(host, db, True)

			advanced_connect(host, db, False)

			version_navigation(host, db)

			-- thread count is set to 2 so it works with
			-- the Matisse evaluation version
			multi_threaded_connect(host, db, 2, 8)
		end

feature {NONE} -- Basic Connect

	basic_connect (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
		do
			if impossible = False then
				print("%NTest Basic Connect:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction({MT_DATABASE}.Mt_Min_Tran_Priority)

				print("connection and read write access to: " + db.out + "%N" )

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

feature {NONE} -- Version Connect

	version_connect (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
		do
			if impossible = False then
				print("%NTest Version Connect:%N")
				create db.make(host, dbname)
				db.open()

				db.start_version_access(Void)

				print("connection and read only access to: " + db.out + "%N")

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


feature {NONE} -- Advanced Connect

	advanced_connect (host, dbname:STRING; read_only:BOOLEAN)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			connected: BOOLEAN
		do
			if impossible = False then
				print("%NTest Advanced Connect:%N")
				create db.make(host, dbname)

				if read_only = True then
					db.set_data_access_mode({MT_DATABASE}.Mt_Data_Readonly)
				else
					db.set_data_access_mode({MT_DATABASE}.Mt_Data_Modification)
				end

				db.open()

				connected := db.is_connection_open()
				if connected then
					if db.data_access_mode () = {MT_DATABASE}.Mt_Data_Readonly then
						db.start_version_access(Void)
					else
						db.start_transaction({MT_DATABASE}.Mt_Max_Tran_Priority)
					end

					print("connection and ")
					if db.is_version_access_in_progress() = True then
						print("read only access to: ")
					else
						print("read write access to: ")
					end
					print(db.out)
					print("%N")

					if db.is_transaction_in_progress() = True then
						db.rollback()
					else
						db.end_version_access()
					end
					db.close()
				end
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


feature {NONE} -- Version Navigation

	list_versions (db: MT_DATABASE)
		local
			iter: MT_VERSION_ITERATOR
			ver : STRING
		do
			iter := db.version_iterator
			from
				iter.start
			until
				iter.exhausted
			loop
				ver := iter.item
				print("   " + ver + "%N")
				iter.forth
			end
			iter.close
		end

	version_navigation (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			vername : STRING
		do
			if impossible = False then
				print("%NTest Version Navigation Connect:%N")
				create db.make(host, dbname)
				db.open()

				db.start_transaction(db.Mt_Max_Tran_Priority)

				print("Version list before regular commit:%N")
				list_versions (db)

				db.commit ()

				db.start_transaction(db.Mt_Max_Tran_Priority)

				print("Version list after regular commit:%N")
				list_versions (db)

				vername := db.commit_and_save("Snapshot_")
				print("Commit to version named: " + vername + "%N")

				db.start_version_access(Void)
				print("Version list after named commit:%N")
				list_versions (db)

				db.end_version_access()

				db.start_version_access(vername)
				print("Sucessful access within version: " + vername + "%N")

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

feature {NONE} -- Multi-Threaded Connect

	multi_threaded_connect(host, dbname:STRING; thread_count, nb_loop: INTEGER)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			io_mutex: MUTEX
			thr_ctrl: THREAD_CONTROL
			n: INTEGER
			t: TASK
			cnx_pool: ARRAY[MT_DATABASE]
			db: MT_DATABASE
			sync_ctx: MT_SYNC_CONTEXT
		do
			if impossible = False then
				print("%NTest Multi-Threaded Connect:%N")
				create io_mutex.make
				create thr_ctrl
				create cnx_pool.make_filled (Void, 1, thread_count)
				print ("Thread count: " + thread_count.out + "%N")

				from
					n := 1
				until
					n > thread_count
				loop
					create sync_ctx.make
					create db.make_context (host, dbname, sync_ctx)
					cnx_pool.put (db, n)
					db.open ()
					create t.make (db, io_mutex, n, nb_loop)
					t.launch

					n := n + 1
				end

				t := void

				io_mutex.lock
				print("%NAll tasks launched...%N")
				io_mutex.unlock

				thr_ctrl.join_all

				print("%NAll tasks completed...%N")
				from
					n := 1
				until
					n > thread_count
				loop
					db := cnx_pool.item (n)
					if db.is_connection_open () then
						db.close ()
					end
					n := n + 1
				end
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



end -- class CONNECT_EXAMPLES
