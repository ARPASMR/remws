
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class 
	INDEX_SUB_CLASS

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	INDEX_CLASS
-- END of Matisse SDL generation of ancestor

-- BEGIN generation of redefine by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
		redefine
			field_position_of_identifier,
			field_position_of_idxnum,
			field_position_of_idxint,
			field_position_of_idxstr
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

end -- class INDEX_SUB_CLASS

