indexing

	description:

		"Agent extensions for GTK_RANGE"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/05/05 20:46:54 $"
	revision: "$Revision: 1.1 $"

deferred class GTK_RANGE_AGENT

inherit

	GTK_OBJECT_AGENT_SKELETON
	
feature {ANY} -- Signals

	connect_agent_to_adjust_bounds_signal (an_agent: PROCEDURE [ANY, TUPLE [GTK_RANGE, DOUBLE]]) is
			-- Connect `a_agent' to the current widget
		require
			agent_not_void: an_agent /= Void
		local
			a_receiver: GTK_ADJUST_BOUNDS_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (an_agent)
			connect_signal_receiver (a_receiver)
		end
							

	-- TODO: change-value signal, present since 2.6
			-- Implementation that relies on the presence of two other
			-- classes, i.e.: GTK_ADJUST_BOUND_SIGNAL_RECEIVER_AGENT and
			-- GTK_ADJUST_BOUND_SIGNAL_RECEIVER
									
			-- 		local
			-- 			a_receiver: GTK_ADJUST_BOUND_SIGNAL_RECEIVER_AGENT
			-- 		do
			-- 			create a_receiver.make (a_agent)
			-- 			connect_signal_receiver (a_receiver)
			-- 		end

-- TODO:	connect_move_slider_signal_receiver (a_receiver: GTK_MOVE_SLIDER_RECEIVER) is
-- 			-- Connect `a_receiver' to the current widget
-- 		require
-- 			a_receiver_not_void: a_receiver /= Void
-- 		do
-- 			connect_signal_receiver (a_receiver)
-- 		end


end
