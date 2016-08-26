indexing

	description:

		"Shared equality testers for EWG_EWG_C_AST_TYPE (and descendant) objects"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/11/02 03:54:04 $"
	revision: "$Revision: 1.2 $"

class EWG_C_AST_SHARED_TYPE_EQUALITY_TESTER

feature -- Access

	type_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_TYPE] is
			-- Type equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

	struct_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_STRUCT_TYPE] is
			-- Struct equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

	union_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_UNION_TYPE] is
			-- Union equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

	enum_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_ENUM_TYPE] is
			-- Enum equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

	primitive_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_PRIMITIVE_TYPE] is
			-- Primitive equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

	alias_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_ALIAS_TYPE] is
			-- Alias equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

	function_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_FUNCTION_TYPE] is
			-- Function equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

	pointer_equality_tester: EWG_C_AST_TYPE_EQUALITY_TESTER [EWG_C_AST_POINTER_TYPE] is
			-- Pointer equality tester
		once
		  create Result
		ensure
			tester_not_void: Result /= Void
		end

end
