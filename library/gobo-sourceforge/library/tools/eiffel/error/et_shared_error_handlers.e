indexing

	description:

		"Shared Eiffel error handlers"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-08-24 13:37:02 +0200 (Sun, 24 Aug 2008) $"
	revision: "$Revision: 6492 $"

class ET_SHARED_ERROR_HANDLERS

feature -- Access

	null_error_handler: ET_NULL_ERROR_HANDLER is
			-- Null Eiffel error handler
		once
			create Result.make_null
		ensure
			null_error_handler_not_void: Result /= Void
		end

end
