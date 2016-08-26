indexing

	description:
		"Cursors for arrayed lists"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: fixed_list_cursor, cursor;
	date: "$Date: 2007-01-14 10:58:40 +0100 (Sun, 14 Jan 2007) $"
	revision: "$Revision: 5811 $"

class ARRAYED_LIST_CURSOR inherit

	CURSOR

create
	make

feature {NONE} -- Initialization

	make (current_index: INTEGER) is
			-- Create a cursor and set it up on `current_index'.
		do
			index := current_index
		end

feature {ARRAYED_LIST, FIXED_LIST, BINARY_TREE} -- Access

	index: INTEGER;
		-- Index of current item

indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"







end -- class ARRAYED_LIST_CURSOR



