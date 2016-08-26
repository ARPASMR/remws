indexing

	description:

		"Generates Eiffel abstraction wrappers for function declarations"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/05/18 09:32:12 $"
	revision: "$Revision: 1.5 $"

class EWG_EIFFEL_ABSTRACTION_FUNCTION_WRAPPER_GENERATOR

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

			file_name := file_system.pathname (directory_structure.eiffel_abstraction_function_directory_name, STRING_.as_lower (class_name) + ".e")
			create file.make (file_name)
			file.recursive_open_write
			if file.is_open_write then
				file.put_line (Generated_file_warning_eiffel_comment)
				file.put_line ("-- functions wrapper")
				file.put_line ("class " + class_name)
				file.put_new_line
				file.put_line ("obsolete")
				file.put_string ("%T%"Use class ")
				file.put_string (class_name)
				file.put_line ("_EXTERNAL instead.%"")
				file.put_new_line
				file.put_string ("inherit")
				file.put_new_line
				file.put_new_line
				file.put_string ("%T")
				file.put_string (class_name)
				file.put_string ("_EXTERNAL")
				file.put_new_line
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
		end

feature

	generate_function_accessor (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		do
			-- TODO: We ignore functions with struct or union return type for now
			-- later this problem will be taken care of in the C glue code layer
			if
				a_function_wrapper.function_declaration.function_type.return_type.skip_consts_and_aliases.is_struct_type or
					a_function_wrapper.function_declaration.function_type.return_type.skip_consts_and_aliases.is_union_type
			then
				-- For now we do not support unions or structs as return types to functions
				output_stream.put_line ("-- Ignoring " + a_function_wrapper.mapped_eiffel_name + " since its return type is a composite type")
			else
				generate_routine_signature (a_function_wrapper)

				generate_locals (a_function_wrapper)

				output_stream.put_string ("%T%Tdo")
				output_stream.put_new_line

				generate_routine_call_preparation (a_function_wrapper)

				if
					a_function_wrapper.function_declaration.function_type.return_type.skip_consts_and_aliases /=
					c_system.types.void_type
				then
					output_stream.put_string ("%T%T%TResult := ")
				else
					output_stream.put_string ("%T%T%T")
				end

				generate_routine_call (a_function_wrapper)

				output_stream.put_line ("%T%Tend")
			end
			output_stream.put_new_line
		end

	generate_routine_signature (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_MEMBER_WRAPPER]
			native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER
			zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER
		do
			output_stream.put_string ("%T" + a_function_wrapper.mapped_eiffel_name)

			if a_function_wrapper.function_declaration.function_type.members.count > 0 then
				output_stream.put_character (' ')
				output_stream.put_character ('(')
				from
					cs := a_function_wrapper.members.new_cursor
					cs.start
				until
					cs.off
				loop
					native_member_wrapper ?= cs.item
					if native_member_wrapper /= Void then
						generate_signature_parameter_for_native_member_wrapper (native_member_wrapper)
					end
					zero_terminated_string_member_wrapper ?= cs.item
					if zero_terminated_string_member_wrapper /= Void then
						generate_signature_parameter_for_zero_terminated_string_member_wrapper (zero_terminated_string_member_wrapper)
					end
					if not cs.is_last then
						output_stream.put_string ("; ")
					end
					cs.forth
				end
				output_stream.put_character (')')
			end

			if a_function_wrapper.function_declaration.function_type.return_type.skip_consts_and_aliases /= c_system.types.void_type then
				output_stream.put_string (": ")
				output_stream.put_string (a_function_wrapper.function_declaration.function_type.return_type.corresponding_eiffel_type)
			end
			output_stream.put_string (" is")
			output_stream.put_new_line
		end

	generate_signature_parameter_for_native_member_wrapper (a_native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER) is
		require
			a_native_member_wrapper_not_void: a_native_member_wrapper /= Void
		do
			output_stream.put_string (a_native_member_wrapper.mapped_eiffel_name)
			output_stream.put_string (": ")
			output_stream.put_string (a_native_member_wrapper.eiffel_type)
		end

	generate_signature_parameter_for_zero_terminated_string_member_wrapper (a_zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER) is
		require
			a_zero_terminated_string_member_wrapper_not_void: a_zero_terminated_string_member_wrapper /= Void
		do
			output_stream.put_string (a_zero_terminated_string_member_wrapper.mapped_eiffel_name)
			output_stream.put_string (": ")
			output_stream.put_string (a_zero_terminated_string_member_wrapper.eiffel_type)
		end

feature

	generate_routine_call (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_MEMBER_WRAPPER]
			native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER
			zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER
		do
			output_stream.put_string (a_function_wrapper.mapped_eiffel_name + "_external")

			if a_function_wrapper.function_declaration.function_type.members.count > 0 then
				output_stream.put_character (' ')
				output_stream.put_character ('(')
				from
					cs := a_function_wrapper.members.new_cursor
					cs.start
				until
					cs.off
				loop
					native_member_wrapper ?= cs.item
					if native_member_wrapper /= Void then
						generate_routine_call_parameter_for_native_member_wrapper (native_member_wrapper)
					end
					zero_terminated_string_member_wrapper ?= cs.item
					if zero_terminated_string_member_wrapper /= Void then
						generate_routine_call_parameter_for_zero_terminated_string_member_wrapper (zero_terminated_string_member_wrapper)
					end
					if not cs.is_last then
						output_stream.put_string (", ")
					end
					cs.forth
				end
				output_stream.put_character (')')
			end
			output_stream.put_new_line
		end

	generate_routine_call_parameter_for_native_member_wrapper (a_native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER) is
		require
			a_native_member_wrapper_not_void: a_native_member_wrapper /= Void
		do
			output_stream.put_string (a_native_member_wrapper.mapped_eiffel_name)
		end

	generate_routine_call_parameter_for_zero_terminated_string_member_wrapper (a_zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER) is
		require
			a_zero_terminated_string_member_wrapper_not_void: a_zero_terminated_string_member_wrapper /= Void
		do
			output_stream.put_string (a_zero_terminated_string_member_wrapper.mapped_eiffel_name)
			output_stream.put_string ("_c_string.item")
		end

feature

	generate_routine_call_preparation (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_MEMBER_WRAPPER]
			native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER
			zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER
		do
			if a_function_wrapper.function_declaration.function_type.members.count > 0 then
				from
					cs := a_function_wrapper.members.new_cursor
					cs.start
				until
					cs.off
				loop
					native_member_wrapper ?= cs.item
					if native_member_wrapper /= Void then
						generate_routine_call_preparation_for_native_member_wrapper (native_member_wrapper)
					end
					zero_terminated_string_member_wrapper ?= cs.item
					if zero_terminated_string_member_wrapper /= Void then
						generate_routine_call_preparation_for_zero_terminated_string_member_wrapper (zero_terminated_string_member_wrapper)
					end
					cs.forth
				end
			end
		end

	generate_routine_call_preparation_for_native_member_wrapper (a_native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER) is
		require
			a_native_member_wrapper_not_void: a_native_member_wrapper /= Void
		do
			-- Nothing to do
		end

	generate_routine_call_preparation_for_zero_terminated_string_member_wrapper (a_zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER) is
		require
			a_zero_terminated_string_member_wrapper_not_void: a_zero_terminated_string_member_wrapper /= Void
		do
			output_stream.put_string ("%T%T%Tcreate ")
			output_stream.put_string (a_zero_terminated_string_member_wrapper.mapped_eiffel_name)
			output_stream.put_string ("_c_string.make_shared_from_string (")
			output_stream.put_string (a_zero_terminated_string_member_wrapper.mapped_eiffel_name)
			output_stream.put_string (")")
			output_stream.put_new_line
		end

feature

	generate_locals (a_function_wrapper: EWG_FUNCTION_WRAPPER) is
		require
			a_function_wrapper_not_void: a_function_wrapper /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_MEMBER_WRAPPER]
			native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER
			zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER
		do
			output_stream.put_string ("%T%Tlocal")
			output_stream.put_new_line
			if a_function_wrapper.function_declaration.function_type.members.count > 0 then
				from
					cs := a_function_wrapper.members.new_cursor
					cs.start
				until
					cs.off
				loop
					native_member_wrapper ?= cs.item
					if native_member_wrapper /= Void then
						generate_local_for_native_member_wrapper (native_member_wrapper)
					end
					zero_terminated_string_member_wrapper ?= cs.item
					if zero_terminated_string_member_wrapper /= Void then
						generate_local_for_zero_terminated_string_member_wrapper (zero_terminated_string_member_wrapper)
					end
					cs.forth
				end
			end
		end

	generate_local_for_native_member_wrapper (a_native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER) is
		require
			a_native_member_wrapper_not_void: a_native_member_wrapper /= Void
		do
			-- Nothing to do
		end

	generate_local_for_zero_terminated_string_member_wrapper (a_zero_terminated_string_member_wrapper: EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER) is
		require
			a_zero_terminated_string_member_wrapper_not_void: a_zero_terminated_string_member_wrapper /= Void
		do
			output_stream.put_string ("%T%T%T")
			output_stream.put_string (a_zero_terminated_string_member_wrapper.mapped_eiffel_name)
			output_stream.put_string ("_c_string: EWG_ZERO_TERMINATED_STRING")
			output_stream.put_new_line
		end

end
