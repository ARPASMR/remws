
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	SUPER

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	MT_STORABLE
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance

creation
	make

feature -- Initialization

	make (an_id: STRING) is
		do
			identifier_ := an_id.twin
		end


-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 8.4.0
-- Date: Sat Oct 23 16:40:08 2010

feature {NONE}

	identifier_: STRING

feature -- Access

	identifier: STRING
		do
			if is_obsolete or else identifier_ = Void then
				identifier_ := mt_get_string_by_position (field_position_of_identifier)
			end
			Result := identifier_
		end


feature -- Element change

	set_identifier (new_identifier: STRING)
		do
			if new_identifier = Void then

				identifier_ := Void

			else

				identifier_ := new_identifier.twin
			end

			mt_set_string (field_position_of_identifier)
		end


feature {NONE} -- Implementation

	field_position_of_identifier: INTEGER
		once
			Result := field_position_of ("identifier_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class SUPER

