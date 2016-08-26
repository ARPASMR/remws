note
	description: "Abstract Context class for the binding"
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

deferred class
	MT_CONTEXT

inherit
	MT_NATIVE

feature {MT_DATABASE} -- Schema Object Cache
	get_cached (a_schema_cache: HASH_TABLE[MTOBJECT, STRING]; a_sch_name : STRING) : MTOBJECT
		require
			not_void: a_schema_cache /= Void and a_sch_name /= Void
		deferred
		end
	set_cached (a_schema_cache: HASH_TABLE[MTOBJECT, STRING]; a_sch_name: STRING; sch_obj: MTOBJECT)
		require
			not_void: a_schema_cache /= Void and a_sch_name /= Void and sch_obj /= Void
		deferred
		end

feature {MT_DATABASE} -- Abstract Methods
   get_last_error_msg (): STRING deferred end
   get_last_error_code (): INTEGER_32 deferred end
   get_connection_option (option: INTEGER_32): INTEGER_32 deferred end
   set_connection_option (option, value: INTEGER_32) deferred end
   get_string_connection_option (option: INTEGER_32): STRING deferred end
   set_string_connection_option (option: INTEGER_32; value: POINTER) deferred end
   connect_database (host, db, user, passwd: POINTER) deferred end
   disconnect_database () deferred end
   get_connection_state (): INTEGER_32 deferred end
   start_transaction (priority: INTEGER_32): INTEGER_32 deferred end
   commit_transaction (a_prefix: POINTER): STRING deferred end
   abort_transaction () deferred end
   is_transaction_in_progress () : BOOLEAN deferred end
   start_version_access (time_name: POINTER): INTEGER_32 deferred end
   end_version_access () deferred end
   is_version_access_in_progress () : BOOLEAN deferred end
   preallocate_objects (num: INTEGER_32): INTEGER_32 deferred end
   num_preallocated_objects (): INTEGER_32 deferred end

