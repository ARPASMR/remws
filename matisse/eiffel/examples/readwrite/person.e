
note
	description: "Generated with Matisse Schema Definition Language 9.0.0";
	date: "$Date: 2011/12/03 00:41:48 $"

class 
	PERSON

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MTOBJECT
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance

    redefine
        deep_remove
      , deep_lock
    end

-- BEGIN generation of create by Matisse SDL
create
	make_from_mtoid
	, make_from_mtclass
-- END of Matisse SDL generation of create
	, make_person

-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 9.0.0
-- Date: Fri Dec  2 16:18:37 2011

feature -- Property Access

	get_firstname_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of firstName from the database
		do
			Result := mtdb.get_mtattribute("firstName", mtdb.get_mtclass("PERSON"))
		end

	firstname, get_firstname (): STRING
		-- get the value of firstName from the database
		do
			Result := get_string (get_firstname_attribute ())
		end

	is_firstname_default_value (): BOOLEAN
		-- Check if firstName attribute value is set to its default value
		do
			Result := is_default_value (get_firstname_attribute ())
		end

	get_lastname_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of lastName from the database
		do
			Result := mtdb.get_mtattribute("lastName", mtdb.get_mtclass("PERSON"))
		end

	lastname, get_lastname (): STRING
		-- get the value of lastName from the database
		do
			Result := get_string (get_lastname_attribute ())
		end

	is_lastname_default_value (): BOOLEAN
		-- Check if lastName attribute value is set to its default value
		do
			Result := is_default_value (get_lastname_attribute ())
		end

	get_comment_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of comment from the database
		do
			Result := mtdb.get_mtattribute("comment", mtdb.get_mtclass("PERSON"))
		end

	comment, get_comment (): STRING
		-- get the value of comment from the database
		do
			Result := get_string (get_comment_attribute ())
		end

	is_comment_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_comment_attribute ())
		end

	is_comment_default_value (): BOOLEAN
		-- Check if comment attribute value is set to its default value
		do
			Result := is_default_value (get_comment_attribute ())
		end

	get_age_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of age from the database
		do
			Result := mtdb.get_mtattribute("age", mtdb.get_mtclass("PERSON"))
		end

	age, get_age (): INTEGER_32
		-- get the value of age from the database
		do
			Result := get_integer (get_age_attribute ())
		end

	is_age_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_age_attribute ())
		end

	is_age_default_value (): BOOLEAN
		-- Check if age attribute value is set to its default value
		do
			Result := is_default_value (get_age_attribute ())
		end

	get_birthdate_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of birthdate from the database
		do
			Result := mtdb.get_mtattribute("birthdate", mtdb.get_mtclass("PERSON"))
		end

	birthdate, get_birthdate (): DATE
		-- get the value of birthdate from the database
		do
			Result := get_date (get_birthdate_attribute ())
		end

	is_birthdate_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_birthdate_attribute ())
		end

	is_birthdate_default_value (): BOOLEAN
		-- Check if birthdate attribute value is set to its default value
		do
			Result := is_default_value (get_birthdate_attribute ())
		end

	get_dependents_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of dependents from the database
		do
			Result := mtdb.get_mtattribute("dependents", mtdb.get_mtclass("PERSON"))
		end

	dependents, get_dependents (): INTEGER_32
		-- get the value of dependents from the database
		do
			Result := get_integer (get_dependents_attribute ())
		end

	is_dependents_default_value (): BOOLEAN
		-- Check if dependents attribute value is set to its default value
		do
			Result := is_default_value (get_dependents_attribute ())
		end

	get_photo_attribute (): MTATTRIBUTE
		-- get the attribute descriptor of photo from the database
		do
			Result := mtdb.get_mtattribute("photo", mtdb.get_mtclass("PERSON"))
		end

	photo, get_photo (): ARRAY [NATURAL_8]
		-- get the value of photo from the database
		do
			Result := get_image (get_photo_attribute ())
		end

	is_photo_null (): BOOLEAN
		-- Check if nullable attribute value is set to MT_NULL
		do
			Result := is_null (get_photo_attribute ())
		end

	is_photo_default_value (): BOOLEAN
		-- Check if photo attribute value is set to its default value
		do
			Result := is_default_value (get_photo_attribute ())
		end

	get_photo_elements (buffer: ARRAY [NATURAL_8]; count, offset: INTEGER_32) : INTEGER_32
		do
			Result := get_byte_list_elements (get_photo_attribute(), buffer, count, offset)
		end

	get_photo_size () : INTEGER_32
		do
			Result := get_list_size (get_photo_attribute())
		end

	get_address_relationship (): MTRELATIONSHIP
		-- get the relationship descriptor of Address from the database
		do
			Result := mtdb.get_mtrelationship ("Address", mtdb.get_mtclass("PERSON"))
		end

	address, get_address (): POSTALADDRESS
		-- get the Address relationship successor from the database
		do
			Result ?= get_successor (get_address_relationship ())
		end


