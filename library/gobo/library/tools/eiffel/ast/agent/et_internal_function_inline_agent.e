indexing

	description:

		"Eiffel inline agents with an internal (do or once) function as associated feature"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-02-17 15:29:21 +0100 (Sat, 17 Feb 2007) $"
	revision: "$Revision: 5895 $"

deferred class ET_INTERNAL_FUNCTION_INLINE_AGENT

inherit

	ET_FUNCTION_INLINE_AGENT
		undefine
			reset, locals
		end

	ET_INTERNAL_ROUTINE_INLINE_AGENT
		rename
			make as make_inline_agent
		undefine
			type, implicit_result
		end

end
