note
	description: "Summary description for {SCHEDULER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCHEDULER

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create tasks.make
		end

feature -- Queries

	is_master: BOOLEAN
			--
		do
			Result := master
		end

	is_slave: BOOLEAN
			--
		do
			Result := not master
		end

feature -- Operations

	force_master
			--
		do
			master := true
		end

	put (t: TASK)
			--
		do
			tasks.extend (t)
		end

	search(t: TASK)
			--
		do
			tasks.search (t)
			if not tasks.exhausted then
				found := tasks.item
			else
				found := Void
			end
		end

	found: TASK
			-- Last search result

	remove(t: TASK)
			--
		do
			search (t)
			if not tasks.exhausted then
				tasks.remove
			end
		end

	replace(t: TASK)
			--
		do
			search (t)
			if not tasks.exhausted then
				tasks.replace (t)
			end
		end

	list: SORTED_TWO_WAY_LIST[TASK]
			--
		do
			Result := tasks
		end

	take_online(t: TASK)
			--
		do
			t.take_online
		end

	take_offline(t: TASK)
			--
		do
			t.take_offline
		end

feature {NONE} -- Implementation

	tasks:  SORTED_TWO_WAY_LIST[TASK]
	master: BOOLEAN

end
