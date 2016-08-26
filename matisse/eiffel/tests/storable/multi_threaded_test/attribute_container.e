
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class 
	ATTRIBUTE_CONTAINER

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MT_STORABLE
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance



-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 8.4.0
-- Date: Wed Oct  6 09:17:05 2010

feature {NONE}

	the_string_: STRING
	the_integer_: INTEGER
	the_boolean_: BOOLEAN
	the_timestamp_: DATE_TIME
	the_date_: DATE
	the_string_list_: LINKED_LIST [STRING]
	the_image_: ARRAY [NATURAL_8]
	the_numeric_: DECIMAL
	the_float_: REAL

feature -- Access

	the_string: STRING
		do
			if is_obsolete or else the_string_ = Void then
				the_string_ := mt_get_string_by_position (field_position_of_the_string)
			end
			Result := the_string_
		end

	the_integer: INTEGER
		do
			if is_obsolete or else the_integer_ = Integer_default_value then
				the_integer_ := mt_get_integer_by_position (field_position_of_the_integer)
			end
			Result := the_integer_
		end

	the_boolean: BOOLEAN
		do
			if is_obsolete or else the_boolean_ = Boolean_default_value then
				the_boolean_ := mt_get_boolean_by_position (field_position_of_the_boolean)
			end
			Result := the_boolean_
		end

	the_timestamp: DATE_TIME
		do
			if is_obsolete or else the_timestamp_ = Void then
				the_timestamp_ := mt_get_timestamp_by_position (field_position_of_the_timestamp)
			end
			Result := the_timestamp_
		end

	the_date: DATE
		do
			if is_obsolete or else the_date_ = Void then
				the_date_ := mt_get_date (field_position_of_the_date)
			end
			Result := the_date_
		end

	the_string_list: LINKED_LIST [STRING]
		do
			if is_obsolete or else the_string_list_ = Void then
				the_string_list_ := mt_get_string_list_by_position (field_position_of_the_string_list)
			end
			Result := the_string_list_
		end

	the_image: ARRAY [NATURAL_8]
		do
			if is_obsolete or else the_image_ = Void then
				the_image_ := mt_get_image_by_position (field_position_of_the_image)
			end
			Result := the_image_
		end

	get_the_image_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_the_image, buffer, count, offset)
		end

	the_numeric: DECIMAL
		do
			if is_obsolete or else the_numeric_ = Void then
				the_numeric_ := mt_get_decimal_by_position (field_position_of_the_numeric)
			end
			Result := the_numeric_
		end

	the_float: REAL
		do
			if is_obsolete or else the_float_ = Real_default_value then
				the_float_ := mt_get_real_by_position (field_position_of_the_float)
			end
			Result := the_float_
		end


feature -- Element change

	set_the_string (new_the_string: STRING)
		do
			if new_the_string = Void then

				the_string_ := Void

			else

				the_string_ := new_the_string.twin
			end

			mt_set_string (field_position_of_the_string)
		end

	set_the_integer (new_the_integer: INTEGER)
		do
			the_integer_ := new_the_integer
			mt_set_integer (field_position_of_the_integer)
		end

	set_the_boolean (new_the_boolean: BOOLEAN)
		do
			the_boolean_ := new_the_boolean
			mt_set_boolean (field_position_of_the_boolean)
		end

	set_the_timestamp (new_the_timestamp: DATE_TIME)
		do
			if new_the_timestamp = Void then

				the_timestamp_ := Void

			else

				the_timestamp_ := new_the_timestamp.twin
			end

			mt_set_timestamp (field_position_of_the_timestamp)
		end

	set_the_date (new_the_date: DATE)
		do
			if new_the_date = Void then

				the_date_ := Void

			else

				the_date_ := new_the_date.twin
			end

			mt_set_date (field_position_of_the_date)
		end

	set_the_string_list (new_the_string_list: LINKED_LIST [STRING])
		do
			the_string_list_ := new_the_string_list
			mt_set_string_list (field_position_of_the_string_list)
		end

	set_the_image (new_the_image: ARRAY [NATURAL_8])
		do
			if new_the_image = Void then

				the_image_ := Void

			else

				the_image_ := new_the_image.twin
			end

			mt_set_image (field_position_of_the_image)
		end

	set_the_image_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_the_image, buffer,
					buffer_size, offset, discard_after)
		end

	set_the_numeric (new_the_numeric: DECIMAL)
		do
			if new_the_numeric = Void then

				the_numeric_ := Void

			else

				the_numeric_ := new_the_numeric.twin
			end

			mt_set_decimal (field_position_of_the_numeric)
		end

	set_the_float (new_the_float: REAL)
		do
			the_float_ := new_the_float
			mt_set_real (field_position_of_the_float)
		end


feature {NONE} -- Implementation

	field_position_of_the_string: INTEGER
		once
			Result := field_position_of ("the_string_")
		end

	field_position_of_the_integer: INTEGER
		once
			Result := field_position_of ("the_integer_")
		end

	field_position_of_the_boolean: INTEGER
		once
			Result := field_position_of ("the_boolean_")
		end

	field_position_of_the_timestamp: INTEGER
		once
			Result := field_position_of ("the_timestamp_")
		end

	field_position_of_the_date: INTEGER
		once
			Result := field_position_of ("the_date_")
		end

	field_position_of_the_string_list: INTEGER
		once
			Result := field_position_of ("the_string_list_")
		end

	field_position_of_the_image: INTEGER
		once
			Result := field_position_of ("the_image_")
		end

	field_position_of_the_numeric: INTEGER
		once
			Result := field_position_of ("the_numeric_")
		end

	field_position_of_the_float: INTEGER
		once
			Result := field_position_of ("the_float_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class ATTRIBUTE_CONTAINER

