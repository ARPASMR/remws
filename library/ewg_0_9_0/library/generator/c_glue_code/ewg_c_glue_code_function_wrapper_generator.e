indexing

	description:

		"Generates glue code for function wrappers"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/12/06 18:22:42 $"
	revision: "$Revision: 1.22 $"

class EWG_C_GLUE_CODE_FUNCTION_WRAPPER_GENERATOR

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
			create eiffel_to_c_declaration_list_printer.make (output_stream, eiffel_to_c_declaration_printer)
			eiffel_to_c_declaration_list_printer.set_declarator_prefix ("ewg_")
			create casted_declarator_printer.make (output_stream)
			create eiffel_to_c_indirection_printer.make (output_stream, eiffel_compiler_mode)
			create eiffel_to_c_cast_printer.make (output_stream, eiffel_compiler_mode)
			create declarator_printer.make (output_stream)
			casted_declarator_printer.add_printer (eiffel_to_c_indirection_printer)
			casted_declarator_printer.add_printer (eiffel_to_c_cast_printer)
			casted_declarator_printer.add_printer (declarator_printer)
			create eiffel_to_c_parameter_list_printer.make (output_stream, casted_declarator_printer)
			eiffel_to_c_parameter_list_printer.set_declarator_prefix ("ewg_")
			create c_declaration_printer.make (output_stream)
			create c_cast_printer.make (output_stream)
		end

feature -- Generation

	generate (a_eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET) is
		local
			cs: DS_BILINEAR_CURSOR [EWG_FUNCTION_WRAPPER]
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
		do
			file_name := directory_structure.function_c_glue_code_file_name (eiffel_compiler_mode.eiffel_compiler_mode)
			create file.make (file_name)
			file.recursive_open_write
			if not file.is_open_write then
				error_handler.report_cannot_write_error (file_name)
			else
				output_stream := file
				make_printers
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
			output_stream.put_string ("#include <")
			output_stream.put_string (a_function_wrapper.header_file_name)
			output_stream.put_line (">")
			output_stream.put_new_line
			generate_function_accessor (a_function_wrapper)
			generate_function_address_accessor (a_function_wrapper)
		end

	generate_function_accessor (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			function_type: EWG_C_AST_FUNCTION_TYPE
			return_type: EWG_C_AST_TYPE
			declarator: STRING
		do
			function_type := a_function_wrapper.function_declaration.function_type
			return_type := function_type.return_type

			output_stream.put_string ("// Wraps call to function '")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string ("'")
			output_stream.put_new_line
			output_stream.put_string ("// For ")
			output_stream.put_string (eiffel_compiler_mode.eiffel_compiler_name)
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
			c_to_eiffel_declaration_printer.print_declaration_from_type (return_type, declarator)

			output_stream.put_new_line

			output_stream.put_line ("{")
			generate_call (a_function_wrapper)

			output_stream.put_line ("}")
			output_stream.put_new_line
		end

	generate_function_address_accessor (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
			-- Generate function that returns pointer to function wrapped by
			-- `a_function_wrapper'. This pointer can be used to register
			-- the function wrapped by `a_function_wrapper' as a callback.
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		do
			output_stream.put_string ("// Return address of function '")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string ("'")
			output_stream.put_new_line

			output_stream.put_string ("void* ewg_get_function_address_")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string (" (void)")
			output_stream.put_new_line

			output_stream.put_line ("{")
			output_stream.put_string ("%Treturn (void*) ")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string (";")
			output_stream.put_new_line
			output_stream.put_line ("}")
			output_stream.put_new_line
		end

	generate_call (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
			-- Generate a call to `a_function_wrapper'.
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			function_type: EWG_C_AST_FUNCTION_TYPE
			needs_return: BOOLEAN
			pointer: EWG_C_AST_POINTER_TYPE
		do
			function_type := a_function_wrapper.function_declaration.function_type

			output_stream.put_string ("%T")
			needs_return := function_type.return_type.skip_consts_and_aliases /= c_system.types.void_type
			if needs_return then
				if
					function_type.return_type.skip_consts_and_aliases.is_struct_type or
						function_type.return_type.skip_consts_and_aliases.is_union_type
				then
					create pointer.make (function_type.return_type.header_file_name, function_type.return_type)
					c_declaration_printer.print_declaration_from_type (pointer, "result")
					output_stream.put_string (" = ")
					c_cast_printer.print_declaration_from_type (pointer, "")
					output_stream.put_string (" malloc (sizeof(")
					c_declaration_printer.print_declaration_from_type (function_type.return_type, "")
					output_stream.put_line ("));")
					output_stream.put_string ("%T*result = ")
				else
					output_stream.put_string ("return ")
				end
			end
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string (" (")
			if function_type.members.count > 0 then
				eiffel_to_c_parameter_list_printer.print_declaration_list (function_type.members)
			end
			output_stream.put_character (')')
			if needs_return then
				if
					function_type.return_type.skip_consts_and_aliases.is_struct_type or
						function_type.return_type.skip_consts_and_aliases.is_union_type
				then
					output_stream.put_line (";")
					output_stream.put_string ("%Treturn result")
				end
			end
			output_stream.put_character (';')
			output_stream.put_new_line
		end

feature {NONE} -- Helper formatters

	c_to_eiffel_declaration_printer: EWG_C_TO_EIFFEL_DECLARATION_PRINTER
	eiffel_to_c_declaration_printer: EWG_EIFFEL_TO_C_DECLARATION_PRINTER
	eiffel_to_c_declaration_list_printer: EWG_C_DECLARATION_LIST_PRINTER
	casted_declarator_printer: EWG_COMPOSITE_DECLARATION_PRINTER
	eiffel_to_c_indirection_printer: EWG_EIFFEL_TO_C_INDIRECTION_PRINTER
	eiffel_to_c_cast_printer: EWG_EIFFEL_TO_C_TYPE_CAST_PRINTER
	declarator_printer: EWG_C_DECLARATOR_PRINTER
	eiffel_to_c_parameter_list_printer: EWG_C_DECLARATION_LIST_PRINTER
	c_declaration_printer: EWG_C_DECLARATION_PRINTER
	c_cast_printer: EWG_C_TYPE_CAST_PRINTER


invariant

	c_to_eiffel_declaration_printer_not_void: c_to_eiffel_declaration_printer /= Void
	eiffel_to_c_declaration_printer_not_void: eiffel_to_c_declaration_printer /= Void
	eiffel_to_c_declaration_list_printer_not_void: eiffel_to_c_declaration_list_printer /= Void
	casted_declarator_printer_not_void: casted_declarator_printer /= Void
	eiffel_to_c_indirection_printer_not_void: eiffel_to_c_indirection_printer /= Void
	eiffel_to_c_cast_printer_not_void: eiffel_to_c_cast_printer /= Void
	declarator_printer_not_void: declarator_printer /= Void
	eiffel_to_c_parameter_list_printer_not_void: eiffel_to_c_parameter_list_printer /= Void
	c_declaration_printer_not_void: c_declaration_printer /= Void
	c_cast_printer_not_void: c_cast_printer /= Void

end
