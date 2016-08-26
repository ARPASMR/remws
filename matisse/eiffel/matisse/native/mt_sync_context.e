note
	description: "Synchronous Context class for the binding"
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
	MT_SYNC_CONTEXT

inherit
	MT_CONTEXT

	MEMORY
		redefine
			dispose
		end

create
	make

feature {NONE} -- Implementation
	mt_context: INTEGER_64

	ctxlock: MUTEX
	cachelock: MUTEX

	dispose
		-- Redefinition of dispose of MEMORY.
		-- Free space allocated for MtContext.
		do
			-- CANNOT raise an exception
			-- MUST fulfill its contract
			c_free_connection (mt_context)
		end

feature  -- Initialization

	make
		do
		    create ctxlock.make
		    create cachelock.make
		    mt_context := c_allocate_connection
		end

feature  -- Implementation Schema Object Cache
	
	get_cached (a_schema_cache: HASH_TABLE[MTOBJECT, STRING]; a_sch_name : STRING) : MTOBJECT
		do
			cachelock.lock
			a_schema_cache.search (a_sch_name)
			if a_schema_cache.found then
				Result := a_schema_cache.found_item
			end
			cachelock.unlock
		end

	set_cached (a_schema_cache: HASH_TABLE[MTOBJECT, STRING]; a_sch_name: STRING; sch_obj: MTOBJECT)
		do
			cachelock.lock
			a_schema_cache.extend (sch_obj, a_sch_name)
			cachelock.unlock
		end
	
feature -- Implementation MATISSE C API

	get_oids_of_classes (num: INTEGER_32; buf: POINTER)
		do
			ctxlock.lock
			c_get_oids_of_classes (mt_context, num, buf)
			ctxlock.unlock
		end

   get_classes_count (): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_classes_count (mt_context)
			ctxlock.unlock
		end

