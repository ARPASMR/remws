indexing

	description:

		"Wraps members that are of type char* (in the sense of zero terminated strings)"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/10/20 00:10:16 $"
	revision: "$Revision: 1.3 $"

class EWG_ZERO_TERMINATED_STRING_MEMBER_WRAPPER

inherit

	EWG_MEMBER_WRAPPER
		rename
			make as make_member_wrapper
		end

creation

	make

feature {NONE} -- Initialization

	make (a_mapped_eiffel_name: STRING; a_header_file_name: STRING;
			a_c_declaration: EWG_C_AST_DECLARATION) is
		require
			a_mapped_eiffel_name_not_void: a_mapped_eiffel_name /= Void
			a_mapped_eiffel_name_not_empty: not a_mapped_eiffel_name.is_empty
			a_header_file_name_not_void: a_header_file_name /= Void
			a_header_file_name_not_empty: not a_header_file_name.is_empty
			a_c_declaration_not_void: a_c_declaration /= Void
			a_c_declarations_type_is_char_pointer_type: a_c_declaration.type.is_char_pointer_type
		do
			make_member_wrapper (a_mapped_eiffel_name, a_header_file_name)
			c_declaration := a_c_declaration
		ensure
			mapped_eiffel_name_set: mapped_eiffel_name = a_mapped_eiffel_name
			header_file_name_set: header_file_name = a_header_file_name
			c_declaration_set: c_declaration = a_c_declaration
		end

feature

	c_declaration: EWG_C_AST_DECLARATION
			-- C declaration to wrap

	eiffel_type: STRING is
		do
			Result := "STRING"
		ensure
			result_not_void: Result /= Void
		end

	proposed_feature_name_list: DS_LINEAR [STRING] is
		local
			list: DS_LINKED_LIST [STRING]
		do
			create list.make
			list.put_last (mapped_eiffel_name)
			Result := list
		end

invariant

	c_declaration_not_void: c_declaration /= Void
	c_declarations_type_is_char_pointer_type: c_declaration.type.is_char_pointer_type

end
