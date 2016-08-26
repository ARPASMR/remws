
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class 
	CHILD

inherit

-- BEGIN generation of inheritance by Matisse SDL
-- BEGIN generation of ancestor by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
	ATTRIBUTE_CONTAINER
-- END of Matisse SDL generation of ancestor

-- BEGIN generation of redefine by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
		redefine
			field_position_of_the_string,
			field_position_of_the_integer,
			field_position_of_the_boolean,
			field_position_of_the_timestamp,
			field_position_of_the_date,
			field_position_of_the_string_list,
			field_position_of_the_image,
			field_position_of_the_numeric,
			field_position_of_the_float
-- END of Matisse SDL generation of redefine

-- BEGIN generation of end by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
		end
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance



-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 8.4.0
-- Date: Wed Oct  6 09:17:05 2010

feature {NONE}

	parent_: PARENT
	parents_: MT_LINKED_LIST [PARENT]

feature -- Access

	parent: PARENT
		do
			if is_obsolete or else parent_ = Void then
				parent_ ?= mt_get_successor_by_position (field_position_of_parent)
			end
			Result := parent_
		end

	parents: LINKED_LIST [PARENT]
		do
			if is_persistent then
				parents_.load_successors
			end
			Result := parents_
		end


feature -- Element change

	set_parent (new_parent: PARENT)
		do
			check_persistence (new_parent)
			parent_ := new_parent
			mt_set_successor (field_position_of_parent)
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
			Result := field_position_of ("the_numeridb_session.externals.c_")
		end

	field_position_of_the_float: INTEGER
		once
			Result := field_position_of ("the_float_")
		end


	field_position_of_parent: INTEGER
		once
			Result := field_position_of ("parent_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class CHILD

