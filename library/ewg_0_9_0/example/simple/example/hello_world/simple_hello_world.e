indexing

	description:

		"Simple example using EWG wrappers"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/07/13 17:48:15 $"
	revision: "$Revision: 1.7 $"

class SIMPLE_HELLO_WORLD

inherit

	SIMPLE_HEADER_FUNCTIONS_EXTERNAL

	COLORS_ENUM_EXTERNAL

creation

	make

feature

	make is
		do
				-- Create a new struct of type 'struct foo'
				-- `unshared' means that when `foo' will get
				-- collected, the struct it wrapps will be
				-- freed.
			create foo.make_new_unshared

				-- Set members `a' and `b'.
				-- Note that `a' and `b' are real
				-- members of struct foo.
			foo.set_a (33)
			foo.set_b (75)

				-- Output the members
			print ("foo.a (33): " + foo.a.out + "%N")
			print ("foo.b (75): " + foo.b.out + "%N")

				-- Create a union of type 'foo1'
			create foo1.make_new_unshared

				-- Set member
			foo1.set_a (42)

				-- Output member
			print ("foo1.a (42): " + foo1.a.out + "%N")

				-- Call external function
			func1_external (24, 53)

				-- Call external function with non 'void' return type
			print ("func2 (7): " + func2_external (3, 4).out + "%N")

			-- Output enum values
			print ("red: " + red.out + "%N")
		end

	foo: FOO_STRUCT
			-- Wrapper object for `struct foo'

	foo1: FOO1_UNION
			-- Wrapper object for `foo1' (a typedef'd union)

end
