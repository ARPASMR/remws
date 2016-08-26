indexing

	description:

		"Generates Eiffel abstraction wrappers for C struct types"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/14 20:02:45 $"
	revision: "$Revision: 1.13 $"

class EWG_EIFFEL_ABSTRACTION_STRUCT_WRAPPER_GENERATOR

inherit

	EWG_ABSTRACT_GENERATOR

	EWG_RENAMER
		export {NONE} all end

creation

	make

feature -- Generation

	generate (a_eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET) is
		local
			cs: DS_BILINEAR_CURSOR [EWG_STRUCT_WRAPPER]
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
		do
			from
				cs := a_eiffel_wrapper_set.new_struct_wrapper_cursor
				cs.start
			until
				cs.off
			loop
				file_name := file_system.pathname (directory_structure.eiffel_abstraction_struct_directory_name,
															  STRING_.as_lower (cs.item.mapped_eiffel_name)
															  + "_struct.e")

				create file.make (file_name)
				file.recursive_open_write

				if not file.is_open_write then
					error_handler.report_cannot_write_error (file_name)
				else
					file.put_line (Generated_file_warning_eiffel_comment)
					file.put_new_line
					output_stream := file
					generate_struct_wrapper (cs.item)
					file.close
				end
				cs.forth
				error_handler.tick
			end
		end

