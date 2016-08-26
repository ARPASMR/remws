indexing

	description:

		"ECF adapted class library lists"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-10-26 20:29:45 +0100 (Sun, 26 Oct 2008) $"
	revision: "$Revision: 6539 $"

class ET_ECF_ADAPTED_LIBRARIES

inherit

	ET_ADAPTED_LIBRARIES
		redefine
			library,
			do_adapted
		end

create

	make, make_empty

feature -- Access

	library (i: INTEGER): ET_ECF_ADAPTED_LIBRARY is
			-- `i'-th library
		do
			Result := libraries.item (i)
		end

feature -- Iteration

	do_adapted (an_action: PROCEDURE [ANY, TUPLE [ET_ADAPTED_LIBRARY]]) is
			-- Apply `an_action' to every library, from first to last.
			-- (Semantics not guaranteed if `an_action' changes the list.)
		local
			i, nb: INTEGER
		do
			nb := libraries.count
			from i := 1 until i > nb loop
				an_action.call ([libraries.item (i)])
				i := i + 1
			end
		end

end
