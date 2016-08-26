note
	description: "MATISSE-Eiffel Binding: define the SQL callable statement class"
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
	MT_CALLABLE_STATEMENT

inherit
	MT_PREPARED_STATEMENT

	MT_DATETIME
		undefine
			is_equal, copy
		end

create
	make


feature -- Get result

	get_boolean, get_param_boolean, boolean_result : BOOLEAN
			-- Get boolean param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_boolean ( stmt_offset, 0)
		end

	get_byte, get_param_byte, byte_result : INTEGER_8
			-- Get byte param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_byte ( stmt_offset, 0)
		end

	get_character, get_param_character, character_result : CHARACTER
			-- Get character param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_char ( stmt_offset, 0)
		end

	get_double, get_param_double, double_result : DOUBLE
			-- Get double param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_double ( stmt_offset, 0)
		end

	get_float, get_param_float, float_result : REAL
			-- Get float param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_float ( stmt_offset, 0)
		end

	get_integer, get_param_integer, integer_result : INTEGER_32
			-- Get integer param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_integer ( stmt_offset, 0)
		end

	get_interval, get_param_interval, interval_result : DATE_TIME_DURATION
			-- Get interval param result
		require
			stmt_valid: is_open
		local
			days:      INTEGER_32
			fine_secs: DOUBLE
			negative:  BOOLEAN
		do
			if mtdb.context.sql_get_param_interval_days_fsecs ( stmt_offset, 0, $days, $fine_secs, $negative) then
				Result := date_time_duration_from_days_fsecs (days, fine_secs, negative)
			end
		end

	get_long, get_param_long, long_result : INTEGER_64
			-- Get long param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_long ( stmt_offset, 0)
		end

	get_numeric, get_param_numeric, numeric_result : DECIMAL
			-- Get numeric param result
		require
			stmt_valid: is_open
		local
			c_array: ANY
			array:   ARRAY[INTEGER_32]
		do
			create array.make_filled (0, 1, 6)
			c_array := array.to_c

			if mtdb.context.sql_get_param_numeric ( stmt_offset, 0, $c_array) then
				create Result.from_int_array (array)
			end
		end

	get_short, get_param_short, short_result : INTEGER_16
			-- Get short param result
		require
			stmt_valid: is_open
		do
			Result := mtdb.context.sql_get_param_short ( stmt_offset, 0)
		end

	get_date, get_param_date, date_result : DATE
			-- Get date param result
		require
			stmt_valid: is_open
		local
			c_array: ANY
			array:   ARRAY[INTEGER_32]
		do
			create array.make_filled (0, 1, 3)
			c_array := array.to_c

			if mtdb.context.sql_get_param_date ( stmt_offset, 0, $c_array) then
				create Result.make (array.item (1), array.item (2), array.item (3))
			end
		end

	get_timestamp, get_param_timestamp, timestamp_result : DATE_TIME
			-- Get timestamp param result
		require
			stmt_valid: is_open
		local
			c_array: ANY
			array:   ARRAY[INTEGER_32]
		do
			create array.make_filled (0, 1, 7)
			c_array := array.to_c

			if mtdb.context.sql_get_param_timestamp ( stmt_offset, 0, $c_array) then
				create Result.make (array.item (1), array.item (2), array.item (3), array.item (4), array.item (5), array.item (6))
			end
		end

	get_bytes, get_audio, get_image, get_video, get_param_bytes, bytes_result : ARRAY[INTEGER_8]
			-- Get bytes, audio, image, video param result
		require
			stmt_valid: is_open
		local
			c_array:  ANY
			size:     INTEGER_32
			array:    ARRAY[INTEGER_8]
		do
			size := mtdb.context.sql_get_param_size ( stmt_offset, 0, $size)

			create array.make_filled (0, 1, size)
			c_array := array.to_c

			if mtdb.context.sql_get_param_bytes ( stmt_offset, 0, $size, $c_array) then
				create Result.make_from_array (array)
			end
		end

	get_text, get_param_text, text_result : STRING
			-- Get text param result
		require
			stmt_valid: is_open
		do
			create Result.make_empty
			Result := mtdb.context.sql_get_param_text ( stmt_offset, 0)
		end

	get_string, get_param_string, string_result : STRING
			-- Get string param result
		require
			stmt_valid: is_open
		do
			create Result.make_empty
			Result := mtdb.context.sql_get_param_string ( stmt_offset, 0)
		end


end -- class MT_CALLABLE_STATEMENT
