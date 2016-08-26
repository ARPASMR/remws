note
	description: "MATISSE-Eiffel Binding: define the class to control a Matisse connection."
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
	MT_DATABASE

inherit
	ANY
		redefine
			out
		end

create
	make, make_factory, make_context, make_full

feature {NONE} -- Implementation

	hostname: STRING

	database_name: STRING

	ctx: MT_CONTEXT

	factory: MT_OBJECT_FACTORY

	-- in an ideal world it should be an array of MTOBJECT
	-- where each generated schema object has its own ID
	-- but Eiffel would need to support static method
	schema_cache: HASH_TABLE[MTOBJECT, STRING]

feature -- Initialization

	make (a_hostname, a_dbname: STRING)
		-- create a Matisse connection object to be used in a non-threaded environment
		local
			vactx: MT_ASYNC_CONTEXT
			vfactory: MT_DYNAMIC_OBJECT_FACTORY
		do
			create vactx.make ()
			create vfactory.make ()
			make_full(a_hostname, a_dbname, vfactory, vactx)
		end

	make_factory (a_hostname, a_dbname: STRING; a_factory: MT_OBJECT_FACTORY)
		-- create a Matisse connection object to be used in a non-threaded environment
		local
			vactx: MT_ASYNC_CONTEXT
		do
			create vactx.make ()
			make_full(a_hostname, a_dbname, a_factory, vactx)
		end

	make_context (a_hostname, a_dbname: STRING; a_ctx: MT_CONTEXT)
		-- create a Matisse connection object to be used in a multi-threaded
		-- or not environment
		local
			vfactory: MT_DYNAMIC_OBJECT_FACTORY
		do
			create vfactory.make ()
			make_full(a_hostname, a_dbname, vfactory, a_ctx)
		end

	make_full (a_hostname, a_dbname: STRING; a_factory: MT_OBJECT_FACTORY; a_ctx: MT_CONTEXT)
		-- create a Matisse connection object to be used in a multi-threaded
		-- or not environment with a specific object factory
		require
			arguments_exist: a_hostname /= Void and a_dbname /= Void
								  and a_factory /= Void and a_ctx /= Void
			arguments_not_empty: not (a_hostname.is_empty or a_dbname.is_empty)
		do
			hostname := a_hostname.twin
			database_name := a_dbname.twin
			factory := a_factory
			ctx := a_ctx
			-- cache & persistence mgmt
			create persister_base.make (Current)
		end


feature -- Server Execution Priority

	Mt_Min_Server_Execution_Priority: INTEGER_32 = 0
	Mt_Normal_Server_Execution_Priority: INTEGER_32 = 1
	Mt_Above_Normal_Server_Execution_Priority: INTEGER_32 = 2
	Mt_Max_Server_Execution_Priority: INTEGER_32 = 3

feature -- Transaction Priority

	Mt_Min_Tran_Priority: INTEGER_32 = 0
	Mt_Max_Tran_Priority: INTEGER_32 = 9

feature -- Wait Time

	Mt_No_Wait: INTEGER_32 = 0
	Mt_Wait_Forever: INTEGER_32 = -1

feature -- ON OFF

	Mt_On: INTEGER_32 = 1
	Mt_Off: INTEGER_32 = 0

feature -- Data Access Mode

	Mt_Data_Modification: INTEGER_32 = 0
	Mt_Data_Readonly: INTEGER_32 = 1
	Mt_Data_Definition: INTEGER_32 = 2

feature -- Locking policy

	Mt_Default_Access: INTEGER_32 = 0
	Mt_Access_For_Update: INTEGER_32 = 1

feature  -- Connection Options

	Mt_Server_Execution_Priority: INTEGER_32 = 0
	Mt_Lock_Wait_Time: INTEGER_32 = 1
	Mt_Data_Access_Mode: INTEGER_32 = 2
	Mt_Locking_Policy: INTEGER_32 = 3
	Mt_Memory_Transport: INTEGER_32 = 4
	Mt_Networktrans_Bufsz: INTEGER_32 = 5
	Mt_Memorytrans_Bufsz: INTEGER_32 = 6
	Mt_Sql_Transaction: INTEGER_32 = 7
	Mt_Transport_Type: INTEGER_32 = 8
	Mt_Schema_Namespace: INTEGER_32 = 10
	Mt_Sql_Current_Namespace: INTEGER_32 = 11

