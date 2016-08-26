indexing

	description:

		"VTCG test cases"

	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"

deferred class TEST_VTCG

inherit

	GELINT_TEST_CASE

feature -- Test

	test_1 is
			-- Test #1.
		do
			compile_and_test ("test1")
		end

feature {NONE} -- Implementation

	rule_dirname: STRING is
			-- Name of the directory containing the tests of the rule being tested
		once
			Result := file_system.nested_pathname ("${GOBO}", <<"test", "gelint", "validity", "vtcg">>)
			Result := Execution_environment.interpreted_string (Result)
		end

end
