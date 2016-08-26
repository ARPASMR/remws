indexing

	description:

		"Eiffel internal (do or once) routines"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-09-02 14:03:45 +0200 (Tue, 02 Sep 2008) $"
	revision: "$Revision: 6495 $"

deferred class ET_INTERNAL_ROUTINE

inherit

	ET_ROUTINE
		undefine
			locals
		redefine
			reset_after_features_flattened
		end

	ET_INTERNAL_ROUTINE_CLOSURE
		rename
			implementation_closure as implementation_feature
		undefine
			implementation_feature
		end

feature -- Initialization

	reset_after_features_flattened is
			-- Reset current feature as it was just after it was last flattened.
		do
			if implementation_checked then
				if locals /= Void then
					locals.reset
				end
				if compound /= Void then
					compound.reset
				end
				if rescue_clause /= Void then
					rescue_clause.reset
				end
			end
			precursor
		end

end
