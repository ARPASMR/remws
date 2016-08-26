note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

	inherit

		MESSAGE_TYPES
			undefine
			   default_create, copy

			redefine
				out
			end


		STORABLE
		    redefine
	    	    out
	        end

create
	make

feature -- Representation

	out: STRING
			--
		do
			Result := "{" + id.out + "}" + " [" + cmd + "]"
			if attached {TASK} tsk then
				Result := Result + " " + tsk.out
			else
				Result := Result + " no task"
			end
		end

feature {NONE} -- Initialization

	make
			--
		do
		end

feature -- Access

	type: INTEGER
			--
		do
			Result := id
		end

	command: STRING
			--
		do
			Result := cmd
		end

	task: TASK
			--
		do
			Result := tsk;
		end

	is_start_message: BOOLEAN
			--
		do
			Result := id = start_scheduler
		end

	is_stop_message: BOOLEAN
			--
		do
			Result := id = stop_scheduler
		end

	is_execute_message: BOOLEAN
			--
		do
			Result := id = execute
		end

feature -- Modifiers

	set_type(c: INTEGER)
			--
		do
			id := c
		end

	set_command(c: STRING)
			--
		do
			cmd := c
		end

	set_task(t: TASK)
			--
		do
			tsk := t
		end



feature {NONE} -- Implementation

	id:  INTEGER
	cmd: STRING
	tsk: TASK

end
