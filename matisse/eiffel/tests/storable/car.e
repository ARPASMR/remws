
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class 
	CAR

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

	year_: INTEGER

feature -- Access

	year: INTEGER
		do
			if is_obsolete or else year_ = Integer_default_value then
				year_ := mt_get_integer_by_position (field_position_of_year)
			end
			Result := year_
		end


feature -- Element change

	set_year (new_year: INTEGER)
		do
			year_ := new_year
			mt_set_integer (field_position_of_year)
		end


feature {NONE} -- Implementation

	field_position_of_year: INTEGER
		once
			Result := field_position_of ("year_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class CAR

