indexing

	description:

		"Tests for the EWG runtime library"

	library: "EWG test"
	copyright: "Copyright (c) 2002, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/11/06 22:01:19 $"
	revision: "$Revision: 1.2 $"

deferred class EWG_TEST_RUNTIME

inherit

	TS_TEST_CASE

feature

	test_memory_routines is
		local
			pointer: EWG_MANAGED_POINTER
		do
			create pointer.make_new_unshared (4)
			pointer.put_integer_8 (127, 0)
			pointer.put_integer_8 (127, 1)
			pointer.put_integer_8 (127, 2)
			pointer.put_integer_8 (127, 3)
			
			assert_equal ("read byte 0 successfuly", 127, pointer.read_integer_8 (0))
			assert_equal ("read byte 1 successfuly", 127, pointer.read_integer_8 (1))
			assert_equal ("read byte 2 successfuly", 127, pointer.read_integer_8 (2))
			assert_equal ("read byte 3 successfuly", 127, pointer.read_integer_8 (3))
			
			assert_equal ("read byte 0-1 successfuly", 32639, pointer.read_integer_16 (0))
			assert_equal ("read byte 2-3 successfuly", 32639, pointer.read_integer_16 (1))

			assert_equal ("read byte 0-4 successfuly", 2139062143, pointer.read_integer (0))

			pointer.put_integer_16 (2000, 0)
			assert_equal ("read byte 2000 successfuly", 2000, pointer.read_integer_16 (0))
		end
		
	test_negative_values is
			-- Test negative values on memory routines
		local
			pointer: EWG_MANAGED_POINTER
		do
			create pointer.make_new_unshared (4)
			pointer.put_integer_8 (-10, 0)
			assert_equal ("read negative 8 bit value", -10, pointer.read_integer_8 (0))			
			pointer.put_integer_16 (-2122, 0)
			assert_equal ("read negative 16 bit value", -2122, pointer.read_integer_16 (0))			
			pointer.put_integer (-7512223, 0)
			assert_equal ("read negative 32 bit value", -7512223, pointer.read_integer (0))			
		end

end
