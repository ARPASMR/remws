indexing

	description:

		"Test Case application"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/01 11:13:39 $"
	revision: "$Revision: 1.1 $"

class TEST_APPLICATION

inherit

	TEST_HEADER_FUNCTIONS_EXTERNAL

creation

	make

feature

	make is
		do
			foo_external (Default_pointer)
		end

end
