indexing

	description:

		"Abstract processor for the 'Visitor Pattern' on phase 2 C types"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.2 $"

deferred class EWG_C_AST_TYPE_PROCESSOR

feature

	process_primitive_type (a_type: EWG_C_AST_PRIMITIVE_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
	process_eiffel_object_type (a_type: EWG_C_AST_EIFFEL_OBJECT_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end

	process_alias_type (a_type: EWG_C_AST_ALIAS_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
	process_pointer_type (a_type: EWG_C_AST_POINTER_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
	process_array_type (a_type: EWG_C_AST_ARRAY_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
	process_const_type (a_type: EWG_C_AST_CONST_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end

	process_function_type (a_type: EWG_C_AST_FUNCTION_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
	process_struct_type (a_type: EWG_C_AST_STRUCT_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
	process_union_type (a_type: EWG_C_AST_UNION_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
	process_enum_type (a_type: EWG_C_AST_ENUM_TYPE) is
			-- Process `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end
	
end
