note
	description: "Summary description for {VEHICLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VEHICLE

feature -- queries

	is_moving: BOOLEAN
			--
		do
			Result := start
		end

	has_wheels: BOOLEAN
			-- Does this mean of transport have wheels?

	wheels_number: INTEGER
			-- Wheels number

feature -- Commands

	start: BOOLEAN
			--
		do
			Result := true
		end

	stop: BOOLEAN
			--
		do
			Result := true
		end

end
