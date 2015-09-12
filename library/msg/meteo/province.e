note
	description: "Summary description for {PROVINCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROVINCE

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
			create id.make_empty
			create name.make_empty
		end

	make_from_id_and_name (an_id: STRING; a_name: STRING)
			-- Initialization for `Current' based upon `an_id' and `a_name'
		require
			attached_an_id:  attached an_id
			attached_a_name: attached a_name
		do
			create id.make_from_string (an_id)
			create name.make_from_string (a_name)
		ensure
			id_equals_an_id: id.is_equal (an_id)
			name_equals_a_name: name.is_equal (a_name)
		end

feature -- Access

	id:   STRING
	name: STRING

feature -- Status setting

	set_id (an_id: STRING)
			-- Sets `id'
		do
			id.copy (an_id)
		ensure
			id_equals_an_id: id.is_equal (an_id)
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
			-- `STATION_TYPE' as string
		do
			create Result.make_empty
			Result := "{id: " + id.out + ", name: " + name + "}"
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
