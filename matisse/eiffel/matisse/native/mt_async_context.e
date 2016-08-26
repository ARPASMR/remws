note
	description: "Asynchronous Context class for the binding"
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
	MT_ASYNC_CONTEXT

inherit
	MT_CONTEXT

	MEMORY
		redefine
			dispose
		end

create
	make

feature -- Initialization

	make
			-- Initialization for `Current'.
		do
		    mt_context := c_allocate_connection
		end


feature {NONE} -- Implementation
	mt_context: INTEGER_64

	dispose
		-- Redefinition of dispose of MEMORY.
		-- Free space allocated for MtContext.
		do
			-- CANNOT raise an exception
			-- MUST fulfill its contract
			c_free_connection (mt_context)
		end

feature  -- Implementation Schema Object Cache

	get_cached (a_schema_cache: HASH_TABLE[MTOBJECT, STRING]; a_sch_name : STRING) : MTOBJECT
		do
			a_schema_cache.search (a_sch_name)
			if a_schema_cache.found then
				Result := a_schema_cache.found_item
			end
		end

	set_cached (a_schema_cache: HASH_TABLE[MTOBJECT, STRING]; a_sch_name: STRING; sch_obj: MTOBJECT)
		do
			a_schema_cache.extend (sch_obj, a_sch_name)
		end

feature  -- Implementation MATISSE C API

	get_oids_of_classes (num: INTEGER_32; buf: POINTER)
		do
			c_get_oids_of_classes (mt_context, num, buf)
		end

   get_classes_count (): INTEGER_32
		do
			Result := c_get_classes_count (mt_context)
		end

feature  -- Implementation MTATTRIBUTE

   get_attribute (name: POINTER): INTEGER_32
		do
			Result := c_get_attribute (mt_context, name)
		end

   get_attribute_from_names (name, class_name: POINTER): INTEGER_32
		do
			Result := c_get_attribute_from_names (mt_context, name, class_name)
		end


   get_class_attribute (name: POINTER; cls_oid: INTEGER_32): INTEGER_32
		do
			Result := c_get_class_attribute (mt_context, name, cls_oid)
		end

   check_attribute (aid, oid: INTEGER_32)
		do
			c_check_attribute (mt_context, aid, oid)
		end

   get_dimension (oid, aid, rank: INTEGER_32): INTEGER_32
		do
			Result := c_get_dimension (mt_context, oid, aid, rank)
		end

   is_default_value (oid, aid: INTEGER_32): BOOLEAN
		do
			Result := c_is_default_value (mt_context, oid, aid)
		end

   get_value_type (oid, aid: INTEGER_32): INTEGER_32
		do
			Result := c_get_value_type (mt_context, oid, aid)
		end

	-- MT_BYTE --
   get_byte_value (oid, aid: INTEGER_32): NATURAL_8
		do
			Result := c_get_byte_value (mt_context, oid,aid)
		end

   get_byte_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_byte_array (mt_context, oid, aid, size, buffer)
		end

   -- MT_LONG --
   get_integer_64_value (oid, aid: INTEGER_32): INTEGER_64
      do
			Result := c_get_integer_64_value (mt_context, oid, aid)
      end

   get_integer_64_array (oid, aid, size: INTEGER_32; buffer: POINTER)
      do
			c_get_integer_64_array (mt_context, oid, aid, size, buffer)
      end

	-- MT_INTEGER_32 --
   get_integer_value (oid, aid: INTEGER_32): INTEGER_32
		do
			Result := c_get_integer_value (mt_context, oid, aid)
		end

   get_integer_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_integer_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_SHORT --
   get_short_value (oid, aid: INTEGER_32): INTEGER_16
		do
			Result := c_get_short_value (mt_context, oid, aid)
		end

   get_short_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_short_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_NUMERIC --
   get_numeric_value (oid, aid: INTEGER_32; ptr_array: POINTER)
    do
      c_mt_get_numeric_value (mt_context, oid, aid, ptr_array)
    end

   get_numeric_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_numeric_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_DOUBLE --
   get_double_value(oid, aid: INTEGER_32): DOUBLE
		do
			Result := c_get_double_value (mt_context, oid, aid)
		end

   get_double_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_double_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_FLOAT --
   get_real_value (oid, aid: INTEGER_32): REAL
		do
			Result := c_get_real_value (mt_context, oid, aid)
		end

   get_real_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_real_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_CHAR --
   get_char_value (oid, aid: INTEGER_32): CHARACTER
		do
			Result := c_get_char_value (mt_context, oid, aid)
		end

	-- MT_STRING --
   get_string_value (oid, aid: INTEGER_32): STRING
		do
			Result := c_get_string_value (mt_context, oid, aid)
		end

   get_string_array (oid, aid, size: INTEGER_32; buffer: ANY)
		do
			c_get_string_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_BOOLEAN --
   get_boolean_value (oid, aid: INTEGER_32): BOOLEAN
		do
			Result := c_get_boolean_value (mt_context, oid, aid)
		end

   get_boolean_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_boolean_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_DATE --
   get_date_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_date_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_TIMESTAMP --
   get_timestamp_value (oid, aid: INTEGER_32; yr, mh, dy, hr, me, sd, msd: POINTER)
		do
			c_get_timestamp_value (mt_context, oid, aid, yr, mh, dy, hr, me, sd, msd)
		end

   get_timestamp_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_get_timestamp_array (mt_context, oid, aid, size, buffer)
		end

	-- MT_INTERVAL --
   get_interval_value(oid, aid: INTEGER_32) : INTEGER_64
		do
			Result := c_get_interval_value (mt_context, oid, aid)
		end

	get_interval_array (oid, aid, count: INTEGER_32; buf_interval_milisec: POINTER)
		do
			c_get_interval_array (mt_context, oid, aid, count, buf_interval_milisec)
		end

	--	
	-- Setting values
	--

   set_value_integer_64 (oid, aid, type: INTEGER_32; value: INTEGER_64; rank: INTEGER_32)
		do
			c_set_value_integer_64 (mt_context, oid, aid, type, value, rank)
		end

   set_value_integer (oid, aid, type, value, rank: INTEGER_32)
		do
			c_set_value_integer (mt_context, oid, aid, type, value, rank)
		end

   set_value_u8 (oid, aid, value: INTEGER_32)
		do
			c_set_value_u8 (mt_context, oid, aid, value)
		end

   set_value_s16 (oid, aid, value: INTEGER_32)
		do
			c_set_value_s16 (mt_context, oid, aid, value)
		end

   mt_set_value_numeric (oid, aid: INTEGER_32; item1, item2, item3, item4, item5, item6: INTEGER_32)
		do
			c_mt_set_value_numeric (mt_context, oid, aid, item1, item2, item3, item4, item5, item6)
		end

   mt_set_value_numeric_list (oid, aid: INTEGER_32; value: POINTER; numElem: INTEGER_32)
		do
			c_mt_set_value_numeric_list (mt_context, oid, aid, value, numElem)
		end

   set_value_double (oid, aid, type: INTEGER_32; value: DOUBLE; rank: INTEGER_32)
		do
			c_set_value_double (mt_context, oid, aid, type, value, rank)
		end

   set_value_real (oid, aid, type: INTEGER_32; value: REAL)
		do
			c_set_value_real (mt_context, oid, aid, type, value)
		end

   set_value_char (oid, aid, type: INTEGER_32; value: CHARACTER; rank: INTEGER_32)
		do
			c_set_value_char (mt_context, oid, aid, type, value, rank)
		end

   set_value_boolean (oid, aid: INTEGER_32; value: BOOLEAN)
		do
			c_set_value_boolean (mt_context, oid, aid, value)
		end

   set_value_boolean_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			c_set_value_boolean_array (mt_context, oid, aid, size, buffer)
		end

   set_value_date (oid, aid: INTEGER_32; year, month, day: INTEGER_32)
		do
			c_set_value_date (mt_context, oid, aid, year, month, day)
		end

   set_value_date_array (oid, aid, size: INTEGER_32; years, months, days: POINTER)
		do
			c_set_value_date_array (mt_context, oid, aid, size, years, months, days)
		end

   set_value_timestamp (oid, aid, year, month, day, hour, minute, second, microsec: INTEGER_32)
		do
			c_set_value_timestamp (mt_context, oid, aid, year, month, day, hour, minute, second, microsec)
		end

   set_value_timestamp_array (oid, aid, count: INTEGER_32; years, months, days, hours, minutes, seconds, microsecs: POINTER)
		do
			c_set_value_timestamp_array (mt_context, oid, aid, count, years, months, days, hours, minutes, seconds, microsecs)
		end

   set_value_time_interval (oid, aid: INTEGER_32; interval_milisec: INTEGER_64)
		do
			c_set_value_time_interval (mt_context, oid, aid, interval_milisec)
		end

   set_value_time_interval_array (oid, aid, count: INTEGER_32; interval_milisec: POINTER)
		do
			c_set_value_time_interval_array (mt_context, oid, aid, count, interval_milisec)
		end

   set_value_string (oid, aid, type: INTEGER_32; value: POINTER; encoding: INTEGER_32)
		do
			c_set_value_string (mt_context, oid, aid, type, value, encoding)
		end

   set_value_array_numeric (oid, aid, type: INTEGER_32; value: POINTER; rank, num: INTEGER_32)
		do
			c_set_value_array_numeric (mt_context, oid, aid, type, value, rank, num)
		end

   set_value_short_array (oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32)
		do
			c_set_value_short_array (mt_context, oid, aid, type, value, rank)
		end

   set_value_void (oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32)
		do
			c_set_value_void (mt_context, oid, aid, type, value, rank)
		end

   get_attribute_type (aid: INTEGER_32): INTEGER_32
		do
			Result := c_get_attribute_type (mt_context, aid)
		end

   set_value_byte_list_elements (oid, aid, type: INTEGER_32; buffer: POINTER;
			count, offset: INTEGER_32; discard_after: BOOLEAN)
		do
			c_set_value_byte_list_elements (mt_context, oid, aid, type, buffer, count, offset, discard_after)
		end

   get_byte_list_elements (oid, aid: INTEGER_32; buffer: POINTER; count, offset: INTEGER_32): INTEGER_32
		do
			Result := c_get_byte_list_elements (mt_context, oid, aid, buffer, count, offset)
		end

feature -- Implementation MT_CALLABLE_STATEMENT

   sql_get_param_boolean (stmt_offset, param_idx : INTEGER_32) : BOOLEAN
			-- Get the boolean param return value (MT_BOOLEAN)
		do
			Result := c_mt_sql_get_param_boolean (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_byte (stmt_offset, param_idx : INTEGER_32) : INTEGER_8
			-- Get the byte param return value (MT_BYTE)
		do
			Result := c_mt_sql_get_param_byte (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_char (stmt_offset, param_idx : INTEGER_32) : CHARACTER
			-- Get the char param return value (MT_CHAR)
		do
			Result := c_mt_sql_get_param_char (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_double (stmt_offset, param_idx : INTEGER_32) : DOUBLE
			-- Get the double param return value (MT_DOUBLE)
		do
			Result := c_mt_sql_get_param_double (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_float (stmt_offset, param_idx : INTEGER_32) : REAL
			-- Get the float param return value (MT_FLOAT)
		do
			Result := c_mt_sql_get_param_float (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_integer (stmt_offset, param_idx : INTEGER_32) : INTEGER_32
			-- Get the integer param return value (MT_INTEGER)
		do
			Result := c_mt_sql_get_param_integer (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_interval (stmt_offset, param_idx : INTEGER_32; c_array1, c_array2 : POINTER) : BOOLEAN
			-- Get the interval param return value (MT_INTERVAL)
		do
			Result := c_mt_sql_get_param_interval (mt_context, stmt_offset, param_idx, c_array1, c_array2)
		end

   sql_get_param_interval_days_fsecs(stmt_offset, param_idx : INTEGER_32; days, fsecs, negative: POINTER) : BOOLEAN
			-- Get the interval param return value (MT_INTERVAL)
		do
			Result := c_mt_sql_get_param_interval_days_fsecs (mt_context, stmt_offset, param_idx, days, fsecs, negative)
		end

   sql_get_param_long (stmt_offset, param_idx : INTEGER_32) : INTEGER_64
			-- Get the long param return value (MT_LONG)
		do
			Result := c_mt_sql_get_param_long (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_numeric (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the interval param return value (MT_NUMERIC)
		do
			Result := c_mt_sql_get_param_numeric (mt_context, stmt_offset, param_idx, c_array)
		end

   sql_get_param_short (stmt_offset, param_idx : INTEGER_32) : INTEGER_16
			-- Get the short param return value (MT_SHORT)
		do
			Result := c_mt_sql_get_param_short (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_date (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the date param return value (MT_DATE)
		do
			Result := c_mt_sql_get_param_date (mt_context, stmt_offset, param_idx, c_array)
		end

   sql_get_param_timestamp (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the timestamp param return value (MT_TIMESTAMP)
		do
			Result := c_mt_sql_get_param_timestamp (mt_context, stmt_offset, param_idx, c_array)
		end

   sql_get_param_bytes (stmt_offset, param_idx : INTEGER_32; sz, c_array : POINTER) : BOOLEAN
			-- Get the bytes param return value (MT_BYTES, MT_AUDIO, MT_IMAGE, MT_VIDEO)
		do
			Result := c_mt_sql_get_param_bytes (mt_context, stmt_offset, param_idx, sz, c_array)
		end

   sql_get_param_text (stmt_offset, param_idx : INTEGER_32) : STRING
			-- Get the text param return value (MT_TEXT)
		do
			Result := c_mt_sql_get_param_text (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_string (stmt_offset, param_idx : INTEGER_32) : STRING
			-- Get the string param return value (MT_STRING)
		do
			Result := c_mt_sql_get_param_string (mt_context, stmt_offset, param_idx)
		end

   sql_get_param_size(stmt_offset, param_idx : INTEGER_32; size: POINTER) : INTEGER_32
			-- Get the result param size (All types)
		do
			Result := c_mt_sql_get_param_size (mt_context, stmt_offset, param_idx, size)
		end

feature -- Implementation MTNAMESPACE

   get_namespace (name: POINTER): INTEGER_32
		do
			Result := c_get_namespace (mt_context, name)
		end

   get_schema_object_full_name (oid: INTEGER_32): STRING
		do
			Result := c_get_schema_object_full_name (mt_context, oid)
		end

feature -- Implementation MT_CLASS

   get_class_from_name (name: POINTER): INTEGER_32
		do
			Result := c_get_class_from_name (mt_context, name)
		end

   get_object_class (oid: INTEGER_32): INTEGER_32
		do
			Result := c_get_object_class (mt_context, oid)
		end

   get_attributes_count (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_attributes_count (mt_context, cid)
		end

   get_all_attributes (cid, num: INTEGER_32; buf: POINTER)
		do
			c_get_all_attributes (mt_context, cid, num, buf)
		end

   get_relationships_count (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_relationships_count (mt_context, cid)
		end

   get_all_relationships (cid, num: INTEGER_32; buf: POINTER)
		do
			c_get_all_relationships (mt_context, cid, num, buf)
		end

   get_inverse_relationships_count (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_inverse_relationships_count (mt_context, cid)
		end

   get_all_inverse_relationships (cid, num: INTEGER_32; buf: POINTER)
		do
			c_get_all_inverse_relationships (mt_context, cid, num, buf)
		end

   get_subclasses_count (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_subclasses_count (mt_context, cid)
		end

   get_all_subclasses (cid, num: INTEGER_32; buf: POINTER)
		do
			c_get_all_subclasses (mt_context, cid, num, buf)
		end

   get_superclasses_count (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_superclasses_count (mt_context, cid)
		end

   get_all_superclasses (cid, num: INTEGER_32; buf: POINTER)
		do
			c_get_all_superclasses (mt_context, cid, num, buf)
		end

   get_methods_count (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_methods_count (mt_context, cid)
		end

   get_all_methods (cid, num: INTEGER_32; buf: POINTER)
		do
			c_get_all_methods (mt_context, cid, num, buf)
		end

   get_instances_number (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_instances_number (mt_context, cid)
		end

   get_own_instances_number (cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_own_instances_number (mt_context, cid)
		end

   get_class_property_from_name (name: POINTER; oid: INTEGER_32): INTEGER_32
		do
			Result := c_get_class_property_from_name (mt_context, name, oid)
		end

feature -- Class Stream

   open_instances_stream (cid, num_preftech: INTEGER_32): INTEGER_32
		do
			Result := c_open_instances_stream (mt_context, cid, num_preftech)
		end

   open_own_instances_stream (cid, num_preftech: INTEGER_32): INTEGER_32
		do
			Result := c_open_own_instances_stream (mt_context, cid, num_preftech)
		end

feature -- Version Stream

   open_version_stream (): INTEGER_32
		do
			Result := c_open_version_stream (mt_context)
		end

feature  -- Create Object

	create_object (name: POINTER): INTEGER_32
		do
			Result := c_create_object (mt_context, name)
		end

feature -- Database options

   get_last_error_msg () : STRING
		do
			Result := c_get_last_error_msg (mt_context)
		end

   get_last_error_code () : INTEGER_32
		do
			Result := c_get_last_error_code (mt_context)
		end

   get_connection_option (option: INTEGER_32): INTEGER_32
		do
			Result := c_get_connection_option (mt_context, option)
		end

   set_connection_option (option, value: INTEGER_32)
		do
			c_set_connection_option (mt_context, option, value)
		end


   get_string_connection_option (option: INTEGER_32): STRING
		do
			Result := c_get_string_connection_option (mt_context, option)
		end

   set_string_connection_option (option: INTEGER_32; value: POINTER)
		do
			c_set_string_connection_option (mt_context, option, value)
		end

   connect_database (host, db, user, passwd: POINTER)
		do
			c_connect_database (mt_context, host, db, user, passwd)
		end

   disconnect_database ()
		do
			c_disconnect_database (mt_context)
		end

   get_connection_state (): INTEGER_32
		do
			Result := c_get_connection_state (mt_context)
		end

   start_transaction (priority: INTEGER_32): INTEGER_32
			-- Return the version number.
		do
			Result := c_start_transaction (mt_context, priority)
		end

   commit_transaction (a_prefix: POINTER): STRING
		do
			Result := c_commit_transaction (mt_context, a_prefix)
		end

   abort_transaction ()
		do
			c_abort_transaction (mt_context)
		end

   is_transaction_in_progress () : BOOLEAN
		do
			Result := c_is_transaction_in_progress (mt_context)
		end

   start_version_access (time_name: POINTER): INTEGER_32
			-- Return the version number accessed.
		do
			Result := c_start_version_access (mt_context, time_name)
		end

   end_version_access ()
		do
			c_end_version_access (mt_context)
		end

   is_version_access_in_progress () : BOOLEAN
		do
			Result := c_is_version_access_in_progress (mt_context)
		end


	preallocate_objects (num: INTEGER_32): INTEGER_32
		do
			Result := c_preallocate_objects (mt_context, num)
		end

	num_preallocated_objects (): INTEGER_32
		do
			Result := c_num_preallocated_objects (mt_context)
		end

   get_invalid_object (): INTEGER_32
		do
			Result := c_get_invalid_object (mt_context)
		end

feature  -- Implementation MTENTRYPOINTDICTIONARY

   get_entry_point_dictionary (dict_name: POINTER): INTEGER_32
		-- Get oid of ep dictionary
		do
			Result := c_get_entry_point_dictionary (mt_context, dict_name)
		end


   get_object_from_entry_point (ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_object_from_entry_point (mt_context, ep_name, dict_id, cid)
		end

   get_object_number_from_entry_point (ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32
		do
			Result := c_get_object_number_from_entry_point (mt_context, ep_name, dict_id, cid)
		end

   get_objects_from_entry_point (dict_id, cid: INTEGER_32; ep_name: POINTER): ARRAY[INTEGER_32]
		do
			Result := c_get_objects_from_entry_point (mt_context, dict_id, cid, ep_name)
		end

   lock_objects_from_entry_point (lock: INTEGER_32; c_ep_name: POINTER; aid, cid: INTEGER_32)
		do
			c_lock_objects_from_entry_point (mt_context, lock, c_ep_name, aid, cid)
		end

feature  -- Entrypoint Stream

   open_entry_point_stream (name: POINTER; ep_id, cid, nb_obj_per_call: INTEGER_32): INTEGER_32
		do
			Result := c_open_entry_point_stream (mt_context, name, ep_id, cid, nb_obj_per_call)
		end

feature  -- Implementation MTINDEX

   get_index (index_name: POINTER): INTEGER_32
		do
			Result := c_get_index (mt_context, index_name)
		end

   index_entries_count (iid: INTEGER_32): INTEGER_32
		do
			Result := c_index_entries_count (mt_context, iid)
		end

   load_index_info (iid: INTEGER_32; num_classes, crit_class_oids, num_criteria, attrs, types, sizes, orders: POINTER)
		do
			c_load_index_info (mt_context, iid, num_classes, crit_class_oids, num_criteria, attrs, types, sizes, orders)
		end

   index_lookup (index_oid, class_oid, criteria_count: INTEGER_32; crit_start_array: POINTER): INTEGER_32
		do
			Result := c_index_lookup (mt_context, index_oid, class_oid, criteria_count, crit_start_array)
		end

   index_lookup_object (index_oid, class_oid, criteria_count: INTEGER_32; crit_array: POINTER): INTEGER_32
		do
			Result := c_index_lookup_object (mt_context, index_oid, class_oid, criteria_count, crit_array)
		end

   index_object_number (index_oid, class_oid, criteria_count: INTEGER_32; crit_array: POINTER): INTEGER_32
		do
			Result := c_index_object_number (mt_context, index_oid, class_oid, criteria_count, crit_array)
		end

feature  -- Index Stream

   open_index_entries_stream_by_name(index_name, class_name: POINTER; direction: INTEGER_32;
	                                  c_cit_start_array, c_crit_end_array: POINTER;
	                                  nb_obj_per_call: INTEGER_32): INTEGER_32
		do
			Result := c_open_index_entries_stream_by_name (mt_context, index_name, class_name, direction, c_cit_start_array, c_crit_end_array, nb_obj_per_call)
		end

   open_index_entries_stream(index_oid, class_oid, direction, count: INTEGER_32;
	                          c_cit_start_array, c_crit_end_array: POINTER; nb_obj_per_call: INTEGER_32): INTEGER_32
		do
			Result := c_open_index_entries_stream (mt_context, index_oid, class_oid, direction, count, c_cit_start_array, c_crit_end_array, nb_obj_per_call)
		end

   open_index_object_stream(index_oid, class_oid, direction, seg_count: INTEGER_32;
	                         start_key, end_key: POINTER; num_preftech: INTEGER_32): INTEGER_32
		do
			Result := c_open_index_object_stream (mt_context, index_oid, class_oid,
	                                            direction, seg_count, start_key,
	                                            end_key, num_preftech)
		end

feature  -- Implementation MT_INFO

   max_buffered_objects (): INTEGER_32
		do
			Result := c_max_buffered_objects (mt_context)
		end

   max_index_criteria_number (): INTEGER_32
		do
			Result := c_max_index_criteria_number (mt_context)
		end

   max_index_key_length (): INTEGER_32
		do
			Result := c_max_index_key_length (mt_context)
		end

   get_num_data_bytes_received (): INTEGER_32
		do
			Result := c_get_num_data_bytes_received (mt_context)
		end

   get_num_data_bytes_sent (): INTEGER_32
		do
			Result := c_get_num_data_bytes_sent (mt_context)
		end

feature -- Irelationship Stream

   open_predecessors_stream (oid, rid: INTEGER_32): INTEGER_32
		do
			Result := c_open_predecessors_stream (mt_context, oid, rid)
		end

feature -- Object Name

   object_mt_name (oid: INTEGER_32): STRING
			-- Get a string of attribute "MtName" for the object oid.
		do
			Result := c_object_mt_name (mt_context, oid)
		end

feature -- Object Attribute Stream

   open_attributes_stream (sid: INTEGER_32): INTEGER_32
		do
			Result := c_open_attributes_stream (mt_context, sid)
		end

feature -- Object Creation

   dynamic_create_storable_eif_object (mt_handle: INTEGER_32): MT_OBJECT
		do
			Result := c_dynamic_create_storable_eif_object (mt_context, mt_handle)
		end

   dynamic_create_proxi_eif_object (mt_handle: INTEGER_32): MTOBJECT
		do
			Result := c_dynamic_create_proxi_eif_object (mt_context, mt_handle)
		end

   create_empty_rs_container (name: POINTER; pred_oid, rel_oid: INTEGER_32): ANY
		do
			Result := c_create_empty_rs_container (mt_context, name, pred_oid, rel_oid)
		end

   create_object_from_cid (class_oid: INTEGER_32) : INTEGER_32
			-- Create new MATISSE object using MtCreateObject ().
			-- Return new oid.
		do
			Result := c_create_object_from_cid (mt_context, class_oid)
		end

feature -- Implementation MT_OBJECT

   is_predefined_object (oid: INTEGER_32): BOOLEAN
		do
			Result := c_is_predefined_object (mt_context, oid)
		end

   check_object(oid: INTEGER_32)
		do
			c_check_object (mt_context, oid)
		end

   remove_object (oid: INTEGER_32)
		do
			c_remove_object (mt_context, oid)
		end

   remove_value (oid, aid: INTEGER_32)
		do
			c_remove_value (mt_context, oid, aid)
		end

   remove_successor (oid, rid, sid: INTEGER_32)
		do
			c_remove_successor (mt_context, oid, rid, sid)
		end

   remove_all_successors (oid, rid: INTEGER_32)
		do
			c_remove_all_successors (mt_context, oid, rid)
		end


   clear_all_successors (oid, rid: INTEGER_32)
		do
			c_clear_all_successors (mt_context, oid, rid)
		end

   remove_successor_ignore_nosuchsucc (pred_oid, rid, succ_oid: INTEGER_32)
		do
			c_remove_successor_ignore_nosuchsucc (mt_context, pred_oid, rid, succ_oid)
		end

   remove_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER)
		do
			c_remove_successors (mt_context, oid, rid, num, succ_oids)
		end

   object_size (oid: INTEGER_32): INTEGER_32
		do
			Result := c_object_size (mt_context, oid)
		end

   print_to_file (oid: INTEGER_32;file_pointer: POINTER)
		do
			c_print_to_file (mt_context, oid, file_pointer)
		end

   is_instance_of (oid, cid: INTEGER_32): BOOLEAN
		do
			Result := c_is_instance_of (mt_context, oid, cid)
		end

   get_added_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			Result := c_get_added_successors (mt_context, oid, rid)
		end

   get_removed_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			Result := c_get_removed_successors (mt_context, oid, rid)
		end

   get_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			Result := c_get_successors (mt_context, oid, rid)
		end

   get_successor_size (oid, rid: INTEGER_32): INTEGER_32
		do
			Result := c_get_successor_size (mt_context, oid, rid)
		end

   get_predecessors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			Result := c_get_predecessors (mt_context, oid, rid)
		end

	get_predecessors_by_name (oid: INTEGER_32; rshp_name: POINTER): ARRAY[INTEGER_32]
		do
			Result := c_get_predecessors_by_name (mt_context, oid, rshp_name)
		end

   free_object (oid: INTEGER_32)
		do
			c_free_object (mt_context, oid)
		end

   add_successor_first (oid, rid, soid: INTEGER_32)
		do
			c_add_successor_first (mt_context, oid, rid, soid)
		end

   add_successor_append (oid, rid, soid: INTEGER_32)
		do
			c_add_successor_append (mt_context, oid, rid, soid)
		end

   add_successor_after (oid, rid, soid, ooid: INTEGER_32)
		do
			c_add_successor_after (mt_context, oid, rid, soid, ooid)
		end

   add_num_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER)
		do
			c_add_num_successors (mt_context, oid, rid, num, succ_oids)
		end

   set_successor (oid, rid, succ: INTEGER_32)
		do
			c_set_successor (mt_context, oid, rid, succ)
		end

   set_num_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER)
		do
			c_set_num_successors (mt_context, oid, rid, num, succ_oids)
		end

   set_successors (pred_oid, rid, size: INTEGER_32; succ_oids: POINTER)
		do
			c_set_successors (mt_context, pred_oid, rid, size, succ_oids)
		end

   lock_object (oid, lock: INTEGER_32)
		do
			c_lock_object (mt_context, oid, lock)
		end

   load_object (oid: INTEGER_32)
		do
			c_load_object (mt_context, oid)
		end

   get_successor (pred_oid, rid: INTEGER_32): INTEGER_32
		do
			Result := c_get_successor (mt_context, pred_oid, rid)
		end

   get_single_successor (pred_oid, rid: INTEGER_32): INTEGER_32
			-- This is useful with 'Single-relationship'.
			-- (If there is no successor, return 0).
			-- (If there are more than one successor, return -1).
		do
			Result := c_get_single_successor (mt_context, pred_oid, rid)
		end

   write_lock_object (an_oid: INTEGER_32)
		do
			c_write_lock_object (mt_context, an_oid)
		end

   read_lock_object (an_oid: INTEGER_32)
		do
			c_read_lock_object (mt_context, an_oid)
		end

   mt_oid_exist (an_oid: INTEGER_32): BOOLEAN
		do
			Result := c_mt_oid_exist (mt_context, an_oid)
		end

feature -- Object Inverse Relationship Stream

   open_inverse_relationships_stream (oid: INTEGER_32): INTEGER_32
		do
			Result := c_open_inverse_relationships_stream (mt_context, oid)
		end

feature -- Relationship Stream

   open_relationships_stream (sid: INTEGER_32): INTEGER_32
		do
			Result := c_open_relationships_stream (mt_context, sid)
		end

feature -- Implementation MT_PROPERTY

	check_property (pid, oid: INTEGER_32): BOOLEAN
		do
			Result := c_check_property (mt_context, pid, oid)
		end

feature  -- Implementation MTRELATIONSHIP

   get_relationship_from_name (name: POINTER): INTEGER_32
		do
			Result := c_get_relationship_from_name (mt_context, name)
		end

   get_relationship_from_names (name, class_name: POINTER): INTEGER_32
		do
			Result := c_get_relationship_from_names (mt_context, name, class_name)
		end

   get_class_relationship (name: POINTER; cls_oid: INTEGER_32): INTEGER_32
		do
			Result := c_get_class_relationship (mt_context, name, cls_oid)
		end

   check_relationship (rid, oid: INTEGER_32)
		do
			c_check_relationship (mt_context, rid, oid)
		end -- c_check_relationship

   get_max_cardinality (relationship_oid: INTEGER_32): INTEGER_32
		do
			Result := c_get_max_cardinality (mt_context, relationship_oid)
		end

   remove_all_succs_ignerr (rid, oid, sts: INTEGER_32)
			-- Remove all successors of oid-object through rid-
			-- relationship.
			-- Ignore the error sts.
		do
			c_remove_all_succs_ignerr (mt_context, rid, oid, sts)
		end

   remove_all_succs_ignore_nosuccessors (rid, oid: INTEGER_32)
			-- Remove all successors of oid-object through rid-
			-- relationship.
			-- Ignore the error MATISSE_NOSUCCESSORS.
		do
			c_remove_all_succs_ignore_nosuccessors (mt_context, rid, oid)
		end

   append_successor_ignore_alreadysucc(oid, rid, soid: INTEGER_32)
		do
			c_append_successor_ignore_alreadysucc (mt_context, oid, rid, soid)
		end

   add_successor_first_ignore_alreadysucc(oid, rid, soid: INTEGER_32)
		do
			c_add_successor_first_ignore_alreadysucc (mt_context, oid, rid, soid)
		end

   get_relationship_class_name (rid: INTEGER_32): STRING
		do
			Result := c_get_relationship_class_name (mt_context, rid)
		end

   get_inverse_relationship (rid: INTEGER_32): INTEGER_32
		do
			Result := c_get_inverse_relationship (mt_context, rid)
		end

feature -- Relationship Stream

   open_successors_stream (oid, rid: INTEGER_32): INTEGER_32
		do
			Result := c_open_successors_stream (mt_context, oid, rid)
		end

   open_successors_stream_by_name (oid: INTEGER_32; rel_name: POINTER): INTEGER_32
		do
			Result := c_open_successors_stream_by_name (mt_context, oid, rel_name)
		end

feature  -- SQL

   sql_alloc_stmt (): INTEGER_32
		do
			Result := c_mt_sql_alloc_stmt (mt_context)
		end

   sql_free_stmt (a_stmt_offset: INTEGER_32)
		do
			c_mt_sql_free_stmt (mt_context, a_stmt_offset)
		end

   sql_exec_query (a_stmt_offset: INTEGER_32; statement: POINTER)
			-- Execute a select query.
		do
			c_mt_sql_exec_query (mt_context, a_stmt_offset, statement)
		end

   sql_exec_update (a_stmt_offset: INTEGER_32; statement: POINTER): INTEGER_32
			-- Execute a update, insert, delete stmt.
			-- (returns the number of objects affected)
		do
			Result := c_mt_sql_exec_update (mt_context, a_stmt_offset, statement)
		end

   sql_exec (a_stmt_offset: INTEGER_32; statement: POINTER): BOOLEAN
			-- Execute any SQL statement
		do
			Result := c_mt_sql_exec (mt_context, a_stmt_offset, statement)
		end

   sql_get_update_count (a_stmt_offset: INTEGER_32): INTEGER_32
		do
			Result := c_mt_sql_get_update_count (mt_context, a_stmt_offset)
		end

   sql_get_stmt_type (a_stmt_offset: INTEGER_32): INTEGER_32
		do
			Result := c_mt_sql_get_stmt_type (mt_context, a_stmt_offset)
		end

   sql_get_stmt_info (a_stmt_offset, a_stmt_attr: INTEGER_32): STRING
		do
			Result := c_mt_sql_get_stmt_info (mt_context, a_stmt_offset, a_stmt_attr)
		end

   sql_open_stream (a_stmt_offset: INTEGER_32): INTEGER_32
			-- Return type  MtStream which is actually mts_int32
		do
			Result := c_mt_sql_open_stream (mt_context, a_stmt_offset)
		end

   sql_next (a_stream: INTEGER_32): BOOLEAN
			-- Return type is MtStream which is actually mts_int32
		do
			Result := c_mt_sql_next (mt_context, a_stream)
		end

   sql_get_column_type (a_stmt_offset, colnum: INTEGER_32): INTEGER_32
		do
			Result := c_mt_sql_get_column_type (mt_context, a_stmt_offset, colnum)
		end

   sql_find_column_index (stmt_offset: INTEGER_32; c_str_ptr: POINTER): INTEGER_32
		do
			Result := c_mt_find_column_index (mt_context, stmt_offset, c_str_ptr)
		end

   sql_get_column_count (stmt_offset: INTEGER_32): INTEGER_32
		do
			Result := c_mt_get_column_count (mt_context, stmt_offset)
		end

   sql_get_column_name (a_stmt_offset, colnum: INTEGER_32): STRING
		do
			Result := c_mt_sql_get_column_name (mt_context, a_stmt_offset, colnum)
		end

   sql_set_current_row (stream_offset, row_idx: INTEGER_32)
		do
			c_mt_sql_set_current_row (mt_context, stream_offset, row_idx)
		end

   sql_get_row_value_type (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			Result := c_mt_sql_get_row_value_type (mt_context, stream_offset, colnum)
		end

   sql_get_row_boolean (stream_offset, colnum: INTEGER_32): BOOLEAN
		do
			Result := c_mt_sql_get_row_boolean (mt_context, stream_offset, colnum)
		end

   sql_get_row_double (stream_offset, colnum: INTEGER_32): DOUBLE
		do
			Result := c_mt_sql_get_row_double (mt_context, stream_offset, colnum)
		end

   sql_get_row_float (stream_offset, colnum: INTEGER_32): REAL
		do
			Result := c_mt_sql_get_row_float (mt_context, stream_offset, colnum)
		end

   sql_get_row_date (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			Result := c_mt_sql_get_row_date (mt_context, stream_offset, colnum, c_array)
		end

   sql_get_row_ts (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			Result := c_mt_sql_get_row_ts (mt_context, stream_offset, colnum, c_array)
		end

   sql_get_row_ti (stream_offset, colnum: INTEGER_32; c_array1, c_array2: POINTER): BOOLEAN
		do
			Result := c_mt_sql_get_row_ti (mt_context, stream_offset, colnum, c_array1, c_array2)
		end

   sql_get_row_ti_days_fsecs (stream_offset, colnum: INTEGER_32; days, fsecs, negative: POINTER): BOOLEAN
		do
			Result := c_mt_sql_get_row_ti_days_fsecs (mt_context, stream_offset, colnum, days, fsecs, negative)
		end

   sql_get_row_byte (stream_offset, colnum: INTEGER_32): INTEGER_8
		do
			Result := c_mt_sql_get_row_byte (mt_context, stream_offset, colnum)
		end

   sql_get_row_bytes (stream_offset, colnum, size: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			Result := c_mt_sql_get_row_bytes (mt_context, stream_offset, colnum, size, c_array)
		end

   sql_get_row_text (stream_offset, colnum: INTEGER_32): STRING
		do
			Result := c_mt_sql_get_row_text (mt_context, stream_offset, colnum)
		end

   sql_get_row_char (stream_offset, colnum: INTEGER_32): CHARACTER
		do
			Result := c_mt_sql_get_row_char (mt_context, stream_offset, colnum)
		end

   sql_get_row_short (stream_offset, colnum: INTEGER_32): INTEGER_16
		do
			Result := c_mt_sql_get_row_short (mt_context, stream_offset, colnum)
		end

   sql_get_row_integer (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			Result := c_mt_sql_get_row_integer (mt_context, stream_offset, colnum)
		end

   sql_get_row_long (stream_offset, colnum: INTEGER_32): INTEGER_64
		do
			Result := c_mt_sql_get_row_long (mt_context, stream_offset, colnum)
		end

   sql_get_row_numeric (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			Result := c_mt_sql_get_row_numeric (mt_context, stream_offset, colnum, c_array)
		end

   sql_get_row_string (stream_offset, colnum: INTEGER_32): STRING
		do
			Result := c_mt_sql_get_row_string (mt_context, stream_offset, colnum)
		end

   sql_get_row_ref (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			Result := c_mt_sql_get_row_ref (mt_context, stream_offset, colnum)
		end

   sql_get_row_size (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			Result := c_mt_sql_get_row_size (mt_context, stream_offset, colnum)
		end

feature -- Stream

   next_object (sid: INTEGER_32): INTEGER_32
		do
			Result := c_next_object (mt_context, sid)
		end

   next_property (sid: INTEGER_32): INTEGER_32
		do
			Result := c_next_property (mt_context, sid)
		end

   next_version (sid: INTEGER_32): STRING
		do
			Result := c_next_version (mt_context, sid)
		end

   close_stream (sid: INTEGER_32)
		do
			c_mt_close_stream (mt_context, sid)
		end

feature -- Events Implementation

	event_subscribe (posted_events: INTEGER_64)
		do
			c_mt_event_subscribe (mt_context, posted_events)
		end

	event_unsubscribe ()
		do
			c_mt_event_unsubscribe (mt_context)
		end

	event_wait (timeout: INTEGER_32): INTEGER_64
		do
			Result := c_mt_event_wait (mt_context, timeout)
		end

	event_notify (events: INTEGER_64)
		do
			c_mt_event_notify (mt_context, events)
		end

end
