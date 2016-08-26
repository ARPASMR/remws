indexing

	description:

		"C anonymous declaration printer"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.2 $"

class EWG_C_ANONYMOUS_DECLARATION_PRINTER

inherit

	EWG_C_DECLARATION_PROCESSOR

	EWG_ABSTRACT_C_DECLARATION_PRINTER

creation

	make,
	make_string

feature -- Declaring

	print_declaration_from_type (a_type: EWG_C_AST_TYPE; a_declarator: STRING) is
		do
			reset
			declarator := ""
			process (a_type)
		end

end
