indexing

	description:

		"ECF conditions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-10-26 20:29:45 +0100 (Sun, 26 Oct 2008) $"
	revision: "$Revision: 6539 $"

deferred class ET_ECF_CONDITION

feature -- Status report

	is_enabled (a_state: ET_ECF_STATE): BOOLEAN is
			-- Does `a_state' fulfill current condition?
		require
			a_state_not_void: a_state /= Void
		deferred
		end

end
