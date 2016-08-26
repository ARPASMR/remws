note
	description: "Unit tests for class MT_SUBSCRIPTION_MANAGER."
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

	Contributor(s): Neal L Lester
	]"

deferred class
	TEST_MT_SUBSCRIPTION_MANAGER

inherit

	TS_TEST_CASE
		redefine
			set_up, tear_down
		end

	COMMON_FEATURES

feature


	set_up is
		do
			-- create appl.set_login(target_host, target_database)
			-- appl.set_base
			create appl.make(target_host, target_database)
			appl.open
			appl.set_subscription_manager (subscription_manager)
		end

	tear_down is
		do
			if appl.is_transaction_in_progress then
				appl.abort_transaction
			elseif appl.is_version_access_in_progress then
				appl.end_version_access
			end
			appl.close
		end

	test_mt_subscription_manager is
			-- Test the subscription manager
		local
			my_subscriber: MY_SUBSCRIBER
			super: SUPER
			property: INTEGER
		do
			create my_subscriber
			create super.make ("Test")
			appl.start_transaction (0)
			appl.persist (super)
			subscription_manager.subscribe_property_updates (super, my_subscriber, super.oids_of_property_names (<<"identifier">>))
			property := super.oid_of_property_name ("identifier")
			my_subscriber.subscribed_properties.compare_objects
			assert ("my_subscriber.subscribed_properties has identifier", my_subscriber.subscribed_properties.has (subscription_manager.key (super.oid, property)))
			assert ("My subscriber not updated before update", not my_subscriber.was_updated)
			super.set_identifier ("Another Test")
			assert ("My subscriber updated after update", my_subscriber.was_updated)
			appl.commit
			assert ("My subscriber updated after update and commit", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("My subscriber not updated before update and reset", not my_subscriber.was_updated)
			subscription_manager.unsubscribe_all_property_updates (my_subscriber)
			appl.start_transaction (0)
			super.set_identifier ("Another Test")
			assert ("My subscriber not updated after unsubscribe", not my_subscriber.was_updated)
			appl.commit
			assert ("My subscriber not updated after unsubscribe and commit", not my_subscriber.was_updated)
			subscription_manager.subscribe_all_notifications (my_subscriber)
			assert ("My subscriber not updated after subscribe_all_notifications", not my_subscriber.was_updated)
			appl.start_transaction (0)
			super.set_identifier ("Yet Another Test")
			assert ("My subscriber updated after update with subscribe_all_notifications", my_subscriber.was_updated)
			appl.commit
			assert ("My subscriber updated after update with subscribe_all_notifications and commit", my_subscriber.was_updated)
			subscription_manager.subscribe_all_notifications (Void)
			my_subscriber.reset_was_updated
			appl.start_transaction (0)
			super.set_identifier ("Yet Another Testing Test")
			assert ("My subscriber not updated after subscribe_all_notifications (Void)", not my_subscriber.was_updated)
			appl.commit
			assert ("My subscriber not updated after subscribe_all_notifications (Void)", not my_subscriber.was_updated)
		end


	test_attribute_notifications is
			-- Test notification of subscribers after attribute updates
		local
			my_subscriber: MY_SUBSCRIBER
			attributes: ATTRS_CLASS
			double_list: LINKED_LIST [DOUBLE]
			real_list: LINKED_LIST [REAL]
			date1, date2, date3: DATE
			date_list: LINKED_LIST [DATE]
			date_time1, date_time2, date_time3: DATE_TIME
			date_time_list: LINKED_LIST [DATE_TIME]
			duration1, duration2, duration3: DATE_TIME_DURATION
			-- duration_list: LINKED_LIST [DATE_TIME_DURATION]
			integer_list: LINKED_LIST [INTEGER]
			int16_1, int16_2, int16_3: INTEGER_16
			int16_list: LINKED_LIST [INTEGER_16]
			int64_1, int64_2, int64_3: INTEGER_64
			int64_list: LINKED_LIST [INTEGER_64]
			decimal1, decimal2, decimal3: DECIMAL
			decimal_list: LINKED_LIST [DECIMAL]
			boolean_list: LINKED_LIST [BOOLEAN]
			string_list: LINKED_LIST [STRING]
			test_string: STRING
		do
			appl.start_transaction (0)
			create attributes
			appl.persist (attributes)
			create my_subscriber
			subscription_manager.subscribe_property_updates (attributes, my_subscriber, attributes.oids_of_property_names (<<"att_double", "att_double_null">>))
			assert ("attributes 1", not my_subscriber.was_updated)
			attributes.set_att_double (45.45)
			assert ("attributes 2", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 3", not my_subscriber.was_updated)
			attributes.set_att_double_null (45.45)
			assert ("attributes 4", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 5", not my_subscriber.was_updated)
			attributes.set_att_double_array (<<45.45, 45.45, 45.45>>)
			assert ("attributes 6", not my_subscriber.was_updated)
			subscription_manager.subscribe_property_updates (attributes, my_subscriber, attributes.oids_of_property_names (<<"att_double_array">>))
			attributes.set_att_double_array (<<45.45, 45.45, 45.45>>)
			assert ("attributes 7", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 8", not my_subscriber.was_updated)
			subscription_manager.unsubscribe_all_property_updates (my_subscriber)
			attributes.set_att_double (45.45)
			attributes.set_att_double_null (45.45)
			attributes.set_att_double_array (<<45.45, 45.45, 45.45>>)
			assert ("attributes 9", not my_subscriber.was_updated)
			subscription_manager.subscribe_property_updates (attributes, my_subscriber, attributes.oids_of_property_names (<<"att_double", "att_double_null", "att_double_list", "att_double_list_null", "att_double_array", "att_double_array_null","att_float", "att_float_null", "att_float_list", "att_float_list_null", "att_float_array", "att_float_array_null", "att_date", "att_date_null", "att_date_list", "att_date_list_null", "att_ts", "att_ts_null", "att_ts_list", "att_ts_list_null", "att_ti", "att_ti_null", "att_ti_list", "att_ti_list_null", "att_byte", "att_byte_null", "att_bytes", "att_bytes_null", "att_text", "att_text_null", "att_image", "att_image_null", "att_audio", "att_audio_null", "att_video", "att_video_null", "att_char", "att_char_null", "att_short", "att_short_null", "att_short_list", "att_short_list_null", "att_integer", "att_integer_null", "att_int_list", "att_int_list_null", "att_long", "att_long_null", "att_numeric", "att_numeric_null", "att_numeric_list", "att_numeric_list_null", "att_boolean", "att_boolean_null", "att_boolean_list", "att_boolean_list_null", "att_string", "att_string_null", "att_string_list", "att_string_list_null", "att_string_array", "att_string_array_null", "att_string_utf8", "att_string_utf8_null", "att_string_list_utf8", "att_string_list_utf8_null", "att_any">>))


			attributes.set_att_double (50.50)
			assert ("attributes 10", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 11", not my_subscriber.was_updated)
			attributes.set_att_double_null (50.50)
			assert ("attributes 12", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 13", not my_subscriber.was_updated)
			create double_list.make
			double_list.put_right (30.30)
			double_list.put_right (40.40)
			double_list.put_right (50)
			attributes.set_att_double_list (double_list)
			assert ("attributes 14", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 15", not my_subscriber.was_updated)
			attributes.set_att_double_list_null (double_list)
			assert ("attributes 16", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 16.1", not my_subscriber.was_updated)
			attributes.set_att_double_list_null (Void)
			assert ("attributes 16.2", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 17", not my_subscriber.was_updated)
			attributes.set_att_double_array (<<12.12, 13.13, 40, 50>>)
			assert ("attributes 18", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 19", not my_subscriber.was_updated)
			attributes.set_att_double_array_null (<<12.12, 13.13, 40, 50>>)
			assert ("attributes 20", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 21", not my_subscriber.was_updated)
			attributes.set_att_double_array_null (Void)
			assert ("attributes 21.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 21.2", not my_subscriber.was_updated)
			attributes.set_att_float (55.55)
			assert ("attributes 22", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 23", not my_subscriber.was_updated)
			attributes.set_att_float_null (44.44)
			assert ("attributes 24", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 25", not my_subscriber.was_updated)
			create real_list.make
			real_list.put_right (22)
			real_list.put_right (23)
			real_list.put_right (24.4)
			real_list.put_right (35.6)
			attributes.set_att_float_list (real_list)
			assert ("attributes 26", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 27", not my_subscriber.was_updated)
			attributes.set_att_float_list_null (real_list)
			assert ("attributes 28", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 29", not my_subscriber.was_updated)
			attributes.set_att_float_list_null (Void)
			assert ("attributes 29.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 29.2", not my_subscriber.was_updated)
			attributes.set_att_float_array (<<22, 23, 24.4, 35.6>>)
			assert ("attributes 30", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 31", not my_subscriber.was_updated)
			attributes.set_att_float_array_null (<<22, 23, 24.4, 35.6>>)
			assert ("attributes 32", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 33", not my_subscriber.was_updated)
			attributes.set_att_float_array_null (Void)
			assert ("attributes 33.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 33.2", not my_subscriber.was_updated)
			create date1.make (2000,12,12)
			create date2.make (2000,11,11)
			create date3.make (2000,10,10)
			attributes.set_att_date (date1)
			assert ("attributes 34", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 35", not my_subscriber.was_updated)
			attributes.set_att_date_null (date2)
			assert ("attributes 36", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 37", not my_subscriber.was_updated)
			attributes.set_att_date_null (Void)
			assert ("attributes 37.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 37,2", not my_subscriber.was_updated)
			create date_list.make
			date_list.put_right (date1)
			date_list.put_right (date2)
			date_list.put_right (date3)
			attributes.set_att_date_list (date_list)
--			assert ("attributes 38", my_subscriber.was_updated)  -- TBD [KN]
			my_subscriber.reset_was_updated
			assert ("attributes 39", not my_subscriber.was_updated)
			attributes.set_att_date_list_null (date_list)
--			assert ("attributes 40", my_subscriber.was_updated)  -- TBD [KN]
			my_subscriber.reset_was_updated
			assert ("attributes 41", not my_subscriber.was_updated)
			create date_time1.make (2000, 12, 12, 12, 12, 12)
			create date_time2.make (2000, 11, 11, 11, 11, 11)
			create date_time3.make (2000, 10, 10, 10, 10, 10)
			attributes.set_att_ts (date_time1)
			assert ("attributes 42", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 43", not my_subscriber.was_updated)
			attributes.set_att_ts_null (date_time1)
			assert ("attributes 44", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 45", not my_subscriber.was_updated)
			attributes.set_att_ts_null (Void)
			assert ("attributes 45.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 45.2", not my_subscriber.was_updated)
			create date_time_list.make
			date_time_list.put_right (date_time1)
			date_time_list.put_right (date_time2)
			date_time_list.put_right (date_time3)
			attributes.set_att_ts_list (date_time_list)
--			assert ("attributes 46", my_subscriber.was_updated)  -- TBD [KN]
			my_subscriber.reset_was_updated
			assert ("attributes 47", not my_subscriber.was_updated)
			attributes.set_att_ts_list_null (date_time_list)
--			assert ("attributes 48", my_subscriber.was_updated)  -- TBD [KN]
			my_subscriber.reset_was_updated
			assert ("attributes 49", not my_subscriber.was_updated)
			create duration1.make_definite (0,5,0,0)
			create duration2.make_definite (0,6,0,0)
			create duration3.make_definite (0,7,0,0)
--			create duration2.make (0,0,0,6,0,0)
--			create duration3.make (0,0,0,7,0,0)
--			create duration_list.make
--			duration_list.put_right (duration1)
--			duration_list.put_right (duration2)
--			duration_list.put_right (duration3)
			attributes.set_att_ti (duration1)
			assert ("attributes 50", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 51", not my_subscriber.was_updated)
			attributes.set_att_ti_null (duration2)
			assert ("attributes 52", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 53", not my_subscriber.was_updated)
--			attributes.set_att_ti_list (duration_list)
--			assert ("attributes 54", my_subscriber.was_updated)  -- TBD [KN]
--			my_subscriber.reset_was_updated
--			assert ("attributes 55", not my_subscriber.was_updated)
--			attributes.set_att_ti_list_null (duration_list)
--			assert ("attributes 56", my_subscriber.was_updated)  -- TBD [KN]
--			my_subscriber.reset_was_updated
--			assert ("attributes 57", not my_subscriber.was_updated)
			attributes.set_att_byte (9)
			assert ("attributes 58", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 59", not my_subscriber.was_updated)
			attributes.set_att_byte_null (10)
			assert ("attributes 60", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 61", not my_subscriber.was_updated)
			attributes.set_att_bytes (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 62", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 63", not my_subscriber.was_updated)
			attributes.set_att_bytes_null (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 64", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 65", not my_subscriber.was_updated)
			attributes.set_att_bytes_null (Void)
			assert ("attributes 65.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 65.2", not my_subscriber.was_updated)
			test_string := (34).to_character_8.out + (55).to_character_8.out + (209).to_character_8.out + (134).to_character_8.out
			attributes.set_att_text (test_string)
			assert ("attributes 66", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 67", not my_subscriber.was_updated)

			attributes.set_att_text_null (test_string)
			assert ("attributes 68", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 69", not my_subscriber.was_updated)
			attributes.set_att_image (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 70", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 71", not my_subscriber.was_updated)
			attributes.set_att_image_null (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 72", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 73", not my_subscriber.was_updated)
			attributes.set_att_image_null (Void)
			assert ("attributes 73.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 73.2", not my_subscriber.was_updated)
			attributes.set_att_audio (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 74", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 75", not my_subscriber.was_updated)
			attributes.set_att_audio_null (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 76", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 77", not my_subscriber.was_updated)
			attributes.set_att_audio_null (Void)
			assert ("attributes 77.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 77.2", not my_subscriber.was_updated)
			attributes.set_att_video (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 78", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 79", not my_subscriber.was_updated)
			attributes.set_att_video_null (<<(34).as_natural_8, (55).as_natural_8, (209).as_natural_8, (134).as_natural_8>>)
			assert ("attributes 80", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 81", not my_subscriber.was_updated)
			attributes.set_att_video_null (Void)
			assert ("attributes 80", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 81", not my_subscriber.was_updated)
			attributes.set_att_char ('t')
			assert ("attributes 82", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 83", not my_subscriber.was_updated)
			attributes.set_att_char_null ('r')
			assert ("attributes 84", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 85", not my_subscriber.was_updated)
			attributes.set_att_short (1223)
			assert ("attributes 86", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 87", not my_subscriber.was_updated)
			attributes.set_att_short_null (4333)
			assert ("attributes 88", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 89", not my_subscriber.was_updated)
			int16_1 := 12
			int16_2 := 12
			int16_3 := 44
			create int16_list.make
			int16_list.put_right (int16_1)
			int16_list.put_right (int16_2)
			int16_list.put_right (int16_3)
			attributes.set_att_short_list (int16_list)
			assert ("attributes 90", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 91", not my_subscriber.was_updated)
			attributes.set_att_short_list_null (int16_list)
			assert ("attributes 92", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 93", not my_subscriber.was_updated)
			attributes.set_att_short_list_null (Void)
			assert ("attributes 93.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 93.2", not my_subscriber.was_updated)
			attributes.set_att_integer (4)
			assert ("attributes 94", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 95", not my_subscriber.was_updated)
			attributes.set_att_integer_null (5)
			assert ("attributes 96", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 97", not my_subscriber.was_updated)
			create integer_list.make
			integer_list.put_right (1)
			integer_list.put_right (2)
			integer_list.put_right (3)
			attributes.set_att_int_list (integer_list)
			assert ("attributes 98", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 99", not my_subscriber.was_updated)
			attributes.set_att_int_list_null (integer_list)
			assert ("attributes 100", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 101", not my_subscriber.was_updated)
			attributes.set_att_int_list_null (Void)
			assert ("attributes 101.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 101.2", not my_subscriber.was_updated)
			int64_1 := 12
			int64_2 := 12
			int64_3 := 44
			create int64_list.make
			int64_list.put_right (int64_1)
			int64_list.put_right (int64_2)
			int64_list.put_right (int64_3)
			attributes.set_att_long (int64_1)
--			assert ("attributes 102", my_subscriber.was_updated)  -- TBD when ISE's INTEGER_64 is stable
			my_subscriber.reset_was_updated
			assert ("attributes 103", not my_subscriber.was_updated)
			attributes.set_att_long_null (int64_2)
--			assert ("attributes 104", my_subscriber.was_updated)  -- TBD when ISE's INTEGER_64 is stable
			my_subscriber.reset_was_updated
			assert ("attributes 105", not my_subscriber.was_updated)
			create decimal1.make_from_string ("10")
			create decimal2.make_from_string ("20.20")
			create decimal3.make_from_string ("30.30")
			create decimal_list.make
			decimal_list.put_right (decimal1)
			decimal_list.put_right (decimal2)
			decimal_list.put_right (decimal3)
			attributes.set_att_numeric (decimal1)
			assert ("attributes 106", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 107", not my_subscriber.was_updated)
			attributes.set_att_numeric_null (decimal2)
			assert ("attributes 108", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 109", not my_subscriber.was_updated)
			attributes.set_att_numeric_null (Void)
			assert ("attributes 109.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 109.2", not my_subscriber.was_updated)
			attributes.set_att_numeric_list (decimal_list)
			assert ("attributes 110", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 111", not my_subscriber.was_updated)
			attributes.set_att_numeric_list_null (decimal_list)
			assert ("attributes 112", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 113", not my_subscriber.was_updated)
			attributes.set_att_numeric_list_null (Void)
			assert ("attributes 113.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 113.2", not my_subscriber.was_updated)
			attributes.set_att_boolean (False)
			assert ("attributes 114", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 115", not my_subscriber.was_updated)
			attributes.set_att_boolean_null (True)
			assert ("attributes 116", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 117", not my_subscriber.was_updated)
			create boolean_list.make
			boolean_list.put_right (False)
			boolean_list.put_right (True)
			boolean_list.put_right (False)
			attributes.set_att_boolean_list (boolean_list)
--			assert ("attributes 118", my_subscriber.was_updated)  -- TBD [KN]
			my_subscriber.reset_was_updated
			assert ("attributes 119", not my_subscriber.was_updated)
			attributes.set_att_boolean_list_null (boolean_list)
--			assert ("attributes 120", my_subscriber.was_updated)  -- TBD [KN]
			my_subscriber.reset_was_updated
			assert ("attributes 121", not my_subscriber.was_updated)
			attributes.set_att_string ("String")
			assert ("attributes 122", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 123", not my_subscriber.was_updated)
			attributes.set_att_string_null ("Null String")
			assert ("attributes 124", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 125", not my_subscriber.was_updated)
			create string_list.make
			string_list.put_right ("AAbb")
			string_list.put_right ("EEff")
			string_list.put_right ("GGhh")
			attributes.set_att_string_list (string_list)
			assert ("attributes 126", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 127", not my_subscriber.was_updated)
			attributes.set_att_string_list_null (string_list)
			assert ("attributes 128", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 129", not my_subscriber.was_updated)
			attributes.set_att_string_list_null (Void)
			assert ("attributes 129.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 129.2", not my_subscriber.was_updated)
			attributes.set_att_string_array (<<"Abc", "Efg", "Hij">>)
			assert ("attributes 130", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 131", not my_subscriber.was_updated)
			attributes.set_att_string_array_null (<<"Abc", "Efg", "Hij">>)
			assert ("attributes 132", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 133", not my_subscriber.was_updated)
			attributes.set_att_string_array_null (Void)
			assert ("attributes 133.1", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 133.2", not my_subscriber.was_updated)

--			attributes.set_att_string_utf8 (UC_STRING)
--			assert ("attributes 134", my_subscriber.was_updated)
--			my_subscriber.reset_was_updated
--			assert ("attributes 135", not my_subscriber.was_updated)
--			attributes.set_att_string_utf8_null (UC_STRING)
--			assert ("attributes 136", my_subscriber.was_updated)
--			my_subscriber.reset_was_updated
--			assert ("attributes 137", not my_subscriber.was_updated)
--			attributes.set_att_string_list_utf8 (LINKED_LIST [UC_STRING])
--			assert ("attributes 138", my_subscriber.was_updated)
--			my_subscriber.reset_was_updated
--			assert ("attributes 139", not my_subscriber.was_updated)
--			attributes.set_att_string_list_utf8_null (LINKED_LIST [UC_STRING])
--			assert ("attributes 140", my_subscriber.was_updated)
--			my_subscriber.reset_was_updated
--			assert ("attributes 141", not my_subscriber.was_updated)
			attributes.set_att_any ("A String")
--			assert ("attributes 142", my_subscriber.was_updated)
			my_subscriber.reset_was_updated
			assert ("attributes 143", not my_subscriber.was_updated)
			appl.abort_transaction
		end

	test_relationship_notification is
			-- Test notification of subscribers after relationship updates
		local
			obj1: EIFFEL_CLASS1
			obj3, obj3_1, obj3_2: EIFFEL_CLASS3
			my_subscriber1, my_subscriber11, my_subscriber12, my_subscriber1_of, my_subscriber31, my_subscriber32, my_subscriber32_1, my_subscriber32_2: MY_SUBSCRIBER
			list: LINKED_LIST [EIFFEL_CLASS3]
		do
			create my_subscriber1
			create my_subscriber11
			create my_subscriber12
			create my_subscriber1_of
			create my_subscriber31
			create my_subscriber32
			create my_subscriber32_1
			create my_subscriber32_2
			appl.start_transaction (0)
			create obj1.make1
			appl.persist (obj1)
			create obj3.make1
			appl.persist (obj3)
			create obj3_1.make1
			appl.persist (obj3_1)
			create obj3_2.make1
			appl.persist (obj3_2)
			subscription_manager.subscribe_property_updates (obj1, my_subscriber1, obj1.oids_of_property_names (<<"rs1">>))
			subscription_manager.subscribe_property_updates (obj1, my_subscriber11, obj1.oids_of_property_names (<<"rs11">>))
			subscription_manager.subscribe_property_updates (obj1, my_subscriber12, obj1.oids_of_property_names (<<"rs12">>))
			subscription_manager.subscribe_property_updates (obj3, my_subscriber1_of, obj3.oids_of_property_names (<<"rs1_of">>))
			subscription_manager.subscribe_property_updates (obj3, my_subscriber31, obj3.oids_of_property_names (<<"rs31">>))
			subscription_manager.subscribe_property_updates (obj3, my_subscriber32, obj3.oids_of_property_names (<<"rs32">>))
			subscription_manager.subscribe_property_updates (obj3_1, my_subscriber32_1, obj3_1.oids_of_property_names (<<"rs32">>))
			subscription_manager.subscribe_property_updates (obj3_2, my_subscriber32_2, obj3_2.oids_of_property_names (<<"rs32">>))
			assert ("Relationships 1", not my_subscriber1.was_updated)
			assert ("Relationships 2", not my_subscriber11.was_updated)
			assert ("Relationships 3", not my_subscriber12.was_updated)
			assert ("Relationships 4", not my_subscriber1_of.was_updated)
			assert ("Relationships 5", not my_subscriber31.was_updated)
			assert ("Relationships 6", not my_subscriber32.was_updated)
			obj1.set_rs11 (obj3)
			assert ("Relationships 7", not my_subscriber1.was_updated)
			assert ("Relationships 8", my_subscriber11.was_updated)
			assert ("Relationships 9", not my_subscriber12.was_updated)
			assert ("Relationships 10", not my_subscriber1_of.was_updated)
			assert ("Relationships 11", my_subscriber31.was_updated)
			assert ("Relationships 12", not my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 13", not my_subscriber1.was_updated)
			assert ("Relationships 14", not my_subscriber11.was_updated)
			assert ("Relationships 15", not my_subscriber12.was_updated)
			assert ("Relationships 16", not my_subscriber1_of.was_updated)
			assert ("Relationships 17", not my_subscriber31.was_updated)
			assert ("Relationships 18", not my_subscriber32.was_updated)
			obj1.set_rs11 (Void)
			assert ("Relationships 19", not my_subscriber1.was_updated)
			assert ("Relationships 20", my_subscriber11.was_updated)
			assert ("Relationships 21", not my_subscriber12.was_updated)
			assert ("Relationships 22", not my_subscriber1_of.was_updated)
			assert ("Relationships 23", my_subscriber31.was_updated)
			assert ("Relationships 24", not my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 25", not my_subscriber1.was_updated)
			assert ("Relationships 26", not my_subscriber11.was_updated)
			assert ("Relationships 27", not my_subscriber12.was_updated)
			assert ("Relationships 28", not my_subscriber1_of.was_updated)
			assert ("Relationships 29", not my_subscriber31.was_updated)
			assert ("Relationships 30", not my_subscriber32.was_updated)
			obj1.rs12.force (obj3)
			assert ("Relationships 31", not my_subscriber1.was_updated)
			assert ("Relationships 32", not my_subscriber11.was_updated)
			assert ("Relationships 33", my_subscriber12.was_updated)
			assert ("Relationships 34", not my_subscriber1_of.was_updated)
			assert ("Relationships 35", not my_subscriber31.was_updated)
			assert ("Relationships 36", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 37", not my_subscriber1.was_updated)
			assert ("Relationships 38", not my_subscriber11.was_updated)
			assert ("Relationships 39", not my_subscriber12.was_updated)
			assert ("Relationships 40", not my_subscriber1_of.was_updated)
			assert ("Relationships 41", not my_subscriber31.was_updated)
			assert ("Relationships 42", not my_subscriber32.was_updated)
			obj1.rs12.start
			obj1.rs12.search (obj3)
			assert ("Relationships 43", not obj1.rs12.after)
			obj1.rs12.remove
			assert ("Relationships 44", not my_subscriber1.was_updated)
			assert ("Relationships 45", not my_subscriber11.was_updated)
			assert ("Relationships 46", my_subscriber12.was_updated)
			assert ("Relationships 47", not my_subscriber1_of.was_updated)
			assert ("Relationships 48", not my_subscriber31.was_updated)
			assert ("Relationships 49", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 50", not my_subscriber1.was_updated)
			assert ("Relationships 51", not my_subscriber11.was_updated)
			assert ("Relationships 52", not my_subscriber12.was_updated)
			assert ("Relationships 53", not my_subscriber1_of.was_updated)
			assert ("Relationships 54", not my_subscriber31.was_updated)
			assert ("Relationships 55", not my_subscriber32.was_updated)
			obj1.rs12.put_front (obj3)
			assert ("Relationships 56", not my_subscriber1.was_updated)
			assert ("Relationships 57", not my_subscriber11.was_updated)
			assert ("Relationships 58", my_subscriber12.was_updated)
			assert ("Relationships 59", not my_subscriber1_of.was_updated)
			assert ("Relationships 60", not my_subscriber31.was_updated)
			assert ("Relationships 61", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 62", not my_subscriber1.was_updated)
			assert ("Relationships 63", not my_subscriber11.was_updated)
			assert ("Relationships 64", not my_subscriber12.was_updated)
			assert ("Relationships 65", not my_subscriber1_of.was_updated)
			assert ("Relationships 66", not my_subscriber31.was_updated)
			assert ("Relationships 67", not my_subscriber32.was_updated)
			obj3.set_rs32 (Void)
			assert ("Relationships 68", not my_subscriber1.was_updated)
			assert ("Relationships 69", not my_subscriber11.was_updated)
			assert ("Relationships 70", my_subscriber12.was_updated)
			assert ("Relationships 71", not my_subscriber1_of.was_updated)
			assert ("Relationships 72", not my_subscriber31.was_updated)
			assert ("Relationships 73", my_subscriber32.was_updated)
			obj1.rs12.force (obj3)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 74", not my_subscriber1.was_updated)
			assert ("Relationships 75", not my_subscriber11.was_updated)
			assert ("Relationships 76", not my_subscriber12.was_updated)
			assert ("Relationships 77", not my_subscriber1_of.was_updated)
			assert ("Relationships 78", not my_subscriber31.was_updated)
			assert ("Relationships 79", not my_subscriber32.was_updated)
			obj1.rs12.start
			obj1.rs12.prune (obj3)
			assert ("Relationships 80", not my_subscriber1.was_updated)
			assert ("Relationships 81", not my_subscriber11.was_updated)
			assert ("Relationships 82", my_subscriber12.was_updated)
			assert ("Relationships 83", not my_subscriber1_of.was_updated)
			assert ("Relationships 84", not my_subscriber31.was_updated)
			assert ("Relationships 85", my_subscriber32.was_updated)
			obj1.rs12.force (obj3)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 86", not my_subscriber1.was_updated)
			assert ("Relationships 87", not my_subscriber11.was_updated)
			assert ("Relationships 88", not my_subscriber12.was_updated)
			assert ("Relationships 89", not my_subscriber1_of.was_updated)
			assert ("Relationships 90", not my_subscriber31.was_updated)
			assert ("Relationships 91", not my_subscriber32.was_updated)
			obj1.rs12.start
			obj1.rs12.search (obj3)
			obj1.rs12.put (obj3)
			assert ("Relationships 92", not my_subscriber1.was_updated)
			assert ("Relationships 93", not my_subscriber11.was_updated)
			assert ("Relationships 94", my_subscriber12.was_updated)
			assert ("Relationships 95", not my_subscriber1_of.was_updated)
			assert ("Relationships 96", not my_subscriber31.was_updated)
			assert ("Relationships 97", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 98", not my_subscriber1.was_updated)
			assert ("Relationships 99", not my_subscriber11.was_updated)
			assert ("Relationships 100", not my_subscriber12.was_updated)
			assert ("Relationships 101", not my_subscriber1_of.was_updated)
			assert ("Relationships 102", not my_subscriber31.was_updated)
			assert ("Relationships 103", not my_subscriber32.was_updated)
			obj1.rs12.prune_all (obj3)
			assert ("Relationships 104", not my_subscriber1.was_updated)
			assert ("Relationships 105", not my_subscriber11.was_updated)
			assert ("Relationships 106", my_subscriber12.was_updated)
			assert ("Relationships 107", not my_subscriber1_of.was_updated)
			assert ("Relationships 108", not my_subscriber31.was_updated)
			assert ("Relationships 109", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 110", not my_subscriber1.was_updated)
			assert ("Relationships 111", not my_subscriber11.was_updated)
			assert ("Relationships 112", not my_subscriber12.was_updated)
			assert ("Relationships 113", not my_subscriber1_of.was_updated)
			assert ("Relationships 114", not my_subscriber31.was_updated)
			assert ("Relationships 115", not my_subscriber32.was_updated)
			obj1.rs12.start
			obj1.rs12.force (obj3)
			obj1.rs12.start
			obj1.rs12.search (obj3)
			obj1.rs12.put_right (obj3_1)
			obj1.rs12.start
			obj1.rs12.search (obj3)
			assert ("Relationships 116", not my_subscriber1.was_updated)
			assert ("Relationships 117", not my_subscriber11.was_updated)
			assert ("Relationships 118", my_subscriber12.was_updated)
			assert ("Relationships 119", not my_subscriber1_of.was_updated)
			assert ("Relationships 120", not my_subscriber31.was_updated)
			assert ("Relationships 121", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 122", not my_subscriber1.was_updated)
			assert ("Relationships 123", not my_subscriber11.was_updated)
			assert ("Relationships 124", not my_subscriber12.was_updated)
			assert ("Relationships 125", not my_subscriber1_of.was_updated)
			assert ("Relationships 126", not my_subscriber31.was_updated)
			assert ("Relationships 127", not my_subscriber32.was_updated)
			obj1.rs12.remove_right
			assert ("Relationships 128", not my_subscriber1.was_updated)
			assert ("Relationships 129", not my_subscriber11.was_updated)
			assert ("Relationships 130", my_subscriber12.was_updated)
			assert ("Relationships 131", not my_subscriber1_of.was_updated)
			assert ("Relationships 132", not my_subscriber31.was_updated)
			assert ("Relationships 133", not my_subscriber32.was_updated)
			assert ("Relationships 133-1", my_subscriber32_1.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 134", not my_subscriber1.was_updated)
			assert ("Relationships 135", not my_subscriber11.was_updated)
			assert ("Relationships 136", not my_subscriber12.was_updated)
			assert ("Relationships 137", not my_subscriber1_of.was_updated)
			assert ("Relationships 138", not my_subscriber31.was_updated)
			assert ("Relationships 139", not my_subscriber32.was_updated)
			obj1.rs12.finish
			obj1.rs12.put_left (obj3)
			assert ("Relationships 140", not my_subscriber1.was_updated)
			assert ("Relationships 141", not my_subscriber11.was_updated)
			assert ("Relationships 142", my_subscriber12.was_updated)
			assert ("Relationships 143", not my_subscriber1_of.was_updated)
			assert ("Relationships 144", not my_subscriber31.was_updated)
			assert ("Relationships 145", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 146", not my_subscriber1.was_updated)
			assert ("Relationships 147", not my_subscriber11.was_updated)
			assert ("Relationships 148", not my_subscriber12.was_updated)
			assert ("Relationships 149", not my_subscriber1_of.was_updated)
			assert ("Relationships 150", not my_subscriber31.was_updated)
			assert ("Relationships 151", not my_subscriber32.was_updated)
			obj1.rs12.finish
			obj1.rs12.remove_left
			assert ("Relationships 152", not my_subscriber1.was_updated)
			assert ("Relationships 153", not my_subscriber11.was_updated)
			assert ("Relationships 154", my_subscriber12.was_updated)
			assert ("Relationships 155", not my_subscriber1_of.was_updated)
			assert ("Relationships 156", not my_subscriber31.was_updated)
			assert ("Relationships 157", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 158", not my_subscriber1.was_updated)
			assert ("Relationships 159", not my_subscriber11.was_updated)
			assert ("Relationships 160", not my_subscriber12.was_updated)
			assert ("Relationships 161", not my_subscriber1_of.was_updated)
			assert ("Relationships 162", not my_subscriber31.was_updated)
			assert ("Relationships 163", not my_subscriber32.was_updated)
			obj1.rs12.extend (obj3)
			assert ("Relationships 164", not my_subscriber1.was_updated)
			assert ("Relationships 165", not my_subscriber11.was_updated)
			assert ("Relationships 166", my_subscriber12.was_updated)
			assert ("Relationships 167", not my_subscriber1_of.was_updated)
			assert ("Relationships 168", not my_subscriber31.was_updated)
			assert ("Relationships 169", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 170", not my_subscriber1.was_updated)
			assert ("Relationships 171", not my_subscriber11.was_updated)
			assert ("Relationships 172", not my_subscriber12.was_updated)
			assert ("Relationships 173", not my_subscriber1_of.was_updated)
			assert ("Relationships 174", not my_subscriber31.was_updated)
			assert ("Relationships 175", not my_subscriber32.was_updated)
			obj1.rs12.wipe_out
			obj1.rs12.force (obj3)
			assert ("Relationships 176", not my_subscriber1.was_updated)
			assert ("Relationships 177", not my_subscriber11.was_updated)
			assert ("Relationships 178", my_subscriber12.was_updated)
			assert ("Relationships 179", not my_subscriber1_of.was_updated)
			assert ("Relationships 180", not my_subscriber31.was_updated)
			assert ("Relationships 181", my_subscriber32.was_updated)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 182", not my_subscriber1.was_updated)
			assert ("Relationships 183", not my_subscriber11.was_updated)
			assert ("Relationships 184", not my_subscriber12.was_updated)
			assert ("Relationships 185", not my_subscriber1_of.was_updated)
			assert ("Relationships 186", not my_subscriber31.was_updated)
			assert ("Relationships 187", not my_subscriber32.was_updated)
			obj1.rs12.put_i_th (obj3_1,1)
			assert ("Relationships 188", not my_subscriber1.was_updated)
			assert ("Relationships 189", not my_subscriber11.was_updated)
			assert ("Relationships 190", my_subscriber12.was_updated)
			assert ("Relationships 191", not my_subscriber1_of.was_updated)
			assert ("Relationships 192", not my_subscriber31.was_updated)
			assert ("Relationships 193", my_subscriber32.was_updated)
			obj1.rs12.go_i_th (1)
			assert ("Relationships 193.1", obj1.rs12.item = obj3_1)
			obj1.rs12.put_right (obj3_2)
			obj1.rs12.start
			obj1.rs12.search (obj3_2)
			assert ("193.2", obj1.equal (obj1.rs12.index, 2))
			obj1.rs12.go_i_th (1)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 194", not my_subscriber1.was_updated)
			assert ("Relationships 195", not my_subscriber11.was_updated)
			assert ("Relationships 196", not my_subscriber12.was_updated)
			assert ("Relationships 197", not my_subscriber1_of.was_updated)
			assert ("Relationships 198", not my_subscriber31.was_updated)
			assert ("Relationships 199", not my_subscriber32.was_updated)
			obj1.rs12.swap (2)
			assert ("Relationships 200", not my_subscriber1.was_updated)
			assert ("Relationships 201", not my_subscriber11.was_updated)
			assert ("Relationships 202", my_subscriber12.was_updated)
			assert ("Relationships 203", not my_subscriber1_of.was_updated)
			assert ("Relationships 204", not my_subscriber31.was_updated)
			assert ("Relationships 205", not my_subscriber32.was_updated)
			assert ("Relationships 205-1", my_subscriber32_1.was_updated)
			assert ("Relationships 205-2", my_subscriber32_2.was_updated)
			-- list := clone (obj1.rs12)
			create list.make
			from
				obj1.rs12.start
			until
				obj1.rs12.off
			loop
				list.extend (obj1.rs12.item)
				obj1.rs12.forth
			end

			obj1.rs12.wipe_out
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 206", not my_subscriber1.was_updated)
			assert ("Relationships 207", not my_subscriber11.was_updated)
			assert ("Relationships 208", not my_subscriber12.was_updated)
			assert ("Relationships 209", not my_subscriber1_of.was_updated)
			assert ("Relationships 210", not my_subscriber31.was_updated)
			assert ("Relationships 211", not my_subscriber32.was_updated)
			obj1.rs12.append (list)
			assert ("Relationships 212", not my_subscriber1.was_updated)
			assert ("Relationships 213", not my_subscriber11.was_updated)
			assert ("Relationships 214", my_subscriber12.was_updated)
			assert ("Relationships 215", not my_subscriber1_of.was_updated)
			assert ("Relationships 216", not my_subscriber31.was_updated)
			assert ("Relationships 217", not my_subscriber32.was_updated)
			assert ("Relationships 217-1", my_subscriber32_1.was_updated)
			assert ("Relationships 217-2", my_subscriber32_2.was_updated)
			obj1.rs12.wipe_out
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 218", not my_subscriber1.was_updated)
			assert ("Relationships 219", not my_subscriber11.was_updated)
			assert ("Relationships 220", not my_subscriber12.was_updated)
			assert ("Relationships 221", not my_subscriber1_of.was_updated)
			assert ("Relationships 222", not my_subscriber31.was_updated)
			assert ("Relationships 223", not my_subscriber32.was_updated)
			obj1.rs12.fill (list)
			assert ("Relationships 224", not my_subscriber1.was_updated)
			assert ("Relationships 225", not my_subscriber11.was_updated)
			assert ("Relationships 226", my_subscriber12.was_updated)
			assert ("Relationships 227", not my_subscriber1_of.was_updated)
			assert ("Relationships 228", not my_subscriber31.was_updated)
			assert ("Relationships 229", not my_subscriber32.was_updated)
			assert ("Relationships 229-1", my_subscriber32_1.was_updated)
			assert ("Relationships 229-2", my_subscriber32_2.was_updated)
			list.prune_all (obj3)
			obj1.rs12.wipe_out
			obj1.rs12.force (obj3)
			obj1.rs12.go_i_th (1)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 230", not my_subscriber1.was_updated)
			assert ("Relationships 231", not my_subscriber11.was_updated)
			assert ("Relationships 232", not my_subscriber12.was_updated)
			assert ("Relationships 233", not my_subscriber1_of.was_updated)
			assert ("Relationships 234", not my_subscriber31.was_updated)
			assert ("Relationships 235", not my_subscriber32.was_updated)
			obj1.rs12.merge_right (list)
			assert ("Relationships 236", not my_subscriber1.was_updated)
			assert ("Relationships 237", not my_subscriber11.was_updated)
			assert ("Relationships 238", my_subscriber12.was_updated)
			assert ("Relationships 239", not my_subscriber1_of.was_updated)
			assert ("Relationships 240", not my_subscriber31.was_updated)
			assert ("Relationships 241", not my_subscriber32.was_updated)
			assert ("Relationships 241-1", my_subscriber32_1.was_updated)
			assert ("Relationships 241-2", my_subscriber32_2.was_updated)
			obj1.rs12.wipe_out
			obj1.rs12.force (obj3)
			obj1.rs12.go_i_th (1)
			my_subscriber1.reset_was_updated
			my_subscriber11.reset_was_updated
			my_subscriber12.reset_was_updated
			my_subscriber1_of.reset_was_updated
			my_subscriber31.reset_was_updated
			my_subscriber32.reset_was_updated
			assert ("Relationships 242", not my_subscriber1.was_updated)
			assert ("Relationships 243", not my_subscriber11.was_updated)
			assert ("Relationships 244", not my_subscriber12.was_updated)
			assert ("Relationships 245", not my_subscriber1_of.was_updated)
			assert ("Relationships 246", not my_subscriber31.was_updated)
			assert ("Relationships 247", not my_subscriber32.was_updated)
			list.extend (obj3_1)
			list.extend (obj3_2)
			obj1.rs12.merge_left (list)
			assert ("Relationships 248", not my_subscriber1.was_updated)
			assert ("Relationships 249", not my_subscriber11.was_updated)
			assert ("Relationships 250", my_subscriber12.was_updated)
			assert ("Relationships 251", not my_subscriber1_of.was_updated)
			assert ("Relationships 252", not my_subscriber31.was_updated)
			assert ("Relationships 253", not my_subscriber32.was_updated)
			assert ("Relationships 253-1", my_subscriber32_1.was_updated)
			assert ("Relationships 253-2", my_subscriber32_2.was_updated)
			appl.abort_transaction
		end

feature {NONE}	-- Implementation

	appl: MT_STORABLE_DATABASE

	subscription_manager: MT_SUBSCRIPTION_MANAGER is
		--
		once
			create Result
		end

end -- class TEST_MT_SUBSCRIPTION_MANAGER
