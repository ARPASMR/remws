indexing

	description:

		"C pointer types"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/19 03:28:49 $"
	revision: "$Revision: 1.8 $"

class EWG_C_AST_POINTER_TYPE

inherit

	EWG_C_AST_BASED_TYPE
		rename
			make as make_based_type
		redefine
			is_same_type,
			total_pointer_and_array_indirections,
			total_pointer_indirections,
			is_char_pointer_type,
			corresponding_eiffel_type,
			skip_consts_and_pointers,
			skip_consts_aliases_and_pointers,
			skip_const_pointer_and_array_types,
			has_type_as_base_with_no_pointer_or_array_types_inbetween_indirect,
			number_of_pointer_or_array_types_between_current_and_type_recursive,
			is_pointer_type
		end

	EWG_C_CALLING_CONVENTION_CONSTANTS
		export {NONE} all end

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all end

creation

	make

feature {NONE} -- Creation

	make (a_header_file_name: STRING; a_base: EWG_C_AST_TYPE) is
		require
			a_header_file_name_not_void: a_header_file_name /= Void
			a_base_not_void: a_base /= Void
		do
			make_based_type (Void, a_header_file_name, a_base)
		ensure
			base_set: base = a_base
			header_file_name_set: header_file_name = a_header_file_name
		end

feature

	is_same_type (other: EWG_C_AST_TYPE): BOOLEAN is
		local
			other_pointer: EWG_C_AST_POINTER_TYPE
		do
			other_pointer ?= other
			if other_pointer /= Void then
				Result := Current = other_pointer or else is_same_based_type (other_pointer)
			end
		end

	append_anonymous_hash_string_to_string (a_string: STRING) is
		do
			a_string.append_string ("pointer_")
			base.append_hash_string_to_string (a_string)
		end

	total_pointer_and_array_indirections: INTEGER is
			-- Number of total pointer and array indirections
		do
			Result := 1 + base.skip_consts_and_aliases.total_pointer_and_array_indirections
		end

	total_pointer_indirections: INTEGER is
			-- Number of total pointer indirections
		do
			Result := 1 + base.skip_consts_and_aliases.total_pointer_indirections
		end

	is_pointer_type: BOOLEAN is
		do
			Result := True
		end

	corresponding_eiffel_type: STRING is
		do
			Result := "POINTER"
		end

	skip_consts_and_pointers: EWG_C_AST_TYPE is
		do
			Result := base.skip_consts_and_pointers
		end

	skip_consts_aliases_and_pointers: EWG_C_AST_TYPE is
		do
			Result := base.skip_consts_aliases_and_pointers
		end

	skip_const_pointer_and_array_types: EWG_C_AST_TYPE is
		do
			Result := base.skip_const_pointer_and_array_types
		end

	has_type_as_base_with_no_pointer_or_array_types_inbetween_indirect (a_type: EWG_C_AST_TYPE): BOOLEAN is
		do
			Result := False
		end

	is_char_pointer_type: BOOLEAN is
			-- Is the current type a pointer to char ?
			-- (Note aliases and consts are ignored)
		local
			primitive_type: EWG_C_AST_PRIMITIVE_TYPE
		do
			if
				base.skip_consts_and_aliases.is_primitive_type
				then
					primitive_type ?= base.skip_consts_and_aliases
					check
						primitive_type_not_void: primitive_type /= Void
					end
				Result := primitive_type.is_char_type
			end
		end

	function_type: EWG_C_AST_FUNCTION_TYPE is
			-- If `Current' is a callback, return the corresponding function type
		require
			is_callback: is_callback
		do
			Result ?= based_type_recursive
		ensure
			function_type_not_void: Result /= Void
		end

feature -- Visitor Pattern

	process (a_processor: EWG_C_AST_TYPE_PROCESSOR) is
			-- Process `Current' using `a_processor'.
		do
			a_processor.process_pointer_type (Current)
		end

feature {EWG_C_AST_BASED_TYPE}

	number_of_pointer_or_array_types_between_current_and_type_recursive (a_type: EWG_C_AST_TYPE; a_indirections: INTEGER): INTEGER is
		local
			base_based_type: EWG_C_AST_BASED_TYPE
		do
			if base = a_type then
				Result := a_indirections + 1
			else
				base_based_type ?= base
				if base_based_type /= Void then
					Result := base_based_type.number_of_pointer_or_array_types_between_current_and_type_recursive (a_type, a_indirections + 1)
				end
			end
		end

invariant

	is_anonymous: is_anonymous

end
