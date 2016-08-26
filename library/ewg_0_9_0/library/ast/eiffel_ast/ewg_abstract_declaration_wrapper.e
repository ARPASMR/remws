indexing

	description:

		"Deferred common base for wrapper classes that wrap types"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/18 01:07:12 $"
	revision: "$Revision: 1.1 $"

deferred class EWG_ABSTRACT_DECLARATION_WRAPPER

inherit

	EWG_ABSTRACT_WRAPPER

feature

	declaration: EWG_C_AST_DECLARATION is
		deferred
		end

invariant

	declaration_not_void: declaration /= Void

end
