indexing

	description:

		"Eiffel conversion expressions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2003-2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-07-02 01:17:09 +0200 (Wed, 02 Jul 2008) $"
	revision: "$Revision: 6441 $"

deferred class ET_CONVERT_EXPRESSION

inherit

	ET_EXPRESSION

feature -- Access

	expression: ET_EXPRESSION
			-- Expression to be converted

	convert_feature: ET_CONVERT_FEATURE
			-- Conversion feature

	position: ET_POSITION is
			-- Position of first character of
			-- current node in source code
		do
			Result := expression.position
		end

	first_leaf: ET_AST_LEAF is
			-- First leaf node in current node
		do
			Result := expression.first_leaf
		end

	last_leaf: ET_AST_LEAF is
			-- Last leaf node in current node
		do
			Result := expression.last_leaf
		end

	break: ET_BREAK is
			-- Break which appears just after current node
		do
			Result := expression.break
		end

invariant

	expression_not_void: expression /= Void
	convert_feature_not_void: convert_feature /= Void

end