feature {ANY} -- Abstract Methods
   get_oids_of_classes (num: INTEGER_32; buf: POINTER) deferred end
   get_classes_count (): INTEGER_32 deferred end
   get_attribute (name: POINTER): INTEGER_32 deferred end
   get_attribute_from_names (name, class_name: POINTER): INTEGER_32 deferred end
   get_class_attribute (att_name: POINTER; cls_oid: INTEGER_32): INTEGER_32 deferred end
   check_attribute (aid, oid: INTEGER_32) deferred end
   get_dimension (oid, aid, rank: INTEGER_32): INTEGER_32 deferred end
   is_default_value (oid, aid: INTEGER_32): BOOLEAN deferred end
   get_value_type (oid, aid: INTEGER_32): INTEGER_32 deferred end
   get_byte_value (oid, aid: INTEGER_32): NATURAL_8 deferred end
   get_byte_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_integer_64_value (oid, aid: INTEGER_32): INTEGER_64 deferred end
   get_integer_64_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_integer_value (oid, aid: INTEGER_32): INTEGER_32 deferred end
   get_integer_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_short_value (oid, aid: INTEGER_32): INTEGER_16 deferred end
   get_short_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_numeric_value (oid, aid: INTEGER_32; ptr_array: POINTER) deferred end
   get_numeric_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_double_value(oid, aid: INTEGER_32): DOUBLE deferred end
   get_double_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_real_value (oid, aid: INTEGER_32): REAL deferred end
   get_real_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_char_value (oid, aid: INTEGER_32): CHARACTER deferred end
   get_string_value (oid, aid: INTEGER_32): STRING deferred end
   get_string_array (oid, aid, size: INTEGER_32; buffer: ANY) deferred end
   get_boolean_value (oid, aid: INTEGER_32): BOOLEAN deferred end
   get_boolean_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_date_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_timestamp_value (oid, aid: INTEGER_32; yr, mh, dy, hr, me, sd, msd: POINTER) deferred end
   get_timestamp_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   get_interval_value(oid, aid: INTEGER_32) : INTEGER_64 deferred end
   get_interval_array (oid, aid, count: INTEGER_32; buf_interval_milisec: POINTER) deferred end
   set_value_integer_64 (oid, aid, type: INTEGER_32; value: INTEGER_64; rank: INTEGER_32) deferred end
   set_value_integer (oid, aid, type, value, rank: INTEGER_32) deferred end
   set_value_u8 (oid, aid, value: INTEGER_32) deferred end
   set_value_s16 (oid, aid, value: INTEGER_32) deferred end
   mt_set_value_numeric (oid, aid: INTEGER_32; item1, item2, item3, item4, item5, item6: INTEGER_32) deferred end
   mt_set_value_numeric_list (oid, aid: INTEGER_32; value: POINTER; numElem: INTEGER_32) deferred end
   set_value_double (oid, aid, type: INTEGER_32; value: DOUBLE; rank: INTEGER_32) deferred end
   set_value_real (oid, aid, type: INTEGER_32; value: REAL) deferred end
   set_value_char (oid, aid, type: INTEGER_32; value: CHARACTER; rank: INTEGER_32) deferred end
   set_value_boolean (oid, aid: INTEGER_32; value: BOOLEAN) deferred end
   set_value_boolean_array (oid, aid, size: INTEGER_32; buffer: POINTER) deferred end
   set_value_date (oid, aid: INTEGER_32; year, month, day: INTEGER_32) deferred end
   set_value_date_array (oid, aid, size: INTEGER_32; years, months, days: POINTER) deferred end
   set_value_timestamp (oid, aid, year, month, day, hour, minute, second, microsec: INTEGER_32) deferred end
   set_value_timestamp_array (oid, aid, count: INTEGER_32; years, months, days, hours, minutes, seconds, microsecs: POINTER) deferred end
   set_value_time_interval (oid, aid: INTEGER_32; interval_milisec: INTEGER_64) deferred end
   set_value_time_interval_array (oid, aid, count: INTEGER_32; interval_milisec: POINTER) deferred end
   set_value_string (oid, aid, type: INTEGER_32; value: POINTER; encoding: INTEGER_32) deferred end
   set_value_array_numeric (oid, aid, type: INTEGER_32; value: POINTER; rank, num: INTEGER_32) deferred end
   set_value_short_array (oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32) deferred end
   set_value_void (oid, aid, type: INTEGER_32; value: POINTER; rank: INTEGER_32) deferred end
   get_attribute_type (aid: INTEGER_32): INTEGER_32 deferred end
   set_value_byte_list_elements (oid, aid, type: INTEGER_32; buffer: POINTER; count, offset: INTEGER_32; discard_after: BOOLEAN) deferred end
   get_byte_list_elements (oid, aid: INTEGER_32; buffer: POINTER; count, offset: INTEGER_32): INTEGER_32 deferred end
   sql_get_param_boolean (stmt_offset, param_idx : INTEGER_32) : BOOLEAN deferred end
   sql_get_param_byte (stmt_offset, param_idx : INTEGER_32) : INTEGER_8 deferred end
   sql_get_param_char (stmt_offset, param_idx : INTEGER_32) : CHARACTER deferred end
   sql_get_param_double (stmt_offset, param_idx : INTEGER_32) : DOUBLE deferred end
   sql_get_param_float (stmt_offset, param_idx : INTEGER_32) : REAL deferred end
   sql_get_param_integer (stmt_offset, param_idx : INTEGER_32) : INTEGER_32 deferred end
   sql_get_param_interval (stmt_offset, param_idx : INTEGER_32; c_array1, c_array2 : POINTER) : BOOLEAN deferred end
   sql_get_param_interval_days_fsecs(stmt_offset, param_idx : INTEGER_32; days, fsecs, negative: POINTER) : BOOLEAN deferred end
   sql_get_param_long (stmt_offset, param_idx : INTEGER_32) : INTEGER_64 deferred end
   sql_get_param_numeric (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN deferred end
   sql_get_param_short (stmt_offset, param_idx : INTEGER_32) : INTEGER_16 deferred end
   sql_get_param_date (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN deferred end
   sql_get_param_timestamp (stmt_offset, param_idx : INTEGER_32; c_array : POINTER) : BOOLEAN deferred end
   sql_get_param_bytes (stmt_offset, param_idx : INTEGER_32; sz, c_array : POINTER) : BOOLEAN deferred end
   sql_get_param_text (stmt_offset, param_idx : INTEGER_32) : STRING deferred end
   sql_get_param_string (stmt_offset, param_idx : INTEGER_32) : STRING deferred end
   sql_get_param_size(stmt_offset, param_idx : INTEGER_32; size: POINTER) : INTEGER_32 deferred end
   get_namespace (name: POINTER): INTEGER_32 deferred end
   get_schema_object_full_name (oid: INTEGER_32): STRING deferred end
   get_class_from_name (name: POINTER): INTEGER_32 deferred end
   get_object_class (oid: INTEGER_32): INTEGER_32 deferred end
   get_attributes_count (cid: INTEGER_32): INTEGER_32 deferred end
   get_all_attributes (cid, num: INTEGER_32; buf: POINTER) deferred end
   get_relationships_count (cid: INTEGER_32): INTEGER_32 deferred end
   get_all_relationships (cid, num: INTEGER_32; buf: POINTER) deferred end
   get_inverse_relationships_count (cid: INTEGER_32): INTEGER_32 deferred end
   get_all_inverse_relationships (cid, num: INTEGER_32; buf: POINTER) deferred end
   get_subclasses_count (cid: INTEGER_32): INTEGER_32 deferred end
   get_all_subclasses (cid, num: INTEGER_32; buf: POINTER) deferred end
   get_superclasses_count (cid: INTEGER_32): INTEGER_32 deferred end
   get_all_superclasses (cid, num: INTEGER_32; buf: POINTER) deferred end
   get_methods_count (cid: INTEGER_32): INTEGER_32 deferred end
   get_all_methods (cid, num: INTEGER_32; buf: POINTER) deferred end
   get_instances_number (cid: INTEGER_32): INTEGER_32 deferred end
   get_own_instances_number (cid: INTEGER_32): INTEGER_32 deferred end
   get_class_property_from_name (name: POINTER; oid: INTEGER_32): INTEGER_32 deferred end
   open_instances_stream (cid, num_preftech: INTEGER_32): INTEGER_32 deferred end
   open_own_instances_stream (cid, num_preftech: INTEGER_32): INTEGER_32 deferred end
   open_version_stream (): INTEGER_32 deferred end
   create_object (name: POINTER): INTEGER_32 deferred end
   get_invalid_object (): INTEGER_32 deferred end
   get_entry_point_dictionary (dict_name: POINTER): INTEGER_32 deferred end
   get_object_from_entry_point (ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32 deferred end
   get_object_number_from_entry_point (ep_name: POINTER; dict_id, cid: INTEGER_32): INTEGER_32 deferred end
   get_objects_from_entry_point (dict_id, cid: INTEGER_32; ep_name: POINTER): ARRAY[INTEGER_32] deferred end
   lock_objects_from_entry_point (lock: INTEGER_32; c_ep_name: POINTER; aid, cid: INTEGER_32) deferred end
   open_entry_point_stream (name: POINTER; ep_id, cid, nb_obj_per_call: INTEGER_32): INTEGER_32 deferred end
   get_index (index_name: POINTER): INTEGER_32 deferred end
   index_entries_count (iid: INTEGER_32): INTEGER_32 deferred end
   load_index_info (iid: INTEGER_32; num_classes, crit_class_oids, num_criteria, attrs, types, sizes, orders: POINTER) deferred end
   index_lookup (index_oid, class_oid, criteria_count: INTEGER_32; crit_start_array: POINTER): INTEGER_32 deferred end
   index_lookup_object (index_oid, class_oid, criteria_count: INTEGER_32; crit_array: POINTER): INTEGER_32 deferred end
   index_object_number (index_oid, class_oid, criteria_count: INTEGER_32; crit_array: POINTER): INTEGER_32 deferred end
   open_index_entries_stream_by_name(index_name, class_name: POINTER; direction: INTEGER_32;
	                                  c_cit_start_array, c_crit_end_array: POINTER;
	                                  nb_obj_per_call: INTEGER_32): INTEGER_32 deferred end
   open_index_entries_stream(index_oid, class_oid, direction, count: INTEGER_32;
	                          c_cit_start_array, c_crit_end_array: POINTER; nb_obj_per_call: INTEGER_32): INTEGER_32 deferred end
   open_index_object_stream(index_oid, class_oid, direction, seg_count: INTEGER_32;
	                         start_key, end_key: POINTER; num_preftech: INTEGER_32): INTEGER_32 deferred end
   max_buffered_objects (): INTEGER_32 deferred end
   max_index_criteria_number (): INTEGER_32 deferred end
   max_index_key_length (): INTEGER_32 deferred end
   get_num_data_bytes_received (): INTEGER_32 deferred end
   get_num_data_bytes_sent (): INTEGER_32 deferred end
   open_predecessors_stream (oid, rid: INTEGER_32): INTEGER_32 deferred end
   object_mt_name (oid: INTEGER_32): STRING deferred end
   open_attributes_stream (sid: INTEGER_32): INTEGER_32 deferred end
   dynamic_create_storable_eif_object (mtoid: INTEGER_32): MT_OBJECT deferred end
   dynamic_create_proxi_eif_object (mtoid: INTEGER_32): MTOBJECT deferred end
   create_empty_rs_container (name: POINTER; pred_oid, rel_oid: INTEGER_32): ANY deferred end
   create_object_from_cid (class_oid: INTEGER_32) : INTEGER_32 deferred end
   is_predefined_object (oid: INTEGER_32): BOOLEAN deferred end
   check_object(oid: INTEGER_32) deferred end
   remove_object (oid: INTEGER_32) deferred end
   remove_value (oid, aid: INTEGER_32) deferred end
   remove_successor (oid, rid, sid: INTEGER_32) deferred end
   remove_all_successors (oid, rid: INTEGER_32) deferred end
   clear_all_successors (oid, rid: INTEGER_32) deferred end
   remove_successor_ignore_nosuchsucc (pred_oid, rid, succ_oid: INTEGER_32) deferred end
   remove_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER) deferred end
   object_size (oid: INTEGER_32): INTEGER_32 deferred end
   print_to_file (oid: INTEGER_32;file_pointer: POINTER) deferred end
   is_instance_of (oid, cid: INTEGER_32): BOOLEAN deferred end
   get_added_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32] deferred end
   get_removed_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32] deferred end
   get_successors (oid, rid: INTEGER_32): ARRAY[INTEGER_32] deferred end
   get_successor_size (oid, rid: INTEGER_32): INTEGER_32 deferred end
   get_predecessors (oid, rid: INTEGER_32): ARRAY[INTEGER_32] deferred end
   get_predecessors_by_name (oid: INTEGER_32; rshp_name: POINTER): ARRAY[INTEGER_32] deferred end
   free_object (oid: INTEGER_32) deferred end
   add_successor_first (oid, rid, soid: INTEGER_32) deferred end
   add_successor_append (oid, rid, soid: INTEGER_32) deferred end
   add_successor_after (oid, rid, soid, ooid: INTEGER_32) deferred end
   add_num_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER) deferred end
   set_successor (oid, rid, succ: INTEGER_32) deferred end
   set_num_successors (oid, rid, num: INTEGER_32; succ_oids: POINTER) deferred end
   set_successors (pred_oid, rid, size: INTEGER_32; succ_oids: POINTER) deferred end
   lock_object (oid, lock: INTEGER_32) deferred end
   load_object (oid: INTEGER_32) deferred end
   get_single_successor (pred_oid, rid: INTEGER_32): INTEGER_32 deferred end
   get_successor (pred_oid, rid: INTEGER_32): INTEGER_32 deferred end
   write_lock_object (an_oid: INTEGER_32) deferred end
   read_lock_object (an_oid: INTEGER_32) deferred end
   mt_oid_exist (an_oid: INTEGER_32): BOOLEAN deferred end
   open_inverse_relationships_stream (oid: INTEGER_32): INTEGER_32 deferred end
   open_relationships_stream (sid: INTEGER_32): INTEGER_32 deferred end
   check_property (pid, oid: INTEGER_32): BOOLEAN deferred end
   get_relationship_from_name (name: POINTER): INTEGER_32 deferred end
   get_relationship_from_names (name, class_name: POINTER): INTEGER_32 deferred end
   get_class_relationship (rel_name: POINTER; cls_oid: INTEGER_32): INTEGER_32 deferred end
   check_relationship (rid, oid: INTEGER_32) deferred end
   get_max_cardinality (relationship_oid: INTEGER_32): INTEGER_32 deferred end
   remove_all_succs_ignerr (rid, oid, sts: INTEGER_32) deferred end
   remove_all_succs_ignore_nosuccessors (rid, oid: INTEGER_32) deferred end
   append_successor_ignore_alreadysucc(oid, rid, soid: INTEGER_32) deferred end
   add_successor_first_ignore_alreadysucc(oid, rid, soid: INTEGER_32) deferred end
   get_relationship_class_name (rid: INTEGER_32): STRING deferred end
   get_inverse_relationship (rid: INTEGER_32): INTEGER_32 deferred end
   open_successors_stream (oid, rid: INTEGER_32): INTEGER_32 deferred end
   open_successors_stream_by_name (oid: INTEGER_32; rel_name: POINTER): INTEGER_32 deferred end
   sql_alloc_stmt (): INTEGER_32 deferred end
   sql_free_stmt (a_stmt_offset: INTEGER_32) deferred end
   sql_exec_query (a_stmt_offset: INTEGER_32; statement: POINTER) deferred end
   sql_exec_update (a_stmt_offset: INTEGER_32; statement: POINTER): INTEGER_32 deferred end
   sql_exec (a_stmt_offset: INTEGER_32; statement: POINTER): BOOLEAN deferred end
   sql_get_update_count (a_stmt_offset: INTEGER_32): INTEGER_32 deferred end
   sql_get_stmt_type (a_stmt_offset: INTEGER_32): INTEGER_32 deferred end
   sql_get_stmt_info (a_stmt_offset, a_stmt_attr: INTEGER_32): STRING deferred end
   sql_open_stream (a_stmt_offset: INTEGER_32): INTEGER_32 deferred end
   sql_next (a_stream: INTEGER_32): BOOLEAN deferred end
   sql_get_column_type (a_stmt_offset, colnum: INTEGER_32): INTEGER_32 deferred end
   sql_find_column_index (stmt_offset: INTEGER_32; c_str_ptr: POINTER): INTEGER_32 deferred end
   sql_get_column_count (stmt_offset: INTEGER_32): INTEGER_32 deferred end
   sql_get_column_name (a_stmt_offset, colnum: INTEGER_32): STRING deferred end
   sql_set_current_row (stream_offset, row_idx: INTEGER_32) deferred end
   sql_get_row_value_type (stream_offset, colnum: INTEGER_32): INTEGER_32 deferred end
   sql_get_row_boolean (stream_offset, colnum: INTEGER_32): BOOLEAN deferred end
   sql_get_row_double (stream_offset, colnum: INTEGER_32): DOUBLE deferred end
   sql_get_row_float (stream_offset, colnum: INTEGER_32): REAL deferred end
   sql_get_row_date (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN deferred end
   sql_get_row_ts (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN deferred end
   sql_get_row_ti (stream_offset, colnum: INTEGER_32; c_array1, c_array2: POINTER): BOOLEAN deferred end
   sql_get_row_ti_days_fsecs (stream_offset, colnum: INTEGER_32; days, fsecs, negative: POINTER): BOOLEAN deferred end
   sql_get_row_byte (stream_offset, colnum: INTEGER_32): INTEGER_8 deferred end
   sql_get_row_bytes (stream_offset, colnum, size: INTEGER_32; c_array: POINTER): BOOLEAN deferred end
   sql_get_row_text (stream_offset, colnum: INTEGER_32): STRING deferred end
   sql_get_row_char (stream_offset, colnum: INTEGER_32): CHARACTER deferred end
   sql_get_row_short (stream_offset, colnum: INTEGER_32): INTEGER_16 deferred end
   sql_get_row_integer (stream_offset, colnum: INTEGER_32): INTEGER_32 deferred end
   sql_get_row_long (stream_offset, colnum: INTEGER_32): INTEGER_64 deferred end
   sql_get_row_numeric (stream_offset, colnum: INTEGER_32; c_array: POINTER): BOOLEAN deferred end
   sql_get_row_string (stream_offset, colnum: INTEGER_32): STRING deferred end
   sql_get_row_ref (stream_offset, colnum: INTEGER_32): INTEGER_32 deferred end
   sql_get_row_size (stream_offset, colnum: INTEGER_32): INTEGER_32 deferred end
   next_object (sid: INTEGER_32): INTEGER_32 deferred end
   next_property (sid: INTEGER_32): INTEGER_32 deferred end
   next_version (sid: INTEGER_32): STRING deferred end
   close_stream (sid: INTEGER_32) deferred end

feature -- Events Implementation
	
   event_subscribe (posted_events: INTEGER_64) deferred end
   event_unsubscribe () deferred end
   event_wait (timeout: INTEGER_32): INTEGER_64 deferred end
   event_notify (events: INTEGER_64) deferred end

end
