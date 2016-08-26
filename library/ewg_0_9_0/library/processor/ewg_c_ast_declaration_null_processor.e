indexing

	description:

		"Dummy processor for the 'Visitor Pattern' on phase 2 C declarations"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.2 $"

class EWG_C_AST_DECLARATION_NULL_PROCESSOR

inherit

	EWG_C_AST_DECLARATION_PROCESSOR
	
creation

	make

feature {NONE} -- Initialization

	make is
		do
		end

feature

	process_typedef_declaration (a_base_type: EWG_C_AST_TYPE; a_alias: STRING) is
		do
		end
	
	process_function_declaration (a_function_type: EWG_C_AST_FUNCTION_TYPE; a_name: STRING) is
		do
		end
	
	process_variable_declaration (a_type: EWG_C_AST_TYPE; a_name: STRING) is
		do
		end
	
	process_type_declaration (a_type: EWG_C_AST_TYPE) is
		do
		end

end
