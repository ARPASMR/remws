indexing

	description:

		"Agent extensions for GTK_SPINBUTTON"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/12/18 08:36:40 $"
	revision: "$Revision: 1.1 $"

deferred class GTK_SPIN_BUTTON_AGENT

inherit GTK_OBJECT_AGENT_SKELETON
	
feature {ANY} -- Signals
	connect_agent_to_change_value_signal (an_agent: PROCEDURE [ANY, TUPLE [GTK_SPINBUTTON,INTEGER]]) is
			-- Connect `an_agent' to 'change-value' signal of the current widget
		require
			an_agent_not_void: an_agent /= Void
		local
			a_receiver: GTK_CHANGE_VALUE_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (an_agent)
			connect_signal_receiver (a_receiver)
		end

	-- TODO wrap the following signals
-- The "input" signal

-- gint        user_function                  (GtkSpin_Button *spin_button,
--                                             gpointer arg1,
--                                             gpointer user_data);

-- spin_button :	the object which received the signal.
-- arg1 :	
-- user_data :	user data set when the signal handler was connected.
-- Returns :	
-- The "output" signal

-- gboolean    user_function                  (GtkSpin_Button *spin_button,
--                                             gpointer user_data);

-- spin_button :	the object which received the signal.
-- user_data :	user data set when the signal handler was connected.
-- Returns :	
-- The "value-changed" signal

-- void        user_function                  (GtkSpin_Button *spin_button,
--                                             gpointer user_data);

-- spin_button :	the object which received the signal.
-- user_data :	user data set when the signal handler was connected.
-- See Also

end
