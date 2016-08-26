indexing

	description:

		"Eiffel internal (do or once) procedures"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2007-04-23 23:23:03 +0200 (Mon, 23 Apr 2007) $"
	revision: "$Revision: 5948 $"

deferred class ET_INTERNAL_PROCEDURE

inherit

	ET_PROCEDURE
		undefine
			reset_after_features_flattened, locals
		end

	ET_INTERNAL_ROUTINE

end
