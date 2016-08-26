
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class
	MTOBJECT

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MT_OBJECT
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance

	-- TBD should be moved
	MT_DATETIME
		undefine
			is_equal, copy
		end

-- BEGIN generation of create by Matisse SDL
create
	make_from_mtoid
	, make_from_mtclass
-- END of Matisse SDL generation of create
	, make_mtobject

feature {NONE} -- Initialization

	-- bound to a database
	mtdb: MT_DATABASE

feature -- Access

	get_mtdatabase () : MT_DATABASE
		do
			Result := mtdb
		end

feature -- Initialization

	frozen make_from_mtoid (a_db: MT_DATABASE; a_db_oid: INTEGER_32)
		-- Constructs an MtObject bound to an existing object.
		-- This constructor is generally used for internal purposes only.
		do
			mtdb := a_db
			oid := a_db_oid
		end

	frozen make_from_mtclass (a_class: MTCLASS)
		-- Creates a new persistent MATISSE instance.
		-- This constructor is generally used only by generated stubs.
		do
			mtdb := a_class.get_mtdatabase ()
			oid := mtdb.context.create_object_from_cid(a_class.oid)
		end


	make_mtobject (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("MtObject"))
		end



feature -- Access

	mtoid, get_mtoid (): INTEGER_32
		-- Object ID in Matisse.
		do
			Result := oid
		end

	mtclass, get_mtclass (): MTCLASS
		-- Matisse Class of the current object
		local
			clsid: INTEGER_32
		do
			clsid := Current.get_mtdatabase ().context.get_object_class (Current.oid)
			create Result.make_from_mtoid (Current.get_mtdatabase (), clsid)
		end

	is_instance_of (a_class: MTCLASS): BOOLEAN
		-- Is current object an instance of 'one_class'.
	do
		Result := mtdb.context.is_instance_of (oid, a_class.oid)
	end


feature -- Deletion

	frozen remove ()
		-- Removes this object from the database.
		-- This "proxy"'" object will then point to a removed object
		-- and any further atempts to use it will raise an exception
		do
			mtdb.context.remove_object (oid)
		end

	deep_remove ()
		-- Delete the current object from the database.
		-- must be redefined in subclasses to delete composed object if necessary
		do
			remove ()
		end


feature -- Locking

	lock (a_lock: INTEGER_32)
		-- Lock current object in Matisse.
		require
			a_lock_is_read_or_is_write: a_lock = {MT_DATABASE}.Mt_Read
												 or else a_lock = {MT_DATABASE}.Mt_Write
		do
			mtdb.context.lock_object ( oid, a_lock)
		end


	deep_lock (a_lock: INTEGER_32)
		-- Lock the current object from the database.
		-- must be redefined in subclasses to lock sub-part of an object if necessary
		do
			lock(a_lock)
		end

