indexing
	description: "Truth values, with the boolean operations"
	external_name: "System.Boolean"
	assembly: "mscorlib"
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2004, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008-04-03 23:51:43 +0200 (Thu, 03 Apr 2008) $"
	revision: "$Revision: 6333 $"

frozen expanded class BOOLEAN

inherit
	BOOLEAN_REF
		redefine
			infix "and",
			infix "and then",
			infix "or",
			infix "or else",
			infix "xor",
			infix "implies",
			prefix "not"
		end

create
	default_create,
	make_from_reference

convert
	make_from_reference ({BOOLEAN_REF})

feature -- Basic operations

	infix "and" (other: BOOLEAN): BOOLEAN is
			-- Boolean conjunction with `other'
		external
			"built_in"
		end

	infix "and then" (other: BOOLEAN): BOOLEAN is
			-- Boolean semi-strict conjunction with `other'
		external
			"built_in"
		end

	infix "implies" (other: BOOLEAN): BOOLEAN is
			-- Boolean implication of `other'
			-- (semi-strict)
		external
			"built_in"
		end

	prefix "not": BOOLEAN is
			-- Negation
		external
			"built_in"
		end

	infix "or" (other: BOOLEAN): BOOLEAN is
			-- Boolean disjunction with `other'
		external
			"built_in"
		end

	infix "or else" (other: BOOLEAN): BOOLEAN is
			-- Boolean semi-strict disjunction with `other'
		external
			"built_in"
		end

	infix "xor" (other: BOOLEAN): BOOLEAN is
			-- Boolean exclusive or with `other'
		external
			"built_in"
		end

end
