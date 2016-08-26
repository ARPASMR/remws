
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	INDEX_CLASS

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

	idxnum_: DECIMAL
	idxint_: INTEGER
	idxstr_: STRING

feature -- Access

	idxnum: DECIMAL
		do
			if is_obsolete or else idxnum_ = Void then
				idxnum_ := mt_get_decimal_by_position (field_position_of_idxnum)
			end
			Result := idxnum_
		end

	idxint: INTEGER
		do
			if is_obsolete or else idxint_ = Integer_default_value then
				idxint_ := mt_get_integer_by_position (field_position_of_idxint)
			end
			Result := idxint_
		end

	idxstr: STRING
		do
			if is_obsolete or else idxstr_ = Void then
				idxstr_ := mt_get_string_by_position (field_position_of_idxstr)
			end
			Result := idxstr_
		end


feature -- Element change

	set_idxnum (new_idxnum: DECIMAL)
		do
			if new_idxnum = Void then

				idxnum_ := Void

			else

				idxnum_ := new_idxnum.twin
			end

			mt_set_decimal (field_position_of_idxnum)
		end

	set_idxint (new_idxint: INTEGER)
		do
			idxint_ := new_idxint
			mt_set_integer (field_position_of_idxint)
		end

	set_idxstr (new_idxstr: STRING)
		do
			if new_idxstr = Void then

				idxstr_ := Void

			else

				idxstr_ := new_idxstr.twin
			end

			mt_set_string (field_position_of_idxstr)
		end


feature {NONE} -- Implementation

	field_position_of_identifier: INTEGER
		once
			Result := field_position_of ("identifier_")
		end


	field_position_of_idxnum: INTEGER
		once
			Result := field_position_of ("idxnum_")
		end

	field_position_of_idxint: INTEGER
		once
			Result := field_position_of ("idxint_")
		end

	field_position_of_idxstr: INTEGER
		once
			Result := field_position_of ("idxstr_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class INDEX_CLASS

