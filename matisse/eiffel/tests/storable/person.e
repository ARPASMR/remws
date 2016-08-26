
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class 
	PERSON

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
-- Date: Sat Oct 23 16:40:08 2010

feature {NONE}

	lastname_: STRING
	firstname_: STRING
	creationdate_: DATE_TIME
	facephoto_: ARRAY [NATURAL_8]
	spouse_: PERSON
	cars_: MT_LINKED_LIST [CAR]
	cars_ht_: MT_HASH_TABLE [CAR, STRING]

feature -- Access

	lastname: STRING
		do
			if is_obsolete or else lastname_ = Void then
				lastname_ := mt_get_string_by_position (field_position_of_lastname)
			end
			Result := lastname_
		end

	firstname: STRING
		do
			if is_obsolete or else firstname_ = Void then
				firstname_ := mt_get_string_by_position (field_position_of_firstname)
			end
			Result := firstname_
		end

	creationdate: DATE_TIME
		do
			if is_obsolete or else creationdate_ = Void then
				creationdate_ := mt_get_timestamp_by_position (field_position_of_creationdate)
			end
			Result := creationdate_
		end

	facephoto: ARRAY [NATURAL_8]
		do
			if is_obsolete or else facephoto_ = Void then
				facephoto_ := mt_get_image_by_position (field_position_of_facephoto)
			end
			Result := facephoto_
		end

	get_facephoto_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER) : INTEGER
		do
			Result := mt_get_byte_list_elements (field_position_of_facephoto, buffer, count, offset)
		end

	spouse: PERSON
		do
			if is_obsolete or else spouse_ = Void then
				spouse_ ?= mt_get_successor_by_position (field_position_of_spouse)
			end
			Result := spouse_
		end

	cars: LINKED_LIST [CAR]
		do
			if is_persistent then
				cars_.load_successors
			end
			Result := cars_
		end

	cars_ht: HASH_TABLE [CAR, STRING]
		do
			if is_persistent then
				if cars_ht_ = Void then
					Create cars_ht_.make (1)
					cars_ht_.become_persistent_container (db, Current, field_position_of_cars_ht)
				else
					cars_ht_.load_successors
				end
			end
			Result := cars_ht_
		end


feature -- Element change

	set_lastname (new_lastname: STRING)
		do
			if new_lastname = Void then

				lastname_ := Void

			else

				lastname_ := new_lastname.twin
			end

			mt_set_string (field_position_of_lastname)
		end

	set_firstname (new_firstname: STRING)
		do
			if new_firstname = Void then

				firstname_ := Void

			else

				firstname_ := new_firstname.twin
			end

			mt_set_string (field_position_of_firstname)
		end

	set_creationdate (new_creationdate: DATE_TIME)
		do
			if new_creationdate = Void then

				creationdate_ := Void

			else

				creationdate_ := new_creationdate.twin
			end

			mt_set_timestamp (field_position_of_creationdate)
		end

	set_facephoto (new_facephoto: ARRAY [NATURAL_8])
		do
			if new_facephoto = Void then

				facephoto_ := Void

			else

				facephoto_ := new_facephoto.twin
			end

			mt_set_image (field_position_of_facephoto)
		end

	set_facephoto_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_facephoto, buffer,
					buffer_size, offset, discard_after)
		end

	set_spouse (new_spouse: PERSON)
		do
			check_persistence (new_spouse)
			spouse_ := new_spouse
			mt_set_successor (field_position_of_spouse)
		end


feature {NONE} -- Implementation

	field_position_of_lastname: INTEGER
		once
			Result := field_position_of ("lastname_")
		end

	field_position_of_firstname: INTEGER
		once
			Result := field_position_of ("firstname_")
		end

	field_position_of_creationdate: INTEGER
		once
			Result := field_position_of ("creationdate_")
		end

	field_position_of_facephoto: INTEGER
		once
			Result := field_position_of ("facephoto_")
		end

	field_position_of_spouse: INTEGER
		once
			Result := field_position_of ("spouse_")
		end

	field_position_of_cars_ht: INTEGER
		once
			Result := field_position_of ("cars_ht_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class PERSON

