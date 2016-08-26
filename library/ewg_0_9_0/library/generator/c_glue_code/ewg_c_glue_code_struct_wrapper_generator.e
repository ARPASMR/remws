indexing

	description:

		"Generates C glue code for struct wrappers"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:40:03 $"
	revision: "$Revision: 1.15 $"

class EWG_C_GLUE_CODE_STRUCT_WRAPPER_GENERATOR

inherit

	EWG_ABSTRACT_GENERATOR
		redefine
			make_internal
		end

	EWG_SHARED_C_SYSTEM
		export {NONE} all end

	EWG_RENAMER
		export {NONE} all end

	EWG_SHARED_TEMPLATE_EXPANDER
		export {NONE} all end

creation

	make

feature {NONE} -- Implementation

	make_internal is
		do
			Precursor
			make_printers
		end

	make_printers is
		do
			create c_to_eiffel_declaration_printer.make (output_stream, eiffel_compiler_mode)
			create c_to_eiffel_cast_printer.make (output_stream, eiffel_compiler_mode)
			create eiffel_to_c_declaration_printer.make (output_stream, eiffel_compiler_mode)
			create eiffel_to_c_cast_printer.make (output_stream, eiffel_compiler_mode)
		end

feature

	generate (a_eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET) is
		local
			cs: DS_BILINEAR_CURSOR [EWG_STRUCT_WRAPPER]
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
		do
			file_name := directory_structure.struct_c_glue_code_file_name (eiffel_compiler_mode.eiffel_compiler_mode)
			create file.make (file_name)
			file.recursive_open_write
			if not file.is_open_write then
				error_handler.report_cannot_write_error (file_name)
			else
				file.put_line (Generated_file_warning_c_comment)
				file.put_line ("// struct glue code")
				file.put_new_line
				output_stream := file
				make_printers
				from
					cs := a_eiffel_wrapper_set.new_struct_wrapper_cursor
					cs.start
				until
					cs.off
				loop
					generate_struct_wrapper (cs.item)
					error_handler.tick
					cs.forth
				end
				file.close
			end
		end

