note
	description: "Summary description for {MESSAGE_TYPES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE_TYPES

feature -- Access

	-- scheduler messages
	noop:              INTEGER =  0
			-- no operation message
	start_scheduler:   INTEGER =  1
			-- start the scheduler thread
	stop_scheduler:    INTEGER =  2
			-- stop thescheduler thread
	put:               INTEGER =  3
			-- put a new task in list
	remove:            INTEGER =  4
			-- remove a task from list
	update:            INTEGER =  5
			-- update a task
	list:              INTEGER =  6
			-- list tasks

	-- task messages
	execute:           INTEGER =  7
			-- execute a task
	abort:             INTEGER =  8
			-- abort a running task
	change_priority:   INTEGER =  9
			-- change a task priority
	take_online:       INTEGER = 10
			-- take a task online
	take_offline:      INTEGER = 11
			-- take a task offline


end
