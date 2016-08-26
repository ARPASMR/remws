indexing

	description:

		"TODO"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/27 12:48:30 $"
	revision: "$Revision: 1.3 $"

class DBT

inherit

	DB_DBT_STRUCT

creation

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared

feature

	fill_with_zeros is
			-- Zeros out struct
		require
			item_exits: exists
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i >= sizeof
			loop
				managed_data.put_integer_8 (0, i)
				i := i + 1
			end
		end

	set_string (a_string: STRING) is
			-- Fills the dbt with a string
		require
			item_exits: exists
			a_string_not_void: a_string /= Void
		local
			c_string: EWG_ZERO_TERMINATED_STRING
		do
			create c_string.make_shared_from_string (a_string)
			set_size (a_string.count + 1)
			set_data (c_string.item)
				-- TODO: When should we free memory referenced by `c_string'?
		ensure
			data_not_void: data /= Default_pointer
		end

	string: STRING is
			-- Gets string from dbt
		require
			item_exits: exists
			valid_data: data /= Default_pointer
		local
			c_string: EWG_ZERO_TERMINATED_STRING
		do
			create c_string.make_shared_with_capacity (data, size)
			Result := c_string.string
		ensure
			result_not_void: Result /= Void
		end
	
end
