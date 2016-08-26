indexing

	description:

		"Agent extensions for G_MAIN"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/19 19:34:01 $"
	revision: "$Revision: 1.1 $"

deferred class G_TIMOUT_SOURCE_AGENT

feature {ANY}

	set_timeout_receiver (a_receiver: G_TIMEOUT_RECEIVER) is
			-- Make `a_receiver' to be the event receiver for this
			-- timout source.
		require
			a_receiver_not_void: a_receiver /= Void
		deferred
		end

end
