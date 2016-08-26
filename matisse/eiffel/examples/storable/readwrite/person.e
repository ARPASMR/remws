
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:49 $"

class 
	PERSON

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MT_STORABLE
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance

	redefine
		deep_remove
	end

-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 9.0.0
-- Date: Fri Dec  2 16:35:27 2011

feature {NONE}

	firstname_: STRING
	lastname_: STRING
	comment_: STRING
	age_: INTEGER_32
	birthdate_: DATE
	dependents_: INTEGER_32
	photo_: ARRAY [NATURAL_8]
	address_: POSTALADDRESS

feature -- Access

	firstname: STRING
		do
			if is_obsolete or else firstname_ = Void then
				firstname_ := mt_get_string_by_position (field_position_of_firstname)
			end
			Result := firstname_
		end

	lastname: STRING
		do
			if is_obsolete or else lastname_ = Void then
				lastname_ := mt_get_string_by_position (field_position_of_lastname)
			end
			Result := lastname_
		end

	comment: STRING
		do
			if is_obsolete or else comment_ = Void then
				comment_ := mt_get_string_by_position (field_position_of_comment)
			end
			Result := comment_
		end

	age: INTEGER_32
		do
			if is_obsolete or else age_ = Integer_default_value then
				age_ := mt_get_integer_by_position (field_position_of_age)
			end
			Result := age_
		end

	birthdate: DATE
		do
			if is_obsolete or else birthdate_ = Void then
				birthdate_ := mt_get_date (field_position_of_birthdate)
			end
			Result := birthdate_
		end

	dependents: INTEGER_32
		do
			if is_obsolete or else dependents_ = Integer_default_value then
				dependents_ := mt_get_integer_by_position (field_position_of_dependents)
			end
			Result := dependents_
		end

	photo: ARRAY [NATURAL_8]
		do
			if is_obsolete or else photo_ = Void then
				photo_ := mt_get_image_by_position (field_position_of_photo)
			end
			Result := photo_
		end

	get_photo_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER_32) : INTEGER_32
		do
			Result := mt_get_byte_list_elements (field_position_of_photo, buffer, count, offset)
		end

	address: POSTALADDRESS
		do
			if is_obsolete or else address_ = Void then
				address_ ?= mt_get_successor_by_position (field_position_of_address)
			end
			Result := address_
		end


feature -- Element change

	set_firstname (new_firstname: STRING)
		do
			if new_firstname = Void then

				firstname_ := Void

			else

				firstname_ := new_firstname.twin
			end

			mt_set_string (field_position_of_firstname)
		end

	set_lastname (new_lastname: STRING)
		do
			if new_lastname = Void then

				lastname_ := Void

			else

				lastname_ := new_lastname.twin
			end

			mt_set_string (field_position_of_lastname)
		end

	set_comment (new_comment: STRING)
		do
			if new_comment = Void then

				comment_ := Void

			else

				comment_ := new_comment.twin
			end

			mt_set_string (field_position_of_comment)
		end

	set_age (new_age: INTEGER_32)
		do
			age_ := new_age
			mt_set_integer (field_position_of_age)
		end

	set_birthdate (new_birthdate: DATE)
		do
			if new_birthdate = Void then

				birthdate_ := Void

			else

				birthdate_ := new_birthdate.twin
			end

			mt_set_date (field_position_of_birthdate)
		end

	set_dependents (new_dependents: INTEGER_32)
		do
			dependents_ := new_dependents
			mt_set_integer (field_position_of_dependents)
		end

	set_photo (new_photo: ARRAY [NATURAL_8])
		do
			if new_photo = Void then

				photo_ := Void

			else

				photo_ := new_photo.twin
			end

			mt_set_image (field_position_of_photo)
		end

	set_photo_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER_32;
			discard_after: BOOLEAN)
		do
			mt_set_byte_list_elements (field_position_of_photo, buffer,
					buffer_size, offset, discard_after)
		end

	set_address (new_address: POSTALADDRESS)
		do
			check_persistence (new_address)
			address_ := new_address
			mt_set_successor (field_position_of_address)
		end


feature {NONE} -- Implementation

	field_position_of_firstname: INTEGER_32
		once
			Result := field_position_of ("firstname_")
		end

	field_position_of_lastname: INTEGER_32
		once
			Result := field_position_of ("lastname_")
		end

	field_position_of_comment: INTEGER_32
		once
			Result := field_position_of ("comment_")
		end

	field_position_of_age: INTEGER_32
		once
			Result := field_position_of ("age_")
		end

	field_position_of_birthdate: INTEGER_32
		once
			Result := field_position_of ("birthdate_")
		end

	field_position_of_dependents: INTEGER_32
		once
			Result := field_position_of ("dependents_")
		end

	field_position_of_photo: INTEGER_32
		once
			Result := field_position_of ("photo_")
		end

	field_position_of_address: INTEGER_32
		once
			Result := field_position_of ("address_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

feature  -- Delete object

	deep_remove ()
		-- Delete the current object and the Address from the database.
		local
			adrs: POSTALADDRESS
		do

			adrs := Current.address ()
			if adrs /= Void then
				adrs.deep_remove ()
			end
			mt_remove ()
		end

end -- class PERSON

