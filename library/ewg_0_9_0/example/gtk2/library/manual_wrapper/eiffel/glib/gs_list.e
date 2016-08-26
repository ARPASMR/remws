indexing

	description:

			"Singly-Linked Lists. linked lists containing integer values or pointers"
			"to data, limited to iterating over the list in one direction."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/08/01 21:36:24 $"
	revision: "$Revision: 1.1 $"

class GS_LIST

inherit

	GSLIST_STRUCT
		export {G_OBJECT} all end

creation

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared

feature {NONE}

end
