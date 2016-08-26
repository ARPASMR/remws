indexing

	description:

		"Agent extension of GTK_MOTION_NOTIFY_EVENT_SIGNAL_RECEIVER"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/26 21:55:17 $"
	revision: "$Revision: 1.1 $"

class GTK_MOTION_NOTIFY_EVENT_SIGNAL_RECEIVER_AGENT

inherit

	GTK_MOTION_NOTIFY_EVENT_SIGNAL_RECEIVER
		rename
			make as make_internal
		end

	G_RECEIVER_AGENT_SKELETON [FUNCTION [ANY, TUPLE [GTK_WIDGET, GDK_MOTION_EVENT], BOOLEAN]]

creation

	make

feature {NONE}

	on_motion_notify_event (a_widget: GTK_WIDGET; a_event: GDK_MOTION_EVENT): BOOLEAN is
		do
			Result := agent_.item ([a_widget, a_event])
		end
	
end
