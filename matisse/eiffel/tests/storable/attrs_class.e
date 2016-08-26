
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	ATTRS_CLASS

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	SUPER
-- END of Matisse SDL generation of ancestor

-- BEGIN generation of redefine by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
		redefine
			field_position_of_identifier
-- END of Matisse SDL generation of redefine
			, post_retrieved
-- BEGIN generation of end by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
		end
-- END of Matisse SDL generation of end

-- END of Matisse SDL generation of inheritance



-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 8.4.0
-- Date: Sat Oct 23 16:40:08 2010

feature {NONE}

	att_double_: DOUBLE
	att_double_null_: DOUBLE
	att_double_list_: LINKED_LIST [DOUBLE]
	att_double_list_null_: LINKED_LIST [DOUBLE]
	att_double_array_: ARRAY [DOUBLE]
	att_double_array_null_: ARRAY [DOUBLE]
	att_float_: REAL
	att_float_null_: REAL
	att_float_list_: LINKED_LIST [REAL]
	att_float_list_null_: LINKED_LIST [REAL]
	att_float_array_: ARRAY [REAL]
	att_float_array_null_: ARRAY [REAL]
	att_date_: DATE
	att_date_null_: DATE
	att_date_list_: LINKED_LIST [DATE]
	att_date_list_null_: LINKED_LIST [DATE]
	att_ts_: DATE_TIME
	att_ts_null_: DATE_TIME
	att_ts_list_: LINKED_LIST [DATE_TIME]
	att_ts_list_null_: LINKED_LIST [DATE_TIME]
	att_ti_: DATE_TIME_DURATION
	att_ti_null_: DATE_TIME_DURATION
	att_ti_list_: LINKED_LIST [DATE_TIME_DURATION]
	att_ti_list_null_: LINKED_LIST [DATE_TIME_DURATION]
	att_byte_: NATURAL_8
	att_byte_null_: NATURAL_8
	att_bytes_: ARRAY [NATURAL_8]
	att_bytes_null_: ARRAY [NATURAL_8]
	att_image_: ARRAY [NATURAL_8]
	att_image_null_: ARRAY [NATURAL_8]
	att_audio_: ARRAY [NATURAL_8]
	att_audio_null_: ARRAY [NATURAL_8]
	att_video_: ARRAY [NATURAL_8]
	att_video_null_: ARRAY [NATURAL_8]
	att_char_: CHARACTER
	att_char_null_: CHARACTER
	att_short_: INTEGER_16
	att_short_null_: INTEGER_16
	att_short_list_: LINKED_LIST [INTEGER_16]
	att_short_list_null_: LINKED_LIST [INTEGER_16]
	att_integer_: INTEGER
	att_integer_null_: INTEGER
	att_int_list_: LINKED_LIST [INTEGER]
	att_int_list_null_: LINKED_LIST [INTEGER]
	att_long_: INTEGER_64
	att_long_null_: INTEGER_64
	att_long_list_: LINKED_LIST [INTEGER_64]
	att_long_list_null_: LINKED_LIST [INTEGER_64]
	att_numeric_: DECIMAL
	att_numeric_null_: DECIMAL
	att_numeric_list_: LINKED_LIST [DECIMAL]
	att_numeric_list_null_: LINKED_LIST [DECIMAL]
	att_boolean_: BOOLEAN
	att_boolean_null_: BOOLEAN
	att_boolean_list_: LINKED_LIST [BOOLEAN]
	att_boolean_list_null_: LINKED_LIST [BOOLEAN]
	att_string_: STRING
	att_string_null_: STRING
	att_string_list_: LINKED_LIST [STRING]
	att_string_list_null_: LINKED_LIST [STRING]
	att_string_array_: ARRAY [STRING]
	att_string_array_null_: ARRAY [STRING]
	att_string_utf8_: UC_STRING
	att_string_utf8_null_: UC_STRING
	att_string_utf16_: UC_STRING
	att_string_utf16_null_: UC_STRING
	att_string_list_utf8_: LINKED_LIST [UC_STRING]
	att_string_list_utf8_null_: LINKED_LIST [UC_STRING]
	att_string_list_utf16_: LINKED_LIST [UC_STRING]
	att_string_list_utf16_null_: LINKED_LIST [UC_STRING]
	att_text_: STRING
	att_text_null_: STRING
	att_text_utf8_: UC_STRING
	att_text_utf8_null_: UC_STRING
	att_text_utf16_: UC_STRING
	att_text_utf16_null_: UC_STRING
	att_any_: ANY