feature -- Value by type


	get_byte_array (att: MTATTRIBUTE; a_mttype: INTEGER_32): ARRAY [NATURAL_8]
		local
			array_size, v_mttype: INTEGER_32
			to_c: ANY
		do
			v_mttype := mtdb.context.get_value_type (oid, att.oid)
			if v_mttype = a_mttype then
				array_size := get_dimension(att, 0)
				create Result.make_filled (0, 1, array_size)
				to_c := Result.to_c
				mtdb.context.get_byte_array (oid, att.oid, array_size, $to_c);
			end
		end

	-- MT_AUDIO
	get_audio (att: MTATTRIBUTE): ARRAY [NATURAL_8]
		-- Reads a MT_AUDIO attribute value.
		do
			Result := get_byte_array (att, {MTTYPE}.Mt_Audio)
		end

	-- MT_IMAGE
	get_image (att: MTATTRIBUTE): ARRAY [NATURAL_8]
		-- Reads a MT_IMAGE attribute value.
		do
			Result := get_byte_array (att, {MTTYPE}.Mt_Image)
		end

	-- MT_VIDEO
	get_video (att: MTATTRIBUTE): ARRAY [NATURAL_8]
		-- Reads a MT_VIDEO attribute value.
		do
			Result := get_byte_array (att, {MTTYPE}.Mt_Video)
		end

	-- MT_TEXT
	get_text (att: MTATTRIBUTE): STRING
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Text then
				Result := mtdb.context.get_string_value ( oid, att.oid)
			end
		end

	get_text_utf8 (att: MTATTRIBUTE): UC_STRING
		local
			a_string: STRING
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Text then
				a_string := mtdb.context.get_string_value ( oid, att.oid)
				if a_string /= Void then
					create Result.make_from_utf8 (a_string)
				end
			end
		end

	get_text_utf16 (att: MTATTRIBUTE): UC_STRING
		-- TBD return a utf8
		local
			a_string: STRING
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Text then
				a_string := mtdb.context.get_string_value ( oid, att.oid)
				if a_string /= Void then
					create Result.make_from_utf8 (a_string)
				end
			end
		end

	-- MT_CHAR --
	get_char, get_character (att: MTATTRIBUTE) : CHARACTER
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Char then
				Result := mtdb.context.get_char_value ( oid, att.oid);
			end
		end


	-- MT_BOOLEAN --
	get_boolean (att: MTATTRIBUTE) : BOOLEAN
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Boolean then
				Result := mtdb.context.get_boolean_value ( oid, att.oid)
			end
		end


	-- MT_BOOLEAN_LIST --
	get_booleans, get_boolean_list (att: MTATTRIBUTE): ARRAY [BOOLEAN]
		local
			num_elem, count: INTEGER_32
			buffer: ARRAY[BOOLEAN]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Boolean_List then
				num_elem := get_dimension(att, 0)
				create buffer.make_filled (FALSE, 1, num_elem)
				to_c := buffer.to_c
				mtdb.context.get_boolean_array ( oid, att.oid, num_elem, $to_c)

				create Result.make_filled (FALSE, 1, num_elem)
				from
					count := 1
				until
					count = num_elem + 1
				loop
					Result.force (buffer.item (count), count)
					count := count + 1
				end
			end
		end


	-- MT_STRING --
	get_string (att: MTATTRIBUTE): STRING
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_String then
				Result := mtdb.context.get_string_value ( oid, att.oid)
			end
		end

	-- MT_STRING (UTF8)--
	get_string_utf8 (att: MTATTRIBUTE): UC_STRING
		local
			a_string: STRING
		do
			a_string := mtdb.context.get_string_value ( oid, att.oid)
			if a_string /= Void then
				create Result.make_from_utf8 (a_string)
			end
		end

	-- MT_STRING (UTF16)--
	get_string_utf16 (att: MTATTRIBUTE): UC_STRING
      -- TBD return a uf8 string
		local
			a_string: STRING
		do
			a_string := mtdb.context.get_string_value ( oid, att.oid)
			if a_string /= Void then
				create Result.make_from_utf8 (a_string)
			end
		end


	-- MT_STRING_LIST --
	get_strings, get_string_list (att: MTATTRIBUTE): ARRAY [STRING]
		local
			list_size, count: INTEGER_32
			buffer: ARRAY[STRING]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_String_List then
				list_size := get_dimension(att, 0)
				create buffer.make_filled (Void, 1, list_size)
				to_c := buffer.to_c
				mtdb.context.get_string_array ( oid, att.oid, list_size, to_c)

				create Result.make_filled (Void, 1, list_size)
				from
					count := 1
				until
					count = list_size + 1
				loop
					Result.force (buffer.item(count), count)
					count := count + 1
				end
			end
		end

	-- MT_STRING_LIST (UTF8) --
	get_strings_utf8 (att: MTATTRIBUTE): ARRAY [UC_STRING]
      -- TBD
		do

		end

	-- MT_STRING_LIST (UTF16) --
	get_strings_utf16 (att: MTATTRIBUTE): ARRAY [UC_STRING]
      -- TBD
		do

		end

	-- MT_DOUBLE --
	get_double (att: MTATTRIBUTE): DOUBLE
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Double then
				Result := mtdb.context.get_double_value ( oid, att.oid);
			end
		end

	-- MT_DOUBLE_LIST --
	get_doubles, get_double_list (att: MTATTRIBUTE): ARRAY [DOUBLE]
		local
			num_elem, count: INTEGER_32
			buffer: ARRAY[DOUBLE]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Double_List then
				num_elem := get_dimension(att, 0)
				create buffer.make_filled (0, 1, num_elem)
				to_c := buffer.to_c
				mtdb.context.get_double_array ( oid, att.oid, num_elem, $to_c)

				create Result.make_filled (0, 1, num_elem)
				from
					count := 1
				until
					count = num_elem + 1
				loop
					Result.force (buffer.item (count), count)
					count := count + 1
				end
			end
		end

	-- MT_FLOAT --	
	get_float (att: MTATTRIBUTE): REAL
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Float then
				Result := mtdb.context.get_real_value ( oid, att.oid);
			end
		end

	-- MT_FLOAT_LIST --	
	get_floats, get_float_list (att: MTATTRIBUTE): ARRAY [REAL]
		local
			num_elem, count: INTEGER_32
			buffer: ARRAY[REAL]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Float_List then
				num_elem := get_dimension(att, 0)
				create buffer.make_filled (0, 1, num_elem)
				to_c := buffer.to_c
				mtdb.context.get_real_array ( oid, att.oid, num_elem, $to_c)

				create Result.make_filled (0, 1, num_elem)
				from
					count := 1
				until
					count = num_elem + 1
				loop
					Result.force (buffer.item (count), count)
					count := count + 1
				end
			end
		end

	-- MT_DATE --
	get_date (att: MTATTRIBUTE): DATE
		local
			yr, mh, dy: INTEGER_32
			hr, me, sd, msd: INTEGER_32 -- not used for Date
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Date then
				mtdb.context.get_timestamp_value ( oid, att.oid, $yr, $mh, $dy, $hr, $me, $sd, $msd)
				create Result.make (yr, mh, dy)
			end
		end

	-- MT_DATE_LIST
	get_dates, get_date_list (att: MTATTRIBUTE): ARRAY [DATE]
		local
			num_elem, count: INTEGER_32
			buffer: ARRAY[INTEGER_32]
			to_c: ANY
			each: DATE
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Date_List then
				num_elem := get_dimension(att, 0)
				create buffer.make_filled (0, 1, num_elem * 3)
				to_c := buffer.to_c
				mtdb.context.get_date_array ( oid, att.oid, num_elem, $to_c)

				create Result.make_filled (Void, 1, num_elem)
				from
					count := 0
				until
					count = num_elem
				loop
					create each.make (buffer.item(count * 3 + 1), -- year
									  buffer.item(count * 3 + 2), -- month
									  buffer.item(count * 3 + 3)) -- day
					Result.force (each, count)
					count := count + 1
				end
			end
		end

	-- MT_TIMESTAMP --
	get_timestamp (att: MTATTRIBUTE): DATE_TIME
		local
			yr, mh, dy, hr, me, sd, msd: INTEGER_32
			fine_sec: DOUBLE
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Timestamp then
				mtdb.context.get_timestamp_value ( oid, att.oid, $yr, $mh, $dy, $hr, $me, $sd, $msd)
				fine_sec := sd + (msd / 1000000)
				create Result.make_fine (yr, mh, dy, hr, me, fine_sec)
			end
		end

	-- MT_TIMESTAMP_LIST
	get_timestamps, get_timestamp_list (att: MTATTRIBUTE): ARRAY [DATE_TIME]
		local
			num_elem, count: INTEGER_32
			buffer: ARRAY[INTEGER_32]
			to_c: ANY
			each: DATE_TIME
			fine_sec: DOUBLE
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Timestamp_List then
				num_elem := get_dimension(att, 0)
				create buffer.make_filled (0, 1, num_elem * 7)
				to_c := buffer.to_c
				mtdb.context.get_timestamp_array ( oid, att.oid, num_elem, $to_c)

				create Result.make_filled (Void, 1, num_elem)
				from
					count := 0
				until
					count = num_elem
				loop
					fine_sec := buffer.item (count * 7 + 6) -- second
						+ (buffer.item (count * 7 + 7) / 1000000) -- microsecond
					create each.make_fine (buffer.item(count * 7 + 1), -- year
											 buffer.item(count * 7 + 2), -- month
											 buffer.item(count * 7 + 3), -- day
											 buffer.item(count * 7 + 4), -- hour
											 buffer.item(count * 7 + 5), -- minute
											 fine_sec)
					Result.force (each, count)
					count := count + 1
				end
			end
		end

	-- MT_INTERVAL --
	get_interval, get_time_interval (att: MTATTRIBUTE): DATE_TIME_DURATION
		-- Type of result is still subject to change
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Interval then
				Result := date_time_duration_from_milliseconds (mtdb.context.get_interval_value ( oid, att.oid))
			end
		end

	-- MT_INTERVAL_LIST --
	get_intervals, get_time_intervals, get_interval_list, get_time_interval_list (att: MTATTRIBUTE): ARRAY [DATE_TIME_DURATION]
		local
			num_elem, i: INTEGER_32
			-- milliseconds: INTEGER_64
			-- new_duration: DATE_TIME_DURATION
			buffer: ARRAY [INTEGER_64]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Interval_List then
				num_elem := get_dimension(att, 0)
				create buffer.make_filled (0, 1, num_elem)
				create Result.make_filled (Void, 1, num_elem)
				to_c := buffer.to_c
				--mtdb.context.get_integer_64_array ( an_object.oid, oid, num_elem, $to_c)
				mtdb.context.get_interval_array ( oid, att.oid, num_elem, $to_c)
				from
					i := 1
				until
					i > num_elem
				loop
					Result.force (date_time_duration_from_milliseconds (buffer [i]), i)
					i := i + 1
				end
			end
		end

	-- MT_BYTE
	get_byte (att: MTATTRIBUTE): NATURAL_8
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Byte then
				Result := mtdb.context.get_byte_value ( oid, att.oid);
			end
		end

	-- MT_BYTES
	get_bytes, get_byte_list (att: MTATTRIBUTE): ARRAY [NATURAL_8]
		-- Reads a MT_BYTES attribute value.
		do
			Result := get_byte_array (att, {MTTYPE}.Mt_Bytes)
		end


	-- MT_SHORT --
	get_short (att: MTATTRIBUTE): INTEGER_16
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Short then
				Result := mtdb.context.get_short_value ( oid, att.oid);
			end
		end

	-- MT_SHORT_LIST --
	get_shorts, get_short_list (att: MTATTRIBUTE): ARRAY [INTEGER_16]
		local
			list_count, count: INTEGER_32
			buf: ARRAY[INTEGER_16]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Short_List then
				list_count := get_dimension(att, 0)
				create Result.make_filled (0, 1, list_count)
				create buf.make_filled (0, 1, list_count)
				to_c := buf.to_c
				mtdb.context.get_short_array ( oid, att.oid, list_count, $to_c)
				from
					count := 1
				until
					count = list_count + 1
				loop
					Result.force (buf.item (count), count)
					count := count + 1
				end
			end
		end

	-- MT_INTEGER --
	get_integer (att: MTATTRIBUTE): INTEGER_32
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Integer then
				Result := mtdb.context.get_integer_value (  oid, att.oid);
			end
		end

	-- MT_INTEGER_LIST --
	get_integers, get_integer_list (att: MTATTRIBUTE): ARRAY [INTEGER_32]
		local
			list_count, count: INTEGER_32
			buffer: ARRAY[INTEGER_32]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Integer_List then
				list_count := get_dimension(att, 0)
				create buffer.make_filled (0, 1, list_count)
				create Result.make_filled (0, 1, list_count)
				to_c := buffer.to_c
				mtdb.context.get_integer_array ( oid, att.oid, list_count, $to_c)
				from
					count := 1
				until
					count = list_count + 1
				loop
					Result.force (buffer.item (count), count)
					count := count + 1
				end
			end
		end


	-- MT_LONG --
	get_long, get_integer_64 (att: MTATTRIBUTE): INTEGER_64
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_long then
				Result := mtdb.context.get_integer_64_value ( oid, att.oid);
			end
		end

	-- MT_LONG_LIST --
	get_longs, get_long_list, get_integer_64_list (att: MTATTRIBUTE): ARRAY [INTEGER_64]
		local
			list_count, count: INTEGER_32
			buffer: ARRAY[INTEGER_64]
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Long_List then
				list_count := get_dimension(att, 0)
				create buffer.make_filled (0, 1, list_count)
				create Result.make_filled (0, 1, list_count)
				to_c := buffer.to_c
				mtdb.context.get_integer_64_array ( oid, att.oid, list_count, $to_c)
				from
					count := 1
				until
					count = list_count + 1
				loop
					Result.force (buffer.item (count), count)
					count := count + 1
				end
			end
		end

	-- MT_NUMERIC --
	get_numeric, get_decimal (att: MTATTRIBUTE): DECIMAL
		local
			res_array: ARRAY[INTEGER_32]
			any_a: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Numeric then
				create res_array.make_filled(0, 1, 6)
				any_a := res_array.to_c
				mtdb.context.get_numeric_value ( oid, att.oid, $any_a)
				create Result.from_int_array (res_array)
			end
		end

	-- MT_NUMERIC_LIST --
	get_numerics, get_numeric_list, get_decimal_list (att: MTATTRIBUTE): ARRAY [DECIMAL]
		local
			num_elem, count: INTEGER_32
			buffer: ARRAY[INTEGER_32]
			each_dec: DECIMAL
			to_c: ANY
		do
			if mtdb.context.get_value_type ( oid, att.oid) = {MTTYPE}.Mt_Numeric_List then
				num_elem := get_dimension(att, 0)
				create buffer.make_filled (0, 1, num_elem * 6)
				to_c := buffer.to_c
				mtdb.context.get_numeric_array ( oid, att.oid, num_elem, $to_c)

				create Result.make_filled (Void, 1, num_elem)
				from
					count := 1
				until
					count = num_elem + 1
				loop
					create each_dec.from_int_buf_array (buffer, (count - 1) * 6 + 1)
					Result.force (each_dec, count)
					count := count + 1
				end
			end
		end

	dimension, get_dimension (att: MTATTRIBUTE; rank: INTEGER_32): INTEGER_32
			-- Dimension of an attribute value.
			-- When the value of the attribute is an array, returns the size of the
			-- array for the dimension rank.
			-- If the attribute value is a list, rank must be equal to 0 and dimension
			-- gives the number of elements in the list.
		require
			rank_positive_or_null: rank >= 0
		do
			Result := mtdb.context.get_dimension ( oid, att.oid, rank)
		end

	get_value_of_mt_type (att: MTATTRIBUTE; a_type: INTEGER_32): ANY
		do
			inspect a_type
			when {MTTYPE}.Mt_Null  then
				Result := Void
			when {MTTYPE}.Mt_Audio then
				Result := get_audio (att)
			when {MTTYPE}.Mt_Image then
				Result := get_image (att)
			when {MTTYPE}.Mt_Video then
				Result := get_video (att)
			when {MTTYPE}.Mt_Text then
				Result := get_text (att)
			when {MTTYPE}.Mt_Char  then
				Result := get_character (att)
			when {MTTYPE}.Mt_Boolean then
				Result := get_boolean (att)
			when {MTTYPE}.Mt_Boolean_List then
				Result := get_booleans (att)
			when {MTTYPE}.Mt_String  then
				Result := get_string (att)
			when {MTTYPE}.Mt_String_List  then
				Result := get_strings (att)
			when {MTTYPE}.Mt_Double  then
				Result := get_double (att)
			when {MTTYPE}.Mt_Double_List  then
				Result := get_doubles (att)
			when {MTTYPE}.Mt_Float  then
				Result := get_float (att)
			when {MTTYPE}.Mt_Float_List  then
				Result := get_floats (att)
			when {MTTYPE}.Mt_Date then
				Result := get_date (att)
			when {MTTYPE}.Mt_Date_List then
				Result := get_dates (att)
			when {MTTYPE}.Mt_Timestamp then
				Result := get_timestamp (att)
			when {MTTYPE}.Mt_Timestamp_List then
				Result := get_timestamps (att)
			when {MTTYPE}.Mt_Interval then
				Result := get_time_interval (att)
			when {MTTYPE}.Mt_Interval_List then
				Result := get_intervals (att)
			when {MTTYPE}.Mt_Byte then
				Result := get_byte (att)
			when {MTTYPE}.Mt_Bytes  then
				Result := get_bytes (att)
			when {MTTYPE}.Mt_Short  then
				Result := get_short (att)
			when {MTTYPE}.Mt_Short_list then
				Result := get_shorts (att)
			when {MTTYPE}.Mt_Integer  then
				Result := get_integer (att)
			when {MTTYPE}.Mt_Integer_List  then
				Result := get_integers (att)
			when {MTTYPE}.Mt_Long  then
				Result := get_long (att)
			when {MTTYPE}.Mt_Long_List  then
				Result := get_longs (att)
			when {MTTYPE}.Mt_Numeric  then
				Result := get_numeric (att)
			when {MTTYPE}.Mt_Numeric_List  then
				Result := get_numerics (att)
			else
			end
		end

	get_value (att: MTATTRIBUTE): ANY
		do
			Result := get_value_of_mt_type (att, mtdb.context.get_value_type( oid, att.oid))
		end

	get_type (att: MTATTRIBUTE): INTEGER_32
		do
			Result := mtdb.context.get_value_type ( oid, att.oid)
		end

	get_character_encoding (att: MTATTRIBUTE): INTEGER_32
		-- TBD
		do
			Result := {MTTYPE}.Mt_Ascii
		end

	is_null (att: MTATTRIBUTE): BOOLEAN
		do
			Result := mtdb.context.get_value_type (oid, att.oid) = {MTTYPE}.Mt_null
		end

	is_default_value (att: MTATTRIBUTE): BOOLEAN
		do
			Result :=  mtdb.context.is_default_value (oid, att.oid)
		end

	get_list_size (att: MTATTRIBUTE): INTEGER_32
		do
			Result := get_dimension (att, 0)
		end

