indexing

	description:

		"Generates C glue header for function wrappers"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/10/25 09:25:07 $"
	revision: "$Revision: 1.8 $"

class EWG_C_GLUE_HEADER_FUNCTION_WRAPPER_GENERATOR

inherit

	EWG_ABSTRACT_GENERATOR
		redefine
			make_internal
		end

	EWG_SHARED_C_SYSTEM
		export {NONE} all end

creation

	make

feature {NONE} -- Initialization

	make_internal is
		do
			Precursor
			make_printers
		end

	make_printers is
		do
			create c_to_eiffel_declaration_printer.make (output_stream, eiffel_compiler_mode)
			create eiffel_to_c_declaration_printer.make (output_stream, eiffel_compiler_mode)
			create declarator_printer.make (output_stream)
			create eiffel_to_c_macro_declaration_list_printer.make (output_stream, declarator_printer)
			eiffel_to_c_macro_declaration_list_printer.set_declarator_prefix ("ewg_param_")
			create casted_declarator_printer.make (output_stream)
			create eiffel_to_c_indirection_printer.make (output_stream, eiffel_compiler_mode)
			create eiffel_to_c_cast_printer.make (output_stream, eiffel_compiler_mode)
			casted_declarator_printer.add_printer (eiffel_to_c_indirection_printer)
			casted_declarator_printer.add_printer (eiffel_to_c_cast_printer)
			casted_declarator_printer.add_printer (declarator_printer)
			create eiffel_to_c_parameter_list_printer.make (output_stream, casted_declarator_printer)
			eiffel_to_c_parameter_list_printer.set_declarator_prefix ("ewg_param_")

			create eiffel_to_c_declaration_list_printer.make (output_stream, eiffel_to_c_declaration_printer)
		end

feature

	generate (a_eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET) is
		local
			cs: DS_BILINEAR_CURSOR [EWG_FUNCTION_WRAPPER]
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
		do
			file_name := directory_structure.function_c_glue_header_file_name (eiffel_compiler_mode.eiffel_compiler_mode)
			create file.make (file_name)
			file.recursive_open_write
			if not file.is_open_write then
				error_handler.report_cannot_write_error (file_name)
			else
				output_stream := file
				make_printers
				output_stream.put_new_line
				from
					cs := a_eiffel_wrapper_set.new_function_wrapper_cursor
					cs.start
				until
					cs.off
				loop
					generate_function_wrapper (cs.item)
					cs.forth
					error_handler.tick
				end
				file.close
			end
		end

feature {NONE} -- Implementation

	generate_function_wrapper (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		do
			generate_function_accessor (a_function_wrapper)
		end

feature {NONE} -- Implementation

	generate_function_accessor (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
			-- Generate macro that calls function represented by `a_function_wrapper'.
			-- Every parameter will be casted. This will allow us to use simplified
			-- parameter types on the Eiffel side.
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			function_type: EWG_C_AST_FUNCTION_TYPE
			declarator: STRING
		do
			function_type := a_function_wrapper.function_declaration.function_type
			output_stream.put_string ("// Wraps call to function '")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string ("' in a macro")
			output_stream.put_new_line

			output_stream.put_string ("#include <")
			output_stream.put_string (a_function_wrapper.header_file_name)
			output_stream.put_line (">")
			output_stream.put_new_line

			output_stream.put_string ("#define ewg_function_macro_")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			if function_type.members.count > 0 then
				output_stream.put_string ("(")
				eiffel_to_c_macro_declaration_list_printer.print_declaration_list (function_type.members)
				output_stream.put_character (')')
			end
			output_stream.put_string (" ")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string (" (")
			eiffel_to_c_parameter_list_printer.print_declaration_list (function_type.members)
			output_stream.put_string (")")
			output_stream.put_new_line
			output_stream.put_new_line

			declarator := clone (" ewg_function_")
			declarator.append_string (a_function_wrapper.function_declaration.declarator)
			declarator.append_string (" (")
			if function_type.members.count = 0 then
				declarator.append_string ("void")
			else
				eiffel_to_c_declaration_list_printer.set_string (declarator)
				eiffel_to_c_declaration_printer.set_string (declarator)
				eiffel_to_c_declaration_list_printer.print_declaration_list (function_type.members)
			end
			declarator.append_string (")")
			c_to_eiffel_declaration_printer.print_declaration_from_type (function_type.return_type, declarator)
			output_stream.put_line (";")
		end

feature {NONE} -- Helper formatters

	c_to_eiffel_declaration_printer: EWG_C_TO_EIFFEL_DECLARATION_PRINTER
	eiffel_to_c_macro_declaration_list_printer: EWG_C_DECLARATION_LIST_PRINTER
	casted_declarator_printer: EWG_COMPOSITE_DECLARATION_PRINTER
	eiffel_to_c_indirection_printer: EWG_EIFFEL_TO_C_INDIRECTION_PRINTER
	eiffel_to_c_cast_printer: EWG_EIFFEL_TO_C_TYPE_CAST_PRINTER
	declarator_printer: EWG_C_DECLARATOR_PRINTER
	eiffel_to_c_parameter_list_printer: EWG_C_DECLARATION_LIST_PRINTER
	eiffel_to_c_declaration_printer: EWG_EIFFEL_TO_C_DECLARATION_PRINTER
	eiffel_to_c_declaration_list_printer: EWG_C_DECLARATION_LIST_PRINTER

invariant

	c_to_eiffel_declaration_printer_not_void: c_to_eiffel_declaration_printer /= Void
	eiffel_to_c_macro_declaration_list_printer_not_void: eiffel_to_c_macro_declaration_list_printer /= Void
	casted_declarator_printer_not_void: casted_declarator_printer /= Void
	eiffel_to_c_indirection_printer_not_void: eiffel_to_c_indirection_printer /= Void
	eiffel_to_c_cast_printer_not_void: eiffel_to_c_cast_printer /= Void
	declarator_printer_not_void: declarator_printer /= Void
	eiffel_to_c_parameter_list_printer_not_void: eiffel_to_c_parameter_list_printer /= Void
	eiffel_to_c_declaration_printer_not_void: eiffel_to_c_declaration_printer /= Void
	eiffel_to_c_declaration_list_printer_not_void: eiffel_to_c_declaration_list_printer /= Void

end
