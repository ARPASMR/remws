note
	description: "Summary description for {TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TASK

inherit
	COMPARABLE
	redefine
		out
	end

	TASK_STATUS_CONSTANTS
	undefine
		is_equal
	redefine
		out
	end

	UUID_GENERATOR
	undefine
		is_equal
	redefine
		out
	end

	INET_ADDRESS_FACTORY
	undefine
		is_equal
	redefine
		out
	end

create
	make

feature {NONE} -- Initialization

	make(c: SCHEDULED_COMMAND)
			--
		require
			c_not_void: c /= Void
		do
			uuid := generate_uuid
			create creation_dt.make_now_utc
			cmd  := c
			stat := waiting
			trg  := create_localhost
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := creation_dt < other.creation_datetime
		end

feature -- Access

	id: UUID
			--
		do
			Result := uuid
		end

	creation_datetime: DATE_TIME
			--
		do
			Result := creation_dt
		end

	command: SCHEDULED_COMMAND
			--
		do
			Result := cmd
		end

	status: INTEGER
			--
		do
			Result := stat
		end

	priority: INTEGER
			--
		do
			Result := pri
		end

	target: INET_ADDRESS
			--
		do
			Result := trg
		end

feature -- Modifiers

	set_target(t: INET4_ADDRESS)
			--
		do
			trg := t
		end

feature -- Queries

	is_waiting: BOOLEAN
			--
		do
			Result := stat = waiting
		end

	is_running: BOOLEAN
			--
		do
			Result := stat = running
		end

	is_finished: BOOLEAN
			--
		do
			Result := stat = finished
		end


feature -- Operations

	execute: INTEGER
			--
		require
			command_not_void: command /= Void
		do
			create execution_dt.make_now_utc
			Result := cmd.execute
		end

	execute_on (dt: DATE_TIME)
			--
		require
			command_not_void: command /= Void
		do
			create execution_dt.make_by_date_time (dt.date, dt.time)
		end

	change_priority(p: INTEGER)
			--
		do
			pri := p
		end

	take_online
			--
		do
			online := true
		end

	take_offline
			--
		do
			online := false
		end

feature -- Representation

	out: STRING
			--
		do
			Result := "{" + id.out + "} "
			Result := Result + " " + creation_dt.formatted_out ("yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss.ff<6>")  + " "
			Result := Result + " " + execution_dt.formatted_out ("yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss.ff<6>") + " "
			Result := Result + cmd.text + " " + "[" + stat.out + "] " + pri.out
		end

feature {NONE} -- Implementation

	uuid:         UUID
			-- Unique identifier
	creation_dt:  DATE_TIME
			-- When task was created
	execution_dt: DATE_TIME
			-- When task has to be executed
	cmd:          SCHEDULED_COMMAND
			-- Task command to be executed
	online:       BOOLEAN
			-- Is task active and runnable?
	stat:         INTEGER
			-- Task status: 0 --> WAITING
			--              1 --> RUNNING
			--              2 --> FINISHED
	pri:          INTEGER
			-- task priority
			-- 0   --> default priority
			-- > 0 --> increasing priority
			-- < 0 --> decreasing priority
	trg:          INET_ADDRESS
			-- target machine

end
