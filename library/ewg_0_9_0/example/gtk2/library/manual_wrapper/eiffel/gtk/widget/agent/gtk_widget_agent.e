indexing

	description:

		"Agent extensions for GTK_WIDGET"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/04/30 12:43:15 $"
	revision: "$Revision: 1.5 $"

deferred class GTK_WIDGET_AGENT

inherit

	GTK_OBJECT_AGENT_SKELETON
	
feature {ANY} -- Signals

	connect_activate_signal_receiver_agent (a_agent: PROCEDURE [ANY, TUPLE [GTK_WIDGET]]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_ACTIVATE_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_delete_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_DELETE_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_expose_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_EXPOSE_EVENT], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_EXPOSE_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_configure_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_CONFIGURE_EVENT], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_CONFIGURE_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_motion_notify_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_MOTION_EVENT], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_MOTION_NOTIFY_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_button_press_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_BUTTON_EVENT], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_BUTTON_PRESS_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_key_press_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_KEY_EVENT], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_KEY_PRESS_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_focus_in_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_FOCUS_EVENT], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_FOCUS_IN_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

	connect_focus_out_event_signal_receiver_agent (a_agent: FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_FOCUS_EVENT], BOOLEAN]) is
			-- Connect `a_agent' to the current widget
		require
			a_agent_not_void: a_agent /= Void
		local
			a_receiver: GTK_FOCUS_OUT_EVENT_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (a_agent)
			connect_signal_receiver (a_receiver)
		end

end
