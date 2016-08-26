indexing

	description:

		"Agent extension of GTK_ACTIVATE_SIGNAL_RECEIVER"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/04/30 12:43:16 $"
	revision: "$Revision: 1.2 $"

class GTK_ACTIVATE_SIGNAL_RECEIVER_AGENT

inherit

	GTK_ACTIVATE_SIGNAL_RECEIVER
		rename
			make as make_internal
		end

	G_RECEIVER_AGENT_SKELETON [PROCEDURE [ANY, TUPLE [GTK_WIDGET]]]

creation

	make

feature {NONE}

	on_activate (a_menu_item: GTK_WIDGET) is
		do
			agent_.call ([a_menu_item])
		end
	
end
