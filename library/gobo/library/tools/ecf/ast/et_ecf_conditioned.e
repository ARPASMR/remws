indexing

	description:

		"ECF objects which are taken into account only in some conditions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-10-26 20:29:45 +0100 (Sun, 26 Oct 2008) $"
	revision: "$Revision: 6539 $"

deferred class ET_ECF_CONDITIONED

feature -- Status report

	is_enabled (a_state: ET_ECF_STATE): BOOLEAN is
			-- Does `a_state' fulfill current condition?
		require
			a_state_not_void: a_state /= Void
		do
			Result := condition = Void or else condition.is_enabled (a_state)
		end

feature -- Access

	condition: ET_ECF_CONDITION
			-- Condition, if any

feature -- Setting

	set_condition (a_condition: like condition) is
			-- Set `condition' to `a_condition'.
		do
			condition := a_condition
		ensure
			condition_set: condition = a_condition
		end

end