feature {NONE} -- Implementation

	generate_struct_wrapper (a_struct_wrapper: EWG_STRUCT_WRAPPER) is
		require
			a_struct_wrapper_not_void: a_struct_wrapper /= Void
		local
			escaped_struct_name: STRING
			cast_with_one_pointer_indirection: STRING
			cs: DS_BILINEAR_CURSOR [EWG_C_AST_DECLARATION]
			type_name: STRING
			declaration_printer: EWG_C_DECLARATION_PRINTER
			cast_printer: EWG_C_TYPE_CAST_PRINTER
		do
			type_name := STRING_.make (20)
			create declaration_printer.make_string (type_name)
			if declaration_printer.can_be_printed_from_type (a_struct_wrapper.c_struct_type, "") then
				declaration_printer.print_declaration_from_type (a_struct_wrapper.c_struct_type, "")
			else
					check
						a_struct_wrapper.c_struct_type.has_closest_alias_type
					end
				declaration_printer.print_declaration_from_type (a_struct_wrapper.c_struct_type.closest_alias_type, "")
			end
			escaped_struct_name := clone (type_name)
			escape_type_name_to_be_c_identifier (escaped_struct_name)

			output_stream.put_string ("// glue code for struct `")
			if type_name /= Void then
				output_stream.put_string (type_name)
			else
				output_stream.put_string ("<anonymos struct>")
			end
			output_stream.put_string ("'")
			output_stream.put_new_line
			output_stream.put_new_line

			output_stream.put_line ("#include<" + a_struct_wrapper.header_file_name + ">")
			output_stream.put_new_line

			if a_struct_wrapper.c_struct_type.is_complete then
				template_expander.expand_into_stream_from_array (output_stream,
																				 get_sizeof_template,
																				 <<type_name,
																					escaped_struct_name>>)
			else
				-- TODO: dirty hack, since we cannot determine the size of an
				-- incomplete struct we just say it has size 1
				template_expander.expand_into_stream_from_array (output_stream,
																 get_sizeof_incomplete_template,
																 <<escaped_struct_name>>)
			end
			output_stream.put_new_line

			if a_struct_wrapper.c_struct_type.is_complete then
				cast_with_one_pointer_indirection := STRING_.make (20)
				create cast_printer.make_string (cast_with_one_pointer_indirection)
				cast_printer.enable_additional_pointer_indirection
				cast_printer.print_declaration_from_type (a_struct_wrapper.c_struct_type, "")
				-- member access
				from
					cs := a_struct_wrapper.c_struct_type.members.new_cursor
					cs.start
				until
					cs.off
				loop
					generate_member (cs.item, escaped_struct_name, cast_with_one_pointer_indirection)
					cs.forth
				end
			end

			output_stream.put_new_line
		end

	generate_member (a_struct_member: EWG_C_AST_DECLARATION;
						  a_escaped_struct_name: STRING;
						  a_cast_with_one_pointer_indirection: STRING) is
		require
			a_struct_member_not_void: a_struct_member /= Void
			a_escaped_struct_name_not_void: a_escaped_struct_name /= Void
			a_cast_with_one_pointer_indirection_not_void: a_cast_with_one_pointer_indirection /= Void
		do
			if c_to_eiffel_cast_printer.can_be_printed_from_type (a_struct_member.type, a_struct_member.declarator) then
				generate_member_getter (a_struct_member, a_escaped_struct_name, a_cast_with_one_pointer_indirection)
				if not a_struct_member.type.skip_consts_and_aliases.is_array_type then
					generate_member_setter (a_struct_member, a_escaped_struct_name, a_cast_with_one_pointer_indirection)
				end
			end
		end

	generate_member_getter (a_struct_member: EWG_C_AST_DECLARATION;
									a_escaped_struct_name: STRING;
									a_cast_with_one_pointer_indirection: STRING) is
		require
			a_struct_member_not_void: a_struct_member /= Void
			a_escaped_struct_name_not_void: a_escaped_struct_name /= Void
			a_cast_with_one_pointer_indirection_not_void: a_cast_with_one_pointer_indirection /= Void
		local
			getter_declarator: STRING
		do
			getter_declarator := clone ("ewg_struct_")
			getter_declarator.append_string (a_escaped_struct_name)
			getter_declarator.append_string ("_member_get_")
			getter_declarator.append_string (a_struct_member.declarator)
			getter_declarator.append_string ("(void* a_item)")

			c_to_eiffel_declaration_printer.print_declaration_from_type (a_struct_member.type, getter_declarator)
			output_stream.put_new_line
			output_stream.put_line ("{")
			output_stream.put_string ("%Treturn ")
			if
				a_struct_member.type.skip_consts_and_aliases.is_struct_type or
					a_struct_member.type.skip_consts_and_aliases.is_union_type
			then
				output_stream.put_character ('&')
			end
			c_to_eiffel_cast_printer.print_declaration_from_type (a_struct_member.type , "")
			output_stream.put_character ('(')
			output_stream.put_string (a_cast_with_one_pointer_indirection)
			output_stream.put_string ("a_item)->")
			output_stream.put_string (a_struct_member.declarator)
			output_stream.put_line (";")
			output_stream.put_line ("}")
			output_stream.put_new_line
		end

	generate_member_setter (a_struct_member: EWG_C_AST_DECLARATION;
									a_escaped_struct_name: STRING;
									a_cast_with_one_pointer_indirection: STRING) is
		require
			a_struct_member_not_void: a_struct_member /= Void
			a_escaped_struct_name_not_void: a_escaped_struct_name /= Void
			a_cast_with_one_pointer_indirection_not_void: a_cast_with_one_pointer_indirection /= Void
			type_is_not_array: not a_struct_member.type.skip_consts_and_aliases.is_array_type
		do
			output_stream.put_string ("void ewg_struct_")
			output_stream.put_string (a_escaped_struct_name)
			output_stream.put_string ("_member_set_")
			output_stream.put_string (a_struct_member.declarator)
			output_stream.put_string (" (void* a_item, ")
			eiffel_to_c_declaration_printer.print_declaration_from_type (a_struct_member.type, "a_value")
			output_stream.put_line (")")
			output_stream.put_line ("{")
			output_stream.put_string ("%T(")
			output_stream.put_string (a_cast_with_one_pointer_indirection)
			output_stream.put_string ("a_item)->")
			output_stream.put_string (a_struct_member.declarator)
			output_stream.put_string (" = ")
			if
				a_struct_member.type.skip_consts_and_aliases.is_struct_type or
					a_struct_member.type.skip_consts_and_aliases.is_union_type
			then
				output_stream.put_character ('*')
			end
			eiffel_to_c_cast_printer.print_declaration_from_type (a_struct_member.type, "")
			output_stream.put_line ("a_value;")
			output_stream.put_line ("}")
			output_stream.put_new_line
		end

feature {NONE}

	get_sizeof_template: STRING is
			-- ${1} ... type name
			-- ${2} ... type name escaped to fit requirements of c identifier
		once
			Result := "int ewg_struct_sizeof_${2} ()%N" +
							"{%N" +
							"%Treturn sizeof (${1});%N" +
							"}%N"
		end

	get_sizeof_incomplete_template: STRING is
			-- ${1} ... type name escaped to fit requirements of c identifier
		once
			Result := "int ewg_struct_sizeof_${1} ()%N" +
							"{%N" +
							"%Treturn 1;%N" +
							"}%N"
		end

	c_to_eiffel_declaration_printer: EWG_C_TO_EIFFEL_DECLARATION_PRINTER
	c_to_eiffel_cast_printer: EWG_C_TO_EIFFEL_TYPE_CAST_PRINTER
	eiffel_to_c_declaration_printer: EWG_EIFFEL_TO_C_DECLARATION_PRINTER
	eiffel_to_c_cast_printer: EWG_EIFFEL_TO_C_TYPE_CAST_PRINTER

invariant

	c_to_eiffel_declaration_printer_not_void: c_to_eiffel_declaration_printer /= Void
	c_to_eiffel_cast_printer_not_void: c_to_eiffel_cast_printer /= VOid
	eiffel_to_c_declaration_printer_not_void: eiffel_to_c_declaration_printer /= Void
	eiffel_to_c_cast_printer_not_void: eiffel_to_c_cast_printer /= Void

end