feature -- set values


	-- ANY
	set_value (att: MTATTRIBUTE; val : ANY)
	   -- TBD
		do

		end


	-- MT_NULL
	set_null (att: MTATTRIBUTE)
		local
			p: ANY
		do
			mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
		end

	-- Generic
	set_byte_list (att: MTATTRIBUTE; a_type: INTEGER_32; a_byte_array: ARRAY [NATURAL_8])
		local
			p: ANY
		do
			if a_byte_array.count = 0 then
				mtdb.context.set_value_void ( oid, att.oid, a_type, $p, 0)
			else
				p := a_byte_array.to_c
				mtdb.context.set_value_array_numeric ( oid, att.oid, a_type, $p, 1, a_byte_array.count)
			end
		end


	-- MT_AUDIO
	set_audio (att: MTATTRIBUTE; a_byte_array: ARRAY [NATURAL_8])
		do
			set_byte_list (att, {MTTYPE}.Mt_Audio, a_byte_array)
		end


	-- MT_IMAGE
	set_image (att: MTATTRIBUTE; a_byte_array: ARRAY [NATURAL_8])
		do
			set_byte_list (att, {MTTYPE}.Mt_Image, a_byte_array)
		end


	-- MT_VIDEO
	set_video (att: MTATTRIBUTE; a_byte_array: ARRAY [NATURAL_8])
		do
			set_byte_list (att, {MTTYPE}.Mt_Video, a_byte_array)
		end

	-- MT_TEXT
	set_text (att: MTATTRIBUTE; new_value: STRING)
		do
			set_string_value (att, {MTTYPE}.Mt_Text, new_value)
		end

	set_text_utf8 (att: MTATTRIBUTE; new_value: UC_STRING)
		do
			set_string_utf8_value (att, {MTTYPE}.Mt_Text, new_value)
		end


	-- MT_CHAR --
	set_char, set_character (att: MTATTRIBUTE; new_value: CHARACTER)
		do
			mtdb.context.set_value_char ( oid, att.oid, {MTTYPE}.Mt_Char, new_value, 0)
		end


	-- MT_BOOLEAN --
	set_boolean (att: MTATTRIBUTE; new_value: BOOLEAN)
		do
			mtdb.context.set_value_boolean ( oid, att.oid, new_value)
		end


	-- MT_BOOLEAN_LIST --	
	set_booleans, set_boolean_list (att: MTATTRIBUTE; value: ARRAY [BOOLEAN])
		local
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Boolean_List, $p, 0)
				else
					mtdb.context.set_value_boolean_array ( oid, att.oid, value.count, $value)
				end
			end
		end


	-- MT_STRING --
	-- MT_STRING (UTF8) --	
	set_string (att: MTATTRIBUTE; value: STRING)
		do
			set_string_value (att, {MTTYPE}.Mt_String, value)
		end

	set_string_value (att: MTATTRIBUTE; a_mt_type: INTEGER_32; value: STRING)
		require
			mt_type: a_mt_type = {MTTYPE}.Mt_String or a_mt_type = {MTTYPE}.Mt_Text
		local
			c_string: ANY
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_string ( oid, att.oid, a_mt_type, $p, {MTTYPE}.Mt_Ascii)
			else
				c_string := value.to_c
				mtdb.context.set_value_string ( oid, att.oid, a_mt_type, $c_string, {MTTYPE}.Mt_Ascii)
			end
		end

	set_string_utf8 (att: MTATTRIBUTE; value: UC_STRING)
		do
			set_string_utf8_value (att, {MTTYPE}.Mt_String, value)
		end

	set_string_utf8_value (att: MTATTRIBUTE; a_mt_type: INTEGER_32; value: UC_STRING)
		require
			mt_type: a_mt_type = {MTTYPE}.Mt_String or a_mt_type = {MTTYPE}.Mt_Text
		local
			c_string: ANY
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_string ( oid, att.oid, a_mt_type, $p, {MTTYPE}.Mt_Utf8)
			else
				c_string := value.to_utf8.to_c
				mtdb.context.set_value_string ( oid, att.oid, a_mt_type, $c_string, {MTTYPE}.Mt_Utf8)
			end
		end

	set_string_utf16 (att: MTATTRIBUTE; value: UC_STRING)
	   -- TBD
		do
			set_string_utf8_value (att, {MTTYPE}.Mt_String, value)
		end

	-- MT_STRING_LIST --
	set_strings, set_string_list (att: MTATTRIBUTE; a_string_array: ARRAY [STRING])
		local
			c_string: ANY
			an_array_pointer: ARRAY [POINTER]
			i: INTEGER_32
			p: ANY
		do
			if a_string_array = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if a_string_array.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_String_List, $p, 0)
				else
					create an_array_pointer.make_filled (Default_Pointer, 1, a_string_array.count)
					from
						i := a_string_array.lower
					until
						i > a_string_array.upper
					loop
						if a_string_array.item (i) = Void then
							an_array_pointer.put ($p, i)
						else
							c_string := a_string_array.item (i).to_c
							an_array_pointer.put ($c_string, i)
						end
						i:= i + 1
					end
					p := an_array_pointer.to_c
					mtdb.context.set_value_array_numeric ( oid, att.oid, {MTTYPE}.Mt_String_List, $p, 1, a_string_array.count)
				end
			end
		end

	-- MT_STRING_LIST (UTF8) --
	set_strings_utf8 (att: MTATTRIBUTE; a_string_array: ARRAY [STRING])
      -- TBD
		do
			set_strings (att, a_string_array)
		end

	-- MT_STRING_LIST (UTF16) --
	set_strings_utf16 (att: MTATTRIBUTE; a_string_array: ARRAY [STRING])
      -- TBD
		do
			set_strings (att, a_string_array)
		end


	-- MT_DOUBLE --
	set_double (att: MTATTRIBUTE; value: DOUBLE)
		do
			mtdb.context.set_value_double ( oid, att.oid, {MTTYPE}.Mt_Double, value, 0)
		end

	-- MT_DOUBLE_LIST --
	set_doubles, set_double_list (att: MTATTRIBUTE; a_double_array: ARRAY [DOUBLE])
		local
			p: ANY
		do
			if a_double_array = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if a_double_array.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Double_List, $p, 0)
				else
					p := a_double_array.to_c
					mtdb.context.set_value_array_numeric ( oid, att.oid, {MTTYPE}.Mt_Double_List, $p, 1, a_double_array.count)
				end
			end
		end


	-- MT_FLOAT --	
	set_float, set_real (att: MTATTRIBUTE; value: REAL)
		do
			mtdb.context.set_value_real ( oid, att.oid, {MTTYPE}.Mt_Float, value)
		end


	-- MT_FLOAT_LIST --	
	set_floats, set_float_list, set_real_list (att: MTATTRIBUTE; value: ARRAY [REAL])
		local
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Float_List, $p, 0)
				else
					p := value.to_c
					mtdb.context.set_value_array_numeric ( oid, att.oid, {MTTYPE}.Mt_Float_List, $p, 1, value.count)
				end
			end
		end


	-- MT_DATE --
	set_date (att: MTATTRIBUTE; new_date: DATE)
		local
			p: ANY
		do
			if new_date = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				mtdb.context.set_value_date ( oid, att.oid, new_date.year, new_date.month, new_date.day)
			end
		end

	-- MT_DATE_LIST
	set_dates, set_date_list (att: MTATTRIBUTE; value: ARRAY [DATE])
		local
			years, months, days: ARRAY [INTEGER_32]
			i: INTEGER_32
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Date_List, $p, 0)
				else
					create years.make_filled (0, 1, value.count)
					create months.make_filled (0, 1, value.count)
					create days.make_filled (0, 1, value.count)
					from
						--value.start
						i := 1
					until
						--value.off
						i > value.count
					loop
						years.put (value.item(i).year, i)
						months.put (value.item(i).month, i)
						days.put (value.item(i).day, i)
						--value.forth
						i := i + 1
					end
					mtdb.context.set_value_date_array ( oid, att.oid, years.count, $years, $months, $days)
				end
			end
		end


	-- MT_TIMESTAMP --
	set_timestamp (att: MTATTRIBUTE; new_time: DATE_TIME)
		local
			-- microsecond: INTEGER_32
			p: ANY
		do
			if new_time = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				mtdb.context.set_value_timestamp ( oid, att.oid,
				new_time.year, new_time.month, new_time.day,
				new_time.hour, new_time.minute, new_time.second,
				date_microseconds (new_time))
			end
		end

	date_microseconds (a_date_time: DATE_TIME): INTEGER_32 is
		     require
			valid_a_date_time: a_date_time /= Void
		do
		  Result := (a_date_time.fractional_second * 1000000).floor
		end


	-- MT_TIMESTAMP_LIST
	set_timestamps, set_timestamp_list (att: MTATTRIBUTE; value: ARRAY [DATE_TIME])
		local
			years, months, days, hours, minutes, seconds, microseconds: ARRAY [INTEGER_32]
			i: INTEGER_32
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Timestamp_List, $p, 0)
				else
					create years.make_filled (0, 1, value.count)
					create months.make_filled (0, 1, value.count)
					create days.make_filled (0, 1, value.count)
					create hours.make_filled (0, 1, value.count)
					create minutes.make_filled (0, 1, value.count)
					create seconds.make_filled (0, 1, value.count)
					create microseconds.make_filled (0, 1, value.count)

					from
						--value.start
						i := 1
					until
						--value.off
						i > value.count
					loop
						years.put (value.item(i).year, i)
						months.put (value.item(i).month, i)
						days.put (value.item(i).day, i)
						days.put (value.item(i).hour, i)
						days.put (value.item(i).minute, i)
						days.put (value.item(i).second, i)
						days.put (date_microseconds (value.item(i)), i)

						--value.forth
						i := i + 1
					end
					mtdb.context.set_value_timestamp_array ( oid, att.oid, years.count, $years, $months, $days, $hours, $minutes, $seconds, $microseconds)
				end
			end
		end


	-- MT_INTERVAL --
	set_interval, set_time_interval (att: MTATTRIBUTE; new_interval: DATE_TIME_DURATION)
		local
			-- days: INTEGER_32
			-- fine_seconds: INTEGER_64
			p: ANY
		do
			if new_interval = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				mtdb.context.set_value_time_interval ( oid, att.oid, date_time_fine_seconds (new_interval))
			end
		end

	date_time_fine_seconds (a_date_time_duration: DATE_TIME_DURATION): INTEGER_64
		require
			valid_a_date_time_duration: a_date_time_duration /= Void
		do
			Result := ((a_date_time_duration.date.day * 86400) + (a_date_time_duration.time.fine_seconds_count)).truncated_to_integer_64
		end

	-- MT_INTERVAL_LIST --

	set_intervals, set_interval_list, set_time_interval_list (att: MTATTRIBUTE; value: ARRAY [DATE_TIME_DURATION])
		local
			intervals: ARRAY [INTEGER_64]
			i: INTEGER_32
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Interval_List, $p, 0)
				else
					create intervals.make_filled (0, 1, value.count)
					from
						--value.start
						i := 1
					until
						i > value.count
						--value.off
					loop
						intervals.put (date_time_fine_seconds (value.item(i)), i)
						-- value.forth
						i := i + 1
					end
					p := intervals.to_c
					mtdb.context.set_value_array_numeric ( oid, att.oid, {MTTYPE}.Mt_Interval_List, $p, 1, intervals.count)
				end
			end
		end

	-- MT_BYTE
	set_byte (att: MTATTRIBUTE; new_value: INTEGER_32)
		do
			mtdb.context.set_value_u8 ( oid, att.oid, new_value)
		end

	-- MT_BYTES
	set_bytes (att: MTATTRIBUTE; a_byte_array: ARRAY [NATURAL_8])
		do
			set_byte_list (att, {MTTYPE}.Mt_Bytes, a_byte_array)
		end

	-- MT_SHORT --
	set_short (att: MTATTRIBUTE; new_value: INTEGER_32)
		do
			mtdb.context.set_value_s16 ( oid, att.oid, new_value)
		end

	-- MT_SHORT_LIST --
	set_shorts, set_short_list (att: MTATTRIBUTE; an_array: ARRAY [INTEGER_16])
		local
			p: ANY
		do
			if an_array = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if an_array.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Short_List, $p, 0)
				else
					mtdb.context.set_value_short_array ( oid, att.oid, {MTTYPE}.Mt_Short_List, $an_array, 1)
				end
			end
		end

	-- MT_INTEGER --
	set_integer (att: MTATTRIBUTE; value: INTEGER_32)
		do
			mtdb.context.set_value_integer ( oid, att.oid, {MTTYPE}.Mt_Integer, value, 0)
		end

	-- MT_INTEGER_LIST --
	set_integers, set_integer_list (att: MTATTRIBUTE; value: ARRAY [INTEGER_32])
		local
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid,  {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid,  {MTTYPE}.Mt_Integer_List, $p, 0)
				else
					p := value.to_c
					mtdb.context.set_value_array_numeric ( oid, att.oid, {MTTYPE}.Mt_Integer_List, $p, 1, value.count)
				end
			end
		end



	-- MT_LONG --
	set_long, set_integer_64 (att: MTATTRIBUTE; value: INTEGER_64)
		do
			mtdb.context.set_value_integer_64 ( oid, att.oid, {MTTYPE}.Mt_Long, value, 0)
		end

	-- MT_LONG_LIST --
	set_longs, set_long_list, set_integer_64_list (att: MTATTRIBUTE; value: ARRAY [INTEGER_64])
		local
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid,  {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid,  {MTTYPE}.Mt_Long_List, $p, 0)
				else
					p := value.to_c
					mtdb.context.set_value_array_numeric ( oid, att.oid, {MTTYPE}.Mt_Long_List, $p, 1, value.count)
				end
			end
		end


	-- MT_NUMERIC --
	set_numeric, set_decimal (att: MTATTRIBUTE; value: DECIMAL)
	    local
	    	p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
  				mtdb.context.mt_set_value_numeric ( oid, att.oid,	value.item1, value.item2,
																		value.item3, value.item4, value.item5, value.item6)
    	  	end
		end

	-- MT_NUMERIC_LIST --
	set_numerics, set_numeric_list, set_decimal_list (att: MTATTRIBUTE; value: ARRAY [DECIMAL])
		local
			a_decimal_array: ARRAY [INTEGER_32] -- array of item1 through item6
			p_array: ANY
			i: INTEGER_32
			p: ANY
		do
			if value = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if value.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Numeric_List, $p, 0)
				else

					create a_decimal_array.make_filled (0, 1, value.count * 6)
					from
						--value.start
						i := 1
					until
						i > value.count
						--value.off
					loop
						a_decimal_array.put (value.item(i).item1, i * 6 - 5)
						a_decimal_array.put (value.item(i).item2, i * 6 - 4)
						a_decimal_array.put (value.item(i).item3, i * 6 - 3)
						a_decimal_array.put (value.item(i).item4, i * 6 - 2)
						a_decimal_array.put (value.item(i).item5, i * 6 - 1)
						a_decimal_array.put (value.item(i).item6, i * 6)
						--value.forth
						i := i + 1
					end
					p_array := a_decimal_array.to_c
					-- TBD
					mtdb.context.mt_set_value_numeric_list ( oid, att.oid, $p_array, value.count)
				end
			end
		end


	get_byte_list_elements (att: MTATTRIBUTE; buffer: ARRAY [NATURAL_8];
									count, offset: INTEGER_32): INTEGER_32
		local
			to_c: ANY
		do
			to_c := buffer.to_c
			Result := mtdb.context.get_byte_list_elements ( oid, att.oid, $to_c, count, offset)
		end

	set_byte_list_elements (att: MTATTRIBUTE; buffer: ARRAY [NATURAL_8];
									buffer_size: INTEGER_32; offset: INTEGER_32; discard_after: BOOLEAN)
		local
			to_c: ANY
			p: ANY
		do
			if buffer = Void then
				mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Null, $p, 0)
			else
				if buffer.count = 0 then
					mtdb.context.set_value_void ( oid, att.oid, {MTTYPE}.Mt_Bytes, $p, 0)
				else
					to_c := buffer.to_c
					mtdb.context.set_value_byte_list_elements ( oid, att.oid, {MTTYPE}.Mt_Bytes,
																			  $to_c, buffer_size, offset, discard_after)
				end
			end
		end


