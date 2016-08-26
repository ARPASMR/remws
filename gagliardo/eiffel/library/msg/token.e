note
	description: "Summary description for {TOKEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TOKEN

create make

feature {NONE} -- Initialization

	make
			--
		do
			create id.make_empty
			create expiry.make_fine (1900, 1, 1, 0, 0, 0.0)
		end

feature -- Access

	id:     STRING
	expiry: DATE_TIME

	is_valid: BOOLEAN
			-- Is `Current' a valid token?
		do

		end

feature -- Status setting

	set_id(i: STRING)
			--
		require
			attached_i: attached i
		do
			id := i
		end

	set_expiry(dt: DATE_TIME)
			--
		require
			dt_attached: attached dt
		do
			expiry := dt
		end

feature -- Basic operations

end