feature

	generate_struct_wrapper (a_struct_wrapper: EWG_STRUCT_WRAPPER) is
		local
			cs: DS_BILINEAR_CURSOR [EWG_MEMBER_WRAPPER]
		do
			output_stream.put_string ("class ")
			output_stream.put_string (a_struct_wrapper.mapped_eiffel_name)
			output_stream.put_line ("_STRUCT")
			output_stream.put_new_line
			-- inheritance clause
			output_stream.put_line ("inherit")
			output_stream.put_new_line
			output_stream.put_line ("%TEWG_STRUCT")
			output_stream.put_new_line
			output_stream.put_string ("%T")
			output_stream.put_string (a_struct_wrapper.mapped_eiffel_name)
			output_stream.put_line ("_STRUCT_EXTERNAL")
			output_stream.put_line ("%T%Texport")
			output_stream.put_line ("%T%T%T{NONE} all")
			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line
			-- creation clause
			output_stream.put_line ("creation")
			output_stream.put_new_line
			output_stream.put_line ("%Tmake_new_unshared,")
			output_stream.put_line ("%Tmake_new_shared,")
			output_stream.put_line ("%Tmake_unshared,")
			output_stream.put_line ("%Tmake_shared")
			output_stream.put_new_line
			-- various features clause
			output_stream.put_line ("feature {NONE} -- Implementation")
			output_stream.put_new_line
			output_stream.put_line ("%Tsizeof: INTEGER is")
			output_stream.put_line ("%T%Tdo")
			output_stream.put_line ("%T%T%TResult := sizeof_external")
			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line

			-- member access clause
			output_stream.put_line ("feature {ANY} -- Member Access")
			output_stream.put_new_line
			from
				cs := a_struct_wrapper.members.new_cursor
				cs.start
			until
				cs.off
			loop
				generate_member (cs.item)
				cs.forth
			end
			output_stream.put_line ("end")
		end

	generate_member (a_struct_member: EWG_MEMBER_WRAPPER) is
		local
			native_wrapper: EWG_NATIVE_MEMBER_WRAPPER
			struct_wrapper: EWG_STRUCT_MEMBER_WRAPPER
		do
			native_wrapper ?= a_struct_member
			struct_wrapper ?= a_struct_member

			if native_wrapper /= Void then
				generate_native_wrapped_member (native_wrapper.mapped_eiffel_name,
														  native_wrapper.composite_wrapper,
														  native_wrapper.c_declaration,
														  native_wrapper.header_file_name)
			elseif struct_wrapper /= Void then
				generate_struct_wrapped_member (struct_wrapper)
			else
					check
						dead_end: False
					end
			end
		end

	generate_struct_wrapped_member (a_struct_wrapper: EWG_STRUCT_MEMBER_WRAPPER) is
		local
			eiffel_member_name: STRING
		do
			eiffel_member_name := eiffel_parameter_name_from_c_parameter_name (a_struct_wrapper.c_declaration.declarator)

			output_stream.put_string ("%T")
			output_stream.put_string (escaped_struct_feature_name (a_struct_wrapper.mapped_eiffel_name))
			output_stream.put_string ("_struct: ")
			output_stream.put_string (a_struct_wrapper.struct_wrapper.mapped_eiffel_name)
			output_stream.put_string ("_STRUCT is")
			output_stream.put_new_line

			output_stream.put_string ("%T%T%T-- Access member `")
			output_stream.put_string (a_struct_wrapper.c_declaration.declarator)
			output_stream.put_string ("'")
			output_stream.put_new_line

			output_stream.put_line ("%T%Trequire")
			output_stream.put_line ("%T%T%Texists: exists")

			output_stream.put_line ("%T%Tdo")
			output_stream.put_string ("%T%T%Tcreate Result.make_shared (get_")
			output_stream.put_string (eiffel_member_name)
			output_stream.put_string ("_external")
			output_stream.put_line (" (item))")

			output_stream.put_line ("%T%Tensure")
			output_stream.put_line ("%T%T%Tresult_not_void: Result /= Void")
			output_stream.put_string ("%T%T%Tresult_has_correct_item: Result.item = ")
			output_stream.put_line (eiffel_member_name)

			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line

			if not a_struct_wrapper.c_declaration.type.skip_consts_and_aliases.is_array_type then
				-- the setter
				output_stream.put_string ("%Tset_")
				output_stream.put_string (a_struct_wrapper.mapped_eiffel_name)
				output_stream.put_string ("_struct (a_value: ")
				output_stream.put_string (a_struct_wrapper.struct_wrapper.mapped_eiffel_name)
				output_stream.put_string ("_STRUCT) is")
				output_stream.put_new_line

				output_stream.put_string ("%T%T%T-- Set member `")
				output_stream.put_string (a_struct_wrapper.c_declaration.declarator)
				output_stream.put_string ("'")
				output_stream.put_new_line

				output_stream.put_line ("%T%Trequire")
				output_stream.put_line ("%T%T%Ta_value_not_void: a_value /= Void")
				output_stream.put_line ("%T%T%Texists: exists")

				output_stream.put_line ("%T%Tdo")
				output_stream.put_string ("%T%T%Tset_")
				output_stream.put_string (eiffel_member_name)
				output_stream.put_line ("_external (item, a_value.item)")
				output_stream.put_line ("%T%Tensure")
				output_stream.put_string ("%T%T%Ta_value_set: a_value.item = ")
				output_stream.put_line (eiffel_member_name)
				output_stream.put_line ("%T%Tend")
				output_stream.put_new_line
			end
		end

	generate_native_wrapped_member (a_mapped_eiffel_name: STRING;
											  a_composite_wrapper: EWG_COMPOSITE_WRAPPER;
											  a_c_declaration: EWG_C_AST_DECLARATION;
											  a_header_file_name: STRING) is
		require
			a_mapped_eiffel_name_not_void: a_mapped_eiffel_name /= Void
			a_mapped_eiffel_name_not_empty: not a_mapped_eiffel_name.is_empty
			a_composite_wrapper_not_void: a_composite_wrapper /= Void
			a_c_declaration_not_void: a_c_declaration /= Void
			a_header_file_name_not_void: a_header_file_name /= Void
			a_header_file_name_not_empty: not a_header_file_name.is_empty
		local
			eiffel_member_name: STRING
			escaped_mapped_eiffel_name: STRING
		do
			escaped_mapped_eiffel_name := escaped_struct_feature_name (a_mapped_eiffel_name)
			eiffel_member_name := eiffel_parameter_name_from_c_parameter_name (a_c_declaration.declarator)

			generate_obsolete_native_wrapped_getter (a_mapped_eiffel_name,
																  a_composite_wrapper,
																  a_c_declaration,
																  a_header_file_name)
			-- the getter
			output_stream.put_string ("%T")
			output_stream.put_string (escaped_mapped_eiffel_name)
			output_stream.put_string (": ")
			output_stream.put_string (a_c_declaration.type.corresponding_eiffel_type)
			output_stream.put_string (" is")
			output_stream.put_new_line

			output_stream.put_string ("%T%T%T-- Access member `")
			output_stream.put_string (a_c_declaration.declarator)
			output_stream.put_string ("'")
			output_stream.put_new_line

			output_stream.put_line ("%T%Trequire")
			output_stream.put_line ("%T%T%Texists: exists")

			output_stream.put_line ("%T%Tdo")
			output_stream.put_string ("%T%T%TResult := get_")
			output_stream.put_string (eiffel_member_name)
			output_stream.put_line ("_external (item)")
			output_stream.put_line ("%T%Tensure")
			output_stream.put_string ("%T%T%Tresult_correct: Result = get_")
			output_stream.put_string (eiffel_member_name)
			output_stream.put_line ("_external (item)")
			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line

			if
				not a_c_declaration.type.skip_consts_and_aliases.is_array_type
			then
				-- the setter
				output_stream.put_string ("%Tset_")
				output_stream.put_string (a_mapped_eiffel_name)
				output_stream.put_string (" (a_value: ")
				output_stream.put_string (a_c_declaration.type.corresponding_eiffel_type)
				output_stream.put_string (") is")
				output_stream.put_new_line

				output_stream.put_string ("%T%T%T-- Set member `")
				output_stream.put_string (a_c_declaration.declarator)
				output_stream.put_string ("'")
				output_stream.put_new_line

				output_stream.put_line ("%T%Trequire")
				output_stream.put_line ("%T%T%Texists: exists")

				output_stream.put_line ("%T%Tdo")
				output_stream.put_string ("%T%T%Tset_")
				output_stream.put_string (eiffel_member_name)
				output_stream.put_line ("_external (item, a_value)")
				if
					not (a_c_declaration.type.skip_consts_and_aliases.is_struct_type or
						  a_c_declaration.type.skip_consts_and_aliases.is_union_type)
				then
					output_stream.put_line ("%T%Tensure")
					output_stream.put_string ("%T%T%Ta_value_set: a_value = ")
					output_stream.put_line (escaped_mapped_eiffel_name)
				end

				output_stream.put_line ("%T%Tend")
				output_stream.put_new_line
			end

			if a_c_declaration.type.skip_consts_and_aliases.is_callback then
				-- the function caller
				output_stream.put_line ("-- TODO: function pointers not yet callable from")
				output_stream.put_line ("--%T%Tstruct, use corresponding callback class instead")
			end
		end


	generate_obsolete_native_wrapped_getter (a_mapped_eiffel_name: STRING;
														  a_composite_wrapper: EWG_COMPOSITE_WRAPPER;
														  a_c_declaration: EWG_C_AST_DECLARATION;
														  a_header_file_name: STRING) is
		require
			a_mapped_eiffel_name_not_void: a_mapped_eiffel_name /= Void
			a_mapped_eiffel_name_not_empty: not a_mapped_eiffel_name.is_empty
			a_composite_wrapper_not_void: a_composite_wrapper /= Void
			a_c_declaration_not_void: a_c_declaration /= Void
			a_header_file_name_not_void: a_header_file_name /= Void
			a_header_file_name_not_empty: not a_header_file_name.is_empty
		local
			eiffel_member_name: STRING
			escaped_mapped_eiffel_name: STRING
		do
			escaped_mapped_eiffel_name := escaped_struct_feature_name (a_mapped_eiffel_name)
			eiffel_member_name := eiffel_parameter_name_from_c_parameter_name (a_c_declaration.declarator)

			-- the getter
			output_stream.put_string ("%Tget_")
			output_stream.put_string (a_mapped_eiffel_name)
			output_stream.put_string (": ")
			output_stream.put_string (a_c_declaration.type.corresponding_eiffel_type)
			output_stream.put_string (" is")
			output_stream.put_new_line

			output_stream.put_string ("%T%Tobsolete %"Use `")
			output_stream.put_string (escaped_mapped_eiffel_name)
			output_stream.put_line ("' instead.%"")
			output_stream.put_string ("%T%T%T-- Access member `")
			output_stream.put_string (a_c_declaration.declarator)
			output_stream.put_string ("'")
			output_stream.put_new_line

			output_stream.put_line ("%T%Trequire")
			output_stream.put_line ("%T%T%Texists: exists")

			output_stream.put_line ("%T%Tdo")
			output_stream.put_string ("%T%T%TResult := get_")
			output_stream.put_string (eiffel_member_name)
			output_stream.put_line ("_external (item)")
			output_stream.put_line ("%T%Tensure")
			output_stream.put_string ("%T%T%Tresult_correct: Result = get_")
			output_stream.put_string (eiffel_member_name)
			output_stream.put_line ("_external (item)")
			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line
		end

end
