indexing

	description:

		"EWG config attribute names"

	copyright: "Copyright (c) 2004, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:05 $"
	revision: "$Revision: 1.6 $"


class EWG_CONFIG_WRAPPER_TYPE_NAMES

inherit

	ANY

	EWG_SHARED_STRING_EQUALITY_TESTER
		export {NONE} all end

feature -- Constants

	default_name: STRING is "default"

	none_name: STRING is "none"


	name_set: DS_HASH_SET [STRING] is
		once
			create Result.make (2)
			Result.set_equality_tester (string_equality_tester)
			Result.put_new (default_name)
			Result.put_new (none_name)
		ensure
			name_set_not_void: Result /= Void
			no_void_name: not Result.has (Void)
		end


	is_valid_wrapper_type_name (a_value: STRING): BOOLEAN is
		require
			a_value_not_void: a_value /= Void
		do
			Result := name_set.has (a_value)
		end


end