feature -- Access

	att_double: DOUBLE
		do
			if is_obsolete or else att_double_ = Double_default_value then
				att_double_ := mt_get_double_by_position (field_position_of_att_double)
			end
			Result := att_double_
		end

	att_double_null: DOUBLE
		do
			if is_obsolete or else att_double_null_ = Double_default_value then
				att_double_null_ := mt_get_double_by_position (field_position_of_att_double_null)
			end
			Result := att_double_null_
		end

	att_double_list: LINKED_LIST [DOUBLE]
		do
			if is_obsolete or else att_double_list_ = Void then
				att_double_list_ := mt_get_double_list_by_position (field_position_of_att_double_list)
			end
			Result := att_double_list_
		end

	att_double_list_null: LINKED_LIST [DOUBLE]
		do
			if is_obsolete or else att_double_list_null_ = Void then
				att_double_list_null_ := mt_get_double_list_by_position (field_position_of_att_double_list_null)
			end
			Result := att_double_list_null_
		end

	att_double_array: ARRAY [DOUBLE]
		do
			if is_obsolete or else att_double_array_ = Void then
				att_double_array_ := mt_get_double_array_by_position (field_position_of_att_double_array)
			end
			Result := att_double_array_
		end

	att_double_array_null: ARRAY [DOUBLE]
		do
			if is_obsolete or else att_double_array_null_ = Void then
				att_double_array_null_ := mt_get_double_array_by_position (field_position_of_att_double_array_null)
			end
			Result := att_double_array_null_
		end

	att_float: REAL
		do
			if is_obsolete or else att_float_ = Real_default_value then
				att_float_ := mt_get_real_by_position (field_position_of_att_float)
			end
			Result := att_float_
		end

	att_float_null: REAL
		do
			if is_obsolete or else att_float_null_ = Real_default_value then
				att_float_null_ := mt_get_real_by_position (field_position_of_att_float_null)
			end
			Result := att_float_null_
		end

	att_float_list: LINKED_LIST [REAL]
		do
			if is_obsolete or else att_float_list_ = Void then
				att_float_list_ := mt_get_real_list_by_position (field_position_of_att_float_list)
			end
			Result := att_float_list_
		end

	att_float_list_null: LINKED_LIST [REAL]
		do
			if is_obsolete or else att_float_list_null_ = Void then
				att_float_list_null_ := mt_get_real_list_by_position (field_position_of_att_float_list_null)
			end
			Result := att_float_list_null_
		end

	att_float_array: ARRAY [REAL]
		do
			if is_obsolete or else att_float_array_ = Void then
				att_float_array_ := mt_get_real_array_by_position (field_position_of_att_float_array)
			end
			Result := att_float_array_
		end

	att_float_array_null: ARRAY [REAL]
		do
			if is_obsolete or else att_float_array_null_ = Void then
				att_float_array_null_ := mt_get_real_array_by_position (field_position_of_att_float_array_null)
			end
			Result := att_float_array_null_
		end

	att_date: DATE
		do
			if is_obsolete or else att_date_ = Void then
				att_date_ := mt_get_date (field_position_of_att_date)
			end
			Result := att_date_
		end

	att_date_null: DATE
		do
			if is_obsolete or else att_date_null_ = Void then
				att_date_null_ := mt_get_date (field_position_of_att_date_null)
			end
			Result := att_date_null_
		end

	att_date_list: LINKED_LIST [DATE]
		do
			if is_obsolete or else att_date_list_ = Void then
				att_date_list_ := mt_get_date_list (field_position_of_att_date_list)
			end
			Result := att_date_list_
		end

	att_date_list_null: LINKED_LIST [DATE]
		do
			if is_obsolete or else att_date_list_null_ = Void then
				att_date_list_null_ := mt_get_date_list (field_position_of_att_date_list_null)
			end
			Result := att_date_list_null_
		end

	att_ts: DATE_TIME
		do
			if is_obsolete or else att_ts_ = Void then
				att_ts_ := mt_get_timestamp_by_position (field_position_of_att_ts)
			end
			Result := att_ts_
		end

	att_ts_null: DATE_TIME
		do
			if is_obsolete or else att_ts_null_ = Void then
				att_ts_null_ := mt_get_timestamp_by_position (field_position_of_att_ts_null)
			end
			Result := att_ts_null_
		end

	att_ts_list: LINKED_LIST [DATE_TIME]
		do
			if is_obsolete or else att_ts_list_ = Void then
				att_ts_list_ := mt_get_timestamp_list_by_position (field_position_of_att_ts_list)
			end
			Result := att_ts_list_
		end

	att_ts_list_null: LINKED_LIST [DATE_TIME]
		do
			if is_obsolete or else att_ts_list_null_ = Void then
				att_ts_list_null_ := mt_get_timestamp_list_by_position (field_position_of_att_ts_list_null)
			end
			Result := att_ts_list_null_
		end

	att_ti: DATE_TIME_DURATION
		do
			if is_obsolete or else att_ti_ = Void then
				att_ti_ := mt_get_time_interval_by_position (field_position_of_att_ti)
			end
			Result := att_ti_
		end

	att_ti_null: DATE_TIME_DURATION
		do
			if is_obsolete or else att_ti_null_ = Void then
				att_ti_null_ := mt_get_time_interval_by_position (field_position_of_att_ti_null)
			end
			Result := att_ti_null_
		end

	att_ti_list: LINKED_LIST [DATE_TIME_DURATION]
		do
			if is_obsolete or else att_ti_list_ = Void then
				att_ti_list_ := mt_get_time_interval_List_by_position (field_position_of_att_ti_list)
			end
			Result := att_ti_list_
		end

	att_ti_list_null: LINKED_LIST [DATE_TIME_DURATION]
		do
			if is_obsolete or else att_ti_list_null_ = Void then
				att_ti_list_null_ := mt_get_time_interval_List_by_position (field_position_of_att_ti_list_null)
			end
			Result := att_ti_list_null_
		end

	att_byte: NATURAL_8
		do
			if is_obsolete or else att_byte_ = Integer_default_value then
				att_byte_ := mt_get_byte_by_position (field_position_of_att_byte)
			end
			Result := att_byte_
		end

	att_byte_null: NATURAL_8
		do
			if is_obsolete or else att_byte_null_ = Integer_default_value then
				att_byte_null_ := mt_get_byte_by_position (field_position_of_att_byte_null)
			end
			Result := att_byte_null_
		end

	att_bytes: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_bytes_ = Void then
				att_bytes_ := mt_get_byte_list_by_position (field_position_of_att_bytes)
			end
			Result := att_bytes_
		end

	get_att_bytes_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_bytes, buffer, count, offset)
		end

	att_bytes_null: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_bytes_null_ = Void then
				att_bytes_null_ := mt_get_byte_list_by_position (field_position_of_att_bytes_null)
			end
			Result := att_bytes_null_
		end

	get_att_bytes_null_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_bytes_null, buffer, count, offset)
		end

	att_image: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_image_ = Void then
				att_image_ := mt_get_image_by_position (field_position_of_att_image)
			end
			Result := att_image_
		end

	get_att_image_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_image, buffer, count, offset)
		end

	att_image_null: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_image_null_ = Void then
				att_image_null_ := mt_get_image_by_position (field_position_of_att_image_null)
			end
			Result := att_image_null_
		end

	get_att_image_null_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_image_null, buffer, count, offset)
		end

	att_audio: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_audio_ = Void then
				att_audio_ := mt_get_audio_by_position (field_position_of_att_audio)
			end
			Result := att_audio_
		end

	get_att_audio_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_audio, buffer, count, offset)
		end

	att_audio_null: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_audio_null_ = Void then
				att_audio_null_ := mt_get_audio_by_position (field_position_of_att_audio_null)
			end
			Result := att_audio_null_
		end

	get_att_audio_null_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_audio_null, buffer, count, offset)
		end

	att_video: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_video_ = Void then
				att_video_ := mt_get_video_by_position (field_position_of_att_video)
			end
			Result := att_video_
		end

	get_att_video_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_video, buffer, count, offset)
		end

	att_video_null: ARRAY [NATURAL_8]
		do
			if is_obsolete or else att_video_null_ = Void then
				att_video_null_ := mt_get_video_by_position (field_position_of_att_video_null)
			end
			Result := att_video_null_
		end

	get_att_video_null_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_att_video_null, buffer, count, offset)
		end

	att_char: CHARACTER
		do
			if is_obsolete or else att_char_ = Character_default_value then
				att_char_ := mt_get_character_by_position (field_position_of_att_char)
			end
			Result := att_char_
		end

	att_char_null: CHARACTER
		do
			if is_obsolete or else att_char_null_ = Character_default_value then
				att_char_null_ := mt_get_character_by_position (field_position_of_att_char_null)
			end
			Result := att_char_null_
		end

	att_short: INTEGER_16
		do
			if is_obsolete or else att_short_ = Integer_default_value then
				att_short_ := mt_get_short_by_position (field_position_of_att_short)
			end
			Result := att_short_
		end

	att_short_null: INTEGER_16
		do
			if is_obsolete or else att_short_null_ = Integer_default_value then
				att_short_null_ := mt_get_short_by_position (field_position_of_att_short_null)
			end
			Result := att_short_null_
		end

	att_short_list: LINKED_LIST [INTEGER_16]
		do
			if is_obsolete or else att_short_list_ = Void then
				att_short_list_ := mt_get_short_list_by_position (field_position_of_att_short_list)
			end
			Result := att_short_list_
		end

	att_short_list_null: LINKED_LIST [INTEGER_16]
		do
			if is_obsolete or else att_short_list_null_ = Void then
				att_short_list_null_ := mt_get_short_list_by_position (field_position_of_att_short_list_null)
			end
			Result := att_short_list_null_
		end

	att_integer: INTEGER
		do
			if is_obsolete or else att_integer_ = Integer_default_value then
				att_integer_ := mt_get_integer_by_position (field_position_of_att_integer)
			end
			Result := att_integer_
		end

	att_integer_null: INTEGER
		do
			if is_obsolete or else att_integer_null_ = Integer_default_value then
				att_integer_null_ := mt_get_integer_by_position (field_position_of_att_integer_null)
			end
			Result := att_integer_null_
		end

	att_int_list: LINKED_LIST [INTEGER]
		do
			if is_obsolete or else att_int_list_ = Void then
				att_int_list_ := mt_get_integer_list_by_position (field_position_of_att_int_list)
			end
			Result := att_int_list_
		end

	att_int_list_null: LINKED_LIST [INTEGER]
		do
			if is_obsolete or else att_int_list_null_ = Void then
				att_int_list_null_ := mt_get_integer_list_by_position (field_position_of_att_int_list_null)
			end
			Result := att_int_list_null_
		end

	att_long: INTEGER_64
		do
			if is_obsolete or else att_long_ = Integer64_default_value then
				att_long_ := mt_get_integer_64_by_position (field_position_of_att_long)
			end
			Result := att_long_
		end

	att_long_null: INTEGER_64
		do
			if is_obsolete or else att_long_null_ = Integer64_default_value then
				att_long_null_ := mt_get_integer_64_by_position (field_position_of_att_long_null)
			end
			Result := att_long_null_
		end

	att_long_list: LINKED_LIST [INTEGER_64]
		do
			if is_obsolete or else att_long_list_ = Void then
				att_long_list_ := mt_get_integer_64_list_by_position (field_position_of_att_long_list)
			end
			Result := att_long_list_
		end

	att_long_list_null: LINKED_LIST [INTEGER_64]
		do
			if is_obsolete or else att_long_list_null_ = Void then
				att_long_list_null_ := mt_get_integer_64_list_by_position (field_position_of_att_long_list_null)
			end
			Result := att_long_list_null_
		end

	att_numeric: DECIMAL
		do
			if is_obsolete or else att_numeric_ = Void then
				att_numeric_ := mt_get_decimal_by_position (field_position_of_att_numeric)
			end
			Result := att_numeric_
		end

	att_numeric_null: DECIMAL
		do
			if is_obsolete or else att_numeric_null_ = Void then
				att_numeric_null_ := mt_get_decimal_by_position (field_position_of_att_numeric_null)
			end
			Result := att_numeric_null_
		end

	att_numeric_list: LINKED_LIST [DECIMAL]
		do
			if is_obsolete or else att_numeric_list_ = Void then
				att_numeric_list_ := mt_get_decimal_list_by_position (field_position_of_att_numeric_list)
			end
			Result := att_numeric_list_
		end

	att_numeric_list_null: LINKED_LIST [DECIMAL]
		do
			if is_obsolete or else att_numeric_list_null_ = Void then
				att_numeric_list_null_ := mt_get_decimal_list_by_position (field_position_of_att_numeric_list_null)
			end
			Result := att_numeric_list_null_
		end

	att_boolean: BOOLEAN
		do
			if is_obsolete or else att_boolean_ = Boolean_default_value then
				att_boolean_ := mt_get_boolean_by_position (field_position_of_att_boolean)
			end
			Result := att_boolean_
		end

	att_boolean_null: BOOLEAN
		do
			if is_obsolete or else att_boolean_null_ = Boolean_default_value then
				att_boolean_null_ := mt_get_boolean_by_position (field_position_of_att_boolean_null)
			end
			Result := att_boolean_null_
		end

	att_boolean_list: LINKED_LIST [BOOLEAN]
		do
			if is_obsolete or else att_boolean_list_ = Void then
				att_boolean_list_ := mt_get_boolean_list_by_position (field_position_of_att_boolean_list)
			end
			Result := att_boolean_list_
		end

	att_boolean_list_null: LINKED_LIST [BOOLEAN]
		do
			if is_obsolete or else att_boolean_list_null_ = Void then
				att_boolean_list_null_ := mt_get_boolean_list_by_position (field_position_of_att_boolean_list_null)
			end
			Result := att_boolean_list_null_
		end

	att_string: STRING
		do
			if is_obsolete or else att_string_ = Void then
				att_string_ := mt_get_string_by_position (field_position_of_att_string)
			end
			Result := att_string_
		end

	att_string_null: STRING
		do
			if is_obsolete or else att_string_null_ = Void then
				att_string_null_ := mt_get_string_by_position (field_position_of_att_string_null)
			end
			Result := att_string_null_
		end

	att_string_list: LINKED_LIST [STRING]
		do
			if is_obsolete or else att_string_list_ = Void then
				att_string_list_ := mt_get_string_list_by_position (field_position_of_att_string_list)
			end
			Result := att_string_list_
		end

	att_string_list_null: LINKED_LIST [STRING]
		do
			if is_obsolete or else att_string_list_null_ = Void then
				att_string_list_null_ := mt_get_string_list_by_position (field_position_of_att_string_list_null)
			end
			Result := att_string_list_null_
		end

	att_string_array: ARRAY [STRING]
		do
			if is_obsolete or else att_string_array_ = Void then
				att_string_array_ := mt_get_string_array_by_position (field_position_of_att_string_array)
			end
			Result := att_string_array_
		end

	att_string_array_null: ARRAY [STRING]
		do
			if is_obsolete or else att_string_array_null_ = Void then
				att_string_array_null_ := mt_get_string_array_by_position (field_position_of_att_string_array_null)
			end
			Result := att_string_array_null_
		end

	att_string_utf8: UC_STRING
		do
			if is_obsolete or else att_string_utf8_ = Void then
				att_string_utf8_ := mt_get_string_utf8_by_position (field_position_of_att_string_utf8)
			end
			Result := att_string_utf8_
		end

	att_string_utf8_null: UC_STRING
		do
			if is_obsolete or else att_string_utf8_null_ = Void then
				att_string_utf8_null_ := mt_get_string_utf8_by_position (field_position_of_att_string_utf8_null)
			end
			Result := att_string_utf8_null_
		end

	att_string_utf16: UC_STRING
		do
			if is_obsolete or else att_string_utf16_ = Void then
				att_string_utf16_ := mt_get_string_utf16_by_position (field_position_of_att_string_utf16)
			end
			Result := att_string_utf16_
		end

	att_string_utf16_null: UC_STRING
		do
			if is_obsolete or else att_string_utf16_null_ = Void then
				att_string_utf16_null_ := mt_get_string_utf16_by_position (field_position_of_att_string_utf16_null)
			end
			Result := att_string_utf16_null_
		end

	att_string_list_utf8: LINKED_LIST [UC_STRING]
		do
			if is_obsolete or else att_string_list_utf8_ = Void then
				att_string_list_utf8_ := mt_get_string_utf8_list_by_position (field_position_of_att_string_list_utf8)
			end
			Result := att_string_list_utf8_
		end

	att_string_list_utf8_null: LINKED_LIST [UC_STRING]
		do
			if is_obsolete or else att_string_list_utf8_null_ = Void then
				att_string_list_utf8_null_ := mt_get_string_utf8_list_by_position (field_position_of_att_string_list_utf8_null)
			end
			Result := att_string_list_utf8_null_
		end

	att_string_list_utf16: LINKED_LIST [UC_STRING]
		do
			if is_obsolete or else att_string_list_utf16_ = Void then
				att_string_list_utf16_ := mt_get_string_utf16_list_by_position (field_position_of_att_string_list_utf16)
			end
			Result := att_string_list_utf16_
		end

	att_string_list_utf16_null: LINKED_LIST [UC_STRING]
		do
			if is_obsolete or else att_string_list_utf16_null_ = Void then
				att_string_list_utf16_null_ := mt_get_string_utf16_list_by_position (field_position_of_att_string_list_utf16_null)
			end
			Result := att_string_list_utf16_null_
		end

	att_text: STRING
		do
			if is_obsolete or else att_text_ = Void then
				att_text_ := mt_get_text_by_position (field_position_of_att_text)
			end
			Result := att_text_
		end

	att_text_null: STRING
		do
			if is_obsolete or else att_text_null_ = Void then
				att_text_null_ := mt_get_text_by_position (field_position_of_att_text_null)
			end
			Result := att_text_null_
		end

	att_text_utf8: UC_STRING
		do
			if is_obsolete or else att_text_utf8_ = Void then
				att_text_utf8_ := mt_get_text_utf8_by_position (field_position_of_att_text_utf8)
			end
			Result := att_text_utf8_
		end

	att_text_utf8_null: UC_STRING
		do
			if is_obsolete or else att_text_utf8_null_ = Void then
				att_text_utf8_null_ := mt_get_text_utf8_by_position (field_position_of_att_text_utf8_null)
			end
			Result := att_text_utf8_null_
		end

	att_text_utf16: UC_STRING
		do
			if is_obsolete or else att_text_utf16_ = Void then
				att_text_utf16_ := mt_get_text_utf16_by_position (field_position_of_att_text_utf16)
			end
			Result := att_text_utf16_
		end

	att_text_utf16_null: UC_STRING
		do
			if is_obsolete or else att_text_utf16_null_ = Void then
				att_text_utf16_null_ := mt_get_text_utf16_by_position (field_position_of_att_text_utf16_null)
			end
			Result := att_text_utf16_null_
		end

	att_any: ANY
		do
			if is_obsolete or else att_any_ = Void then
				att_any_ := mt_get_value_by_position (field_position_of_att_any)
			end
			Result := att_any_
		end