feature -- remove values

	remove_value (att: MTATTRIBUTE)
		do
			mtdb.context.remove_value ( oid, att.oid)
		end


	--
	-- ************** RELATIONSHIP *************
	--

feature -- succesors

	successor_iterator(rel: MTRELATIONSHIP): MT_OBJECT_ITERATOR[MTOBJECT]
		-- Opens an iterator on a successor list.
		-- Successor objects are loaded incrementally.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_successors_stream (oid, rel.oid)
			create Result.make(c_stream, mtdb)
		end


	get_successors_upcast (rel: MTRELATIONSHIP; val: ARRAY [MTOBJECT] )
		-- Gets all successors at once.
		do
			mtdb.upcasts( mtdb.context.get_successors ( oid, rel.oid), val )
		end


	get_successors (rel: MTRELATIONSHIP): ARRAY [MTOBJECT]
		-- Gets all successors at once.
		local
			v_res: ARRAY [MTOBJECT]
		do
			create v_res.make_filled(Void, 1, 0)
			mtdb.upcasts( mtdb.context.get_successors ( oid, rel.oid), v_res)
			Result := v_res;
		end

	get_successor_size (rel: MTRELATIONSHIP): INTEGER_32
		-- Counts the number of successors for this object thru the relationship.
		-- This function does not actually load the list of successors, so it is faster than
		-- getSuccessors(rel).count
		do
			Result := mtdb.context.get_successor_size ( oid, rel.oid)
		end

	get_successor (rel: MTRELATIONSHIP): MTOBJECT
		-- Retrieves a single successor thru the relationship.
		do
			Result ?= mtdb.upcast( mtdb.context.get_successor ( oid, rel.oid) )
		end

	add_successors (rel: MTRELATIONSHIP; succs: ARRAY [MTOBJECT])
		-- Adds many successors to a relationship.
		local
			p: ANY
			succ_oids: ARRAY [INTEGER_32]
		do
			succ_oids := convert_successors(succs)
			p := succ_oids.to_c
			mtdb.context.add_num_successors ( oid, rel.oid, succ_oids.count, $p)
		end

	append_successor (rel: MTRELATIONSHIP; succ: MTOBJECT)
		-- Adds a single successor at the end of the successor list.
		do
			mtdb.context.add_successor_append ( oid, rel.oid, succ.oid)
		end

	prepend_successor (rel: MTRELATIONSHIP; succ: MTOBJECT)
		-- Adds a single successor at the beginning of the successor list.
		do
			mtdb.context.add_successor_first ( oid, rel.oid, succ.oid)
		end


	add_successor_after (rel: MTRELATIONSHIP; succ, after_obj: MTOBJECT)
		-- Adds a single successor after a specified object in the successor list.
		do
			mtdb.context.add_successor_after ( oid, rel.oid, succ.oid, after_obj.oid)
		end


	remove_successor (rel: MTRELATIONSHIP; succ: MTOBJECT)
		-- Removes a single object from the successor list.
		do
			mtdb.context.remove_successor ( oid, rel.oid, succ.oid)
		end


	remove_successors (rel: MTRELATIONSHIP; succs: ARRAY [MTOBJECT])
		-- Removes multiple objects from the successor list.
		local
			p: ANY
			succ_oids: ARRAY [INTEGER_32]
		do
			succ_oids := convert_successors(succs)
			p := succ_oids.to_c
			mtdb.context.remove_successors ( oid, rel.oid, succ_oids.count, $p)
		end

	clear_successors (rel: MTRELATIONSHIP)
		-- Removes all successors thru relationship.
		do
			mtdb.context.clear_all_successors ( oid, rel.oid)
		end

	set_successor (rel: MTRELATIONSHIP; succ: MTOBJECT)
		-- Removes all successors thru relationship and adds the object
		do
			mtdb.context.set_successor ( oid, rel.oid, succ.oid)
		end

	set_successors (rel: MTRELATIONSHIP; succs: ARRAY [MTOBJECT])
		-- Removes all successors for relationship and adds all objects
		local
			p: ANY
			succ_oids: ARRAY [INTEGER_32]
		do
			succ_oids := convert_successors(succs)
			p := succ_oids.to_c
			mtdb.context.set_num_successors ( oid, rel.oid, succ_oids.count, $p)
		end

