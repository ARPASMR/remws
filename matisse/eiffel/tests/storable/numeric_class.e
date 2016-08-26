
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	NUMERIC_CLASS

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

	att_numeric1_: DECIMAL
	att_numeric2_: DECIMAL
	att_numeric3_: DECIMAL
	att_numericlist_: LINKED_LIST [DECIMAL]

feature -- Access

	att_numeric1: DECIMAL
		do
			if is_obsolete or else att_numeric1_ = Void then
				att_numeric1_ := mt_get_decimal_by_position (field_position_of_att_numeric1)
			end
			Result := att_numeric1_
		end

	att_numeric2: DECIMAL
		do
			if is_obsolete or else att_numeric2_ = Void then
				att_numeric2_ := mt_get_decimal_by_position (field_position_of_att_numeric2)
			end
			Result := att_numeric2_
		end

	att_numeric3: DECIMAL
		do
			if is_obsolete or else att_numeric3_ = Void then
				att_numeric3_ := mt_get_decimal_by_position (field_position_of_att_numeric3)
			end
			Result := att_numeric3_
		end

	att_numericlist: LINKED_LIST [DECIMAL]
		do
			if is_obsolete or else att_numericlist_ = Void then
				att_numericlist_ := mt_get_decimal_list_by_position (field_position_of_att_numericlist)
			end
			Result := att_numericlist_
		end


feature -- Element change

	set_att_numeric1 (new_att_numeric1: DECIMAL)
		do
			if new_att_numeric1 = Void then

				att_numeric1_ := Void

			else

				att_numeric1_ := new_att_numeric1.twin
			end

			mt_set_decimal (field_position_of_att_numeric1)
		end

	set_att_numeric2 (new_att_numeric2: DECIMAL)
		do
			if new_att_numeric2 = Void then

				att_numeric2_ := Void

			else

				att_numeric2_ := new_att_numeric2.twin
			end

			mt_set_decimal (field_position_of_att_numeric2)
		end

	set_att_numeric3 (new_att_numeric3: DECIMAL)
		do
			if new_att_numeric3 = Void then

				att_numeric3_ := Void

			else

				att_numeric3_ := new_att_numeric3.twin
			end

			mt_set_decimal (field_position_of_att_numeric3)
		end

	set_att_numericlist (new_att_numericlist: LINKED_LIST [DECIMAL])
		do
			att_numericlist_ := new_att_numericlist
			mt_set_decimal_list (field_position_of_att_numericlist)
		end


feature {NONE} -- Implementation

	field_position_of_identifier: INTEGER
		once
			Result := field_position_of ("identifier_")
		end


	field_position_of_att_numeric1: INTEGER
		once
			Result := field_position_of ("att_numeric1_")
		end

	field_position_of_att_numeric2: INTEGER
		once
			Result := field_position_of ("att_numeric2_")
		end

	field_position_of_att_numeric3: INTEGER
		once
			Result := field_position_of ("att_numeric3_")
		end

	field_position_of_att_numericlist: INTEGER
		once
			Result := field_position_of ("att_numericlist_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class NUMERIC_CLASS