feature -- Update Attributes

	set_firstname (a_val: STRING)
		-- update firstName attribute value in the database
		do
			set_string (get_firstname_attribute (), a_val)
		end

	remove_firstname ()
		-- remove firstName attribute value in the database
		do
			remove_value (get_firstname_attribute ())
		end

	set_lastname (a_val: STRING)
		-- update lastName attribute value in the database
		do
			set_string (get_lastname_attribute (), a_val)
		end

	remove_lastname ()
		-- remove lastName attribute value in the database
		do
			remove_value (get_lastname_attribute ())
		end

	set_comment (a_val: STRING)
		-- update comment attribute value in the database
		do
			set_string (get_comment_attribute (), a_val)
		end

	remove_comment ()
		-- remove comment attribute value in the database
		do
			remove_value (get_comment_attribute ())
		end

	set_age (a_val: INTEGER_32)
		-- update age attribute value in the database
		do
			set_integer (get_age_attribute (), a_val)
		end

	remove_age ()
		-- remove age attribute value in the database
		do
			remove_value (get_age_attribute ())
		end

	set_birthdate (a_val: DATE)
		-- update birthdate attribute value in the database
		do
			set_date (get_birthdate_attribute (), a_val)
		end

	remove_birthdate ()
		-- remove birthdate attribute value in the database
		do
			remove_value (get_birthdate_attribute ())
		end

	set_dependents (a_val: INTEGER_32)
		-- update dependents attribute value in the database
		do
			set_integer (get_dependents_attribute (), a_val)
		end

	remove_dependents ()
		-- remove dependents attribute value in the database
		do
			remove_value (get_dependents_attribute ())
		end

	set_photo (a_val: ARRAY [NATURAL_8])
		-- update photo attribute value in the database
		do
			set_image (get_photo_attribute (), a_val)
		end

	remove_photo ()
		-- remove photo attribute value in the database
		do
			remove_value (get_photo_attribute ())
		end

	set_photo_elements(buffer: ARRAY [NATURAL_8]; buffer_size, offset: INTEGER_32;
			discard_after: BOOLEAN)
		do
			set_byte_list_elements (get_photo_attribute (), buffer,
					buffer_size, offset, discard_after)
		end

	set_address (succ: POSTALADDRESS)
		-- Update Address relationship successor
		do
			set_successor (get_address_relationship (), succ)
		end

	clear_address ()
		-- Remove Address relationship successor
		do
			clear_successors (get_address_relationship ())
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

feature -- Default Creation Function

	make_person (a_db: MT_DATABASE)
		-- Default make feature provided as an example
		-- You may delete or modify it to suit your needs.
		do
			make_from_mtclass (a_db.get_mtclass ("PERSON"))
		end

feature  -- Delete object

        deep_remove ()
                -- Delete the current object and the Address from the database.
                local
                        adrs: POSTALADDRESS
                do

                        adrs := Current.address ()
                        if adrs /= Void then
                                -- be careful of cyclic calls
                                -- when using deep_remove() on navigation
                                adrs.deep_remove ()
                        end
                        remove ()
                end

        deep_lock (a_lock: INTEGER)
                -- Lock the current object and the Address from the database.
                local
                        adrs: POSTALADDRESS
                do

                        adrs := Current.address ()
                        if adrs /= Void then
                                -- be careful of cyclic calls
                                -- when using deep_deep() on navigation
                                adrs.deep_lock (a_lock)
                        end
                        lock (a_lock)
                end

end -- class PERSON

