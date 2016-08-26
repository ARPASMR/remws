indexing

	description:

		"Feature names found in EWG_STRUCT"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:45 $"
	revision: "$Revision: 1.3 $"

class EWG_STRUCT_FEATURE_NAMES

inherit

	EWG_SHARED_STRING_EQUALITY_TESTER
		export {NONE} all end

create {EWG_SHARED_STRUCT_FEATURE_NAMES}

	make

feature {NONE} -- Initialization

	make is
			-- Create new feature name object.
		do
		end

feature -- Status

	has (a_name: STRING): BOOLEAN is
			-- Is `a_name' a feature name in class ANY?
		do
			Result := names.has (a_name.as_lower)
		end

feature {NONE} -- Implementation

	names: DS_HASH_SET [STRING] is
			-- Set of names of features from class ANY
		once
			create Result.make (8)
			Result.set_equality_tester (string_equality_tester)
			Result.put_new ("make_new_shared")
			Result.put_new ("make_unshared")
			Result.put_new ("make_shared")
			Result.put_new ("item")
			Result.put_new ("sizeof")
			Result.put_new ("is_shared")
			Result.put_new ("exists")
			Result.put_new ("managed_data")
		ensure
			names_not_void: names /= Void
		end

end
