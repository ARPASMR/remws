indexing

	description:

		"Declaration formatting tests for ewg"

	library: "EWG Library test"
	copyright: "Copyright (c) 2002, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/19 16:19:47 $"
	revision: "$Revision: 1.46 $"

deferred class EWG_TEST_DECLARATION

inherit

	EWG_TEST_CASE

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all end

feature -- Tests

	test_primitive_type is
		do
			assert_declaration_from_source ("char foo", "char foo;")
			assert_declaration_from_source ("int foo", "int foo;")
			assert_declaration_from_source ("long foo", "long foo;")
			assert_declaration_from_source ("double foo", "double foo;")
			assert_declaration_from_source ("float foo", "float foo;")
			assert_declaration_from_source ("short foo", "short foo;")
		end

	test_alias_type is
		do
			assert_declaration_from_source ("foo bar", "typedef char foo; foo bar;")
			assert_declaration_from_source ("foo_struct bar",
													  "struct foo; typedef struct foo foo_struct; foo_struct bar;")
			assert_declaration_from_source ("foo_union bar",
													  "union foo; typedef union foo foo_union; foo_union bar;")
			assert_declaration_from_source ("foo_enum bar",
													  "enum foo; typedef enum foo foo_enum; foo_enum bar;")
		end

	test_pointer_type is
		do
			assert_declaration_from_source ("void *foo", "void *foo;")
			assert_declaration_from_source ("void (*foo) (void)", "void (*foo) (void);")
		end

	test_const_type is
		do
			assert_declaration_from_source ("void const *foo", "void const *foo;")
			assert_declaration_from_source ("void const *foo", "const void *foo;")
			assert_declaration_from_source ("void *const *foo", "void *const *foo;")

			assert_declaration_from_source ("struct foo const bar",
													  "const struct foo {int i;} bar;")
			assert_declaration_from_source ("union foo const bar",
													  "const union foo {int i;} bar;")
			assert_declaration_from_source ("enum foo const bar",
													  "const enum foo {i} bar;")
		end

	test_struct_type is
		do
			assert_declaration_from_source ("struct foo bar", "struct foo bar;")
			assert_declaration_from_source ("struct foo bar", "struct foo {int i;} bar;")
			assert_declaration_from_source ("struct foo bar", "struct foo {int i;}; struct foo bar;")
		end

	test_union_type is
		do
			assert_declaration_from_source ("union foo bar", "union foo bar;")
			assert_declaration_from_source ("union foo bar", "union foo {int i;} bar;")
			assert_declaration_from_source ("union foo bar", "union foo {int i;}; union foo bar;")
		end

	test_enum_type is
		do
			assert_declaration_from_source ("enum foo bar", "enum foo bar;")
			assert_declaration_from_source ("enum foo bar", "enum foo {i} bar;")
			assert_declaration_from_source ("enum foo bar", "enum foo {i}; enum foo bar;")
			assert_declaration_from_source ("enum foo bar", "enum foo {i,j,k}; enum foo bar;")
		end

	test_array_type is
		do
			assert_declaration_from_source ("int foo[32]", "int foo[32];")
			assert_declaration_from_source ("int foo[sizeof(int)]", "int foo[sizeof(int)];")
			assert_declaration_from_source ("int (*foo[30]) (void)", "int (*foo[30]) (void);")
		end

	test_function_type is
		do
			assert_declaration_from_source ("void foo (void)", "void foo (void);")
			assert_declaration_from_source ("void foo (int i)", "void foo (int i);")
			assert_declaration_from_source ("void foo (char *i, double j)",
													  "void foo (char *i, double j);")
			assert_declaration_from_source ("void foo (int anonymous_1)", "void foo (int);")
			assert_declaration_from_source ("void foo (char *anonymous_1, double anonymous_2)",
													  "void foo (char*, double);")
			assert_declaration_from_source ("void foo (int (*bar) (void))",
													  "void foo (int (*bar) (void));")
			assert_declaration_from_source ("void foo (int (*anonymous_1) (void))",
													  "void foo (int (*) (void));")
			-- The following is not valid ANSI C, but gcc accepts
			-- it. Note that the parameter is a pointer to a function and
			-- not just a function
			assert_declaration_from_source ("void foo (int (*anonymous_1) (void))",
													  "void foo (int () (void));")
			assert_declaration_from_source ("int foo (int (*anonymous_1) (double (*anonymous_1) (void)))",
													  "int foo (int (*) (double (*) (void)));")
		end

end
