indexing

	description:
		"Finite structures whose item count is not bounded"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: unbounded, storage;
	date: "$Date: 2007-01-14 10:58:40 +0100 (Sun, 14 Jan 2007) $"
	revision: "$Revision: 5811 $"

deferred class UNBOUNDED [G] inherit

	FINITE [G]

feature -- Status report

	--extendible: BOOLEAN is true;
		-- Can new items be added? (Answer: yes)

-- invariant

	-- extendible: extendible

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







end -- class UNBOUNDED