feature -- Implementation MTATTRIBUTE

   get_attribute (name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_attribute (mt_context, name)
			ctxlock.unlock
		end

   get_attribute_from_names (name, class_name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_attribute_from_names (mt_context, name, class_name)
			ctxlock.unlock
		end

   get_class_attribute (name: POINTER; cls_oid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_class_attribute (mt_context, name, cls_oid)
			ctxlock.unlock
		end

   check_attribute (aid, oid: INTEGER_32)
		do
			ctxlock.lock
			c_check_attribute (mt_context, aid, oid)
			ctxlock.unlock
		end

   get_dimension (oid, aid, rank: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_dimension (mt_context, oid, aid, rank)
			ctxlock.unlock
		end

   is_default_value (oid, aid: INTEGER_32): BOOLEAN
		do
			ctxlock.lock
			Result := c_is_default_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   get_value_type (oid, aid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_value_type (mt_context, oid, aid)
			ctxlock.unlock
		end

	-- MT_BYTE --
   get_byte_value (oid, aid: INTEGER_32): NATURAL_8
		do
			ctxlock.lock
			Result := c_get_byte_value (mt_context, oid,aid)
			ctxlock.unlock
		end

   get_byte_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_byte_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

   -- MT_LONG --
   get_integer_64_value (oid, aid: INTEGER_32): INTEGER_64
      do
         ctxlock.lock
			Result := c_get_integer_64_value (mt_context, oid, aid)
			ctxlock.unlock
      end

   get_integer_64_array (oid, aid, size: INTEGER_32; buffer: POINTER)
      do
         ctxlock.lock
			c_get_integer_64_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
      end

	-- MT_INTEGER --
   get_integer_value (oid, aid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_integer_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   get_integer_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_integer_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_SHORT --
   get_short_value (oid, aid: INTEGER_32): INTEGER_16
		do
			ctxlock.lock
			Result := c_get_short_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   get_short_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_short_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_NUMERIC --
   get_numeric_value (oid, aid: INTEGER_32; ptr_array: POINTER)
		do
			ctxlock.lock
			c_mt_get_numeric_value (mt_context, oid, aid, ptr_array)
			ctxlock.unlock
		end

   get_numeric_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_numeric_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_DOUBLE --
   get_double_value(oid, aid: INTEGER_32): DOUBLE
		do
			ctxlock.lock
			Result := c_get_double_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   get_double_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_double_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_FLOAT --
   get_real_value (oid, aid: INTEGER_32): REAL
		do
			ctxlock.lock
			Result := c_get_real_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   get_real_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_real_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_CHAR --
   get_char_value (oid, aid: INTEGER_32): CHARACTER
		do
			ctxlock.lock
			Result := c_get_char_value (mt_context, oid, aid)
			ctxlock.unlock
		end

	-- MT_STRING --
   get_string_value (oid, aid: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_get_string_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   get_string_array (oid, aid, size: INTEGER_32; buffer: ANY)
		do
			ctxlock.lock
			c_get_string_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_BOOLEAN --
   get_boolean_value (oid, aid: INTEGER_32): BOOLEAN
		do
			ctxlock.lock
			Result := c_get_boolean_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   get_boolean_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_boolean_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_DATE --
   get_date_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_date_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_TIMESTAMP --
   get_timestamp_value (oid, aid: INTEGER_32; yr, mh, dy, hr, me, sd, msd: POINTER)
		do
			ctxlock.lock
			c_get_timestamp_value (mt_context, oid, aid, yr, mh, dy, hr, me, sd, msd)
			ctxlock.unlock
		end

   get_timestamp_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_get_timestamp_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

	-- MT_INTERVAL --
   get_interval_value(oid, aid: INTEGER_32) : INTEGER_64
		do
			ctxlock.lock
			Result := c_get_interval_value (mt_context, oid, aid)
			ctxlock.unlock
		end

	get_interval_array (oid, aid, count: INTEGER_32; buf_interval_milisec: POINTER)
		do
			ctxlock.lock
			c_get_interval_array (mt_context, oid, aid, count, buf_interval_milisec)
			ctxlock.unlock
		end

	--	
	-- Setting values
	--

   set_value_integer_64 (oid, aid, type: INTEGER_32; value: INTEGER_64; rank: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_integer_64 (mt_context, oid, aid, type, value, rank)
			ctxlock.unlock
		end

   set_value_integer (oid, aid, type, value, rank: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_integer (mt_context, oid, aid, type, value, rank)
			ctxlock.unlock
		end

   set_value_u8 (oid, aid, value: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_u8 (mt_context, oid, aid, value)
			ctxlock.unlock
		end

   set_value_s16 (oid, aid, value: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_s16 (mt_context, oid, aid, value)
			ctxlock.unlock
		end

   mt_set_value_numeric (oid, aid: INTEGER_32; item1, item2, item3, item4, item5, item6: INTEGER_32)
		do
			ctxlock.lock
			c_mt_set_value_numeric (mt_context, oid, aid, item1, item2, item3, item4, item5, item6)
			ctxlock.unlock
		end

   mt_set_value_numeric_list (oid, aid: INTEGER_32; value: POINTER; numElem: INTEGER_32)
		do
			ctxlock.lock
			c_mt_set_value_numeric_list (mt_context, oid, aid, value, numElem)
			ctxlock.unlock
		end

   set_value_double (oid, aid, type: INTEGER_32; value: DOUBLE; rank: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_double (mt_context, oid, aid, type, value, rank)
			ctxlock.unlock
		end

   set_value_real (oid, aid, type: INTEGER_32; value: REAL)
		do
			ctxlock.lock
			c_set_value_real (mt_context, oid, aid, type, value)
			ctxlock.unlock
		end

   set_value_char (oid, aid, type: INTEGER_32; value: CHARACTER; rank: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_char (mt_context, oid, aid, type, value, rank)
			ctxlock.unlock
		end

   set_value_boolean (oid, aid: INTEGER_32; value: BOOLEAN)
		do
			ctxlock.lock
			c_set_value_boolean (mt_context, oid, aid, value)
			ctxlock.unlock
		end

   set_value_boolean_array (oid, aid, size: INTEGER_32; buffer: POINTER)
		do
			ctxlock.lock
			c_set_value_boolean_array (mt_context, oid, aid, size, buffer)
			ctxlock.unlock
		end

   set_value_date (oid, aid: INTEGER_32; year, month, day: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_date (mt_context, oid, aid, year, month, day)
			ctxlock.unlock
		end

   set_value_date_array (oid, aid, size: INTEGER_32; years, months, days: POINTER)
		do
			ctxlock.lock
			c_set_value_date_array (mt_context, oid, aid, size, years, months, days)
			ctxlock.unlock
		end

   set_value_timestamp (oid, aid, year, month, day, hour, minute, second, microsec: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_timestamp (mt_context, oid, aid, year, month, day, hour, minute, second, microsec)
			ctxlock.unlock
		end

   set_value_timestamp_array (oid, aid, count: INTEGER_32; years, months, days, hours, minutes, seconds, microsecs: POINTER)
		do
			ctxlock.lock
			c_set_value_timestamp_array (mt_context, oid, aid, count, years, months, days, hours, minutes, seconds, microsecs)
			ctxlock.unlock
		end

   set_value_time_interval (oid, aid: INTEGER_32; interval_milisec: INTEGER_64)
		do
			ctxlock.lock
			c_set_value_time_interval (mt_context, oid, aid, interval_milisec)
			ctxlock.unlock
		end

   set_value_time_interval_array (oid, aid, count: INTEGER_32; interval_milisec: POINTER)
		do
			ctxlock.lock
			c_set_value_time_interval_array (mt_context, oid, aid, count, interval_milisec)
			ctxlock.unlock
		end

   set_value_string (oid, aid, type: INTEGER_32; value: POINTER; encoding: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_string (mt_context, oid, aid, type, value, encoding)
			ctxlock.unlock
		end

   set_value_array_numeric (oid, aid, type: INTEGER_32; value: POINTER; rank, num: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_array_numeric (mt_context, oid, aid, type, value, rank, num)
			ctxlock.unlock
		end

   set_value_short_array (oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_short_array (mt_context, oid, aid, type, value, rank)
			ctxlock.unlock
		end

   set_value_void (oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32)
		do
			ctxlock.lock
			c_set_value_void (mt_context, oid, aid, type, value, rank)
			ctxlock.unlock
		end

   get_attribute_type (aid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_attribute_type (mt_context, aid)
			ctxlock.unlock
		end

   set_value_byte_list_elements (oid, aid, type: INTEGER_32; buffer: POINTER; count, offset: INTEGER_32; discard_after: BOOLEAN)
		do
			ctxlock.lock
			c_set_value_byte_list_elements (mt_context, oid, aid, type, buffer, count, offset, discard_after)
			ctxlock.unlock
		end

   get_byte_list_elements (oid, aid: INTEGER_32; buffer: POINTER; count, offset: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_byte_list_elements (mt_context, oid, aid, buffer, count, offset)
			ctxlock.unlock
		end

feature -- Implementation MT_CALLABLE_STATEMENT

   sql_get_param_boolean (stmt_offset, param_idx : INTEGER_32) : BOOLEAN
			-- Get the boolean param return value (MT_BOOLEAN)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_boolean (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_byte (stmt_offset, param_idx : INTEGER_32) : INTEGER_8
			-- Get the byte param return value (MT_BYTE)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_byte (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_char (stmt_offset, param_idx : INTEGER_32) : CHARACTER
			-- Get the char param return value (MT_CHAR)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_char (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_double (stmt_offset, param_idx : INTEGER_32) : DOUBLE
			-- Get the double param return value (MT_DOUBLE)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_double (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_float (stmt_offset, param_idx : INTEGER_32) : REAL
			-- Get the float param return value (MT_FLOAT)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_float (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_integer (stmt_offset, param_idx : INTEGER_32) : INTEGER_32
			-- Get the integer param return value (MT_INTEGER)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_integer (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_interval (stmt_offset, param_idx : INTEGER_32; c_array1, c_array2 : POINTER) : BOOLEAN
			-- Get the interval param return value (MT_INTERVAL)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_interval (mt_context, stmt_offset, param_idx, c_array1, c_array2)
			ctxlock.unlock
		end

   sql_get_param_interval_days_fsecs(stmt_offset, param_idx : INTEGER_32; days, fsecs, negative: POINTER) : BOOLEAN
			-- Get the interval param return value (MT_INTERVAL)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_interval_days_fsecs (mt_context, stmt_offset, param_idx, days, fsecs, negative)
			ctxlock.unlock
		end

   sql_get_param_long (stmt_offset, param_idx : INTEGER_32) : INTEGER_64
			-- Get the long param return value (MT_LONG)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_long (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_numeric (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the interval param return value (MT_NUMERIC)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_numeric (mt_context, stmt_offset, param_idx, c_array)
			ctxlock.unlock
		end

   sql_get_param_short (stmt_offset, param_idx : INTEGER_32) : INTEGER_16
			-- Get the short param return value (MT_SHORT)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_short (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_date (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the date param return value (MT_DATE)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_date (mt_context, stmt_offset, param_idx, c_array)
			ctxlock.unlock
		end

   sql_get_param_timestamp (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the timestamp param return value (MT_TIMESTAMP)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_timestamp (mt_context, stmt_offset, param_idx, c_array)
			ctxlock.unlock
		end

   sql_get_param_bytes (stmt_offset, param_idx : INTEGER_32; sz, c_array : POINTER) : BOOLEAN
			-- Get the bytes param return value (MT_BYTES, MT_AUDIO, MT_IMAGE, MT_VIDEO)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_bytes (mt_context, stmt_offset, param_idx, sz, c_array)
			ctxlock.unlock
		end

   sql_get_param_text (stmt_offset, param_idx : INTEGER_32) : STRING
			-- Get the text param return value (MT_TEXT)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_text (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_string (stmt_offset, param_idx : INTEGER_32) : STRING
			-- Get the string param return value (MT_STRING)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_string (mt_context, stmt_offset, param_idx)
			ctxlock.unlock
		end

   sql_get_param_size(stmt_offset, param_idx : INTEGER_32; size: POINTER) : INTEGER_32
			-- Get the result param size (All types)
		do
			ctxlock.lock
			Result := c_mt_sql_get_param_size (mt_context, stmt_offset, param_idx, size)
			ctxlock.unlock
		end

feature -- Implementation MTNAMESPACE

   get_namespace (name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_namespace (mt_context, name)
			ctxlock.unlock
		end

   get_schema_object_full_name (oid: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_get_schema_object_full_name (mt_context, oid)
			ctxlock.unlock
		end

feature -- Implementation MTCLASS

   get_class_from_name (name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_class_from_name (mt_context, name)
			ctxlock.unlock
		end

   get_object_class (oid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_object_class (mt_context, oid)
			ctxlock.unlock
		end

   get_attributes_count (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_attributes_count (mt_context, cid)
			ctxlock.unlock
		end

   get_all_attributes (cid, num: INTEGER_32; buf: POINTER)
		do
			ctxlock.lock
			c_get_all_attributes (mt_context, cid, num, buf)
			ctxlock.unlock
		end

   get_relationships_count (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_relationships_count (mt_context, cid)
			ctxlock.unlock
		end

   get_all_relationships (cid, num: INTEGER_32; buf: POINTER)
		do
			ctxlock.lock
			c_get_all_relationships (mt_context, cid, num, buf)
			ctxlock.unlock
		end

   get_inverse_relationships_count (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_inverse_relationships_count (mt_context, cid)
			ctxlock.unlock
		end

   get_all_inverse_relationships (cid, num: INTEGER_32; buf: POINTER)
		do
			ctxlock.lock
			c_get_all_inverse_relationships (mt_context, cid, num, buf)
			ctxlock.unlock
		end

   get_subclasses_count (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_subclasses_count (mt_context, cid)
			ctxlock.unlock
		end

   get_all_subclasses (cid, num: INTEGER_32; buf: POINTER)
		do
			ctxlock.lock
			c_get_all_subclasses (mt_context, cid, num, buf)
			ctxlock.unlock
		end

   get_superclasses_count (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_superclasses_count (mt_context, cid)
			ctxlock.unlock
		end

   get_all_superclasses (cid, num: INTEGER_32; buf: POINTER)
		do
			ctxlock.lock
			c_get_all_superclasses (mt_context, cid, num, buf)
			ctxlock.unlock
		end

   get_methods_count (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_methods_count (mt_context, cid)
			ctxlock.unlock
		end

   get_all_methods (cid, num: INTEGER_32; buf: POINTER)
		do
			ctxlock.lock
			c_get_all_methods (mt_context, cid, num, buf)
			ctxlock.unlock
		end

   get_instances_number (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_instances_number (mt_context, cid)
			ctxlock.unlock
		end

   get_own_instances_number (cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_own_instances_number (mt_context, cid)
			ctxlock.unlock
		end

   get_class_property_from_name (name: POINTER; oid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_class_property_from_name (mt_context, name, oid)
			ctxlock.unlock
		end

feature -- Class Stream

   open_instances_stream (cid, num_preftech: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_instances_stream (mt_context, cid, num_preftech)
			ctxlock.unlock
		end

   open_own_instances_stream (cid, num_preftech: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_own_instances_stream (mt_context, cid, num_preftech)
			ctxlock.unlock
		end

feature -- Version Stream

   open_version_stream (): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_version_stream (mt_context)
			ctxlock.unlock
		end

feature -- Create Object

	create_object (name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_create_object (mt_context, name)
			ctxlock.unlock
		end

feature -- Database Options

   get_last_error_msg () : STRING
		do
			ctxlock.lock
			Result := c_get_last_error_msg (mt_context)
			ctxlock.unlock
		end

   get_last_error_code () : INTEGER_32
		do
			ctxlock.lock
			Result := c_get_last_error_code (mt_context)
			ctxlock.unlock
		end

   get_connection_option (option: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_connection_option (mt_context, option)
			ctxlock.unlock
		end

   set_connection_option (option, value: INTEGER_32)
		do
			ctxlock.lock
			c_set_connection_option (mt_context, option, value)
			ctxlock.unlock
		end

   get_string_connection_option (option: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_get_string_connection_option (mt_context, option)
			ctxlock.unlock
		end

   set_string_connection_option (option: INTEGER_32; value: POINTER)
		do
			ctxlock.lock
			c_set_string_connection_option (mt_context, option, value)
			ctxlock.unlock
		end

   connect_database (host, db, user, passwd: POINTER)
		do
			ctxlock.lock
			c_connect_database (mt_context, host, db, user, passwd)
			ctxlock.unlock
		end

   disconnect_database ()
		do
			ctxlock.lock
			c_disconnect_database (mt_context)
			ctxlock.unlock
		end

   get_connection_state (): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_connection_state (mt_context)
			ctxlock.unlock
		end

   start_transaction (priority: INTEGER_32): INTEGER_32
			-- Return the version number.
		do
			ctxlock.lock
			Result := c_start_transaction (mt_context, priority)
			ctxlock.unlock
		end

   commit_transaction (a_prefix: POINTER) : STRING
		do
			ctxlock.lock
			Result := c_commit_transaction (mt_context, a_prefix)
			ctxlock.unlock
		end

   abort_transaction ()
		do
			ctxlock.lock
			c_abort_transaction (mt_context)
			ctxlock.unlock
		end

   is_transaction_in_progress () : BOOLEAN
			-- Use
		do
			ctxlock.lock
			Result := c_is_transaction_in_progress (mt_context)
			ctxlock.unlock
		end

   start_version_access (time_name: POINTER): INTEGER_32
			-- Return the version number accessed.
		do
			ctxlock.lock
			Result := c_start_version_access (mt_context, time_name)
			ctxlock.unlock
		end

   end_version_access ()
		do
			ctxlock.lock
			c_end_version_access (mt_context)
			ctxlock.unlock
		end

   is_version_access_in_progress () : BOOLEAN
			-- Use
		do
			ctxlock.lock
			Result := c_is_version_access_in_progress (mt_context)
			ctxlock.unlock
		end

	preallocate_objects (num: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_preallocate_objects (mt_context, num)
			ctxlock.unlock
		end

	num_preallocated_objects (): INTEGER_32
		do
			ctxlock.lock
			Result := c_num_preallocated_objects (mt_context)
			ctxlock.unlock
		end

   get_invalid_object (): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_invalid_object (mt_context)
			ctxlock.unlock
		end

feature  -- Implementation MTENTRYPOINTDICTIONARY

   get_entry_point_dictionary (dict_name: POINTER): INTEGER_32
			-- Get oid of ep dictionary
		do
			ctxlock.lock
			Result := c_get_entry_point_dictionary (mt_context, dict_name)
			ctxlock.unlock
		end

   get_object_from_entry_point (ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_object_from_entry_point (mt_context, ep_name, dict_id, cid)
			ctxlock.unlock
		end

   get_object_number_from_entry_point (ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_object_number_from_entry_point (mt_context, ep_name, dict_id, cid)
			ctxlock.unlock
		end

   get_objects_from_entry_point (dict_id, cid: INTEGER_32; ep_name: POINTER): ARRAY[INTEGER_32]
		do
			ctxlock.lock
			Result := c_get_objects_from_entry_point (mt_context, dict_id, cid, ep_name)
			ctxlock.unlock
		end

   lock_objects_from_entry_point (lock: INTEGER_32; c_ep_name: POINTER; aid, cid: INTEGER_32)
		do
			ctxlock.lock
			c_lock_objects_from_entry_point (mt_context, lock, c_ep_name, aid, cid)
			ctxlock.unlock
		end

feature -- Entrypoint Stream

   open_entry_point_stream (name: POINTER; ep_id, cid, nb_obj_per_call: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_entry_point_stream (mt_context, name, ep_id, cid, nb_obj_per_call)
			ctxlock.unlock
		end

feature -- Implementation MTINDEX

   get_index (index_name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_index (mt_context, index_name)
			ctxlock.unlock
		end

   index_entries_count (iid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_index_entries_count (mt_context, iid)
			ctxlock.unlock
		end

   load_index_info (iid: INTEGER_32; num_classes, crit_class_oids, num_criteria, attrs, types, sizes, orders: POINTER)
		do
			ctxlock.lock
			c_load_index_info (mt_context, iid, num_classes, crit_class_oids, num_criteria, attrs, types, sizes, orders)
			ctxlock.unlock
		end

   index_lookup (index_oid, class_oid, criteria_count: INTEGER_32; crit_start_array: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_index_lookup (mt_context, index_oid, class_oid, criteria_count, crit_start_array)
			ctxlock.unlock
		end

   index_lookup_object (index_oid, class_oid, criteria_count: INTEGER_32; crit_array: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_index_lookup_object (mt_context, index_oid, class_oid, criteria_count, crit_array)
			ctxlock.unlock
		end

   index_object_number (index_oid, class_oid, criteria_count: INTEGER_32; crit_array: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_index_object_number (mt_context, index_oid, class_oid, criteria_count, crit_array)
			ctxlock.unlock
		end

feature -- Index Stream

   open_index_entries_stream_by_name(index_name, class_name: POINTER; direction: INTEGER_32;
	                                  c_cit_start_array, c_crit_end_array: POINTER;
	                                  nb_obj_per_call: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_index_entries_stream_by_name (mt_context, index_name, class_name, direction, c_cit_start_array, c_crit_end_array, nb_obj_per_call)
			ctxlock.unlock
		end

   open_index_entries_stream(index_oid, class_oid, direction, count: INTEGER_32;
	                          c_cit_start_array, c_crit_end_array: POINTER; nb_obj_per_call: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_index_entries_stream (mt_context, index_oid, class_oid, direction, count, c_cit_start_array, c_crit_end_array, nb_obj_per_call)
			ctxlock.unlock
		end

   open_index_object_stream(index_oid, class_oid, direction, seg_count: INTEGER_32;
	                         start_key, end_key: POINTER; num_preftech: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_index_object_stream (mt_context, index_oid, class_oid,
	                                            direction, seg_count, start_key,
	                                            end_key, num_preftech)
			ctxlock.unlock
		end

feature -- Implementation MT_INFO

   max_buffered_objects (): INTEGER_32
		do
			ctxlock.lock
			Result := c_max_buffered_objects (mt_context)
			ctxlock.unlock
		end

   max_index_criteria_number (): INTEGER_32
		do
			ctxlock.lock
			Result := c_max_index_criteria_number (mt_context)
			ctxlock.unlock
		end

   max_index_key_length (): INTEGER_32
		do
			ctxlock.lock
			Result := c_max_index_key_length (mt_context)
			ctxlock.unlock
		end

   get_num_data_bytes_received (): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_num_data_bytes_received (mt_context)
			ctxlock.unlock
		end

   get_num_data_bytes_sent (): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_num_data_bytes_sent (mt_context)
			ctxlock.unlock
		end

feature -- Irelationship Stream

   open_predecessors_stream (oid, rid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_predecessors_stream (mt_context, oid, rid)
			ctxlock.unlock
		end

feature -- Object Name

   object_mt_name (oid: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_object_mt_name (mt_context, oid)
			ctxlock.unlock
		end

feature -- Object Attribute Stream

   open_attributes_stream (sid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_attributes_stream (mt_context, sid)
			ctxlock.unlock
		end

feature -- Object Creation

   dynamic_create_storable_eif_object (mt_handle: INTEGER_32): MT_OBJECT
		do
			ctxlock.lock
			Result := c_dynamic_create_storable_eif_object (mt_context, mt_handle)
			ctxlock.unlock
		end

   dynamic_create_proxi_eif_object (mt_handle: INTEGER_32): MTOBJECT
		do
			ctxlock.lock
			Result := c_dynamic_create_proxi_eif_object (mt_context, mt_handle)
			ctxlock.unlock
		end

   create_empty_rs_container (name: POINTER; pred_oid, rel_oid: INTEGER_32): ANY
		do
			ctxlock.lock
			Result := c_create_empty_rs_container (mt_context, name, pred_oid, rel_oid)
			ctxlock.unlock
		end

   create_object_from_cid (class_oid: INTEGER_32) : INTEGER_32
			-- Create new MATISSE object using MtCreateObject ().
			-- Return new oid.
		do
			ctxlock.lock
			Result := c_create_object_from_cid (mt_context, class_oid)
			ctxlock.unlock
		end

feature  -- Implementation MT_OBJECT

   is_predefined_object (oid: INTEGER_32): BOOLEAN
		do
			ctxlock.lock
			Result := c_is_predefined_object (mt_context, oid)
			ctxlock.unlock
		end

   check_object(oid: INTEGER_32)
		do
			ctxlock.lock
			c_check_object (mt_context, oid)
			ctxlock.unlock
		end

   remove_object (oid: INTEGER_32)
		do
			ctxlock.lock
			c_remove_object (mt_context, oid)
			ctxlock.unlock
		end

   remove_value (oid, aid: INTEGER_32)
		do
			ctxlock.lock
			c_remove_value (mt_context, oid, aid)
			ctxlock.unlock
		end

   remove_successor (oid, rid, sid: INTEGER_32)
		do
			ctxlock.lock
			c_remove_successor (mt_context, oid, rid, sid)
			ctxlock.unlock
		end

   remove_all_successors (oid, rid: INTEGER_32)
		do
			ctxlock.lock
			c_remove_all_successors (mt_context, oid, rid)
			ctxlock.unlock
		end

   clear_all_successors (oid, rid: INTEGER_32)
		do
			ctxlock.lock
			c_clear_all_successors (mt_context, oid, rid)
			ctxlock.unlock
		end

   remove_successor_ignore_nosuchsucc (pred_oid, rid, succ_oid: INTEGER_32)
		do
			ctxlock.lock
			c_remove_successor_ignore_nosuchsucc (mt_context, pred_oid, rid, succ_oid)
			ctxlock.unlock
		end

   remove_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER)
		do
			ctxlock.lock
			c_remove_successors (mt_context, oid, rid, num, succ_oids)
			ctxlock.unlock
		end

   object_size (oid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_object_size (mt_context, oid)
			ctxlock.unlock
		end

   print_to_file (oid: INTEGER_32;file_pointer: POINTER)
		do
			ctxlock.lock
			c_print_to_file (mt_context, oid, file_pointer)
			ctxlock.unlock
		end

   is_instance_of (oid, cid: INTEGER_32): BOOLEAN
		do
			ctxlock.lock
			Result := c_is_instance_of (mt_context, oid, cid)
			ctxlock.unlock
		end

   get_added_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			ctxlock.lock
			Result := c_get_added_successors (mt_context, oid, rid)
			ctxlock.unlock
		end

   get_removed_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			ctxlock.lock
			Result := c_get_removed_successors (mt_context, oid, rid)
			ctxlock.unlock
		end

   get_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			ctxlock.lock
			Result := c_get_successors (mt_context, oid, rid)
			ctxlock.unlock
		end

   get_successor_size (oid, rid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_successor_size (mt_context, oid, rid)
			ctxlock.unlock
		end

   get_predecessors (oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		do
			ctxlock.lock
			Result := c_get_predecessors (mt_context, oid, rid)
			ctxlock.unlock
		end

	get_predecessors_by_name (oid: INTEGER_32; rshp_name: POINTER): ARRAY[INTEGER_32]
		do
			ctxlock.lock
			Result := c_get_predecessors_by_name (mt_context, oid, rshp_name)
			ctxlock.unlock
		end

   free_object (oid: INTEGER_32)
		do
			ctxlock.lock
			c_free_object (mt_context, oid)
			ctxlock.unlock
		end

   add_successor_first (oid, rid, soid: INTEGER_32)
		do
			ctxlock.lock
			c_add_successor_first (mt_context, oid, rid, soid)
			ctxlock.unlock
		end

   add_successor_append (oid, rid, soid: INTEGER_32)
		do
			ctxlock.lock
			c_add_successor_append (mt_context, oid, rid, soid)
			ctxlock.unlock
		end

   add_successor_after (oid, rid, soid, ooid: INTEGER_32)
		do
			ctxlock.lock
			c_add_successor_after (mt_context, oid, rid, soid, ooid)
			ctxlock.unlock
		end

   add_num_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER)
		do
			ctxlock.lock
			c_add_num_successors (mt_context, oid, rid, num, succ_oids)
			ctxlock.unlock
		end

   set_successor (oid, rid, succ: INTEGER_32)
		do
			ctxlock.lock
			c_set_successor (mt_context, oid, rid, succ)
			ctxlock.unlock
		end

   set_num_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER)
		do
			ctxlock.lock
			c_set_num_successors (mt_context, oid, rid, num, succ_oids)
			ctxlock.unlock
		end

   set_successors (pred_oid, rid, size: INTEGER_32; succ_oids: POINTER)
		do
			ctxlock.lock
			c_set_successors (mt_context, pred_oid, rid, size, succ_oids)
			ctxlock.unlock
		end

   lock_object (oid, lock: INTEGER_32)
		do
			ctxlock.lock
			c_lock_object (mt_context, oid, lock)
			ctxlock.unlock
		end

   load_object (oid: INTEGER_32)
		do
			ctxlock.lock
			c_load_object (mt_context, oid)
			ctxlock.unlock
		end

   get_successor (pred_oid, rid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_successor (mt_context, pred_oid, rid)
			ctxlock.unlock
		end

   get_single_successor (pred_oid, rid: INTEGER_32): INTEGER_32
			-- This is useful with 'Single-relationship'.
			-- (If there is no successor, return 0).
			-- (If there are more than one successor, return -1).
		do
			ctxlock.lock
			Result := c_get_single_successor (mt_context, pred_oid, rid)
			ctxlock.unlock
		end

   write_lock_object (an_oid: INTEGER_32)
		do
			ctxlock.lock
			c_write_lock_object (mt_context, an_oid)
			ctxlock.unlock
		end

   read_lock_object (an_oid: INTEGER_32)
		do
			ctxlock.lock
			c_read_lock_object (mt_context, an_oid)
			ctxlock.unlock
		end

   mt_oid_exist (an_oid: INTEGER_32): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_oid_exist (mt_context, an_oid)
			ctxlock.unlock
		end

feature -- Object Inverse Relationship Stream

   open_inverse_relationships_stream (oid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_inverse_relationships_stream (mt_context, oid)
			ctxlock.unlock
		end

feature -- Relationship Stream

   open_relationships_stream (sid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_relationships_stream (mt_context, sid)
			ctxlock.unlock
		end

feature -- Implementation MT_PROPERTY

	check_property (pid, oid: INTEGER_32): BOOLEAN
		do
			ctxlock.lock
			Result := c_check_property (mt_context, pid, oid)
			ctxlock.unlock
		end

feature -- Implementation MTRELATIONSHIP

   get_relationship_from_name (name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_relationship_from_name (mt_context, name)
			ctxlock.unlock
		end 

   get_relationship_from_names (name, class_name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_relationship_from_names (mt_context, name, class_name)
			ctxlock.unlock
		end 

   get_class_relationship (name: POINTER; cls_oid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_class_relationship (mt_context, name, cls_oid)
			ctxlock.unlock
		end 

   check_relationship (rid, oid: INTEGER_32)
		do
			ctxlock.lock
			c_check_relationship (mt_context, rid, oid)
			ctxlock.unlock
		end -- c_check_relationship

   get_max_cardinality (relationship_oid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_max_cardinality (mt_context, relationship_oid)
			ctxlock.unlock
		end

   remove_all_succs_ignerr (rid, oid, sts: INTEGER_32)
			-- Remove all successors of oid-object through rid-
			-- relationship.
			-- Ignore the error sts.
		do
			ctxlock.lock
			c_remove_all_succs_ignerr (mt_context, rid, oid, sts)
			ctxlock.unlock
		end

   remove_all_succs_ignore_nosuccessors (rid, oid: INTEGER_32)
			-- Remove all successors of oid-object through rid-
			-- relationship.
			-- Ignore the error MATISSE_NOSUCCESSORS.
		do
			ctxlock.lock
			c_remove_all_succs_ignore_nosuccessors (mt_context, rid, oid)
			ctxlock.unlock
		end

   append_successor_ignore_alreadysucc(oid, rid, soid: INTEGER_32)
		do
			ctxlock.lock
			c_append_successor_ignore_alreadysucc (mt_context, oid, rid, soid)
			ctxlock.unlock
		end

   add_successor_first_ignore_alreadysucc(oid, rid, soid: INTEGER_32)
		do
			ctxlock.lock
			c_add_successor_first_ignore_alreadysucc (mt_context, oid, rid, soid)
			ctxlock.unlock
		end

   get_relationship_class_name (rid: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_get_relationship_class_name (mt_context, rid)
			ctxlock.unlock
		end

   get_inverse_relationship (rid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_get_inverse_relationship (mt_context, rid)
			ctxlock.unlock
		end

feature -- Relationship Stream

   open_successors_stream (oid, rid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_successors_stream (mt_context, oid, rid)
			ctxlock.unlock
		end

   open_successors_stream_by_name (oid: INTEGER_32; rel_name: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_open_successors_stream_by_name (mt_context, oid, rel_name)
			ctxlock.unlock
		end

feature -- SQL

   sql_alloc_stmt (): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_alloc_stmt (mt_context)
			ctxlock.unlock
		end

   sql_free_stmt (a_stmt_offset: INTEGER_32)
		do
			ctxlock.lock
			c_mt_sql_free_stmt (mt_context, a_stmt_offset)
			ctxlock.unlock
		end

   sql_exec_query (a_stmt_offset: INTEGER_32; statement: POINTER)
			-- Execute a select query.
		do
			ctxlock.lock
			c_mt_sql_exec_query (mt_context, a_stmt_offset, statement)
			ctxlock.unlock
		end

   sql_exec_update (a_stmt_offset: INTEGER_32; statement: POINTER): INTEGER_32
			-- Execute a update, insert, delete stmt.
			-- (returns the number of objects affected)
		do
			ctxlock.lock
			Result := c_mt_sql_exec_update (mt_context, a_stmt_offset, statement)
			ctxlock.unlock
		end

   sql_exec (a_stmt_offset: INTEGER_32; statement: POINTER): BOOLEAN
			-- Execute any SQL statement
		do
			ctxlock.lock
			Result := c_mt_sql_exec (mt_context, a_stmt_offset, statement)
			ctxlock.unlock
		end

   sql_get_update_count (a_stmt_offset: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_get_update_count (mt_context, a_stmt_offset)
			ctxlock.unlock
		end

   sql_get_stmt_type (a_stmt_offset: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_get_stmt_type (mt_context, a_stmt_offset)
			ctxlock.unlock
		end

   sql_get_stmt_info (a_stmt_offset, a_stmt_attr: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_mt_sql_get_stmt_info (mt_context, a_stmt_offset, a_stmt_attr)
			ctxlock.unlock
		end

   sql_open_stream (a_stmt_offset: INTEGER_32): INTEGER_32
			-- Return type  MtStream which is actually mts_int32
		do
			ctxlock.lock
			Result := c_mt_sql_open_stream (mt_context, a_stmt_offset)
			ctxlock.unlock
		end

   sql_next (a_stream: INTEGER_32): BOOLEAN
			-- Return type is MtStream which is actually mts_int32
		do
			ctxlock.lock
			Result := c_mt_sql_next (mt_context, a_stream)
			ctxlock.unlock
		end

   sql_get_column_type (a_stmt_offset, colnum: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_get_column_type (mt_context, a_stmt_offset, colnum)
			ctxlock.unlock
		end

   sql_find_column_index (stmt_offset: INTEGER_32; c_str_ptr: POINTER): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_find_column_index (mt_context, stmt_offset, c_str_ptr)
			ctxlock.unlock
		end

   sql_get_column_count (stmt_offset: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_get_column_count (mt_context, stmt_offset)
			ctxlock.unlock
		end

   sql_get_column_name (a_stmt_offset, colnum: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_mt_sql_get_column_name (mt_context, a_stmt_offset, colnum)
			ctxlock.unlock
		end

   sql_set_current_row (stream_offset, row_idx: INTEGER_32)
		do
			ctxlock.lock
			c_mt_sql_set_current_row (mt_context, stream_offset, row_idx)
			ctxlock.unlock
		end

   sql_get_row_value_type (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_value_type (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_boolean (stream_offset, colnum: INTEGER_32): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_boolean (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_double (stream_offset, colnum: INTEGER_32): DOUBLE
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_double (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_float (stream_offset, colnum: INTEGER_32): REAL
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_float (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_date (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_date (mt_context, stream_offset, colnum, c_array)
			ctxlock.unlock
		end

   sql_get_row_ts (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_ts (mt_context, stream_offset, colnum, c_array)
			ctxlock.unlock
		end

   sql_get_row_ti (stream_offset, colnum: INTEGER_32; c_array1, c_array2: POINTER): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_ti (mt_context, stream_offset, colnum, c_array1, c_array2)
			ctxlock.unlock
		end

   sql_get_row_ti_days_fsecs (stream_offset, colnum: INTEGER_32; days, fsecs, negative: POINTER): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_ti_days_fsecs (mt_context, stream_offset, colnum, days, fsecs, negative)
			ctxlock.unlock
		end

   sql_get_row_byte (stream_offset, colnum: INTEGER_32): INTEGER_8
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_byte (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_bytes (stream_offset, colnum, size: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_bytes (mt_context, stream_offset, colnum, size, c_array)
			ctxlock.unlock
		end

   sql_get_row_text (stream_offset, colnum: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_text (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_char (stream_offset, colnum: INTEGER_32): CHARACTER
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_char (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_short (stream_offset, colnum: INTEGER_32): INTEGER_16
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_short (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_integer (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_integer (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_long (stream_offset, colnum: INTEGER_32): INTEGER_64
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_long (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_numeric (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_numeric (mt_context, stream_offset, colnum, c_array)
			ctxlock.unlock
		end

   sql_get_row_string (stream_offset, colnum: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_string (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_ref (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_ref (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

   sql_get_row_size (stream_offset, colnum: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_mt_sql_get_row_size (mt_context, stream_offset, colnum)
			ctxlock.unlock
		end

feature -- Stream

   next_object (sid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_next_object (mt_context, sid)
			ctxlock.unlock
		end

   next_property (sid: INTEGER_32): INTEGER_32
		do
			ctxlock.lock
			Result := c_next_property (mt_context, sid)
			ctxlock.unlock
		end

   next_version (sid: INTEGER_32): STRING
		do
			ctxlock.lock
			Result := c_next_version (mt_context, sid)
			ctxlock.unlock
		end

   close_stream (sid: INTEGER_32)
		do
			ctxlock.lock
			c_mt_close_stream (mt_context, sid)
			ctxlock.unlock
		end

feature -- Events Implementation

	event_subscribe (posted_events: INTEGER_64)
		do
			ctxlock.lock
			c_mt_event_subscribe (mt_context, posted_events)
			ctxlock.unlock
		end
	
	event_unsubscribe ()
		do
			ctxlock.lock
			c_mt_event_unsubscribe (mt_context)
			ctxlock.unlock
		end

	event_wait (timeout: INTEGER_32): INTEGER_64
		do
			ctxlock.lock
			Result := c_mt_event_wait (mt_context, timeout)
			ctxlock.unlock
		end
	
	event_notify (events: INTEGER_64) 
		do
			ctxlock.lock
			c_mt_event_notify (mt_context, events)
			ctxlock.unlock
		end

end