feature -- Transport type

	Mt_Net_Transport: INTEGER_32 = 20
	Mt_Mem_Transport: INTEGER_32 = 21

feature -- Lock type

	Mt_Read: INTEGER_32 = 1
	Mt_Write: INTEGER_32 = 2

feature -- Prefetching type

	Mt_Max_Prefetching: INTEGER_32 = 0
	Mt_No_Prefetching: INTEGER_32 = -1

feature -- Connection State

	Mt_Noconnection: INTEGER_32 = -1
	Mt_Inited: INTEGER_32 = 0
	Mt_Connected: INTEGER_32 = 1
	Mt_Transaction: INTEGER_32 = 2
	MT_Srv_Nocheck: INTEGER_32 = 3
	MT_Srv_Check: INTEGER_32 = 4
	MT_Commit: INTEGER_32 = 5
	Mt_Version: INTEGER_32 = 6
	MT_Stream_Read: INTEGER_32 = 7
	Mt_Version_Stream: INTEGER_32 = 8
	MT_Stream_Modif: INTEGER_32 = 9
	Mt_Transaction_Stream: INTEGER_32 = 10
	Mt_Commit_Wait: INTEGER_32 = 11

feature -- Where

	Mt_First: INTEGER_32 = 1
	Mt_After: INTEGER_32 = 2
	Mt_Append: INTEGER_32 = 3

feature -- Configuration type

	Mt_Max_Buffered_Objects: INTEGER_32 = 0
	Mt_Max_Index_Criteria_Number: INTEGER_32 = 1
	Mt_Max_Index_Key_Length: INTEGER_32 = 2

feature -- Version

	Mt_Version_Name_Max_Len: INTEGER_32 = 32


feature -- Connections

	context () : MT_CONTEXT
		-- database name
		do
			Result := ctx
		end

	name () : STRING
		-- database name
		do
			Result := database_name
		end

	host () : STRING
		-- hostname
		do
			Result := hostname
		end

	connect, open ()
			-- Connect to database.
		do
			open_as(Void, Void)
		end

	open_as(user_name, password: STRING)
			-- Connect to database with a username
		local
			c_host_name, c_database_name, c_user_name, c_password: ANY
		do
			c_host_name := hostname.to_c
			c_database_name := database_name.to_c
			if user_name = Void then
				c_user_name := Void
			else
				c_user_name := user_name.to_c
			end
			if password = Void then
				c_password := Void
			else
				c_password := password.to_c
			end
			ctx.connect_database ($c_host_name, $c_database_name, $c_user_name, $c_password)
			-- cache & persistence mgmt
			persister.connected ()
			-- schema cache
			create schema_cache.make (512)
		end

	disconnect, close ()
			-- Disconnect from database.
		do
			ctx.disconnect_database ()
			-- cache & persistence mgmt
			persister.disconnected ()
			-- schema cache
			schema_cache := Void
		end


	is_connection_open () : BOOLEAN
		-- Check if the connection is open
		local
			state: INTEGER_32
		do
			state := ctx.get_connection_state ()
			if state /= Mt_Inited then
				Result := True
			else
				Result := False
			end
		end

	last_error_msg () : STRING
		-- Get the Last error message that occurs on the connection
		do
			Result := ctx.get_last_error_msg ()
		end

	last_error_code () : INTEGER_32
		-- Get the Last error that occurs on the connection
		do
			Result := ctx.get_last_error_code ()
		end

	commit_transaction, commit ()
		-- Commit work.
		local
			vprefix, vername: STRING
		do
			vprefix := Void
			vername := commit_and_save(vprefix)
		end

	commit_and_save (a_prefix: STRING) : STRING
			-- Commit work and save a version snapshot.
		local
			c_prefix: ANY
		do
			if a_prefix = Void then
				c_prefix := Void
			else
				c_prefix := a_prefix.to_c
			end

			-- cache & persistence mgmt
			persister.flush_updated_objects ()
			-- Actually this is for MT_HASH_TABLE
			Result := ctx.commit_transaction ($c_prefix)
			-- cache & persistence mgmt
			persister.transaction_committed ()
		end

	rollback, abort_transaction ()
			-- Rollback work.
		do
			ctx.abort_transaction ()
			-- cache & persistence mgmt
			persister.transaction_aborted ()
		end


	begin, start_transaction (a_priority : INTEGER_32)
			-- Start a new transaction.
		local
			version: INTEGER_32
		do
			version := ctx.start_transaction (a_priority)
			-- cache & persistence mgmt
			persister.transaction_started (version)
		end

	is_transaction_open, is_transaction_in_progress () : BOOLEAN
			-- Check if in a transaction context.
		do
			Result := ctx.is_transaction_in_progress ()
		end

	start_version_access (version_name: STRING)
		-- Start a new version access
		local
			c_time_name: ANY
			version: INTEGER_32
		do
			if version_name /= Void then
				c_time_name := version_name.to_c
			else
				c_time_name := Void
			end
				version := ctx.start_version_access ($c_time_name)
				-- cache & persistence mgmt
				persister.version_access_started (version)
		end

	end_version_access ()
			-- Stop the current version access.
		do
			ctx.end_version_access ()
			-- cache & persistence mgmt
			persister.version_access_ended ()
		end

	is_version_access_open, is_version_access_in_progress () : BOOLEAN
			-- Check if in a version access context.
		do
			Result := ctx.is_version_access_in_progress ()
		end

	get_state () : INTEGER_32
			-- Check the state of a connection
		do
			Result := ctx.get_connection_state ()
		end

