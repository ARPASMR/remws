note
	description: "Summary description for {OID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OID

inherit
	UUID_GENERATOR

feature -- Queries

	id: UUID
			-- Generate unique identifier
		once
			create Result.make_from_string (generate_uuid.string)
		end
end
