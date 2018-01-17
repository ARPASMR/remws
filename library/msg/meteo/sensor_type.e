note
	description : "Summary description for {SENSOR_TYPE}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:21 (dom 10 dic 2017, 19.44.21, CET) buck $"
	revision    : "$Revision 48 $"

class
	SENSOR_TYPE

inherit
	ANY

	redefine
		out
	end

create
	make,
	make_from_id_and_name

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create name.make_empty
		end

	make_from_id_and_name (an_id: INTEGER; a_name: STRING)
			-- Initialization for `Current' based upon `an_id' and `a_name'
		require
			attached_a_name: attached a_name
		do
			id := an_id
			create name.make_from_string (a_name)
		ensure
			id_equals_an_id: id = an_id
			name_equals_a_name: name.is_equal (a_name)
		end

feature -- Access

	id:   INTEGER
	name: STRING

feature -- Status setting

	set_id (an_id: INTEGER)
			-- Sets `id'
		do
			id := an_id
		ensure
			id_equals_an_id: id = an_id
		end

	set_name (a_name: STRING)
			-- Sets `name'
		require
			attached_a_name: attached a_name
			attached_name:   attached name
		do
			name.copy (a_name)
		ensure
			name_equals_a_name: name.is_equal (a_name)
		end

feature -- Reporting

	out: STRING
			-- `SENSOR_TYPE' as string
		do
			create Result.make_empty
			Result := "{id: " + id.out + ", name: " + name + "}"
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
