
note
	description: "Generated with Matisse Schema Definition Language 8.4.0";
	date: "$Date: 2010/10/24 02:22:54 $"

class
	EIFFEL_CLASS1

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
			, post_retrieved
-- BEGIN generation of end by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
		end
-- END of Matisse SDL generation of end

-- END of Matisse SDL generation of inheritance

creation
	make1

feature -- Initialization

	make1
		do
			create rs1_.make
		end


-- BEGIN generation of accessors by Matisse SDL
-- DO NOT MODIFY UNTIL THE 'END of Matisse SDL generation' MARK BELOW
-- generated with Matisse Schema Definition Language 8.4.0
-- Date: Sat Oct 23 16:40:08 2010

feature {NONE}

	rs1_: MT_LINKED_LIST [EIFFEL_CLASS3]
	rs11_: EIFFEL_CLASS3
	rs12_: MT_LINKED_LIST [EIFFEL_CLASS3]

feature -- Access

	rs1: LINKED_LIST [EIFFEL_CLASS3]
		do
			if is_persistent then
				rs1_.load_successors
			end
			Result := rs1_
		end

	rs11: EIFFEL_CLASS3
		do
			if is_obsolete or else rs11_ = Void then
				rs11_ ?= mt_get_successor_by_position (field_position_of_rs11)
			end
			Result := rs11_
		end

	rs12: LINKED_LIST [EIFFEL_CLASS3]
		do
			if is_persistent then
				rs12_.load_successors
			end
			Result := rs12_
		end


feature -- Element change

	set_rs11 (new_rs11: EIFFEL_CLASS3)
		do
			check_persistence (new_rs11)
			rs11_ := new_rs11
			mt_set_successor (field_position_of_rs11)
		end


feature {NONE} -- Implementation

	field_position_of_identifier: INTEGER
		once
			Result := field_position_of ("identifier_")
		end


	field_position_of_rs11: INTEGER
		once
			Result := field_position_of ("rs11_")
		end


-- END of Matisse SDL generation of accessors

--
-- You may add your own code here...
--

feature -- for testing post_retrieved

	id_for_post_retrieved: STRING

	set_id_for_post_retrieved (s: STRING)
		do
			id_for_post_retrieved := s.twin
		end

	post_retrieved: BOOLEAN
		do
			if not rs1.is_empty and then rs1.first.identifier /= Void then
				id_for_post_retrieved := rs1.first.identifier.twin
			end
			Result := True
		end


end -- class EIFFEL_CLASS1

