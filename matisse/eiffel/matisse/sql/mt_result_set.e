note
	description: "MATISSE-Eiffel Binding: define the result set class resulting from the execution of a SQL statement"
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
	MT_RESULT_SET

inherit
	MT_DATETIME

create
	make

feature {MT_STATEMENT} -- Initialization

	make (a_stmt: MT_STATEMENT)
		require
			statement_not_void: a_stmt /= Void
		do
			executed_stmt := a_stmt
			mtdb := a_stmt.mtdb
			--			set_selection_name
			initialize
		ensure
			not_started: before
		end

feature {NONE} -- Implementation

	mtdb: MT_DATABASE

feature -- Access

	item, object: MT_OBJECT
			-- This function returns the current object available through the
			-- SQL result selection.
		require
			not_off: not off
		do
--			Result := selection_stream.item
		end

	selection_name: STRING

feature -- Cursor movement

	start
			-- This procedure initializes the internal selection stream to access
			-- the objects available through the SQL result selection.
		require
			not_started: before
		do
			c_stream := mtdb.context.sql_open_stream ( executed_stmt.stmt_offset)
			get_next_row
		ensure
			started: not before
		end

	forth
			-- This procedure moves current cursor to the next object
			-- available through the SQL result selection.
		require
			not_after: not after
		do
			get_next_row
		end

feature -- Status report

	is_open, started: BOOLEAN
		do
			Result := c_stream /= invalid_c_stream
		end

feature -- Status setting	

	set_current (row_index: INTEGER_32)
			-- Set the current row position to row_index.
			-- The first row is 0.
		require
			positive: row_index > 0
			started: is_open
		do
			mtdb.context.sql_set_current_row ( c_stream , row_index)
			row_position := row_index
		end

	close
			-- This procedure closes the stream for the SQL result.
		require
			stream_opened: is_open
		do
			mtdb.context.close_stream ( c_stream)
			c_stream := invalid_c_stream
			row_position := row_before
		ensure
			not_started: before
		end

feature -- Status report

	off: BOOLEAN
			-- Is there no current row?
		do
			Result := row_position < 0
		end

	exhausted, after: BOOLEAN
			-- This function tests whether or not the end of the cursor
			-- has been reached.
		do
			Result := row_position = row_after
		end

	before: BOOLEAN
		do
			Result := row_position = row_before
		end

