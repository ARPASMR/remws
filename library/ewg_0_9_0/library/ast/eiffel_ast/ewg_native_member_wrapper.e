indexing

	description:

		"Member wrapper that provides native mapping"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/26 21:56:23 $"
	revision: "$Revision: 1.4 $"

class EWG_NATIVE_MEMBER_WRAPPER

inherit

	EWG_MEMBER_WRAPPER
		rename
			make as make_member_wrapper
		end

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all end

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
		do
			make_member_wrapper (a_mapped_eiffel_name, a_header_file_name)
			c_declaration := a_c_declaration
		ensure
			mapped_eiffel_name_set: mapped_eiffel_name = a_mapped_eiffel_name
			header_file_name_set: header_file_name = a_header_file_name
			c_declaration_set: c_declaration = a_c_declaration
		end

feature

	proposed_feature_name_list: DS_LINEAR [STRING] is
		local
			old_getter_name: STRING
			setter_name: STRING
			list: DS_LINKED_LIST [STRING]
		do
			old_getter_name := STRING_.make (mapped_eiffel_name.count + 4)
			old_getter_name.append_string ("get_")
			old_getter_name.append_string (mapped_eiffel_name)
			
			setter_name := STRING_.make (mapped_eiffel_name.count + 4)
			setter_name.append_string ("set_")
			setter_name.append_string (mapped_eiffel_name)
			
			create list.make
			list.put_last (mapped_eiffel_name)
			list.put_last (old_getter_name)
			list.put_last (setter_name)
			Result := list
		end

	c_declaration: EWG_C_AST_DECLARATION
			-- C declaration to wrap

	eiffel_type: STRING is
		do
			Result := c_declaration.type.corresponding_eiffel_type
		ensure
			result_not_void: Result /= Void
		end

invariant

	c_declaration_not_void: c_declaration /= Void
	
end
