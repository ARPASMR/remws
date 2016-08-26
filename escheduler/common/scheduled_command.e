note
	description: "Summary description for {SCHEDULED_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCHEDULED_COMMAND

create
	make

feature {NONE} -- Initialization

	make(t: STRING)
			--
		require
			t_not_void: t /= Void
		do
			create txt.make_from_string(t)
			txt := t
			create cmd.make (txt)
		end

feature -- Access

	text: STRING
			--
		do
			Result := txt
		end

	shell_command: POSIX_SHELL_COMMAND
			--
		do
			Result := cmd
		end

feature -- Operations

	execute: INTEGER
			--
		require
			text_not_void:          text          /= Void
			shell_command_not_void: shell_command /= Void
		do
			cmd.execute
			Result := cmd.exit_code
		end


feature {NONE} -- Implementation

	txt: STRING
	cmd: POSIX_SHELL_COMMAND

end
