indexing

	description:

		"Generates C glue code for enum wrappers"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/07/12 22:40:22 $"
	revision: "$Revision: 1.5 $"

class EWG_C_GLUE_CODE_ENUM_WRAPPER_GENERATOR

inherit

	EWG_ABSTRACT_GENERATOR
		redefine
			make_internal
		end

	EWG_SHARED_TEMPLATE_EXPANDER
		export {NONE} all end

	EWG_RENAMER
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
			create c_declaration_printer.make (output_stream)
		end

feature

	generate (a_eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET) is
		local
			cs: DS_BILINEAR_CURSOR [EWG_ENUM_WRAPPER]
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
		do
			file_name := directory_structure.enum_c_glue_code_file_name (eiffel_compiler_mode.eiffel_compiler_mode)
			create file.make (file_name)
			file.recursive_open_write
			if not file.is_open_write then
				error_handler.report_cannot_write_error (file_name)
			else
				output_stream := file
				from
					cs := a_eiffel_wrapper_set.new_enum_wrapper_cursor
					cs.start
				until
					cs.off
				loop
					generate_enum_wrapper (cs.item)
					cs.forth
					error_handler.tick
				end
				file.close
			end
		end

feature {NONE}

	generate_enum_wrapper (a_enum_wrapper: EWG_ENUM_WRAPPER) is
		require
			a_enum_wrapper_not_void: a_enum_wrapper /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_C_AST_DECLARATION]
			escaped_enum_name: STRING
			string_printer: EWG_C_DECLARATION_PRINTER
		do
			output_stream.put_string ("#include <" + a_enum_wrapper.header_file_name + ">%N")
			output_stream.put_new_line
			output_stream.put_string ("// c glue code for enum `")
			c_declaration_printer.print_declaration_from_type (a_enum_wrapper.c_enum_type, "")
			output_stream.put_string ("'")
			output_stream.put_new_line
			output_stream.put_new_line

			escaped_enum_name := STRING_.make (20)
			create string_printer.make_string (escaped_enum_name)
			string_printer.print_declaration_from_type (a_enum_wrapper.c_enum_type, "")
			escape_type_name_to_be_c_identifier (escaped_enum_name)

			if a_enum_wrapper.c_enum_type.is_complete then
				from
					cs := a_enum_wrapper.c_enum_type.members.new_cursor
					cs.start
				until
					cs.off
				loop
					generate_member (cs.item, escaped_enum_name)
					cs.forth
				end
			end
		end

	generate_member (a_member: EWG_C_AST_DECLARATION; a_escaped_enum_name: STRING) is
		require
			a_member_not_void: a_member /= Void
			a_escaped_enum_name_not_void: a_escaped_enum_name /= Void
		do
			template_expander.expand_into_stream_from_array (output_stream,
															 enum_member_getter_template,
															 <<a_member.declarator,
																a_escaped_enum_name>>)
			output_stream.put_new_line
		end

feature {NONE}

	enum_member_getter_template: STRING is
			-- ${1} ... enum member name
			-- ${2} ... enum name
		once
			Result :=
							"int ewg_get_enum_${2}_member_${1} ()%N" +
							"{%N" +
							"%Treturn ${1};%N" +
							"}%N"
		end

	c_declaration_printer: EWG_C_DECLARATION_PRINTER

invariant

	c_declaration_printer_not_void: c_declaration_printer /= Void

end
