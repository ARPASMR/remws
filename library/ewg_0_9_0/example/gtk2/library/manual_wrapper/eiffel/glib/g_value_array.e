indexing

	description:

		"Array of G_VALUE objects"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.3 $"

class G_VALUE_ARRAY

inherit

	EWG_STRUCT_ARRAY [G_VALUE]

	GVALUE_STRUCT_EXTERNAL

creation

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared

feature {NONE} -- Implementation

	new_shared_struct_wrapper_from_pointer (a_pointer: POINTER): G_VALUE is
		do
			create Result.make_shared (a_pointer)
		end

	item_size: INTEGER is
		do
			Result := sizeof_external
		end

end
