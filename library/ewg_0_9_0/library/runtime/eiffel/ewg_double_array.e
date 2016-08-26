indexing

	description:

		"Class for wrapping C double arrays"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:17:01 $"
	revision: "$Revision: 1.1 $"

class EWG_DOUBLE_ARRAY

inherit
	
	EWG_ARRAY

creation

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared

feature {ANY} -- Access

	item (i: INTEGER): DOUBLE is
			-- Return the address of the `i'-th item
		require
			exists: exists
			valid_index: is_valid_index (i)
		do
			Result := managed_data.read_double (i * item_size)
		end

	put (v: DOUBLE; i: INTEGER) is
			-- Replace `i'-th entry by `v'
		require
			exists: exists
			valid_index: is_valid_index (i)
		do
			managed_data.put_double (v, i * item_size)
		ensure
			double_set: item (i) = v
		end

feature {NONE} -- Implementation
	
	item_size: INTEGER is
		once
			Result := EXTERNAL_MEMORY_.sizeof_double_external
		end
end
