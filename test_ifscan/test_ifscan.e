note
	description : "test_ifscan application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	TEST_IFSCAN

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			k:   INTEGER
			i:   IFSCAN
			nic: NIC_INTERFACE
		do
			create i.query
			io.put_string ("Interfaces number: " + i.interfaces.capacity.out + "%N")

			from k := 1
			until k > i.number
			loop
				nic := i.interfaces.at (k)
				io.put_string (nic.number.out + "%T" + nic.name + "%T" + nic.address + "%T" + nic.broadcast + "%T" + nic.netmask + "%N")
				k := k + 1
			end
		end

end