feature -- Get value

	get_boolean (column_position: INTEGER_32): BOOLEAN
			-- Retrieves a boolean value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Boolean)
		do
			Result := mtdb.context.sql_get_row_boolean ( c_stream , column_position)
		end

	get_double (column_position: INTEGER_32): DOUBLE
			-- Retrieves a double value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Double)
		do
			Result := mtdb.context.sql_get_row_double ( c_stream , column_position)
		end

	get_real, get_float (column_position: INTEGER_32): REAL
			-- Retrieves a real (float) value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Float)
		do
			Result := mtdb.context.sql_get_row_float ( c_stream , column_position)
		end

	get_date (column_position: INTEGER_32): DATE
			-- Retrieves a date object of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Date)
		local
			res_array: ARRAY[INTEGER_32]
			c_array: ANY
		do
			create res_array.make_filled (0, 1, 3) -- year, month, day
			c_array := res_array.to_c
			if mtdb.context.sql_get_row_date ( c_stream , column_position, $c_array) then
				create Result.make (res_array.item(1), res_array.item(2), res_array.item(3))
			end
		end

	get_timestamp, get_date_time (column_position: INTEGER_32): DATE_TIME
			-- Retrieves a date_time object of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Timestamp)
		local
			res_array: ARRAY[INTEGER_32]
			c_array: ANY
			fine_sec: DOUBLE
		do
			create res_array.make_filled (0, 1, 7) -- year, month, day, ...
			c_array := res_array.to_c
			if mtdb.context.sql_get_row_ts ( c_stream , column_position, $c_array) then
				fine_sec := res_array.item(6) + (res_array.item(7) / 1000000)
				create Result.make_fine (res_array.item(1), res_array.item(2),
																 res_array.item(3), res_array.item(4),
																 res_array.item(5), fine_sec)
			end
		end

	get_interval, get_date_time_duration (column_position: INTEGER_32): DATE_TIME_DURATION
			-- Retrieves a date_time_duration object of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Interval)
		local
			days: INTEGER_32
			fine_secs: DOUBLE
			negative: BOOLEAN
		do
			if mtdb.context.sql_get_row_ti_days_fsecs ( c_stream , column_position,
											$days, $fine_secs, $negative) then
				Result :=
					date_time_duration_from_days_fsecs (days, fine_secs, negative)
			end
		end

	get_byte, get_integer_8 (column_position: INTEGER_32): INTEGER_8
			-- Retrieves a byte value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Byte)
		do
			Result := mtdb.context.sql_get_row_byte ( c_stream , column_position)
		end

	get_bytes, get_audio, get_image, get_video (column_position: INTEGER_32): ARRAY[INTEGER_8]
			-- Retrieves byte array of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Bytes) or
									valid_type (column_position, {MTTYPE}.Mt_Audio) or
									valid_type (column_position, {MTTYPE}.Mt_Image) or
									valid_type (column_position, {MTTYPE}.Mt_Video)
		local
			size: INTEGER_32
			c_array: ANY
		do
			size := mtdb.context.sql_get_row_size ( c_stream , column_position)
			create Result.make_filled (0, 1, size)
			c_array := Result.to_c
			if not mtdb.context.sql_get_row_bytes ( c_stream , column_position, size, $c_array) then
				Result := Void
			end
		end

	get_text (column_position: INTEGER_32): STRING
			-- Retrieves a text value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_text)
		do
			Result := mtdb.context.sql_get_row_text ( c_stream , column_position)
		end

	get_character (column_position: INTEGER_32): CHARACTER
			-- Retrieves a character value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Char)
		do
			Result := mtdb.context.sql_get_row_char ( c_stream , column_position)
		end

	get_short, get_integer_16 (column_position: INTEGER_32): INTEGER_16
			-- Retrieves a short value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Short)
		do
			Result := mtdb.context.sql_get_row_short ( c_stream , column_position)
		end

	get_integer (column_position: INTEGER_32): INTEGER_32
			-- Retrieves an integer value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Integer)
		do
			Result := mtdb.context.sql_get_row_integer ( c_stream , column_position)
		end

	get_long, get_integer_64 (column_position: INTEGER_32): INTEGER_64
			-- Retrieves an long value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Long)
		do
			Result := mtdb.context.sql_get_row_long ( c_stream , column_position)
		end

	get_string (column_position: INTEGER_32): STRING
			-- Retrieves a string value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
			-- Void is returned if the real type is MT_NULL or its value is
			-- Null string.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_String)
		do
			Result := mtdb.context.sql_get_row_string ( c_stream , column_position)
		end

	get_decimal (column_position: INTEGER_32): DECIMAL
			-- Retrieves a decimal value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
			-- Void is returned if the real type is MT_NULL.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Numeric)
		local
			res_array: ARRAY[INTEGER_32]
			c_array: ANY
		do
			create res_array.make_filled (0, 1, 6)
			c_array := res_array.to_c
			if mtdb.context.sql_get_row_numeric ( c_stream , column_position, $c_array) then
				create Result.from_int_array (res_array)
			end
		end

	get_value (column_position: INTEGER_32): ANY
			-- Retrieves a value of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
		local
			type: INTEGER_32
		do
			type := get_type (column_position)
			if {MTTYPE}.Mt_Oid = type then
				Result := get_oid (column_position)
			elseif{MTTYPE}. Mt_Audio = type or {MTTYPE}.Mt_Image = type or {MTTYPE}.Mt_Video = type or {MTTYPE}.Mt_Bytes = type then
				Result := get_bytes (column_position)
			elseif {MTTYPE}.Mt_Text = type then
				Result := get_text (column_position)
			elseif {MTTYPE}.Mt_Char = type then
				Result := get_character (column_position)
			elseif {MTTYPE}.Mt_Boolean = type then
				Result := get_boolean (column_position)
			elseif {MTTYPE}.Mt_String = type then
				Result := get_string (column_position)
			elseif {MTTYPE}.Mt_Double = type then
				Result := get_double (column_position)
			elseif {MTTYPE}.Mt_Float = type then
				Result := get_float (column_position)
			elseif {MTTYPE}.Mt_Date = type then
				Result := get_date (column_position)
			elseif {MTTYPE}.Mt_Timestamp = type then
				Result := get_timestamp (column_position)
			elseif {MTTYPE}.Mt_Interval = type then
				Result := get_interval (column_position)
			elseif {MTTYPE}.Mt_Byte = type then
				Result := get_byte (column_position)
			elseif {MTTYPE}.Mt_Short = type then
				Result := get_short (column_position)
			elseif {MTTYPE}.Mt_Integer = type then
				Result := get_integer (column_position)
			elseif {MTTYPE}.Mt_Long = type then
				Result := get_long (column_position)
			elseif {MTTYPE}.Mt_Numeric = type then
				Result := get_decimal (column_position)
			end
		end

	get_object (column_position: INTEGER_32): MT_OBJECT
			-- Retrieves an object of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The column needs to be REF(c).
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_Oid)
		local
			oid: INTEGER_32
		do
			oid := mtdb.context.sql_get_row_ref ( c_stream , column_position)
			Result := executed_stmt.mtdb.upcast (oid)
		end

	get_oid (column_position: INTEGER_32): STRING
			-- Retrieves a MATISSE oid (Object Identifier) of the designated
			-- column in the current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
			valid_type: valid_type (column_position, {MTTYPE}.Mt_String)
		do
			Result := mtdb.context.sql_get_row_string ( c_stream , column_position)
		end

	get_type (column_position: INTEGER_32): INTEGER_32
			-- Get the value type of the current row at the designated column.
			-- This is usefull when a MATISSE attribute is "Nullable" or of
			-- type "Any"
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
		do
			Result := mtdb.context.sql_get_row_value_type ( c_stream , column_position)
		ensure
			valid_type: {MTTYPE}.Mt_Min_Type < Result and Result < {MTTYPE}.Mt_Max_Type
		end

	is_null(column_position: INTEGER_32): BOOLEAN
		require
			row_exists: not off
			valid_column_position: 0 < column_position and column_position <= column_count
		do
			Result := get_type (column_position) = {MTTYPE}.Mt_Null
		end

