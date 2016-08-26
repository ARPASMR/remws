
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	EIFFEL_CLASS3

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

creation
	make1

feature -- Initialization

	make1 is
		do
		end


-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 8.4.0
-- Date: Sat Oct 23 16:40:08 2010

feature {NONE}

	att1_nullable_: STRING
	rs31_: EIFFEL_CLASS1
	rs32_: EIFFEL_CLASS1

feature -- Access

	att1_nullable: STRING
		do
			if is_obsolete or else att1_nullable_ = Void then
				att1_nullable_ := mt_get_string_by_position (field_position_of_att1_nullable)
			end
			Result := att1_nullable_
		end

	rs31: EIFFEL_CLASS1
		do
			if is_obsolete or else rs31_ = Void then
				rs31_ ?= mt_get_successor_by_position (field_position_of_rs31)
			end
			Result := rs31_
		end

	rs32: EIFFEL_CLASS1
		do
			if is_obsolete or else rs32_ = Void then
				rs32_ ?= mt_get_successor_by_position (field_position_of_rs32)
			end
			Result := rs32_
		end


feature -- Element change

	set_att1_nullable (new_att1_nullable: STRING)
		do
			if new_att1_nullable = Void then

				att1_nullable_ := Void

			else

				att1_nullable_ := new_att1_nullable.twin
			end

			mt_set_string (field_position_of_att1_nullable)
		end

	set_rs31 (new_rs31: EIFFEL_CLASS1)
		do
			check_persistence (new_rs31)
			rs31_ := new_rs31
			mt_set_successor (field_position_of_rs31)
		end

	set_rs32 (new_rs32: EIFFEL_CLASS1)
		do
			check_persistence (new_rs32)
			rs32_ := new_rs32
			mt_set_successor (field_position_of_rs32)
		end


feature {NONE} -- Implementation

	field_position_of_identifier: INTEGER
		once
			Result := field_position_of ("identifier_")
		end


	field_position_of_att1_nullable: INTEGER
		once
			Result := field_position_of ("att1_nullable_")
		end

	field_position_of_rs31: INTEGER
		once
			Result := field_position_of ("rs31_")
		end

	field_position_of_rs32: INTEGER
		once
			Result := field_position_of ("rs32_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class EIFFEL_CLASS3

