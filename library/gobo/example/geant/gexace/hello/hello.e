indexing

	description:

		"Gobo Eiffel Ant Example Class"

	library: "Gobo Eiffel Ant"
	copyright: "Copyright (c) 2001, Sven Ehrke and others"
	license: "MIT License"
	date: "$Date: 2007-01-26 19:55:25 +0100 (Fri, 26 Jan 2007) $"
	revision: "$Revision: 5877 $"


class HELLO

create

	make

feature {NONE} -- Initialization

	make is
			-- Execute 'hello world'.
		do
			print ("Hello World%N")
		end

end
