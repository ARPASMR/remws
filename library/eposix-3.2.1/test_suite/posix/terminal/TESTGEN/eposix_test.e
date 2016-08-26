indexing

	description: "Test harness root class"
	generator: "getest version 3.9"

class EPOSIX_TEST

inherit

	TS_TESTER
		redefine
			build_suite
		end

create

	make, make_default

feature -- Element change

	build_suite is
			-- Add to `suite' the test cases that need to executed.
		local
			l_test1: EPOSIX_TEST_P_TERMINAL
		do
			create l_test1.make_default
			l_test1.set_test ("TEST_P_TERMINAL.test_all", agent l_test1.test_all)
			put_test (l_test1)
		end

end