feature -- Object Count

	get_total_num_objects, total_num_objects (): INTEGER_32
		local
			info: STRING
		do
			info := executed_stmt.get_statement_info({MT_STATEMENT}.MtSql_Stmt_Numobjects)
			Result := info.to_integer ()
		end

	get_total_num_qualified, total_num_qualified (): INTEGER_32
		local
			info: STRING
		do
			info := executed_stmt.get_statement_info({MT_STATEMENT}.MtSql_Stmt_Numqualified)
			Result := info.to_integer ()
		end


feature -- Column meta data

	get_column_type, column_type (column_position: INTEGER_32): INTEGER_32
			-- Retrieves the MATISSE type of the designated column in the
			-- current row of the Current MT_RESULT_SET object.
			-- The first column position is 1.
		require
			valid_column_position: 0 < column_position and column_position <= column_count
		do
			Result := mtdb.context.sql_get_column_type ( executed_stmt.stmt_offset, column_position)
		ensure
			valid_type: {MTTYPE}.Mt_Min_Type < Result and Result < {MTTYPE}.Mt_Max_Type
		end

	find_column (a_column_name: STRING): INTEGER_32
			-- Find the column position from its name.
			-- If not found, 0 will be raised
		local
			c_string: ANY
		do
			c_string := a_column_name.to_c
			Result := mtdb.context.sql_find_column_index ( executed_stmt.stmt_offset, $c_string)
		end

	get_column_count, column_count: INTEGER_32
		do
			Result := mtdb.context.sql_get_column_count ( executed_stmt.stmt_offset)
		end

	get_column_name, column_name (column_position: INTEGER_32): STRING
		require
			valid_column_position: 0 < column_position and column_position <= column_count
		do
			Result := mtdb.context.sql_get_column_name ( executed_stmt.stmt_offset, column_position)
		ensure
			not_void: Result /= Void
		end

	valid_type (column_position, expecting_type: INTEGER_32): BOOLEAN
		require
			valid_column_position: 0 < column_position and column_position <= column_count
		do
			Result := column_type (column_position) = expecting_type or
				column_type (column_position) = {MTTYPE}.Mt_Any
		end

feature -- Measurement

--	count, instance_number: INTEGER_32 is
			-- This function returns the number of objects contained in the
			-- SQL result selection.
--		do
--			Result := mtdb.context.sql_get_instance_number (selection_id)
--		end

feature {NONE} -- Implementation

	get_next_row
		require
			stream_open: c_stream /= invalid_c_stream
		do
			if mtdb.context.sql_next ( c_stream ) then
				row_position := row_position + 1
			else
				row_position := row_after
			end
		end

	--stmt_offset: INTEGER_32
	executed_stmt: MT_STATEMENT

	c_stream: INTEGER_32

	invalid_c_stream: INTEGER_32 = -1

	row_position: INTEGER_32

	row_before: INTEGER_32 = -1

	row_after:  INTEGER_32 = -2

	set_selection_name
			-- This procedure gets the name of the SQL result selection.
			-- If it is not named, an mepty string is set.
		local
--			c_string: POINTER
		do
--			!! selection_name.make (0)
--			c_string := mtdb.context.get_selection_name (selection_id)
--			if c_string = default_pointer then
--				selection_name := ""
--			else
--				selection_name.from_c (c_string)
--			end
		end

	initialize
		do
			c_stream := invalid_c_stream
			row_position := row_before
		end

invariant

	valid_db: mtdb /= Void
--	selection_name_not_void: selection_name /= Void

end -- class MT_RESULT_SET
