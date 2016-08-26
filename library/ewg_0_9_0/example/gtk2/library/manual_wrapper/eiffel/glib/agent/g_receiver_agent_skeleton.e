indexing

	description:

		"Abstract base for receiver agent extensions"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/19 19:34:01 $"
	revision: "$Revision: 1.1 $"

deferred class G_RECEIVER_AGENT_SKELETON [G]

feature {NONE} -- Initialization

	make (a_agent: like agent_) is
		require
			a_agent_not_void: a_agent /= Void
		do
			agent_ := a_agent
			make_internal
		ensure
			agent_set: agent_ = a_agent
		end

	make_internal is
		deferred
		end

feature {NONE} -- Implementation

	agent_: G
	
invariant

	agent_not_void: agent_ /= Void
	
end
