indexing

	description:

		"GTK+ 2 Entry Demo example demostrating the use of entries"

	copyright: "Copyright (c) 2005, Paolo Redaelli"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/05/04 20:25:54 $"
	revision: "$Revision: 1.1 $"

class DEMO_ENTRY

inherit

	GTK_ENTRY
		redefine
			make,
			out
		end

creation make
	
feature make is
			-- Create Current demo entry and set some callbacks
		do
			Precursor
			connect_agent_to_delete_from_cursor_signal (agent on_delete_entry)
			connect_agent_to_insert_at_cursor_signal (agent on_insert_entry)

			connect_agent_to_move_cursor_signal (agent on_move_cursor_entry)
		end

feature
	out: STRING is
		do
			Result := "entry content is:'"
			Result.append(text)
			Result.append("'%N")
			Result.append("activates_default: ")
			Result.append(activates_default.out)
			Result.append("%N")
			Result.append("has_frame: ")
			Result.append(has_frame.out)
			Result.append("%N")
			Result.append("requested_width: ")
			Result.append(requested_width.out)
			Result.append("%Ninvisible_char: '")
			Result.append_character(invisible_char)
			Result.append("'%Nmaximum_length: ")
			Result.append(maximum_length.out)
			Result.append("%Nvisibility: ")
			Result.append(visibility.out)
		end 
feature -- Agents
	
	on_backspace_entry (an_entry: GTK_ENTRY) is
		do
			print ("Entry text is, before a backspace:'")
			print (text)
			print ("'%N")
			check
				an_entry_is_current: an_entry = Current
			end
		end
	
	on_delete_entry (an_entry: GTK_ENTRY; delete_type,arg2: INTEGER) is
		do
			print ("delete-from-cursor signal: Entry text '") print (text)
			print ("' delete type ") print (delete_type.out)
			print (" arg2 ") print(arg2.out) print("%N")
			check
				an_entry_is_current: an_entry = Current
			end
		end
	
	on_insert_entry (an_entry: GTK_ENTRY; a_char: CHARACTER) is
		do
			print ("Inserting '") print (a_char.out) print("' into entry '") print(text) print("'%N")
			check
				an_entry_is_current: an_entry = Current
			end
		end

	on_move_cursor_entry (an_entry: GTK_ENTRY; a_movement_step, arg2, arg3: INTEGER) is
		do
			print ("move-cursor signal on entry '") print(text) print("': movement step ") print (a_movement_step.out)
			print (", arg2 ") print (arg2.out)
			print (", arg3 ") print (arg3.out)
			print ("%N")
			check
				an_entry_is_current: an_entry = Current
			end
		end
end

