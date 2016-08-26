indexing

	description:

		"Eiffel class subprocessors"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-06-28 04:52:05 +0200 (Sat, 28 Jun 2008) $"
	revision: "$Revision: 6434 $"

deferred class ET_CLASS_SUBPROCESSOR

inherit

	ET_CLASS_PROCESSOR

feature -- Error handling

	has_fatal_error: BOOLEAN
			-- Has a fatal error occurred?

	set_fatal_error is
			-- Report a fatal error.
		do
			has_fatal_error := True
		ensure
			has_fatal_error: has_fatal_error
		end

	reset_fatal_error (b: BOOLEAN) is
			-- Set `has_fatal_error' to `b'.
		do
			has_fatal_error := b
		ensure
			fatal_error_set: has_fatal_error = b
		end

end
