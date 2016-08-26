note
	description: "Summary description for {TASK_STATUS_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TASK_STATUS_CONSTANTS

feature -- Access

	waiting:  INTEGER = 0
	running:  INTEGER = 1
	finished: INTEGER = 2

end
