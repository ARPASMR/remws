indexing

	description:

		"Abstract agent extensions for GTK_OBJECT and descendants"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 13:28:22 $"
	revision: "$Revision: 1.2 $"

deferred class GTK_OBJECT_AGENT_SKELETON

inherit

	ANY
		undefine
			is_equal,
			copy
		end
	
	
feature {ANY} -- Signals

	connect_signal_receiver (a_receiver: G_SIGNAL_RECEIVER) is
		require
			a_receiver_not_void: a_receiver /= Void
			singal_supported: True -- TODO:
		deferred
		ensure
			--TODO:
		end
	
end
