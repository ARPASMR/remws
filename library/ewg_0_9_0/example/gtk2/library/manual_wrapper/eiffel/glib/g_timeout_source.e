indexing

	description:

		"Objects representing Timout Sources"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/19 19:34:01 $"
	revision: "$Revision: 1.1 $"

class G_TIMEOUT_SOURCE

inherit

	G_SOURCE

	G_TIMEOUT_SOURCE_AGENT
		
creation {ANY}

	make
		
feature {NONE} -- Initialization

	make (a_interval: INTEGER) is
			-- Creates a new source that will emit timeout events.
			-- The event is emitted repeatedly until its handler returns `False', 
			-- at which point the timeout is automatically destroyed and the function
			-- will not be called again.
			-- The first call to the function will be at the end of the first interval.
			--
			-- Note that timeout events may be delayed, due to the processing of other event
			-- sources. Thus they should not be relied on for precise timing. After each call
			-- to the timeout event, the time of the next timeout is recalculated based on
			-- the current time and the given interval (it does not try to 'catch up' time lost
			-- in delays).
			-- `a_interval':	the time between calls to the function, in milliseconds
			--					(1/1000ths of a second)
			--
			-- NOTE: The returned source will not have been attached to any Context.
			-- Most of the time a call to `Result.attatch_to_default_context' will be the
			-- sensible thing to do.
		require
			a_interval_greater_zero: a_interval > 0
		do
			make_shared (g_timeout_source_new_external (a_interval))
		ensure
			not_attached: not is_attached
		end

feature {ANY} -- Receiver

	set_timeout_receiver (a_receiver: G_TIMEOUT_RECEIVER) is
			-- Make `a_receiver' to be the event receiver for this
			-- timout source.
		do
			set_closure (a_receiver)
		end

end
