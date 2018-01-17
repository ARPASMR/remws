note
	description : "test_pg application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	TEST_PG

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			create conn_string.make_empty
			create pg
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

feature -- Conn string

	-- User ID=root;Password=myPassword;Host=localhost;Port=5432;Database=myDataBase;
    -- Pooling=true;Min Pool Size=0;Max Pool Size=100;Connection Lifetime=0;

    conn_string: STRING

feature -- PG

	pg: POSTGRESQL

end
