indexing

	description:

		"Eiffel internal (do or once) functions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-04-23 23:23:03 +0200 (Mon, 23 Apr 2007) $"
	revision: "$Revision: 5948 $"

deferred class ET_INTERNAL_FUNCTION

inherit

	ET_FUNCTION
		undefine
			reset_after_features_flattened, locals
		end

	ET_INTERNAL_ROUTINE
		undefine
			reset, type, is_prefixable, is_infixable,
			is_bracketable, is_function
		end

end