feature -- Output

	out, to_string () : STRING
		-- qualified database name
		local
			fullname: STRING
		do
			create fullname.make_from_string (database_name)
			fullname.append("@")
			fullname.append(hostname)
			Result := fullname
		end


	set_execution_priority (a_priority: INTEGER_32)
		require
			valid_priority: a_priority <= Mt_Max_Server_Execution_Priority and
						a_priority >= Mt_Min_Server_Execution_Priority
		do
			ctx.set_connection_option (Mt_Server_Execution_Priority, a_priority)
		end

	set_lock_wait_time (a_millisec: INTEGER_32)
		require
			valid_wait_time: a_millisec >= Mt_Wait_Forever
		do
			ctx.set_connection_option (Mt_Lock_Wait_Time, a_millisec)
		end

	set_data_access_mode (a_mode: INTEGER_32)
		require
			mode_type: a_mode = Mt_Data_Modification or
						a_mode = Mt_Data_Readonly or
						a_mode = Mt_Data_Definition
		do
			ctx.set_connection_option (Mt_Data_Access_Mode, a_mode)
		end

	set_locking_policy (a_mode: INTEGER_32)
		require
			valid_mode: a_mode = Mt_Default_Access or a_mode = Mt_Access_For_Update
		do

			ctx.set_connection_option (Mt_Locking_Policy, a_mode)
		end

feature  -- Status

	execution_priority (): INTEGER_32
		do
			Result := ctx.get_connection_option (Mt_Server_Execution_Priority)
		end

	lock_wait_time (): INTEGER_32
		do
			Result := ctx.get_connection_option (Mt_Lock_Wait_Time)
		end

	data_access_mode (): INTEGER_32
		do
			Result := ctx.get_connection_option (Mt_Data_Access_Mode)
		end

	locking_policy (): INTEGER_32
		do
			Result := ctx.get_connection_option (Mt_Locking_Policy)
		end

feature -- map classes

	map_class (a_eif_cls_name: STRING): STRING
		require
			nam_valid: a_eif_cls_name /= Void
		do
			Result := factory.get_database_class(a_eif_cls_name)
		end

feature -- upcast objects

	upcast (a_oid: INTEGER_32): MT_OBJECT
		require
			oid_valid: a_oid > 0
		do
			Result := factory.get_object_instance(Current, a_oid)
		end

	upcasts (oids: ARRAY[INTEGER_32]; a_res: ARRAY [MT_OBJECT])
		--  upcast objects in the correct class using the factory
		require
			array_valid: oids /= Void and a_res /= Void
		local
			i: INTEGER_32
		do
			if oids.count > 0 then
				a_res.grow (oids.count)
			end
			from
				i := oids.lower
			until
				i > oids.upper
			loop
				a_res.force ( upcast (oids.item (i)), i)
					i := i + 1
			end
		end

