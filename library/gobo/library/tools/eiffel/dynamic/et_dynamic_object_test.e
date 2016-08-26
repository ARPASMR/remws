indexing

	description:

		"Eiffel object-tests at run-time"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-16 12:20:22 +0200 (Wed, 16 Apr 2008) $"
	revision: "$Revision: 6349 $"

class ET_DYNAMIC_OBJECT_TEST

inherit

	ET_DYNAMIC_ATTACHMENT
		rename
			attachment as object_test
		end

create

	make

feature {NONE} -- Initialization

	make (a_source_type_set: like source_type_set; a_object_test: like object_test;
		a_current_feature: like current_feature; a_current_type: like current_type) is
			-- Create a new object-test.
		require
			a_source_type_set_not_void: a_source_type_set /= Void
			a_object_test_not_void: a_object_test /= Void
			a_current_feature_not_void: a_current_feature /= Void
			a_current_type_not_void: a_current_type /= Void
		do
			source_type_set := a_source_type_set
			object_test := a_object_test
			current_feature := a_current_feature
			current_type := a_current_type
		ensure
			source_type_set_set: source_type_set = a_source_type_set
			object_test_set: object_test = a_object_test
			current_feature_set: current_feature = a_current_feature
			current_type_set: current_type = a_current_type
		end

feature -- Access

	object_test: ET_OBJECT_TEST
			-- Object-test

	position: ET_POSITION is
			-- Position of attachment
		do
			Result := object_test.name.position
		end

	description: STRING is "object-test"
			-- Kind of attachment

invariant

	object_test_not_void: object_test /= Void

end
