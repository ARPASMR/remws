indexing

	description:

		"Objects representing C primitive types (like 'int' or 'double')"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/18 03:49:18 $"
	revision: "$Revision: 1.3 $"

class EWG_C_AST_PRIMITIVE_TYPE

inherit

	EWG_C_AST_SIMPLE_TYPE
		redefine
			corresponding_eiffel_type,
			is_primitive_type
		end

creation

	make

feature

	corresponding_eiffel_type: STRING is
			-- TODO: not taking care of INTEGER_* yet (waiting for Visual Eiffel)
		do
			-- TODO: handle __int8, __int16, __int32 and __int64
			-- TODO: Take care of how different platforms handle C types.
			if name.has_substring ("int") or
				name.has_substring ("long") or
				name.has_substring ("signed") or -- includes 'unsigned'
				name.has_substring ("short") then
				Result := "INTEGER"
			elseif name.has_substring ("char") then
				Result := "CHARACTER"
			elseif name.has_substring ("double") then
				Result := "DOUBLE"
			elseif name.has_substring ("float") then
				Result := "REAL"
			elseif name.has_substring ("void") then
				Result := "WHAT_SHOULD_I_DO_WITH_VOID"
			else
					check
						dead_end: False
					end
			end
		end

	append_anonymous_hash_string_to_string (a_string: STRING) is
		do
				check
					primitive_type_always_named: False
				end
		end

	is_primitive_type: BOOLEAN is
		do
			Result := True
		end

	is_char_type: BOOLEAN is
			-- Is this type 'char'?
		do
			Result := name.has_substring ("char")
		end

	is_int_type: BOOLEAN is
		do
			Result := name.has_substring ("int")
		end

	is_long_type: BOOLEAN is
		do
			Result := name.has_substring ("long")
		end

	is_double_type: BOOLEAN is
		do
			Result := name.has_substring ("double")
		end

	is_float_type: BOOLEAN is
		do
			Result := name.has_substring ("float")
		end

	is_short_type: BOOLEAN is
		do
			Result := name.has_substring ("short")
		end

feature -- Visitor Pattern

	process (a_processor: EWG_C_AST_TYPE_PROCESSOR) is
			-- Process `Current' using `a_processor'.
		do
			a_processor.process_primitive_type (Current)
		end

invariant

	not_anoymous: not is_anonymous

end
