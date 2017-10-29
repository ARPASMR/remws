note
	description: "Summary description for {QUERY_TOKEN_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QUERY_TOKEN_REQUEST

inherit
	-- REQUEST_I
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

	out:STRING
			-- String representation
		do
			create Result.make_empty
		end

end
