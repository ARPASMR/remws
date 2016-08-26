indexing
	description: "[
		References to objects containing reference to object
		meant to be exchanged with non-Eiffel software.
		]"
	assembly: "mscorlib"
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2004, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2007-02-18 12:15:30 +0100 (Sun, 18 Feb 2007) $"
	revision: "$Revision: 5897 $"

frozen expanded class TYPED_POINTER [G]

inherit
	POINTER_REF
		rename
			item as to_pointer
		end

convert
	to_pointer: {POINTER}

end