feature {NONE} -- implementation

	convert_successors(succs: ARRAY [MTOBJECT]) : ARRAY [INTEGER_32]
		local
			i: INTEGER_32
		do
			create Result.make_filled (0, 1, succs.count)
			from
				i := succs.lower
			until
				i > succs.upper
			loop
				Result.force (succs.item(i).oid, i)
 				i := i + 1
			end
		end

feature -- object iterators

	attributes_iterator(): MT_PROPERTY_ITERATOR[MTATTRIBUTE]
		-- Opens an iterator on the attributes of the object.
		-- Attributes objects are loaded incrementally.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_attributes_stream (oid)
			create Result.make(c_stream, mtdb)
		end


	relationships_iterator(): MT_PROPERTY_ITERATOR[MTRELATIONSHIP]
		-- Opens an iterator on the relationships of the object.
		-- Relationships objects are loaded incrementally.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_relationships_stream (oid)
			create Result.make(c_stream, mtdb)
		end

	inverse_relationships_iterator(): MT_PROPERTY_ITERATOR[MTRELATIONSHIP]
		-- Opens an iterator on the inverse relationships of the object.
		-- Inverse Relationships objects are loaded incrementally.
		local
			c_stream : INTEGER_32
		do
			c_stream := mtdb.context.open_inverse_relationships_stream (oid)
			create Result.make(c_stream, mtdb)
		end


feature -- predefined

	is_predefined: BOOLEAN
			-- Does object belongs to meta-schema?
		local
		do
			Result := mtdb.context.is_predefined_object (oid)
		end


feature -- load/unload

	load
			-- Load current object in client cache so that
			-- there is no more server access readings on this object.
		do
			mtdb.context.load_object ( oid)
		end

	free, unload
			-- Remove object from local cache.
		do
			mtdb.context.free_object ( oid)
		end

feature -- Checks

	check_object (): BOOLEAN
		-- Check instance.
		do
			mtdb.context.check_object ( oid)
		end

	check_mtattribute (att: MTATTRIBUTE): BOOLEAN
		-- Check if attribute is correct in 'one_object'.
		do
			mtdb.context.check_attribute ( oid, att.oid)
		end

	check_mtrelationship (rel: MTRELATIONSHIP): BOOLEAN
		-- Check if relationship is OK
		do
			mtdb.context.check_relationship ( oid, rel.oid)
		end


-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 9.0.0
-- Date: Thu Dec  1 10:19:33 2011



-- END of Matisse SDL generation of accessors


end -- class MTOBJECT

