note
	description : "Summary description for {TOKEN}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

class
	TOKEN

inherit
	ANY

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
			id := i.twin
		end

	set_expiry(dt: DATE_TIME)
			--
		require
			dt_attached: attached dt
		do
			expiry := dt.twin
		end

end
