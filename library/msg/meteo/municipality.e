note
	description: "Summary description for {MUNICIPALITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MUNICIPALITY

inherit
	ANY

	redefine
		out
	end

create
	make,
	make_from_parameters

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create name.make_empty
			create province.make_empty
		end

	make_from_parameters (an_id, an_istat_code: INTEGER; a_name, a_province: STRING)
			-- Initialization for `Current' based upon `an_id' and `a_name'
		require
			attached_a_name:     attached a_name
			attached_a_province: attached a_province
		do
			id         := an_id
			istat_code := an_istat_code
			create name.make_from_string (a_name)
			create province.make_from_string (a_province)
		ensure
			id_equals_an_id: id = an_id
			istat_code_equals_an_istat_code: istat_code = an_istat_code
			name_equals_a_name: name.is_equal (a_name)
			province_equals_a_province: province.is_equal (a_province)
		end

feature -- Access

	id:         INTEGER
	istat_code: INTEGER
	name:       STRING
	province:   STRING

feature -- Status setting

	set_id (an_id: INTEGER)
			-- Sets `id'
		do
			id := an_id
		ensure
			id_equals_an_id: id.is_equal (an_id)
		end

	set_istat_code (an_istat_code: INTEGER)
			-- Sets `istat_code'
		do
			istat_code := an_istat_code
		ensure
			istat_code_equals_an_istat_code: istat_code = an_istat_code
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

	set_province (a_province: STRING)
			-- Sets `province'
		require
			attached_a_province: attached a_province
			attached_province:   attached province
		do
			province.copy (a_province)
		end

feature -- Reporting

	out: STRING
			-- `STATION_TYPE' as string
		do
			Result := "{id: " + id.out + ", name: " + name + ", province: " + province + "}"
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
