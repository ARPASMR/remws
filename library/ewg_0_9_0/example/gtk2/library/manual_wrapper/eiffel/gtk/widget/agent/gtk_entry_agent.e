indexing

	description:

		"Agent extensions for GTK_BUTTON"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/03/04 21:24:57 $"
	revision: "$Revision: 1.2 $"

deferred class GTK_ENTRY_AGENT

inherit

	GTK_OBJECT_AGENT_SKELETON
	
feature {ANY} -- Signals

-- 	connect_agent_to_activate_signal (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY]]) is
-- 			-- Connect `an_agent' to signal "activate"
-- 		require
-- 			an_agent_not_void: an_agent /= Void
-- 		local
-- 			a_receiver: GTK_CLICKED_SIGNAL_RECEIVER_AGENT
-- 		do
-- 			create a_receiver.make (an_agent)
-- 			connect_signal_receiver (a_receiver)

-- 			--user_function (GtkEntry *entry, gpointer user_data);
-- 		end
		
-- 	connect_agent_to_backspace_signal  (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY]]) is
-- 			-- Connect `an_agent' to signal "backspace"
-- 		require
-- 			an_agent_not_void: an_agent /= Void
-- 		local
-- 			a_receiver: GTK_BACKSPACE_SIGNAL_RECEIVER_AGENT
-- 		do
-- 			create a_receiver.make (an_agent)
-- 			connect_signal_receiver (a_receiver)

-- 			-- user_function (GtkEntry *entry, gpointer user_data);
-- 		end
		
-- 	connect_agent_to_copy_clipboard_signal  (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY]]) is
-- 			-- Connect `an_agent' to signal "copy_clipboard"
-- 		require
-- 			an_agent_not_void: an_agent /= Void
-- 		local
-- 			a_receiver: GTK_COPY_CLIPBOARD_SIGNAL_RECEIVER_AGENT
-- 		do
-- 			create a_receiver.make (an_agent)
-- 			connect_signal_receiver (a_receiver)

-- 			-- user_function (GtkEntry *entry, gpointer user_data);
-- 		end
		
	
-- 	connect_agent_to_cut_clipboard_signal  (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY]]) is
-- 			-- Connect `an_agent' to signal "cut_clipboard"
-- 		require
-- 			an_agent_not_void: an_agent /= Void
-- 		local
-- 			a_receiver: GTK_CUT_CLIPBOARD_SIGNAL_RECEIVER_AGENT
-- 		do
-- 			create a_receiver.make (an_agent)
-- 			connect_signal_receiver (a_receiver)

-- 			-- user_function (GtkEntry *entry, gpointer user_data)
-- 		end
		
	
	connect_agent_to_delete_from_cursor_signal (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY,INTEGER,INTEGER]]) is
			-- Connect `an_agent' to signal "delete-from-cursor"
		require
			an_agent_not_void: an_agent /= Void
		local a_receiver: GTK_DELETE_FROM_CURSOR_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (an_agent)
			connect_signal_receiver (a_receiver)

			-- user_function (GtkEntry *entry, GtkDeleteType arg1, gint
			-- arg2, gpointer user_data);
		end
		
	connect_agent_to_insert_at_cursor_signal  (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY,CHARACTER]]) is
			-- Connect `an_agent' to signal "insert-at-cursor"
		require
			an_agent_not_void: an_agent /= Void
		local
			a_receiver: GTK_INSERT_AT_CURSOR_SIGNAL_RECEIVER_AGENT
		do
			create a_receiver.make (an_agent)
			connect_signal_receiver (a_receiver)

			-- user_function (GtkEntry *entry, gchar *arg1, gpointer
			-- user_data);
		end
		
	connect_agent_to_move_cursor_signal (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY,INTEGER,INTEGER,INTEGER]]) is
			-- Connect `an_agent' to signal "move-cursor"
		require
			an_agent_not_void: an_agent /= Void
		local
			a_receiver: GTK_MOVE_CURSOR_SIGNAL_RECEIVER_AGENT
		do
			print ("connect_agent_to_move_cursor_signal%N")
			create a_receiver.make (an_agent)
			connect_signal_receiver (a_receiver)

			-- user_function (GtkEntry *entry, GtkMovementStep arg1, gint
			-- arg2, gboolean arg3, gpointer user_data);
		end
		
-- 	connect_agent_to_paste_clipboard_signal (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY]]) is
-- 			-- Connect `an_agent' to signal "paste_clipboard"
-- 		require
-- 			an_agent_not_void: an_agent /= Void
-- 		local
-- 			a_receiver: GTK_PASTE_CLIPBOARD_SIGNAL_RECEIVER_AGENT
-- 		do
-- 			create a_receiver.make (an_agent)
-- 			connect_signal_receiver (a_receiver)

-- 			-- user_function (GtkEntry *entry, gpointer user_data);
-- 		end
		
-- 	connect_agent_to_populate_popup_signal (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY]]) is
-- 			-- Connect `an_agent' to signal "populate_popup"
-- 		require
-- 			an_agent_not_void: an_agent /= Void
-- 		local
-- 			a_receiver: GTK_POPULATE_POPUP_SIGNAL_RECEIVER_AGENT
-- 		do
-- 			create a_receiver.make (an_agent)
-- 			connect_signal_receiver (a_receiver)

-- 			-- user_function (GtkEntry *entry, GtkMenu *arg1, gpointer
-- 			-- user_data);
-- 		end
		
-- 	connect_agent_to_toggle_overwrite_signal (an_agent: PROCEDURE[ANY,TUPLE[GTK_ENTRY]]) is
-- 			-- Connect `an_agent' to signal "toggle_overwrite"
-- 		require
-- 			an_agent_not_void: an_agent /= Void
-- 		local
-- 			a_receiver: GTK_TOGGLE_OVERWRITE_SIGNAL_RECEIVER_AGENT
-- 		do
-- 			create a_receiver.make (an_agent)
-- 			connect_signal_receiver (a_receiver)

-- 			-- user_function (GtkEntry *entry, gpointer user_data);
-- 		end
		
end
