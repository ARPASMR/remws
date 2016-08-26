
indexing

	description:
		"Priority queues, without commitment to a particular representation"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: priority_queue, dispenser;
	access: fixed, membership;
	contents: generic;
	date: "$Date: 2007-01-14 10:58:40 +0100 (Sun, 14 Jan 2007) $"
	revision: "$Revision: 5811 $"

deferred class PRIORITY_QUEUE [G -> PART_COMPARABLE] inherit

	DISPENSER [G]

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







end -- class PRIORITY_QUEUE



