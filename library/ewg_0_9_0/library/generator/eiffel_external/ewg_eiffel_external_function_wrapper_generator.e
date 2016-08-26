indexing

	description:

		"Generates Eiffel external wrappers for function declarations"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/07/13 17:48:15 $"
	revision: "$Revision: 1.9 $"

class EWG_EIFFEL_EXTERNAL_FUNCTION_WRAPPER_GENERATOR

inherit

	EWG_ABSTRACT_GENERATOR

	EWG_SHARED_C_SYSTEM
		export {NONE} all end

	EWG_RENAMER
		export {NONE} all end

creation

	make

feature -- Generation

	generate (a_eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET) is
		local
			cs: DS_HASH_TABLE_CURSOR [DS_LINKED_LIST [EWG_FUNCTION_WRAPPER], STRING]
		do
			from
				cs := a_eiffel_wrapper_set.new_function_wrapper_groups_cursor
				cs.start
			until
				cs.off
			loop
				generate_function_wrappers_for_class (cs.key, cs.item)
				cs.forth
			end
		end

feature {NONE} -- Implementation

	generate_function_wrappers_for_class (a_class_name: STRING;
														a_function_declaration_list: DS_LINKED_LIST [EWG_FUNCTION_WRAPPER]) is
		require
			a_class_name_not_void: a_class_name /= Void
			a_function_declaration_list_not_void: a_function_declaration_list /= Void
			a_function_declaration_list_not_empty: a_function_declaration_list.count > 0
			a_function_declaration_list_not_has_void: not a_function_declaration_list.has (Void)
		local
			cs: DS_LINKED_LIST_CURSOR [EWG_FUNCTION_WRAPPER]
			class_name: STRING
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
		do
			class_name := clone (a_class_name)
			class_name.append_string ("_EXTERNAL")

			file_name := file_system.pathname (directory_structure.eiffel_external_function_directory_name, "spec")
			file_name := file_system.pathname (file_name, eiffel_compiler_mode.eiffel_compiler_name)
			file_name := file_system.pathname (file_name, STRING_.as_lower (class_name) + ".e")
			create file.make (file_name)
			file.recursive_open_write
			if file.is_open_write then
				file.put_line (Generated_file_warning_eiffel_comment)
				file.put_line ("-- functions wrapper")
				file.put_line ("class " + class_name)
				file.put_new_line
				file.put_line ("feature")
				output_stream := file
				from
					cs := a_function_declaration_list.new_cursor
					cs.start
				until
					cs.off
				loop
					generate_function_wrapper (cs.item)
					cs.forth
					error_handler.tick
				end
				file.put_line ("end")
				file.close
			else
				error_handler.report_cannot_write_error (file_name)
			end
		end

	generate_function_wrapper (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		do
			generate_function_accessor (a_function_wrapper)
			generate_function_address_accessor (a_function_wrapper)
		end

	generate_function_accessor (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_C_AST_DECLARATION]
			parameter_name_generator: EWG_UNIQUE_NAME_GENERATOR
			is_problematic_result: BOOLEAN
			function_type: EWG_C_AST_FUNCTION_TYPE
		do
			function_type := a_function_wrapper.function_declaration.function_type
			output_stream.put_string ("%T" + a_function_wrapper.mapped_eiffel_name + "_external")

			if function_type.members.count > 0 then
				output_stream.put_string (" (")
				from
					cs := function_type.members.new_cursor
					cs.start
				until
					cs.off
				loop
					if cs.item.is_anonymous then
						if parameter_name_generator = Void then
							create parameter_name_generator.make ("anonymous_")
							parameter_name_generator.set_output_stream (output_stream)
						end
						parameter_name_generator.generate_new_name
					else
						append_eiffel_parameter_name_from_c_parameter_name_to_stream (output_stream, cs.item.declarator)
					end
					output_stream.put_string (": ")
					output_stream.put_string (cs.item.type.corresponding_eiffel_type)
					if not cs.is_last then
						output_stream.put_string ("; ")
					end
					cs.forth
				end
				output_stream.put_character (')')
			end

			if function_type.return_type.skip_consts_and_aliases /= c_system.types.void_type then
				output_stream.put_string (": ")
				output_stream.put_string (function_type.return_type.corresponding_eiffel_type)
			end
			output_stream.put_string (" is")
			output_stream.put_new_line

			output_stream.put_line ("%T%Texternal")



			is_problematic_result := function_type.return_type.skip_consts_and_aliases.is_struct_type or
				function_type.return_type.skip_consts_and_aliases.is_union_type

			if eiffel_compiler_mode.is_se_mode then
				if is_problematic_result then
					generate_se_indirect_external_clause (a_function_wrapper)
				else
					generate_se_direct_external_clause (a_function_wrapper)
				end
			elseif eiffel_compiler_mode.is_ise_mode then
				if is_problematic_result then
					generate_ise_indirect_external_clause (a_function_wrapper)
				else
					generate_ise_direct_external_clause (a_function_wrapper)
				end
			elseif eiffel_compiler_mode.is_ve_mode then
				generate_ve_indirect_external_clause (a_function_wrapper)
			else
					check
						dead_end: False
					end
			end
			output_stream.put_line ("%T%Tend")

			output_stream.put_new_line
		end

	generate_se_indirect_external_clause (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		do
			output_stream.put_string ("%T%T%T%"C use <")
			output_stream.put_string (directory_structure.relative_function_c_glue_header_file_name)
			output_stream.put_string (">%"")
			output_stream.put_new_line

			output_stream.put_line ("%T%Talias")

			output_stream.put_string ("%T%T%T%"ewg_function_")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_character ('"')
			output_stream.put_new_line
		end

	generate_se_direct_external_clause (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		do
			output_stream.put_string ("%T%T%T%"C use <")
			output_stream.put_string (a_function_wrapper.header_file_name)
			output_stream.put_string (">%"")
			output_stream.put_new_line
			output_stream.put_line ("%T%Talias")

			output_stream.put_string ("%T%T%T%"")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_character ('"')
			output_stream.put_new_line
		end

	generate_ise_indirect_external_clause (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			declaration_printer: EWG_C_ISE_EXTERNAL_DECLARATION_PRINTER
			declaration_list_printer: EWG_C_DECLARATION_LIST_PRINTER
			function_type: EWG_C_AST_FUNCTION_TYPE
			return_type_printer: EWG_C_TO_EIFFEL_DECLARATION_PRINTER
		do
			function_type := a_function_wrapper.function_declaration.function_type
			create declaration_printer.make (output_stream)
			create declaration_list_printer.make (output_stream, declaration_printer)
			create return_type_printer.make (output_stream, eiffel_compiler_mode)
			-- ISE external clause
			output_stream.put_string ("%T%T%T%"C [macro <")
			output_stream.put_string (directory_structure.relative_function_c_glue_header_file_name)
			output_stream.put_string (">] ")
			if function_type.members.count > 0 then
				output_stream.put_character ('(')
				declaration_list_printer.print_declaration_list (function_type.members)
				output_stream.put_character (')')
			end
			if
				function_type.return_type.skip_consts_and_aliases /=
				c_system.types.void_type
			then
				output_stream.put_character (':')
				return_type_printer.print_declaration_from_type (function_type.return_type, "")
			end
			output_stream.put_character ('"')
			output_stream.put_new_line

			output_stream.put_line ("%T%Talias")

			output_stream.put_string ("%T%T%T%"")
			output_stream.put_string ("ewg_function_")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string ("()%"")
			output_stream.put_new_line
		end

  generate_ise_direct_external_clause (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			declaration_printer: EWG_C_ISE_EXTERNAL_DECLARATION_PRINTER
			declaration_list_printer: EWG_C_DECLARATION_LIST_PRINTER
			function_type: EWG_C_AST_FUNCTION_TYPE
			return_type_printer: EWG_C_ANONYMOUS_DECLARATION_PRINTER
		do
			function_type := a_function_wrapper.function_declaration.function_type
			create declaration_printer.make (output_stream)
			create declaration_list_printer.make (output_stream, declaration_printer)
			create return_type_printer.make (output_stream)
			-- ISE external clause
			output_stream.put_string ("%T%T%T%"C [macro <")
			output_stream.put_string (directory_structure.relative_function_c_glue_header_file_name)
			output_stream.put_string (">] ")
			if function_type.members.count > 0 then
				output_stream.put_character ('(')
				declaration_list_printer.print_declaration_list (function_type.members)
				output_stream.put_character (')')
			end
			if
				function_type.return_type.skip_consts_and_aliases /=
				c_system.types.void_type
			then
				output_stream.put_character (':')
				return_type_printer.print_declaration_from_type (function_type.return_type, "")
			end
			output_stream.put_character ('"')
			output_stream.put_new_line

			output_stream.put_line ("%T%Talias")

			output_stream.put_string ("%T%T%T%"")
			output_stream.put_string ("ewg_function_macro_")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_character ('"')
			output_stream.put_new_line
		end

	generate_ve_indirect_external_clause (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		do
			output_stream.put_line ("%T%T%T%"C%"")
			output_stream.put_line ("%T%Talias")
			output_stream.put_string ("%T%T%T%"ewg_function_")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_character ('"')
			output_stream.put_new_line
		end

	generate_function_address_accessor (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		do
			output_stream.put_string ("%T")
			output_stream.put_string (a_function_wrapper.mapped_eiffel_name)
			output_stream.put_string ("_address_external: POINTER is")
			output_stream.put_new_line

			output_stream.put_string ("%T%T%T-- Address of C function `")
			output_stream.put_string (a_function_wrapper.function_declaration.declarator)
			output_stream.put_string ("'")
			output_stream.put_new_line
			output_stream.put_line ("%T%Texternal")

				if eiffel_compiler_mode.is_se_mode then
					output_stream.put_line ("%T%T%T%"C inline%"")
					output_stream.put_line ("%T%Talias")
					output_stream.put_string ("%T%T%T%"(void*) ")
					output_stream.put_string (a_function_wrapper.function_declaration.declarator)
					output_stream.put_string ("%"")
					output_stream.put_new_line
				elseif eiffel_compiler_mode.is_ise_mode then
					output_stream.put_string ("%T%T%T%"C [macro <")
					output_stream.put_string (a_function_wrapper.header_file_name)
					output_stream.put_string (">]: void*%"")
					output_stream.put_new_line
					output_stream.put_line ("%T%Talias")
					output_stream.put_string ("%T%T%T%"(void*) ")
					output_stream.put_string (a_function_wrapper.function_declaration.declarator)
					output_stream.put_string ("%"")
					output_stream.put_new_line
				elseif eiffel_compiler_mode.is_ve_mode then
					output_stream.put_line ("%T%T%T%"C%"")
					output_stream.put_line ("%T%Talias")
					output_stream.put_string ("%T%T%T%"ewg_get_function_address_")
					output_stream.put_string (a_function_wrapper.function_declaration.declarator)
					output_stream.put_string ("%"")
					output_stream.put_new_line
				else
						check
							dead_end: False
						end
				end
			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line

		end

end
