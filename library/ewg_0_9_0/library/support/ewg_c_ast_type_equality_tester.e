indexing

	description:

		"Equality tester for EWG_EWG_C_AST_TYPE objects"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/10/20 00:10:12 $"
	revision: "$Revision: 1.3 $"

class EWG_C_AST_TYPE_EQUALITY_TESTER [G -> EWG_C_AST_TYPE]

inherit

	KL_EQUALITY_TESTER [G]
		redefine
			test
		end

feature -- Status report

	test (v, u: G): BOOLEAN is
			-- Are `v' and `u' considered equal?
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := (u = Void)
			elseif u = Void then
				Result := False
			else
				Result := v.is_same_type (u)
			end
		end
end