feature -- Persister for STORABLE

	-- manage cache and persist objects
	-- do nothing for PROXI
   persister_base: MT_PERSISTER_BASE

	persister (): MT_PERSISTER_BASE
		do
			Result := persister_base
		end

feature  -- Implementation Schema Object Cache

	-- the 'get_cached' 'set_cached' functions are not ideal since 
	-- multiple threads may try to insert the same object the first time
	-- need to move the whole get_mt<schema> function into context
	-- to keep the lock in case of adding a new object

feature	-- Get a MtNamespace

	get_mtnamespace (a_ns_name: STRING): MTNAMESPACE
			-- create a Namespace descriptor object from name
		require
			not_void: a_ns_name /= Void
			not_empty: not a_ns_name.is_empty
		local
			v_mtnsnam: STRING
			vns: MTNAMESPACE
		do
            v_mtnsnam := map_class(a_ns_name)
			vns ?= ctx.get_cached (schema_cache, v_mtnsnam)
			if vns = Void then
				create vns.make_from_mtname (Current, v_mtnsnam)
				ctx.set_cached (schema_cache, v_mtnsnam, vns)
			end
			Result := vns
		end

feature	-- Get a MtClass

	get_mtclass (a_class_name: STRING): MTCLASS
			-- create a class descriptor object from name
		require
			not_void: a_class_name /= Void
			not_empty: not a_class_name.is_empty
		local
			v_mtclsnam: STRING
			vcls: MTCLASS
		do
            v_mtclsnam := map_class(a_class_name)
			vcls ?= ctx.get_cached (schema_cache, v_mtclsnam)
			if vcls = Void then
				create vcls.make_from_mtname (Current, v_mtclsnam)
				ctx.set_cached (schema_cache, v_mtclsnam, vcls)
			end
			Result := vcls
		end

feature	-- Get a MtAttribute

	get_mtattribute (a_att_name: STRING; a_mtcls: MTCLASS): MTATTRIBUTE
			-- create an attribute descriptor object from a name and class
		require
			not_void: a_att_name /= Void and a_mtcls /= Void
			not_empty: not a_att_name.is_empty
		local
			vatt: MTATTRIBUTE
			schname: STRING
		do
			schname := a_mtcls.oid.out + a_att_name
			vatt ?= ctx.get_cached (schema_cache, schname)
			if vatt = Void then
				create vatt.make_from_mtname (Current, a_att_name, a_mtcls)
				ctx.set_cached (schema_cache, schname, vatt)
			end
			Result := vatt
		end

feature	-- Get a MtRelationship

	get_mtrelationship (a_rel_name: STRING; a_mtcls: MTCLASS): MTRELATIONSHIP
			-- create a relationship descriptor object from a name and class
		require
			not_void: a_rel_name /= Void and a_mtcls /= Void
			not_empty: not a_rel_name.is_empty
		local
			vrel: MTRELATIONSHIP
			schname: STRING
		do
			schname := a_mtcls.oid.out + a_rel_name
			vrel ?= ctx.get_cached (schema_cache, schname)
			if vrel = Void then
				create vrel.make_from_mtname (Current, a_rel_name, a_mtcls)
				ctx.set_cached (schema_cache, schname, vrel)
			end
			Result := vrel
		end

feature	-- Get a MtIndex

	get_mtindex (an_index_name: STRING): MTINDEX
			-- create an index descriptor object from name
		require
			not_void: an_index_name /= Void
			not_empty: not an_index_name.is_empty
		local
			vidx: MTINDEX
			schname: STRING
			v_idxnam: STRING
		do
            v_idxnam := map_class(an_index_name)
			schname := "idx" + v_idxnam
			vidx ?= ctx.get_cached (schema_cache, schname)
			if vidx = Void then
				create vidx.make_from_mtname (Current, v_idxnam)
				ctx.set_cached (schema_cache, schname, vidx)
			end
			Result := vidx
		end