feature -- Element change

	set_att_double (new_att_double: DOUBLE)
		do
			att_double_ := new_att_double
			mt_set_double (field_position_of_att_double)
		end

	set_att_double_null (new_att_double_null: DOUBLE)
		do
			att_double_null_ := new_att_double_null
			mt_set_double (field_position_of_att_double_null)
		end

	set_att_double_list (new_att_double_list: LINKED_LIST [DOUBLE])
		do
			att_double_list_ := new_att_double_list
			mt_set_double_list (field_position_of_att_double_list)
		end

	set_att_double_list_null (new_att_double_list_null: LINKED_LIST [DOUBLE])
		do
			att_double_list_null_ := new_att_double_list_null
			mt_set_double_list (field_position_of_att_double_list_null)
		end

	set_att_double_array (new_att_double_array: ARRAY [DOUBLE])
		do
			att_double_array_ := new_att_double_array
			mt_set_double_array (field_position_of_att_double_array)
		end

	set_att_double_array_null (new_att_double_array_null: ARRAY [DOUBLE])
		do
			att_double_array_null_ := new_att_double_array_null
			mt_set_double_array (field_position_of_att_double_array_null)
		end

	set_att_float (new_att_float: REAL)
		do
			att_float_ := new_att_float
			mt_set_real (field_position_of_att_float)
		end

	set_att_float_null (new_att_float_null: REAL)
		do
			att_float_null_ := new_att_float_null
			mt_set_real (field_position_of_att_float_null)
		end

	set_att_float_list (new_att_float_list: LINKED_LIST [REAL])
		do
			att_float_list_ := new_att_float_list
			mt_set_real_list (field_position_of_att_float_list)
		end

	set_att_float_list_null (new_att_float_list_null: LINKED_LIST [REAL])
		do
			att_float_list_null_ := new_att_float_list_null
			mt_set_real_list (field_position_of_att_float_list_null)
		end

	set_att_float_array (new_att_float_array: ARRAY [REAL])
		do
			att_float_array_ := new_att_float_array
			mt_set_real_array (field_position_of_att_float_array)
		end

	set_att_float_array_null (new_att_float_array_null: ARRAY [REAL])
		do
			att_float_array_null_ := new_att_float_array_null
			mt_set_real_array (field_position_of_att_float_array_null)
		end

	set_att_date (new_att_date: DATE)
		do
			if new_att_date = Void then

				att_date_ := Void

			else

				att_date_ := new_att_date.twin
			end

			mt_set_date (field_position_of_att_date)
		end

	set_att_date_null (new_att_date_null: DATE)
		do
			if new_att_date_null = Void then

				att_date_null_ := Void

			else

				att_date_null_ := new_att_date_null.twin
			end

			mt_set_date (field_position_of_att_date_null)
		end

	set_att_date_list (new_att_date_list: LINKED_LIST [DATE])
		do
			att_date_list_ := new_att_date_list
			mt_set_date_list (field_position_of_att_date_list)
		end

	set_att_date_list_null (new_att_date_list_null: LINKED_LIST [DATE])
		do
			att_date_list_null_ := new_att_date_list_null
			mt_set_date_list (field_position_of_att_date_list_null)
		end

	set_att_ts (new_att_ts: DATE_TIME)
		do
			if new_att_ts = Void then

				att_ts_ := Void

			else

				att_ts_ := new_att_ts.twin
			end

			mt_set_timestamp (field_position_of_att_ts)
		end

	set_att_ts_null (new_att_ts_null: DATE_TIME)
		do
			if new_att_ts_null = Void then

				att_ts_null_ := Void

			else

				att_ts_null_ := new_att_ts_null.twin
			end

			mt_set_timestamp (field_position_of_att_ts_null)
		end

	set_att_ts_list (new_att_ts_list: LINKED_LIST [DATE_TIME])
		do
			att_ts_list_ := new_att_ts_list
			mt_set_timestamp_list (field_position_of_att_ts_list)
		end

	set_att_ts_list_null (new_att_ts_list_null: LINKED_LIST [DATE_TIME])
		do
			att_ts_list_null_ := new_att_ts_list_null
			mt_set_timestamp_list (field_position_of_att_ts_list_null)
		end

	set_att_ti (new_att_ti: DATE_TIME_DURATION)
		do
			if new_att_ti = Void then

				att_ti_ := Void

			else

				att_ti_ := new_att_ti.twin
			end

			mt_set_time_interval (field_position_of_att_ti)
		end

	set_att_ti_null (new_att_ti_null: DATE_TIME_DURATION)
		do
			if new_att_ti_null = Void then

				att_ti_null_ := Void

			else

				att_ti_null_ := new_att_ti_null.twin
			end

			mt_set_time_interval (field_position_of_att_ti_null)
		end

	set_att_ti_list (new_att_ti_list: LINKED_LIST [DATE_TIME_DURATION])
		do
			att_ti_list_ := new_att_ti_list
			mt_set_time_interval_list (field_position_of_att_ti_list)
		end

	set_att_ti_list_null (new_att_ti_list_null: LINKED_LIST [DATE_TIME_DURATION])
		do
			att_ti_list_null_ := new_att_ti_list_null
			mt_set_time_interval_list (field_position_of_att_ti_list_null)
		end

	set_att_byte (new_att_byte: NATURAL_8)
		do
			att_byte_ := new_att_byte
			mt_set_byte (field_position_of_att_byte)
		end

	set_att_byte_null (new_att_byte_null: NATURAL_8)
		do
			att_byte_null_ := new_att_byte_null
			mt_set_byte (field_position_of_att_byte_null)
		end

	set_att_bytes (new_att_bytes: ARRAY [NATURAL_8])
		do
			att_bytes_ := new_att_bytes
			mt_set_byte_list (field_position_of_att_bytes)
		end

	set_att_bytes_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_bytes, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_bytes_null (new_att_bytes_null: ARRAY [NATURAL_8])
		do
			att_bytes_null_ := new_att_bytes_null
			mt_set_byte_list (field_position_of_att_bytes_null)
		end

	set_att_bytes_null_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_bytes_null, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_image (new_att_image: ARRAY [NATURAL_8])
		do
			if new_att_image = Void then

				att_image_ := Void

			else

				att_image_ := new_att_image.twin
			end

			mt_set_image (field_position_of_att_image)
		end

	set_att_image_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_image, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_image_null (new_att_image_null: ARRAY [NATURAL_8])
		do
			if new_att_image_null = Void then

				att_image_null_ := Void

			else

				att_image_null_ := new_att_image_null.twin
			end

			mt_set_image (field_position_of_att_image_null)
		end

	set_att_image_null_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_image_null, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_audio (new_att_audio: ARRAY [NATURAL_8])
		do
			if new_att_audio = Void then

				att_audio_ := Void

			else

				att_audio_ := new_att_audio.twin
			end

			mt_set_audio (field_position_of_att_audio)
		end

	set_att_audio_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_audio, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_audio_null (new_att_audio_null: ARRAY [NATURAL_8])
		do
			if new_att_audio_null = Void then

				att_audio_null_ := Void

			else

				att_audio_null_ := new_att_audio_null.twin
			end

			mt_set_audio (field_position_of_att_audio_null)
		end

	set_att_audio_null_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_audio_null, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_video (new_att_video: ARRAY [NATURAL_8])
		do
			if new_att_video = Void then

				att_video_ := Void

			else

				att_video_ := new_att_video.twin
			end

			mt_set_video (field_position_of_att_video)
		end

	set_att_video_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_video, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_video_null (new_att_video_null: ARRAY [NATURAL_8])
		do
			if new_att_video_null = Void then

				att_video_null_ := Void

			else

				att_video_null_ := new_att_video_null.twin
			end

			mt_set_video (field_position_of_att_video_null)
		end

	set_att_video_null_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_att_video_null, buffer,
					buffer_size, offset, discard_after)
		end

	set_att_char (new_att_char: CHARACTER)
		do
			att_char_ := new_att_char
			mt_set_character (field_position_of_att_char)
		end

	set_att_char_null (new_att_char_null: CHARACTER)
		do
			att_char_null_ := new_att_char_null
			mt_set_character (field_position_of_att_char_null)
		end

	set_att_short (new_att_short: INTEGER_16)
		do
			att_short_ := new_att_short
			mt_set_short (field_position_of_att_short)
		end

	set_att_short_null (new_att_short_null: INTEGER_16)
		do
			att_short_null_ := new_att_short_null
			mt_set_short (field_position_of_att_short_null)
		end

	set_att_short_list (new_att_short_list: LINKED_LIST [INTEGER_16])
		do
			att_short_list_ := new_att_short_list
			mt_set_short_list (field_position_of_att_short_list)
		end

	set_att_short_list_null (new_att_short_list_null: LINKED_LIST [INTEGER_16])
		do
			att_short_list_null_ := new_att_short_list_null
			mt_set_short_list (field_position_of_att_short_list_null)
		end

	set_att_integer (new_att_integer: INTEGER)
		do
			att_integer_ := new_att_integer
			mt_set_integer (field_position_of_att_integer)
		end

	set_att_integer_null (new_att_integer_null: INTEGER)
		do
			att_integer_null_ := new_att_integer_null
			mt_set_integer (field_position_of_att_integer_null)
		end

	set_att_int_list (new_att_int_list: LINKED_LIST [INTEGER])
		do
			att_int_list_ := new_att_int_list
			mt_set_integer_list (field_position_of_att_int_list)
		end

	set_att_int_list_null (new_att_int_list_null: LINKED_LIST [INTEGER])
		do
			att_int_list_null_ := new_att_int_list_null
			mt_set_integer_list (field_position_of_att_int_list_null)
		end

	set_att_long (new_att_long: INTEGER_64)
		do
			att_long_ := new_att_long
			mt_set_integer64 (field_position_of_att_long)
		end

	set_att_long_null (new_att_long_null: INTEGER_64)
		do
			att_long_null_ := new_att_long_null
			mt_set_integer64 (field_position_of_att_long_null)
		end

	set_att_long_list (new_att_long_list: LINKED_LIST [INTEGER_64])
		do
			att_long_list_ := new_att_long_list
			mt_set_integer64_list (field_position_of_att_long_list)
		end

	set_att_long_list_null (new_att_long_list_null: LINKED_LIST [INTEGER_64])
		do
			att_long_list_null_ := new_att_long_list_null
			mt_set_integer64_list (field_position_of_att_long_list_null)
		end

	set_att_numeric (new_att_numeric: DECIMAL)
		do
			if new_att_numeric = Void then

				att_numeric_ := Void

			else

				att_numeric_ := new_att_numeric.twin
			end

			mt_set_decimal (field_position_of_att_numeric)
		end

	set_att_numeric_null (new_att_numeric_null: DECIMAL)
		do
			if new_att_numeric_null = Void then

				att_numeric_null_ := Void

			else

				att_numeric_null_ := new_att_numeric_null.twin
			end

			mt_set_decimal (field_position_of_att_numeric_null)
		end

	set_att_numeric_list (new_att_numeric_list: LINKED_LIST [DECIMAL])
		do
			att_numeric_list_ := new_att_numeric_list
			mt_set_decimal_list (field_position_of_att_numeric_list)
		end

	set_att_numeric_list_null (new_att_numeric_list_null: LINKED_LIST [DECIMAL])
		do
			att_numeric_list_null_ := new_att_numeric_list_null
			mt_set_decimal_list (field_position_of_att_numeric_list_null)
		end

	set_att_boolean (new_att_boolean: BOOLEAN)
		do
			att_boolean_ := new_att_boolean
			mt_set_boolean (field_position_of_att_boolean)
		end

	set_att_boolean_null (new_att_boolean_null: BOOLEAN)
		do
			att_boolean_null_ := new_att_boolean_null
			mt_set_boolean (field_position_of_att_boolean_null)
		end

	set_att_boolean_list (new_att_boolean_list: LINKED_LIST [BOOLEAN])
		do
			att_boolean_list_ := new_att_boolean_list
			mt_set_boolean_list (field_position_of_att_boolean_list)
		end

	set_att_boolean_list_null (new_att_boolean_list_null: LINKED_LIST [BOOLEAN])
		do
			att_boolean_list_null_ := new_att_boolean_list_null
			mt_set_boolean_list (field_position_of_att_boolean_list_null)
		end

	set_att_string (new_att_string: STRING)
		do
			if new_att_string = Void then

				att_string_ := Void

			else

				att_string_ := new_att_string.twin
			end

			mt_set_string (field_position_of_att_string)
		end

	set_att_string_null (new_att_string_null: STRING)
		do
			if new_att_string_null = Void then

				att_string_null_ := Void

			else

				att_string_null_ := new_att_string_null.twin
			end

			mt_set_string (field_position_of_att_string_null)
		end

	set_att_string_list (new_att_string_list: LINKED_LIST [STRING])
		do
			att_string_list_ := new_att_string_list
			mt_set_string_list (field_position_of_att_string_list)
		end

	set_att_string_list_null (new_att_string_list_null: LINKED_LIST [STRING])
		do
			att_string_list_null_ := new_att_string_list_null
			mt_set_string_list (field_position_of_att_string_list_null)
		end

	set_att_string_array (new_att_string_array: ARRAY [STRING])
		do
			att_string_array_ := new_att_string_array
			mt_set_string_array (field_position_of_att_string_array)
		end

	set_att_string_array_null (new_att_string_array_null: ARRAY [STRING])
		do
			att_string_array_null_ := new_att_string_array_null
			mt_set_string_array (field_position_of_att_string_array_null)
		end

	set_att_string_utf8 (new_att_string_utf8: UC_STRING)
		do
			if new_att_string_utf8 = Void then

				att_string_utf8_ := Void

			else

				att_string_utf8_ := new_att_string_utf8.twin
			end

			mt_set_string_utf8 (field_position_of_att_string_utf8)
		end

	set_att_string_utf8_null (new_att_string_utf8_null: UC_STRING)
		do
			if new_att_string_utf8_null = Void then

				att_string_utf8_null_ := Void

			else

				att_string_utf8_null_ := new_att_string_utf8_null.twin
			end

			mt_set_string_utf8 (field_position_of_att_string_utf8_null)
		end

	set_att_string_utf16 (new_att_string_utf16: UC_STRING)
		do
			if new_att_string_utf16 = Void then

				att_string_utf16_ := Void

			else

				att_string_utf16_ := new_att_string_utf16.twin
			end

			mt_set_string_utf16 (field_position_of_att_string_utf16)
		end

	set_att_string_utf16_null (new_att_string_utf16_null: UC_STRING)
		do
			if new_att_string_utf16_null = Void then

				att_string_utf16_null_ := Void

			else

				att_string_utf16_null_ := new_att_string_utf16_null.twin
			end

			mt_set_string_utf16 (field_position_of_att_string_utf16_null)
		end

	set_att_string_list_utf8 (new_att_string_list_utf8: LINKED_LIST [UC_STRING])
		do
			att_string_list_utf8_ := new_att_string_list_utf8
			mt_set_string_utf8_list (field_position_of_att_string_list_utf8)
		end

	set_att_string_list_utf8_null (new_att_string_list_utf8_null: LINKED_LIST [UC_STRING])
		do
			att_string_list_utf8_null_ := new_att_string_list_utf8_null
			mt_set_string_utf8_list (field_position_of_att_string_list_utf8_null)
		end

	set_att_string_list_utf16 (new_att_string_list_utf16: LINKED_LIST [UC_STRING])
		do
			att_string_list_utf16_ := new_att_string_list_utf16
			mt_set_string_utf16_list (field_position_of_att_string_list_utf16)
		end

	set_att_string_list_utf16_null (new_att_string_list_utf16_null: LINKED_LIST [UC_STRING])
		do
			att_string_list_utf16_null_ := new_att_string_list_utf16_null
			mt_set_string_utf16_list (field_position_of_att_string_list_utf16_null)
		end

	set_att_text (new_att_text: STRING)
		do
			if new_att_text = Void then

				att_text_ := Void

			else

				att_text_ := new_att_text.twin
			end

			mt_set_text (field_position_of_att_text)
		end

	set_att_text_null (new_att_text_null: STRING)
		do
			if new_att_text_null = Void then

				att_text_null_ := Void

			else

				att_text_null_ := new_att_text_null.twin
			end

			mt_set_text (field_position_of_att_text_null)
		end

	set_att_text_utf8 (new_att_text_utf8: UC_STRING)
		do
			if new_att_text_utf8 = Void then

				att_text_utf8_ := Void

			else

				att_text_utf8_ := new_att_text_utf8.twin
			end

			mt_set_text (field_position_of_att_text_utf8)
		end

	set_att_text_utf8_null (new_att_text_utf8_null: UC_STRING)
		do
			if new_att_text_utf8_null = Void then

				att_text_utf8_null_ := Void

			else

				att_text_utf8_null_ := new_att_text_utf8_null.twin
			end

			mt_set_text (field_position_of_att_text_utf8_null)
		end

	set_att_text_utf16 (new_att_text_utf16: UC_STRING)
		do
			if new_att_text_utf16 = Void then

				att_text_utf16_ := Void

			else

				att_text_utf16_ := new_att_text_utf16.twin
			end

			mt_set_text (field_position_of_att_text_utf16)
		end

	set_att_text_utf16_null (new_att_text_utf16_null: UC_STRING)
		do
			if new_att_text_utf16_null = Void then

				att_text_utf16_null_ := Void

			else

				att_text_utf16_null_ := new_att_text_utf16_null.twin
			end

			mt_set_text (field_position_of_att_text_utf16_null)
		end

	set_att_any (new_att_any: ANY)
		do
			att_any_ := new_att_any
			mt_set_value (field_position_of_att_any)
		end


