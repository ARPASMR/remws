
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	PARENT

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
			, mt_remove
-- BEGIN generation of end by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
		end
-- END of Matisse SDL generation of end
-- END of Matisse SDL generation of inheritance

feature -- Removal

	mt_remove
		do
			child.mt_remove
			Precursor
		end


-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 8.4.0
-- Date: Wed Oct  6 09:17:05 2010

feature {NONE}

	child_: CHILD
	child_without_inverse_: CHILD
	children_: MT_LINKED_LIST [CHILD]
	children_without_inverse_: MT_LINKED_LIST [CHILD]

feature -- Access

	child: CHILD
		do
			if is_obsolete or else child_ = Void then
				child_ ?= mt_get_successor_by_position (field_position_of_child)
			end
			Result := child_
		end

	child_without_inverse: CHILD
		do
			if is_obsolete or else child_without_inverse_ = Void then
				child_without_inverse_ ?= mt_get_successor_by_position (field_position_of_child_without_inverse)
			end
			Result := child_without_inverse_
		end

	children: LINKED_LIST [CHILD]
		do
			if is_persistent then
				children_.load_successors
			end
			Result := children_
		end

	children_without_inverse: LINKED_LIST [CHILD]
		do
			if is_persistent then
				children_without_inverse_.load_successors
			end
			Result := children_without_inverse_
		end


feature -- Element change

	set_child (new_child: CHILD)
		do
			check_persistence (new_child)
			child_ := new_child
			mt_set_successor (field_position_of_child)
		end

	set_child_without_inverse (new_child_without_inverse: CHILD)
		do
			check_persistence (new_child_without_inverse)
			child_without_inverse_ := new_child_without_inverse
			mt_set_successor (field_position_of_child_without_inverse)
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
			Result := field_position_of ("the_numeric_")
		end

	field_position_of_the_float: INTEGER
		once
			Result := field_position_of ("the_float_")
		end


	field_position_of_child: INTEGER
		once
			Result := field_position_of ("child_")
		end

	field_position_of_child_without_inverse: INTEGER
		once
			Result := field_position_of ("child_without_inverse_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

end -- class PARENT

