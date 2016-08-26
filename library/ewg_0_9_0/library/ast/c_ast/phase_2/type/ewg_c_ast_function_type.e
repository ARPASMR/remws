indexing

	description:

		"C function types"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/06/11 22:29:44 $"
	revision: "$Revision: 1.8 $"

-- TODO: rename `members' to `parameters'
class EWG_C_AST_FUNCTION_TYPE

inherit

	EWG_C_AST_COMPOSITE_TYPE
		rename
			make as make_composite_type
		redefine
			is_same_type,
			directly_nested_types,
			is_function_type,
			set_members
		end

	EWG_C_CALLING_CONVENTION_CONSTANTS

	EWG_SHARED_C_SYSTEM
		export {NONE} all end

creation

	make

feature

	make (a_header_file_name: STRING; a_return_type: EWG_C_AST_TYPE; a_members: like members) is
		require
			a_return_type_not_void: a_return_type /= Void
			a_members_not_void: a_members /= Void
			a_header_file_name_not_void: a_header_file_name /= Void
		do
			make_composite_type (Void, a_header_file_name, a_members)
			return_type := a_return_type
			correct_parameter_types
		end

feature -- Basic Access

	return_type: EWG_C_AST_TYPE
			-- Return type of this function type

	has_ellipsis_parameter: BOOLEAN
			-- Does this function have take arbitrary many unnamed parameters after the regular ones?

	is_variadic: BOOLEAN is
			-- Is this function variadic?
			-- I.e., either has the elipsis parameter or has the last parameter "va_list" from stdarg.h?
		do
			Result := has_ellipsis_parameter
			if
				not Result and
					members /= Void and then
					not members.is_empty and then
					members.last.type.name /= Void
			then
				Result := STRING_.has_substring (members.last.type.header_file_name, "stdarg.h") and
					STRING_.same_string (members.last.type.name, "va_list")
			end
		end

feature

	set_return_type (a_return_type: like return_type) is
		require
			a_return_type_not_void: a_return_type /= Void
		do
			return_type := a_return_type
		end

	set_members (a_members: like members) is
		do
			Precursor (a_members)
			correct_parameter_types
		end

	set_ellipsis_parameter (a_value: BOOLEAN) is
			-- Set `has_ellipsis_parameter' to `a_value'.
		do
			has_ellipsis_parameter := a_value
		ensure
			has_ellipsis_parameter_set: has_ellipsis_parameter = a_value
		end

feature

	is_same_type (other: EWG_C_AST_TYPE): BOOLEAN is
		local
			other_function: EWG_C_AST_FUNCTION_TYPE
		do
			other_function ?= other
			if other_function /= Void then
				if is_anonymous then
					Result := is_same_composite_type (other_function) and
						return_type = other_function.return_type and
						calling_convention = other_function.calling_convention and
						has_ellipsis_parameter = other_function.has_ellipsis_parameter
				else
					Result := is_same_composite_type (other_function)
				end
			end
		end

feature -- Visitor Pattern

	process (a_processor: EWG_C_AST_TYPE_PROCESSOR) is
			-- Process `Current' using `a_processor'.
		do
			a_processor.process_function_type (Current)
		end

feature

	has_callback_parameter: BOOLEAN is
			-- Is at least one parameter an anonymous callback ?
		local
			cs: DS_BILINEAR_CURSOR [EWG_C_AST_DECLARATION]
		do
			Result := False
			from
				cs := members.new_cursor
				cs.start
			until
				cs.off
			loop
				if cs.item.type.is_callback then
					Result := True
					cs.go_after
				end
				cs.forth
			end
		end

feature

	directly_nested_types: DS_LINKED_LIST [EWG_C_AST_TYPE] is
		do
			Result := Precursor
			if return_type /= Void then
				Result.put_last (return_type)
			end
		end

	is_function_type: BOOLEAN is
		do
			Result := True
		end

feature

	calling_convention: INTEGER
			-- Calling convetions used for this function type
			-- See EWG_C_CALLING_CONVENTION_CONSTANTS for details.
feature

	set_calling_convention (a_value: INTEGER) is
			-- Sets the calling conventions used for this function type.
			-- See `calling_convention' for details.
		require
			a_value_is_valid_calling_convention: is_valid_calling_convention_constant (a_value)
		do
			calling_convention := a_value
		ensure
			calling_convention_set: calling_convention = a_value
		end

feature {NONE}

	correct_parameter_types is
			-- Correct parameter types.
			-- Some C compilers support funcitons as function parameters
			-- and give the parameter the semantic of a function pointer.
			-- Example: void foo(void bar(void));
			-- Here `bar' is a pointer to a function, not a function.
		local
			cs: DS_LINEAR_CURSOR [EWG_C_AST_DECLARATION]
			pointer: EWG_C_AST_POINTER_TYPE
		do
			if members /= Void then
				from
					cs := members.new_cursor
					cs.start
				until
					cs.off
				loop
					if cs.item.type.skip_consts_and_aliases.is_function_type then
						create pointer.make (cs.item.type.header_file_name, cs.item.type)
						c_system.types.add_type (pointer)
						cs.item.set_type (c_system.types.last_type)
					end
					cs.forth
				end
			end
		end

invariant

	return_type_not_void: return_type /= Void
	calling_convention_is_valid: is_valid_calling_convention_constant (calling_convention)
	is_anonymous: is_anonymous
	is_function_type: is_function_type

end
