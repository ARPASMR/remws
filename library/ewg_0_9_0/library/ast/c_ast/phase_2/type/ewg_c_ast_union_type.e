indexing

	description:

		"Objects representing C unions"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.3 $"

class EWG_C_AST_UNION_TYPE

inherit

	EWG_C_AST_COMPOSITE_DATA_TYPE
		redefine
			is_same_type,
			is_union_type
		end

creation

	make

feature

	is_same_type (other: EWG_C_AST_TYPE): BOOLEAN is
		local
			other_union: EWG_C_AST_UNION_TYPE
		do
			other_union ?= other
			if other_union /= Void then
				Result := Current = other_union or else is_same_composite_type (other_union)
			end
		end

	is_union_type: BOOLEAN is
		do
			Result := True
		end

feature -- Visitor Pattern

	process (a_processor: EWG_C_AST_TYPE_PROCESSOR) is
			-- Process `Current' using `a_processor'.
		do
			a_processor.process_union_type (Current)
		end

end
