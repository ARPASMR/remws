indexing

	description:

		"Hello world example for Berkeley DB wrapper"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/06/28 23:49:32 $"
	revision: "$Revision: 1.8 $"

class BDB_HELLO_WORLD

inherit

	KL_SHARED_EXCEPTIONS
		export
			{NONE} all
		end

	DB_UNPORTABLE_FUNCTIONS
		export
			{NONE} all
		end

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export
			{NONE} all
		end

	EWG_BDB_CALLBACK_C_GLUE_CODE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	
creation

	make
	
feature

	make is
		local
			p: POINTER
			i: INTEGER
			c_string: EWG_ZERO_TERMINATED_STRING
			mp: EWG_MANAGED_POINTER
			dbp: DB_STRUCT
			key: DBT
			data: DBT
		do
				-- Query the BDB Version
			p := db_version_external (Default_pointer, Default_pointer, Default_pointer)

			create c_string.make_unshared (p)
			print ("Berkely DB Version: " + c_string.string + "%N")

				-- Create DB
				-- Allocate some memory to store the db handle in
			create mp.make_new_unshared (EXTERNAL_MEMORY_.sizeof_pointer_external)
			i := db_create_external (mp.item, Default_pointer, 0)
			if i /= 0 then
				create c_string.make_shared (db_strerror_external (i))
				print ("db_create: " + c_string.string + "%N")
				Exceptions.die (1)
			end
				-- Create wrapper out of handle to db
			create dbp.make_shared (mp.read_pointer (0))
			
				-- Open DB
				-- Use struct function pointer memeber to open db
			create c_string.make_unshared_from_string (Db_name)
			i := call_ewg_db_open_external
			(dbp.open, dbp.item, Default_pointer, c_string.item, Default_pointer, Db_btree, Db_create, Db_open_mode)
			if i /= 0 then
				print ("Error opening the database%N")
			end

				-- Create a key/value pair
			create key.make_new_unshared
			key.fill_with_zeros
			key.set_string ("fruit")
			create data.make_new_unshared
			data.fill_with_zeros
			data.set_string ("apple")

				-- Store the key/value pair in out DB
			i := call_ewg_db_put_or_get_external (dbp.put, dbp.item, Default_pointer, key.item, data.item, 0)
			if i = 0 then
				print ("db: key stored%N")
			else
				print ("Error storing key in DB%N")
			end

				-- Let's zero of `data', so we proove we get something new
			data.fill_with_zeros
				-- Retrieve the key
			i := call_ewg_db_put_or_get_external (dbp.get, dbp.item, Default_pointer, key.item, data.item, 0)
			if i = 0 then
				print ("for key '" + key.string + "'%N")
				print ("got data: '" + data.string + "'%N")
			else
				print ("Error retrieving data from DB%N")
			end
		end

feature
	
	Db_open_mode: INTEGER is 436

	Db_name: STRING is "database.db"

feature {NONE} -- macro constants (not yet generated)

	Db_btree: INTEGER is 1

	Db_create: INTEGER is 1

end