feature -- Get a MtEntryPointDictionary

	get_mtentrypointdictionary (ep_dict_name: STRING): MTENTRYPOINTDICTIONARY
			-- create an entry point dictionary descriptor object from name
		require
			not_void: ep_dict_name /= Void
			not_empty: not ep_dict_name.is_empty
		local
			vepd: MTENTRYPOINTDICTIONARY
			schname: STRING
			v_epdnam: STRING
		do
            v_epdnam := map_class(ep_dict_name)
			schname := "epd" + v_epdnam
			vepd ?= ctx.get_cached (schema_cache, schname)
			if vepd = Void then
				create vepd.make_from_mtname (Current, v_epdnam)
				ctx.set_cached (schema_cache, schname, vepd)
			end
			Result := vepd
		end

feature -- SQL

	create_statement (): MT_STATEMENT
		do
			create Result.make (Current)
		end

	prepare_statement (cmd_text: STRING): MT_PREPARED_STATEMENT
		require
			not_void: cmd_text /= Void
			not_empty: not cmd_text.is_empty
		do
			create Result.make (Current)
			Result.set_command (cmd_text)
		end

	prepare_call (method_call: STRING): MT_CALLABLE_STATEMENT
		require
			not_void: method_call /= Void
			not_empty: not method_call.is_empty
		do
			create Result.make (Current)
			Result.set_command (method_call)
		end

feature -- Versions

	version_iterator (): MT_VERSION_ITERATOR
		-- Creates an iterator on a saved version name.
		-- The iterator will list all the saved version names available.
		local
			c_stream : INTEGER_32
		do
			c_stream := ctx.open_version_stream ()
			create Result.make(c_stream, Current)
		end

feature -- Create Objects

    preallocate (num: INTEGER_32): INTEGER_32
      -- preallocate object OIDs to speed up creation
    	do
    		Result := ctx.preallocate_objects(num)
    	end

    num_preallocated (): INTEGER_32
      -- return the number of preallocated objects
    	do
    		Result := ctx.num_preallocated_objects ()
    	end

feature -- Information specific to a Connection

	max_buffered_objects: INTEGER_32
		-- The maximum number of objects that can be ba carried to the
		-- server in a single call
		do
			Result := ctx.max_buffered_objects ()
		end

    max_index_criteria_number: INTEGER_32
      -- The maximum number of criteria that can define an index.
    	do
   		     Result := ctx.max_index_criteria_number ()
		end

	max_index_key_length: INTEGER_32
		-- The maximum size of an index key to be returned.
		do
    		    Result := ctx.max_index_key_length ()
		end

	total_read_bytes: INTEGER_32
		-- Number of bytes read since beginning of transaction.
		do
			Result := ctx.get_num_data_bytes_received ()
		end

	total_write_bytes: INTEGER_32
		-- Number of bytes written since beginning of transaction.
		do
			Result := ctx.get_num_data_bytes_sent ()
		end

feature -- Using Namespaces

	set_schema_namespace (a_ns: STRING)
        -- Changes the connection Schema Namespace restricting the visible schema objects to this namespace.
        -- A null string sets the Schema Namespace to the root namespace.
		local
			c_ns: ANY
		do
			if a_ns = Void then
				c_ns := Void
			else
				c_ns := a_ns.to_c
			end

			ctx.set_string_connection_option (Mt_Schema_Namespace, $c_ns)
		end

	get_schema_namespace () : STRING
        -- Retrieves the connection Schema Namespace.
		do
			Result := ctx.get_string_connection_option (Mt_Schema_Namespace)
		end

	set_sql_current_namespace (a_ns: STRING)
        -- Changes the SQL session current Namespace eliminating the need to type full qualified class names.
        -- A null or empty string sets the current Namespace to the root namespace.
		local
			c_ns: ANY
		do
			if a_ns = Void then
				c_ns := Void
			else
				c_ns := a_ns.to_c
			end

			ctx.set_string_connection_option (Mt_Sql_Current_Namespace, $c_ns)
		end

	get_sql_current_namespace () : STRING
        -- Retrieves the SQL session current Namespace.
		do
			Result := ctx.get_string_connection_option (Mt_Sql_Current_Namespace)
		end

end -- class MT_DARABASE
