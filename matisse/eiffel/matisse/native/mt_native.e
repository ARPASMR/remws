note
	description: "External C methods for the binding"
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
	MT_NATIVE

feature -- Implementation

	c_get_oids_of_classes (cxn :INTEGER_64; num: INTEGER_32; buf: POINTER)
		external
			"C"
		end

	c_get_classes_count (cxn: INTEGER_64): INTEGER_32
		external
			"C"
		end

feature -- Implementation MTATTRIBUTE

	c_get_attribute (cxn: INTEGER_64; name: POINTER): INTEGER_32
			-- Use MtGetAttrinute.
		external
			"C"
		end

	c_get_attribute_from_names (cxn: INTEGER_64; name, class_name: POINTER): INTEGER_32
			-- Use MtGetClassAttrinute.
		external
			"C"
		end

	c_get_class_attribute (cxn: INTEGER_64; att_name: POINTER; cls_oid: INTEGER_32): INTEGER_32
			-- Use MtGetClassAttrinute.
		external
			"C"
		end

	c_check_attribute (cxn :INTEGER_64; aid, oid: INTEGER_32)
			-- Use Mt_CheckAttribute.
		external
			"C"
		end

	c_get_dimension (cxn :INTEGER_64; oid, aid, rank: INTEGER_32): INTEGER_32
			-- Use Mt_GetDimension.
		external
			"C"
		end

	c_is_default_value (cxn :INTEGER_64; oid, aid: INTEGER_32): BOOLEAN
		-- Use Mt_GetValue to get the default value flag.
		external
			"C"
		end

	c_get_value_type (cxn :INTEGER_64; oid, aid: INTEGER_32): INTEGER_32
			-- Use Mt_GetValue to get the type of an attribute value.
		external
			"C"
		end

	-- MT_BYTE --
	c_get_byte_value (cxn :INTEGER_64; oid, aid: INTEGER_32): NATURAL_8
		external
			"C"
		end

	c_get_byte_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

   -- MT_LONG --
   c_get_integer_64_value (cxn :INTEGER_64; oid, aid: INTEGER_32): INTEGER_64
      external
         "C"
      end

   c_get_integer_64_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
      external
         "C"
      end

	-- MT_INTEGER --
	c_get_integer_value (cxn :INTEGER_64; oid, aid: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_get_integer_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_SHORT --
	c_get_short_value (cxn :INTEGER_64; oid, aid: INTEGER_32): INTEGER_16
		external
			"C"
		end

	c_get_short_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_NUMERIC --
  c_mt_get_numeric_value (cxn :INTEGER_64; oid, aid: INTEGER_32; ptr_array: POINTER)
    external
      "C"
    end

	c_get_numeric_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_DOUBLE --
	c_get_double_value(cxn :INTEGER_64; oid, aid: INTEGER_32): DOUBLE
		external
			"C"
		end

	c_get_double_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_FLOAT --
	c_get_real_value (cxn :INTEGER_64; oid, aid: INTEGER_32): REAL
		external
			"C"
		end

	c_get_real_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_CHAR --
	c_get_char_value (cxn :INTEGER_64; oid, aid: INTEGER_32): CHARACTER
		external
			"C"
		end

	-- MT_STRING --
	c_get_string_value (cxn :INTEGER_64; oid, aid: INTEGER_32): STRING
		external
			"C"
		end

	c_get_string_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: ANY)
		external
			"C"
		end

	-- MT_BOOLEAN --
	c_get_boolean_value (cxn :INTEGER_64; oid, aid: INTEGER_32): BOOLEAN
		external
			"C"
		end

	c_get_boolean_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_DATE --
	c_get_date_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_TIMESTAMP --
	c_get_timestamp_value (cxn :INTEGER_64; oid, aid: INTEGER_32; yr, mh, dy, hr, me, sd, msd: POINTER)
		external
			"C"
		end

	c_get_timestamp_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	-- MT_INTERVAL --
	c_get_interval_value(cxn :INTEGER_64; oid, aid: INTEGER_32) : INTEGER_64
		external
			"C"
		end

	c_get_interval_array (cxn :INTEGER_64; oid, aid, count: INTEGER_32; buf_interval_milisec: POINTER)
		external
			"C"
		end

	--	
	-- Setting values
	--

	c_set_value_integer_64 (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: INTEGER_64; rank: INTEGER_32)
		external
			"C"
		end

	c_set_value_integer (cxn :INTEGER_64; oid, aid, type, value, rank: INTEGER_32)
		external
			"C"
		end

	c_set_value_u8 (cxn :INTEGER_64; oid, aid, value: INTEGER_32)
		external
			"C"
		end

	c_set_value_s16 (cxn :INTEGER_64; oid, aid, value: INTEGER_32)
		external
			"C"
		end

	c_mt_set_value_numeric (cxn :INTEGER_64; oid, aid: INTEGER_32; item1, item2, item3, item4, item5, item6: INTEGER_32)
		external
			"C"
		end

  c_mt_set_value_numeric_list (cxn :INTEGER_64; oid, aid: INTEGER_32; value: POINTER; numElem: INTEGER_32)
		external
			"C"
		end

	c_set_value_double (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: DOUBLE; rank: INTEGER_32)
		external
			"C"
		end

	c_set_value_real (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: REAL)
		external
			"C"
		end

	c_set_value_char (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: CHARACTER; rank: INTEGER_32)
		external
			"C"
		end

	c_set_value_boolean (cxn :INTEGER_64; oid, aid: INTEGER_32; value: BOOLEAN)
		external
			"C"
		end

	c_set_value_boolean_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; buffer: POINTER)
		external
			"C"
		end

	c_set_value_date (cxn :INTEGER_64; oid, aid: INTEGER_32; year, month, day: INTEGER_32)
		external
			"C"
		end

	c_set_value_date_array (cxn :INTEGER_64; oid, aid, size: INTEGER_32; years, months, days: POINTER)
		external
			"C"
		end

	c_set_value_timestamp (cxn :INTEGER_64; oid, aid, year, month, day, hour, minute, second, microsec: INTEGER_32)
		external
			"C"
		end

	c_set_value_timestamp_array (cxn :INTEGER_64; oid, aid, count: INTEGER_32; years, months, days, hours, minutes, seconds, microsecs: POINTER)
		external
			"C"
		end

	c_set_value_time_interval (cxn :INTEGER_64; oid, aid: INTEGER_32; interval_milisec: INTEGER_64)
		external
			"C"
		end

	c_set_value_time_interval_array (cxn :INTEGER_64; oid, aid, count: INTEGER_32; interval_milisec: POINTER)
		external
			"C"
		end

	c_set_value_string (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: POINTER; encoding: INTEGER_32)
		external
			"C"
		end

	c_set_value_array_numeric (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: POINTER; rank, num: INTEGER_32)
		external
			"C"
		end

	c_set_value_short_array (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32)
		external
			"C"
		end

	c_set_value_void (cxn :INTEGER_64; oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32)
		external
			"C"
		end

	c_get_attribute_type (cxn :INTEGER_64; aid: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_set_value_byte_list_elements (cxn :INTEGER_64; oid, aid, type: INTEGER_32; buffer: POINTER;
			count, offset: INTEGER_32; discard_after: BOOLEAN)
		external
			"C"
		end

	c_get_byte_list_elements (cxn :INTEGER_64; oid, aid: INTEGER_32; buffer: POINTER; count, offset: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- Implementation MT_CALLABLE_STATEMENT

	c_mt_sql_get_param_boolean (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : BOOLEAN
			-- Get the boolean param return value (MT_BOOLEAN)
		external
			"C"
		end

	c_mt_sql_get_param_byte (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : INTEGER_8
			-- Get the byte param return value (MT_BYTE)
		external
			"C"
		end

	c_mt_sql_get_param_char (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : CHARACTER
			-- Get the char param return value (MT_CHAR)
		external
			"C"
		end

	c_mt_sql_get_param_double (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : DOUBLE
			-- Get the double param return value (MT_DOUBLE)
		external
			"C"
		end

	c_mt_sql_get_param_float (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : REAL
			-- Get the float param return value (MT_FLOAT)
		external
			"C"
		end

	c_mt_sql_get_param_integer (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : INTEGER_32
			-- Get the integer param return value (MT_INTEGER)
		external
			"C"
		end

	c_mt_sql_get_param_interval (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32; c_array1, c_array2 : POINTER) : BOOLEAN
			-- Get the interval param return value (MT_INTERVAL)
		external
			"C"
		end

	c_mt_sql_get_param_interval_days_fsecs(cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32; days, fsecs, negative: POINTER) : BOOLEAN
			-- Get the interval param return value (MT_INTERVAL)
		external
			"C"
		end

	c_mt_sql_get_param_long (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : INTEGER_64
			-- Get the long param return value (MT_LONG)
		external
			"C"
		end

	c_mt_sql_get_param_numeric (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the interval param return value (MT_NUMERIC)
		external
			"C"
		end

	c_mt_sql_get_param_short (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : INTEGER_16
			-- Get the short param return value (MT_SHORT)
		external
			"C"
		end

	c_mt_sql_get_param_date (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the date param return value (MT_DATE)
		external
			"C"
		end

	c_mt_sql_get_param_timestamp (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN
			-- Get the timestamp param return value (MT_TIMESTAMP)
		external
			"C"
		end

	c_mt_sql_get_param_bytes (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32; sz, c_array : POINTER) : BOOLEAN
			-- Get the bytes param return value (MT_BYTES, MT_AUDIO, MT_IMAGE, MT_VIDEO)
		external
			"C"
		end

	c_mt_sql_get_param_text (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : STRING
			-- Get the text param return value (MT_TEXT)
		external
			"C"
		end

	c_mt_sql_get_param_string (cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32) : STRING
			-- Get the string param return value (MT_STRING)
		external
			"C"
		end

	c_mt_sql_get_param_size(cxn :INTEGER_64; stmt_offset, param_idx : INTEGER_32; size: POINTER) : INTEGER_32
			-- Get the result param size (All types)
		external
			"C"
		end

feature -- Implementation MTNAMESPACE

	c_get_namespace (cxn: INTEGER_64; name: POINTER): INTEGER_32
		-- Use MtCtxGetNamespace.
		external
			"C"
		end

	c_get_schema_object_full_name (cxn :INTEGER_64; oid: INTEGER_32): STRING
		-- Use MtCtxMGetObjectFullName.
		external
			"C"
		end

feature -- Implementation MTCLASS

	c_get_class_from_name (cxn: INTEGER_64; name: POINTER): INTEGER_32
		external
			"C"
		end

	c_get_object_class (cxn :INTEGER_64; oid: INTEGER_32): INTEGER_32
			-- Use MtGetClassFromObject.
		external
			"C"
		end

	c_get_attributes_count (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_GetAllAttributes.
		external
			"C"
		end

	c_get_all_attributes (cxn :INTEGER_64; cid, num: INTEGER_32; buf: POINTER)
			-- Use Mt_GetAllAttributes.
		external
			"C"
		end

	c_get_relationships_count (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_GetAllRelationships.
		external
			"C"
		end

	c_get_all_relationships (cxn :INTEGER_64; cid, num: INTEGER_32; buf: POINTER)
			-- Use Mt_GetAllRelationships.
		external
			"C"
		end

	c_get_inverse_relationships_count (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_GetAllIRelationships.
		external
			"C"
		end

	c_get_all_inverse_relationships (cxn :INTEGER_64; cid, num: INTEGER_32; buf: POINTER)
			-- Use Mt_GetAllIRelationships.
		external
			"C"
		end

	c_get_subclasses_count (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_GetAllISubclasses.
		external
			"C"
		end

	c_get_all_subclasses (cxn :INTEGER_64; cid, num: INTEGER_32; buf: POINTER)
			-- Use Mt_GetAllSubclasses.
		external
			"C"
		end

	c_get_superclasses_count (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_GetAllSuperclasses.
		external
			"C"
		end

	c_get_all_superclasses (cxn :INTEGER_64; cid, num: INTEGER_32; buf: POINTER)
			-- Use Mt_GetAllSuperclasses.
		external
			"C"
		end

	c_get_methods_count (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_MGetAllMethods
		external
			"C"
		end

	c_get_all_methods (cxn :INTEGER_64; cid, num: INTEGER_32; buf: POINTER)
			-- Use Mt_MGetAllMethods
		external
			"C"
		end

	c_get_instances_number (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_GetInstancesNumber.
		external
			"C"
		end

	c_get_own_instances_number (cxn :INTEGER_64; cid: INTEGER_32): INTEGER_32
			-- Use Mt_GetOwnInstancesNumber.
		external
			"C"
		end

	c_get_class_property_from_name (cxn: INTEGER_64; name: POINTER; oid: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- Class Stream

	c_open_instances_stream (cxn :INTEGER_64; cid, num_preftech: INTEGER_32): INTEGER_32
       	 -- Use MtCtx_OpenInstancesStream
		external
			"C"
		end

	c_open_own_instances_stream (cxn :INTEGER_64; cid, num_preftech: INTEGER_32): INTEGER_32
       	 -- Use MtCtx_OpenOwnInstancesStream
		external
			"C"
		end

feature -- Version Stream

	c_open_version_stream (cxn: INTEGER_64): INTEGER_32
		-- Use MtCtxOpenVersionStream
		external
			"C"
		end


feature -- Create Object External

    c_create_object (cxn: INTEGER_64; name: POINTER): INTEGER_32
		external
			"C"
		end

feature -- DB Control Externals

   c_get_last_error_msg (cxn: INTEGER_64): STRING
		-- Use MtError
		external
			"C"
		end

   c_get_last_error_code (cxn: INTEGER_64): INTEGER_32
		-- Use
		external
			"C"
		end

	c_allocate_connection: INTEGER_64
			-- Use MtCtxAllocateContext
		external
			"C"
		end

	c_free_connection (cxn: INTEGER_64)
			-- Use MtCtxFreeContext
		external
			"C"
		end

	c_get_connection_option (cxn :INTEGER_64; option: INTEGER_32): INTEGER_32
			-- Use MtCtxGetConnectionOption
		external
			"C"
		end

	c_set_connection_option (cxn :INTEGER_64; option, value: INTEGER_32)
			-- Use MtCtxSetConnectionOption
		external
			"C"
		end

	c_get_string_connection_option (cxn :INTEGER_64; option: INTEGER_32): STRING
			-- Use MtCtxGetConnectionOption
		external
			"C"
		end

	c_set_string_connection_option (cxn :INTEGER_64; option: INTEGER_32; value: POINTER)
			-- Use MtCtxSetConnectionOption
		external
			"C"
		end

	c_connect_database (cxn: INTEGER_64; host, db, user, passwd: POINTER)
			-- Use MtCtxConnectDatabase
		external
			"C"
		end

	c_disconnect_database (cxn: INTEGER_64)
			-- Use MtCtxGetConnectionState
		external
			"C"
		end

	c_get_connection_state (cxn: INTEGER_64): INTEGER_32
			-- Use MtCtxGetConnectionState
		external
			"C"
		end

	c_start_transaction (cxn :INTEGER_64; priority: INTEGER_32): INTEGER_32
			-- Use MtStartTransaction.
			-- Return the version number.
		external
			"C"
		end

	c_commit_transaction (cxn: INTEGER_64; a_prefix: POINTER) : STRING
			-- Use MtCommitTransaction.
		external
			"C"
		end

	c_abort_transaction (cxn: INTEGER_64)
			-- Use MtAbortTransaction.
		external
			"C"
		end

	c_is_transaction_in_progress (cxn: INTEGER_64) : BOOLEAN
			-- Use MtCtxIsTransactionInProgress.
		external
			"C"
		end

	c_start_version_access (cxn: INTEGER_64; time_name: POINTER): INTEGER_32
			-- Return the version number accessed.
		external
			"C"
		end

	c_end_version_access (cxn: INTEGER_64)
		external
			"C"
		end

	c_is_version_access_in_progress (cxn: INTEGER_64) : BOOLEAN
			-- Use MtCtxIsVersionAccessInProgress
		external
			"C"
		end

	c_preallocate_objects (cxn :INTEGER_64; num: INTEGER_32): INTEGER_32
			-- Use MtCtxPreallocateObjects
			-- Return the number of object preallocated.
		external
			"C"
		end

	c_num_preallocated_objects (cxn: INTEGER_64): INTEGER_32
			-- Use MtCtxNumPreallocatedObjects
			-- Return the number of remaining object preallocated.
		external
			"C"
		end

	c_get_invalid_object (cxn: INTEGER_64): INTEGER_32
			-- Use MtInvalidObject.
		external
			"C"
		end


feature  -- Implementation MTENTRYPOINTDICTIONARY

	c_get_entry_point_dictionary (cxn: INTEGER_64; dict_name: POINTER): INTEGER_32
			-- Get oid of ep dictionary
		external
			"C"
		end

	c_get_object_from_entry_point (cxn: INTEGER_64; ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32
			-- Use MtCtx_GetObjectsFromEntryPoint
		external
			"C"
		end

	c_get_object_number_from_entry_point (cxn: INTEGER_64; ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32
			-- Use MtCtx_GetObjectsFromEntryPoint
		external
			"C"
		end

	c_get_objects_from_entry_point (cxn :INTEGER_64; dict_id, cid: INTEGER_32; ep_name: POINTER): ARRAY[INTEGER_32]
			-- Use Mt_MGetObjectsFromEP.
		external
			"C"
		end

	c_lock_objects_from_entry_point (cxn :INTEGER_64; lock: INTEGER_32; c_ep_name: POINTER; aid, cid: INTEGER_32)
			-- Use LockObjectsFromEP.
		external
			"C"
		end

feature -- Entrypoint Stream

	c_open_entry_point_stream (cxn: INTEGER_64; name: POINTER; ep_id, cid, nb_obj_per_call: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- Implementation MTINDEX

	c_get_index (cxn: INTEGER_64; index_name: POINTER): INTEGER_32
			-- Use MtGetIndex.
		external
			"C"
		end

	c_index_entries_count (cxn :INTEGER_64; iid: INTEGER_32): INTEGER_32
			-- Use MtGetIndexInfo.
		external
			"C"
		end

	c_load_index_info (cxn :INTEGER_64; iid: INTEGER_32; num_classes, crit_class_oids, num_criteria, attrs, types, sizes, orders: POINTER)
			-- Use MtGetIndexInfo.
		external
			"C"
		end

	c_index_lookup (cxn :INTEGER_64; index_oid, class_oid, criteria_count: INTEGER_32;
				       crit_start_array: POINTER): INTEGER_32
		external
			"C"
		end

	c_index_lookup_object (cxn :INTEGER_64; index_oid, class_oid, criteria_count: INTEGER_32;
				              crit_start_array: POINTER): INTEGER_32
		external
			"C"
		end

	c_index_object_number (cxn :INTEGER_64; index_oid, class_oid, criteria_count: INTEGER_32;
				              crit_start_array: POINTER): INTEGER_32
		external
			"C"
		end

feature -- Index Stream

	c_open_index_entries_stream_by_name(cxn: INTEGER_64;
				index_name, class_name: POINTER; direction: INTEGER_32;
				c_cit_start_array, c_crit_end_array:POINTER; nb_obj_per_call: INTEGER_32): INTEGER_32
			-- Use Mt_OpenIndexStream.
		external
			"C"
		end

	c_open_index_entries_stream(cxn :INTEGER_64; index_oid, class_oid, direction, count: INTEGER_32;
				c_cit_start_array, c_crit_end_array: POINTER; nb_obj_per_call: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_open_index_object_stream(cxn :INTEGER_64; index_oid, class_oid, direction, seg_count: INTEGER_32;
				                  start_key, end_key: POINTER; num_preftech: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- MT_DATABASE Implementation

	c_max_buffered_objects (cxn: INTEGER_64): INTEGER_32
			-- Use GetConfigurationInfo.
		external
			"C"
		end

	c_max_index_criteria_number (cxn: INTEGER_64): INTEGER_32
			-- Use GetConfigurationInfo.
		external
			"C"
		end

	c_max_index_key_length (cxn: INTEGER_64): INTEGER_32
			-- Use GetConfigurationInfo.
		external
			"C"
		end

	c_get_num_data_bytes_received (cxn: INTEGER_64): INTEGER_32
			-- Use GetTotalReadBytes.
		external
			"C"
		end

	c_get_num_data_bytes_sent (cxn: INTEGER_64): INTEGER_32
			-- Use GetTotalWriteBytes.
		external
			"C"
		end

feature -- Irelationship Stream

	c_open_predecessors_stream (cxn :INTEGER_64; oid, rid: INTEGER_32): INTEGER_32
			-- Use Mt_OpenIRelStream.
		external
			"C"
		end

feature -- Object Name

	c_object_mt_name (cxn :INTEGER_64; oid: INTEGER_32): STRING
			-- Get a string of attribute "MtName" for the object oid.
		external
			"C"
		end

feature -- Object Attribute Stream

	c_open_attributes_stream (cxn :INTEGER_64; sid: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- Object Creation

	c_create_object_from_cid (cxn :INTEGER_64; class_oid: INTEGER_32) : INTEGER_32
		-- MtCtxCreateObject
		external
			"C"
		end

feature -- Implementation MT_OBJECT

	c_is_predefined_object (cxn :INTEGER_64; oid: INTEGER_32): BOOLEAN
		  -- Use MtPredefinedMSP.
		external
			"C"
		end

	c_check_object(cxn :INTEGER_64; oid: INTEGER_32)
		  -- Use MtCheckInstance.
		external
			"C"
		end

	c_remove_object (cxn :INTEGER_64; oid: INTEGER_32)
		  -- Use MtRemoveObject.
		external
			"C"
		end

	c_remove_value (cxn :INTEGER_64; oid, aid: INTEGER_32)
		  -- Use Mt_RemoveValue.
		external
			"C"
		end

	c_remove_successor (cxn :INTEGER_64; oid, rid, sid: INTEGER_32)
		  -- Use Mt_RemoveSuccessors.
		external
			"C"
		end

	c_remove_all_successors (cxn :INTEGER_64; oid, rid: INTEGER_32)
		  -- Use Mt_RemoveAllSuccessors.
		external
			"C"
		end

	c_remove_successor_ignore_nosuchsucc (cxn :INTEGER_64; pred_oid, rid, succ_oid: INTEGER_32)
		 -- Use Mt_RemoveSuccessors.
		external
			"C"
		end

	c_remove_successors (cxn :INTEGER_64; oid, rid, num: INTEGER_32; succ_oids: POINTER)
			-- Use MtCtx_RemoveNumSuccessors
		external
			"C"
		end

	c_object_size (cxn :INTEGER_64; oid: INTEGER_32): INTEGER_32
		  -- Use MtObjectSize.
		external
			"C"
		end

	c_print_to_file (cxn :INTEGER_64; oid: INTEGER_32;file_pointer: POINTER)
		  -- Use MtPrint.
		external
			"C"
		end

	c_is_instance_of (cxn :INTEGER_64; oid, cid: INTEGER_32): BOOLEAN
		  -- Use MtTypeP.
		external
			"C"
		end

	c_get_added_successors (cxn :INTEGER_64; oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		  -- Use MtGetAllAddedSuccs.
		external
			"C"
		end

	c_get_removed_successors (cxn :INTEGER_64; oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		  -- Use MtGetAllRemSuccs.
		external
			"C"
		end

	c_get_successors (cxn :INTEGER_64; oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		  -- Use MtMGetSuccessors.
		external
			"C"
		end

	c_get_successor_size (cxn :INTEGER_64; oid, rid: INTEGER_32): INTEGER_32
		  -- Use MtMGetSuccessors.
		external
			"C"
		end

	c_get_predecessors (cxn :INTEGER_64; oid, rid: INTEGER_32): ARRAY[INTEGER_32]
		  -- Use MtGetPredecessors.
		external
			"C"
		end

  c_get_predecessors_by_name (cxn :INTEGER_64; oid: INTEGER_32; rshp_name: POINTER): ARRAY[INTEGER_32]
		  -- Use MtGetPredecessors.
		external
			"C"
		end

	c_free_object (cxn :INTEGER_64; oid: INTEGER_32)
		  -- Use MtFreeObjects.
		external
			"C"
		end

	c_add_successor_first (cxn :INTEGER_64; oid, rid, soid: INTEGER_32)
		  -- Use Mt_AddSuccessor MTFIRST.
		external
			"C"
		end

	c_add_successor_append (cxn :INTEGER_64; oid, rid, soid: INTEGER_32)
		  -- Use Mt_AddSuccessor MTAPPEND.
		external
			"C"
		end

	c_add_successor_after (cxn :INTEGER_64; oid, rid, soid, ooid: INTEGER_32)
		  -- Use Mt_AddSuccessor MTAFTER.
		external
			"C"
		end

	c_add_num_successors (cxn :INTEGER_64; oid, rid, num: INTEGER_32; succ_oids: POINTER)
		-- Use MtCtx_AddNumSuccessors
		external
			"C"
		end

	c_set_successor (cxn :INTEGER_64; oid, rid, succ: INTEGER_32)
		-- Use MtCtx_RemoveAllSuccessors + MtCtx_AddSuccessor
		external
			"C"
		end

	c_set_num_successors (cxn :INTEGER_64; oid, rid, num: INTEGER_32; succ_oids: POINTER)
		-- Use MtCtx_RemoveAllSuccessors + MtCtx_AddNumSuccessors
		external
			"C"
		end

	c_set_successors (cxn :INTEGER_64; pred_oid, rid, size: INTEGER_32; succ_oids: POINTER)
		-- Use Mt_SetSuccessors.
		external
			"C"
		end

	c_lock_object (cxn :INTEGER_64; oid, lock: INTEGER_32)
		  -- Use MtLockObjects.
		external
			"C"
		end

	c_load_object (cxn :INTEGER_64; oid: INTEGER_32)
		  -- Use MtLoadObjects.
		external
			"C"
		end

	c_get_successor (cxn :INTEGER_64; pred_oid, rid: INTEGER_32): INTEGER_32
		-- Use Mt_GetSuccessors.
		-- (If there is no successor, return 0).
		external
			"C"
		end

	c_get_single_successor (cxn :INTEGER_64; pred_oid, rid: INTEGER_32): INTEGER_32
			-- Use Mt_GetSuccessors.
			-- This is useful with 'Single-relationship'.
			-- (If there is no successor, return 0).
			-- (If there are more than one successor, return -1).
		external
			"C"
		end

	c_write_lock_object (cxn :INTEGER_64; an_oid: INTEGER_32)
		  -- Use MtLockObjects.
		external
			"C"
		end

	c_read_lock_object (cxn :INTEGER_64; an_oid: INTEGER_32)
		  -- Use MtLockObjects.
		external
			"C"
		end

	c_mt_oid_exist (cxn :INTEGER_64; an_oid: INTEGER_32): BOOLEAN
		external
			"C"
		end

feature -- Object Inverse Relationship Stream

	c_open_inverse_relationships_stream (cxn :INTEGER_64; oid: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- Relationship Stream

	c_open_relationships_stream (cxn :INTEGER_64; sid: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- Implementation MT_PROPERTY

    c_check_property (cxn :INTEGER_64; pid, oid: INTEGER_32): BOOLEAN
      	  -- Use MtCheckProperty.
		external
			"C"
		end

feature -- Implementation MTRELATIONSHIP

	c_get_relationship_from_name (cxn: INTEGER_64; name: POINTER): INTEGER_32
			-- Use GetRelationship.
		external
			"C"
		end

	c_get_relationship_from_names (cxn: INTEGER_64; name, class_name: POINTER): INTEGER_32
			-- Use GetClassRelationship.
		external
			"C"
		end

	c_get_class_relationship (cxn: INTEGER_64; rel_name: POINTER; cls_oid: INTEGER_32): INTEGER_32
			-- Use GetClassRelationship.
		external
			"C"
		end

	c_check_relationship (cxn :INTEGER_64; rid, oid: INTEGER_32)
			-- Use Mt_CheckRelationship.
		external
			"C"
		end

	c_get_max_cardinality (cxn :INTEGER_64; relationship_oid: INTEGER_32): INTEGER_32
		external
			"C"
		alias
			"c_get_max_cardinality_relationship"
		end

	c_remove_all_succs_ignerr (cxn :INTEGER_64; rid, oid, sts: INTEGER_32)
			-- Remove all successors of oid-object through rid-
			-- relationship.
			-- Ignore the error sts.
		external
			"C"
		end

	c_remove_all_succs_ignore_nosuccessors (cxn :INTEGER_64; rid, oid: INTEGER_32)
			-- Remove all successors of oid-object through rid-
			-- relationship.
			-- Ignore the error MT_PERSISTER_NOSUCCESSORS.
		external
			"C"
		end

	c_clear_all_successors (cxn :INTEGER_64; oid, rid: INTEGER_32)
			-- Remove all successors
		external
			"C"
		end

	c_append_successor_ignore_alreadysucc(cxn :INTEGER_64; oid, rid, soid: INTEGER_32)
		external
			"C"
		end
	c_add_successor_first_ignore_alreadysucc(cxn :INTEGER_64; oid, rid, soid: INTEGER_32)
		external
			"C"
		end

	c_get_relationship_class_name (cxn :INTEGER_64; rid: INTEGER_32): STRING
		external
			"C"
		end

	c_get_inverse_relationship (cxn :INTEGER_64; rid: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- Relationship Stream

	c_open_successors_stream (cxn :INTEGER_64; oid, rid: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_open_successors_stream_by_name (cxn :INTEGER_64; oid: INTEGER_32; rel_name: POINTER): INTEGER_32
		external
			"C"
		end

feature  -- SQL

	c_mt_sql_alloc_stmt (cxn: INTEGER_64): INTEGER_32
		external
			"C"
		end

	c_mt_sql_free_stmt (cxn :INTEGER_64; a_stmt_offset: INTEGER_32)
		external
			"C"
		end

	c_mt_sql_exec_query (cxn :INTEGER_64; a_stmt_offset: INTEGER_32; statement: POINTER)
			-- Execute a select query.
		external
			"C"
		end

	c_mt_sql_exec_update (cxn :INTEGER_64; a_stmt_offset: INTEGER_32; statement: POINTER): INTEGER_32
			-- Execute a update, insert, delete stmt.
			-- (returns the number of objects affected)
		external
			"C"
		end

	c_mt_sql_exec (cxn :INTEGER_64; a_stmt_offset: INTEGER_32; statement: POINTER): BOOLEAN
			-- Execute any SQL statement
		external
			"C"
		end

	c_mt_sql_get_update_count (cxn :INTEGER_64; a_stmt_offset: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_sql_get_stmt_type (cxn :INTEGER_64; a_stmt_offset: INTEGER_32): INTEGER
		external
			"C"
		end

	c_mt_sql_get_stmt_info (cxn :INTEGER_64; a_stmt_offset, a_stmt_attr: INTEGER_32): STRING
		external
			"C"
		end

	c_mt_sql_open_stream (cxn :INTEGER_64; a_stmt_offset: INTEGER_32): INTEGER_32
			-- Return type  MtStream which is actually mts_int32
		external
			"C"
		end

	c_mt_sql_next (cxn :INTEGER_64; a_stream: INTEGER_32): BOOLEAN
			-- Return type is MtStream which is actually mts_int32
		external
			"C"
		end

	c_mt_sql_get_column_type (cxn :INTEGER_64; a_stmt_offset, colnum: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_find_column_index (cxn :INTEGER_64; stmt_offset: INTEGER_32; c_str_ptr: POINTER): INTEGER_32
		external
			"C"
		end

	c_mt_get_column_count (cxn :INTEGER_64; stmt_offset: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_sql_get_column_name (cxn :INTEGER_64; a_stmt_offset, colnum: INTEGER_32): STRING
		external
			"C"
		end

	c_mt_sql_set_current_row (cxn :INTEGER_64; stream_offset, row_idx: INTEGER_32)
		external
			"C"
		end

	c_mt_sql_get_row_value_type (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_sql_get_row_boolean (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): BOOLEAN
		external
			"C"
		end

	c_mt_sql_get_row_double (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): DOUBLE
		external
			"C"
		end

	c_mt_sql_get_row_float (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): REAL
		external
			"C"
		end

	c_mt_sql_get_row_date (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		external
			"C"
		end

	c_mt_sql_get_row_ts (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		external
			"C"
		end

	c_mt_sql_get_row_ti (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32; c_array1, c_array2: POINTER): BOOLEAN
		external
			"C"
		end

	c_mt_sql_get_row_ti_days_fsecs (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32; days, fsecs, negative: POINTER): BOOLEAN
		external
			"C"
		end

	c_mt_sql_get_row_byte (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): INTEGER_8
		external
			"C"
		end

	c_mt_sql_get_row_bytes (cxn :INTEGER_64; stream_offset, colnum, size: INTEGER_32; c_array: POINTER): BOOLEAN
		external
			"C"
		end

	c_mt_sql_get_row_text (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): STRING
		external
			"C"
		end

	c_mt_sql_get_row_char (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): CHARACTER
		external
			"C"
		end

	c_mt_sql_get_row_short (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): INTEGER_16
		external
			"C"
		end

	c_mt_sql_get_row_integer (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_sql_get_row_long (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): INTEGER_64
		external
			"C"
		end

	c_mt_sql_get_row_numeric (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN
		external
			"C"
		end

	c_mt_sql_get_row_string (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): STRING
		external
			"C"
		end

	c_mt_sql_get_row_ref (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): INTEGER_32
		external
			"C"
		end

	c_mt_sql_get_row_size (cxn :INTEGER_64; stream_offset, colnum: INTEGER_32): INTEGER_32
		external
			"C"
		end

feature -- ITERATOR

	c_next_object (cxn :INTEGER_64; sid: INTEGER_32): INTEGER_32
	        -- Use MtNextObject.
		external
			"C"
		end

	c_next_property (cxn :INTEGER_64; sid: INTEGER_32): INTEGER_32
       	 -- Use MtNextProperty.
		external
			"C"
		end

	c_next_version (cxn :INTEGER_64; sid: INTEGER_32): STRING
       	 -- Use MtCtxNextVersion
		external
			"C"
		end

	c_mt_close_stream (cxn :INTEGER_64; sid: INTEGER_32)
	        -- Use MtCloseStream
		external
			"C"
		end


feature -- Events Implementation

	c_mt_event_subscribe (cxn: INTEGER_64; posted_events: INTEGER_64)
		-- Use MtCtxEventSubscribe
		external
			"C"
		end

	c_mt_event_unsubscribe (cxn: INTEGER_64)
		-- Use MtCtxEventUnsubscribe
		external
			"C"
		end

	c_mt_event_wait (cxn :INTEGER_64; timeout: INTEGER_32): INTEGER_64
		-- Use MtCtxEventWait
		external
			"C"
		end

	c_mt_event_notify (cxn: INTEGER_64; events: INTEGER_64)
		-- Use MtCtxEventNotify
		external
			"C"
		end

feature -- Eiffel Reflection Implementation

	c_get_eif_type_id (c_class_name: POINTER; proxi: BOOLEAN): INTEGER_32
		external
			"C"
		end

	c_generic_type_id (c_type_name: POINTER): INTEGER_32
		external
			"C"
		end

	c_dynamic_create_storable_eif_object (cxn :INTEGER_64; mtoid: INTEGER_32): MT_OBJECT
		external
			"C"
		end

	c_dynamic_create_proxi_eif_object (cxn :INTEGER_64; mtoid: INTEGER_32): MTOBJECT
		external
			"C"
		end

	c_create_empty_rs_container (cxn: INTEGER_64; name: POINTER; pred_oid, rel_oid: INTEGER_32): ANY
		-- actual type is MT_RS_CONTAINABLE but not used by proxi so
		-- performance penalty is for storable only
		external
			"C"
		end


feature -- Byte array manipulation

	put_byte_array_to_file (file_pointer: POINTER; byte_array: POINTER; count: INTEGER_32): INTEGER_32
			-- Write 'byte_array' at current position.
			-- Return the number of bytes written.
		external
			"C"
		end


end -- class MT_NATIVE

