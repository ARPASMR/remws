indexing

	description:

		"Print C declarator"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/06/16 23:57:15 $"
	revision: "$Revision: 1.3 $"

class EWG_C_DECLARATOR_PRINTER

inherit

	EWG_ABSTRACT_C_DECLARATION_PRINTER
		redefine
			can_be_printed_from_type
		end

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all end

creation

	make,
	make_string

feature -- Status

	can_be_printed_from_type (a_type: EWG_C_AST_TYPE; a_declarator: STRING): BOOLEAN is
		require else
			a_type_not_void: a_type /= Void
			a_declarator_not_void: a_declarator /= Void
		do
			Result := True
		end

feature -- Printing

	print_declaration_from_type (a_type: EWG_C_AST_TYPE; a_declarator: STRING) is
			-- Format the cast for  `a_type'.
		do
			output_stream.put_string (a_declarator)
		end

end
