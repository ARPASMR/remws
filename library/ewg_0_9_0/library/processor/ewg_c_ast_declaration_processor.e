indexing

	description:

		"Abstract processor for the 'Visitor Pattern' on phase 2 C declarations"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.2 $"

deferred class EWG_C_AST_DECLARATION_PROCESSOR

feature

	process_typedef_declaration (a_base_type: EWG_C_AST_TYPE; an_alias: STRING) is
			-- Process typedef with the base type `a_base_type' and the alias `an_alias'.
		require
			a_base_type_not_void: a_base_type /= Void
			an_alias_not_void: an_alias /= Void
			an_alias_not_empty: not an_alias.is_empty
		deferred
		end

	process_function_declaration (a_function_type: EWG_C_AST_FUNCTION_TYPE; a_name: STRING) is
			-- Process function declaration with the type `a_function_type' and the name `a_name'.
		require
			a_function_type_not_void: a_function_type /= Void
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		end

	process_variable_declaration (a_type: EWG_C_AST_TYPE; a_name: STRING) is
			-- Process variable declaration of type `a_type' with the name `a_name'.
		require
			a_type_not_void: a_type /= Void
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		end

	process_type_declaration (a_type: EWG_C_AST_TYPE) is
			-- Process top level type `a_type'.
		require
			a_type_not_void: a_type /= Void
		deferred
		end

end
