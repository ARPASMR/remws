note
	description: "Summary description for {QUERY_TOKEN_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QUERY_TOKEN_RESPONSE

inherit
	--RESPONSE_I
	ANY
	undefine
		out
	end


create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature -- Representation

	out: STRING
			-- Stringrepresentation
		do
			create Result.make_empty
		end

end
