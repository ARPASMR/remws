indexing

	description:

		"Lists of Eiffel dynamic type sets with no sources nor targets"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-09-22 06:39:11 +0200 (Sat, 22 Sep 2007) $"
	revision: "$Revision: 6091 $"

class ET_DYNAMIC_STANDALONE_TYPE_SET_LIST

inherit

	ET_DYNAMIC_TYPE_SET_LIST
		redefine
			item, fixed_array
		end

create

	make, make_with_capacity

feature -- Access

	item (i: INTEGER): ET_DYNAMIC_STANDALONE_TYPE_SET is
			-- Item at index `i' in list
		do
			Result := storage.item (i)
		end

feature {NONE} -- Implementation

	fixed_array: KL_SPECIAL_ROUTINES [ET_DYNAMIC_STANDALONE_TYPE_SET] is
			-- Fixed array routines
		once
			create Result
		end

end