feature {NONE} -- Implementation

	field_position_of_identifier: INTEGER
		once
			Result := field_position_of ("identifier_")
		end


	field_position_of_att_double: INTEGER
		once
			Result := field_position_of ("att_double_")
		end

	field_position_of_att_double_null: INTEGER
		once
			Result := field_position_of ("att_double_null_")
		end

	field_position_of_att_double_list: INTEGER
		once
			Result := field_position_of ("att_double_list_")
		end

	field_position_of_att_double_list_null: INTEGER
		once
			Result := field_position_of ("att_double_list_null_")
		end

	field_position_of_att_double_array: INTEGER
		once
			Result := field_position_of ("att_double_array_")
		end

	field_position_of_att_double_array_null: INTEGER
		once
			Result := field_position_of ("att_double_array_null_")
		end

	field_position_of_att_float: INTEGER
		once
			Result := field_position_of ("att_float_")
		end

	field_position_of_att_float_null: INTEGER
		once
			Result := field_position_of ("att_float_null_")
		end

	field_position_of_att_float_list: INTEGER
		once
			Result := field_position_of ("att_float_list_")
		end

	field_position_of_att_float_list_null: INTEGER
		once
			Result := field_position_of ("att_float_list_null_")
		end

	field_position_of_att_float_array: INTEGER
		once
			Result := field_position_of ("att_float_array_")
		end

	field_position_of_att_float_array_null: INTEGER
		once
			Result := field_position_of ("att_float_array_null_")
		end

	field_position_of_att_date: INTEGER
		once
			Result := field_position_of ("att_date_")
		end

	field_position_of_att_date_null: INTEGER
		once
			Result := field_position_of ("att_date_null_")
		end

	field_position_of_att_date_list: INTEGER
		once
			Result := field_position_of ("att_date_list_")
		end

	field_position_of_att_date_list_null: INTEGER
		once
			Result := field_position_of ("att_date_list_null_")
		end

	field_position_of_att_ts: INTEGER
		once
			Result := field_position_of ("att_ts_")
		end

	field_position_of_att_ts_null: INTEGER
		once
			Result := field_position_of ("att_ts_null_")
		end

	field_position_of_att_ts_list: INTEGER
		once
			Result := field_position_of ("att_ts_list_")
		end

	field_position_of_att_ts_list_null: INTEGER
		once
			Result := field_position_of ("att_ts_list_null_")
		end

	field_position_of_att_ti: INTEGER
		once
			Result := field_position_of ("att_ti_")
		end

	field_position_of_att_ti_null: INTEGER
		once
			Result := field_position_of ("att_ti_null_")
		end

	field_position_of_att_ti_list: INTEGER
		once
			Result := field_position_of ("att_ti_list_")
		end

	field_position_of_att_ti_list_null: INTEGER
		once
			Result := field_position_of ("att_ti_list_null_")
		end

	field_position_of_att_byte: INTEGER
		once
			Result := field_position_of ("att_byte_")
		end

	field_position_of_att_byte_null: INTEGER
		once
			Result := field_position_of ("att_byte_null_")
		end

	field_position_of_att_bytes: INTEGER
		once
			Result := field_position_of ("att_bytes_")
		end

	field_position_of_att_bytes_null: INTEGER
		once
			Result := field_position_of ("att_bytes_null_")
		end

	field_position_of_att_image: INTEGER
		once
			Result := field_position_of ("att_image_")
		end

	field_position_of_att_image_null: INTEGER
		once
			Result := field_position_of ("att_image_null_")
		end

	field_position_of_att_audio: INTEGER
		once
			Result := field_position_of ("att_audio_")
		end

	field_position_of_att_audio_null: INTEGER
		once
			Result := field_position_of ("att_audio_null_")
		end

	field_position_of_att_video: INTEGER
		once
			Result := field_position_of ("att_video_")
		end

	field_position_of_att_video_null: INTEGER
		once
			Result := field_position_of ("att_video_null_")
		end

	field_position_of_att_char: INTEGER
		once
			Result := field_position_of ("att_char_")
		end

	field_position_of_att_char_null: INTEGER
		once
			Result := field_position_of ("att_char_null_")
		end

	field_position_of_att_short: INTEGER
		once
			Result := field_position_of ("att_short_")
		end

	field_position_of_att_short_null: INTEGER
		once
			Result := field_position_of ("att_short_null_")
		end

	field_position_of_att_short_list: INTEGER
		once
			Result := field_position_of ("att_short_list_")
		end

	field_position_of_att_short_list_null: INTEGER
		once
			Result := field_position_of ("att_short_list_null_")
		end

	field_position_of_att_integer: INTEGER
		once
			Result := field_position_of ("att_integer_")
		end

	field_position_of_att_integer_null: INTEGER
		once
			Result := field_position_of ("att_integer_null_")
		end

	field_position_of_att_int_list: INTEGER
		once
			Result := field_position_of ("att_int_list_")
		end

	field_position_of_att_int_list_null: INTEGER
		once
			Result := field_position_of ("att_int_list_null_")
		end

	field_position_of_att_long: INTEGER
		once
			Result := field_position_of ("att_long_")
		end

	field_position_of_att_long_null: INTEGER
		once
			Result := field_position_of ("att_long_null_")
		end

	field_position_of_att_long_list: INTEGER
		once
			Result := field_position_of ("att_long_list_")
		end

	field_position_of_att_long_list_null: INTEGER
		once
			Result := field_position_of ("att_long_list_null_")
		end

	field_position_of_att_numeric: INTEGER
		once
			Result := field_position_of ("att_numeric_")
		end

	field_position_of_att_numeric_null: INTEGER
		once
			Result := field_position_of ("att_numeric_null_")
		end

	field_position_of_att_numeric_list: INTEGER
		once
			Result := field_position_of ("att_numeric_list_")
		end

	field_position_of_att_numeric_list_null: INTEGER
		once
			Result := field_position_of ("att_numeric_list_null_")
		end

	field_position_of_att_boolean: INTEGER
		once
			Result := field_position_of ("att_boolean_")
		end

	field_position_of_att_boolean_null: INTEGER
		once
			Result := field_position_of ("att_boolean_null_")
		end

	field_position_of_att_boolean_list: INTEGER
		once
			Result := field_position_of ("att_boolean_list_")
		end

	field_position_of_att_boolean_list_null: INTEGER
		once
			Result := field_position_of ("att_boolean_list_null_")
		end

	field_position_of_att_string: INTEGER
		once
			Result := field_position_of ("att_string_")
		end

	field_position_of_att_string_null: INTEGER
		once
			Result := field_position_of ("att_string_null_")
		end

	field_position_of_att_string_list: INTEGER
		once
			Result := field_position_of ("att_string_list_")
		end

	field_position_of_att_string_list_null: INTEGER
		once
			Result := field_position_of ("att_string_list_null_")
		end

	field_position_of_att_string_array: INTEGER
		once
			Result := field_position_of ("att_string_array_")
		end

	field_position_of_att_string_array_null: INTEGER
		once
			Result := field_position_of ("att_string_array_null_")
		end

	field_position_of_att_string_utf8: INTEGER
		once
			Result := field_position_of ("att_string_utf8_")
		end

	field_position_of_att_string_utf8_null: INTEGER
		once
			Result := field_position_of ("att_string_utf8_null_")
		end

	field_position_of_att_string_utf16: INTEGER
		once
			Result := field_position_of ("att_string_utf16_")
		end

	field_position_of_att_string_utf16_null: INTEGER
		once
			Result := field_position_of ("att_string_utf16_null_")
		end

	field_position_of_att_string_list_utf8: INTEGER
		once
			Result := field_position_of ("att_string_list_utf8_")
		end

	field_position_of_att_string_list_utf8_null: INTEGER
		once
			Result := field_position_of ("att_string_list_utf8_null_")
		end

	field_position_of_att_string_list_utf16: INTEGER
		once
			Result := field_position_of ("att_string_list_utf16_")
		end

	field_position_of_att_string_list_utf16_null: INTEGER
		once
			Result := field_position_of ("att_string_list_utf16_null_")
		end

	field_position_of_att_text: INTEGER
		once
			Result := field_position_of ("att_text_")
		end

	field_position_of_att_text_null: INTEGER
		once
			Result := field_position_of ("att_text_null_")
		end

	field_position_of_att_text_utf8: INTEGER
		once
			Result := field_position_of ("att_text_utf8_")
		end

	field_position_of_att_text_utf8_null: INTEGER
		once
			Result := field_position_of ("att_text_utf8_null_")
		end

	field_position_of_att_text_utf16: INTEGER
		once
			Result := field_position_of ("att_text_utf16_")
		end

	field_position_of_att_text_utf16_null: INTEGER
		once
			Result := field_position_of ("att_text_utf16_null_")
		end

	field_position_of_att_any: INTEGER
		once
			Result := field_position_of ("att_any_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

feature

	post_retrieved: BOOLEAN is
		do
			for_post_retrieved := att_integer + 10
			Result := True
		end

feature -- attribute used to test 'post_retrieved

	for_post_retrieved: INTEGER

	set_for_post_retrieved (an_int: INTEGER) is
		do
			for_post_retrieved := an_int
		end


end -- class ATTRS_CLASS

