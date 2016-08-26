indexing

	description:

		"MSC extension specific tests for ewg"

	library: "EWG Library test"
	copyright: "Copyright (c) 2002, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class EWG_TEST_MSC_EXTENSIONS

inherit

	EWG_TEST_CASE

	EWG_HEADER_FILE_NAMES
		export {NONE} all end

feature

	test_msc_attributes_and_storage_class_extensions is
		do
			assert_no_syntax_error_with_msc_extensions ("__w64 should parse with msc extenstions", test_043_hpp)
			assert_no_syntax_error_with_msc_extensions ("__cdecl should parse with msc extenstions", test_044_hpp)
			assert_no_syntax_error_with_msc_extensions ("double _cdecl should parse with msc extenstions", test_068_hpp)
			assert_no_syntax_error_with_msc_extensions ("__declspec on function should parse with msc extenstions", test_045_hpp)
			assert_no_syntax_error_with_msc_extensions ("__declspec on variable should parse with msc extenstions", test_067_hpp)
			assert_no_syntax_error_with_msc_extensions ("__declspec and __stdcall should parse with msc extenstions", test_046_hpp)
			assert_no_syntax_error_with_msc_extensions ("_inline should parse with msc extenstions", test_048_hpp)
			assert_no_syntax_error_with_msc_extensions ("noreturn should parse with msc extenstions", test_050_hpp)
			assert_no_syntax_error_with_msc_extensions ("__inline should parse with msc extensions", test_079_hpp)
			assert_no_syntax_error_with_msc_extensions ("__ptr64 should parse with msc extensions", test_095_hpp)
			assert_no_syntax_error_with_msc_extensions ("__declspec for structs should parse with msc extensions", test_096_hpp)
		end

	test_msc_inline_asm is
		do
			assert_no_syntax_error_with_msc_extensions ("__asm should parse with cl extenstions", test_047_hpp)
		end

	test_anonymous_function_type_parameter is
		do
			assert_no_syntax_error_with_msc_extensions ("__cdecl as part of anonymous parameter of type function pointer must parse", test_053_hpp)
			assert_no_syntax_error_with_msc_extensions ("anonymous function-type function parameter with type alias as parameter must parse", test_069_hpp)
			assert_no_syntax_error_with_msc_extensions ("anonymous function-type function parameter with parameter must parse", test_070_hpp)
		end

end
